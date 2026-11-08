/**
 * CloudEscape Leaderboard Lambda
 *
 * Routes:
 *   POST   /sessions         — host creates a new named session → returns sessionId
 *   GET    /sessions/:id     — get session info + all scores for that session
 *   DELETE /sessions/:id     — host clears all scores for a session
 *   POST   /scores           — player saves a score (body must include sessionId)
 *   GET    /scores?sessionId — get all scores for a session, sorted by score desc
 *
 * DynamoDB table: CloudEscapeLeaderboard
 *   PK: pk  (String)  e.g. "SESSION#abc123" or "SCORE#uuid"
 *   SK: sk  (String)  e.g. "META" or "SCORE#uuid"
 *
 * GSI "BySession":
 *   PK: sessionId (String)
 *   SK: score     (Number)  — lets us query all scores for a session sorted
 */

import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  PutCommand,
  GetCommand,
  QueryCommand,
  DeleteCommand,
  ScanCommand,
} from "@aws-sdk/lib-dynamodb";
import { randomUUID } from "crypto";

const client = new DynamoDBClient({});
const ddb    = DynamoDBDocumentClient.from(client);
const TABLE  = process.env.TABLE_NAME ?? "CloudEscapeLeaderboard";

const CORS = {
  "Access-Control-Allow-Origin":  "*",
  "Access-Control-Allow-Headers": "Content-Type",
  "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS",
};

const ok  = (body, status = 200) => ({
  statusCode: status,
  headers: { "Content-Type": "application/json", ...CORS },
  body: JSON.stringify(body),
});
const err = (msg, status = 400) => ok({ error: msg }, status);

// ── Router ───────────────────────────────────────────────────────────────────
export const handler = async (event) => {
  const method   = (event.httpMethod ?? event.requestContext?.http?.method ?? "GET").toUpperCase();
  const rawPath  = event.path ?? event.rawPath ?? "/";
  // Strip stage prefix (e.g. /prod/sessions → /sessions)
  const path     = rawPath.replace(/^\/[^/]+(?=\/)/, '');
  const segments = path.replace(/^\//, "").split("/"); // ["sessions","abc"] etc.
  const qs       = event.queryStringParameters ?? {};

  if (method === "OPTIONS") return ok({});

  try {
    // ── POST /sessions ───────────────────────────────────────────────────────
    if (method === "POST" && segments[0] === "sessions" && !segments[1]) {
      const body        = JSON.parse(event.body ?? "{}");
      const sessionId   = randomUUID();
      const sessionName = String(body.name ?? "Trivia Night").slice(0, 60);
      const createdAt   = new Date().toISOString();

      await ddb.send(new PutCommand({
        TableName: TABLE,
        Item: {
          pk:          `SESSION#${sessionId}`,
          sk:          "META",
          sessionId,
          sessionName,
          createdAt,
          type:        "session",
        },
      }));

      return ok({ sessionId, sessionName, createdAt }, 201);
    }

    // ── GET /sessions/:id ────────────────────────────────────────────────────
    if (method === "GET" && segments[0] === "sessions" && segments[1]) {
      const sessionId = segments[1];

      // Get session metadata
      const meta = await ddb.send(new GetCommand({
        TableName: TABLE,
        Key: { pk: `SESSION#${sessionId}`, sk: "META" },
      }));
      if (!meta.Item) return err("Session not found", 404);

      // Get all scores for session
      const scoresResult = await ddb.send(new QueryCommand({
        TableName:              TABLE,
        IndexName:              "BySession",
        KeyConditionExpression: "sessionId = :sid",
        ExpressionAttributeValues: { ":sid": sessionId },
        ScanIndexForward:       false,
      }));

      const scores = (scoresResult.Items ?? [])
        .filter(i => i.type === "score")
        .sort((a, b) => b.score - a.score || b.percentage - a.percentage);

      return ok({ session: meta.Item, scores });
    }

    // ── DELETE /sessions/:id ─────────────────────────────────────────────────
    if (method === "DELETE" && segments[0] === "sessions" && segments[1]) {
      const sessionId = segments[1];

      // Find all score items for session and delete them
      const result = await ddb.send(new QueryCommand({
        TableName:              TABLE,
        IndexName:              "BySession",
        KeyConditionExpression: "sessionId = :sid",
        ExpressionAttributeValues: { ":sid": sessionId },
      }));

      const items = result.Items ?? [];
      await Promise.all(items.map(item =>
        ddb.send(new DeleteCommand({
          TableName: TABLE,
          Key: { pk: item.pk, sk: item.sk },
        }))
      ));

      // Delete session meta
      await ddb.send(new DeleteCommand({
        TableName: TABLE,
        Key: { pk: `SESSION#${sessionId}`, sk: "META" },
      }));

      return ok({ deleted: items.length + 1 });
    }

    // ── POST /scores ─────────────────────────────────────────────────────────
    if (method === "POST" && segments[0] === "scores") {
      const body = JSON.parse(event.body ?? "{}");
      const { nickname, category, categoryEmoji, score, total, sessionId } = body;

      if (!nickname || category === undefined || score === undefined || !sessionId) {
        return err("nickname, category, score, sessionId are required");
      }

      const scoreId = randomUUID();
      const item = {
        pk:            `SCORE#${scoreId}`,
        sk:            `SCORE#${scoreId}`,
        scoreId,
        sessionId:     String(sessionId),
        nickname:      String(nickname).slice(0, 30),
        category:      String(category),
        categoryEmoji: String(categoryEmoji ?? "☁️"),
        score:         Number(score),
        total:         Number(total ?? 20),
        percentage:    Math.round((Number(score) / Number(total ?? 20)) * 100),
        playedAt:      new Date().toISOString(),
        type:          "score",
      };

      await ddb.send(new PutCommand({ TableName: TABLE, Item: item }));
      return ok({ message: "Score saved", item }, 201);
    }

    // ── GET /scores?sessionId=xxx ────────────────────────────────────────────
    if (method === "GET" && segments[0] === "scores") {
      const sessionId = qs.sessionId;
      if (!sessionId) return err("sessionId query param required");

      const result = await ddb.send(new QueryCommand({
        TableName:              TABLE,
        IndexName:              "BySession",
        KeyConditionExpression: "sessionId = :sid",
        ExpressionAttributeValues: { ":sid": sessionId },
        ScanIndexForward:       false,
      }));

      const scores = (result.Items ?? [])
        .filter(i => i.type === "score")
        .sort((a, b) => b.score - a.score || b.percentage - a.percentage);

      return ok({ scores });
    }

    return err("Not found", 404);
  } catch (e) {
    console.error(e);
    return err("Internal server error", 500);
  }
};
