/**
 * CloudEscape Leaderboard Lambda
 * Routes:
 *   POST /scores  — save a score
 *   GET  /scores  — get top 50 scores (optional ?category=aws)
 *
 * DynamoDB table: CloudEscapeLeaderboard
 *   PK: scoreId (String) — uuid
 *   GSI "ByScore":  pk=category (String), sk=score (Number) — for sorted queries
 */

import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  PutCommand,
  QueryCommand,
  ScanCommand,
} from "@aws-sdk/lib-dynamodb";
import { randomUUID } from "crypto";

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);
const TABLE = process.env.TABLE_NAME ?? "CloudEscapeLeaderboard";

// ── CORS headers ────────────────────────────────────────────────────────────
const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "Content-Type",
  "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
};

function respond(statusCode, body) {
  return {
    statusCode,
    headers: { "Content-Type": "application/json", ...CORS },
    body: JSON.stringify(body),
  };
}

// ── Handler ──────────────────────────────────────────────────────────────────
export const handler = async (event) => {
  const method = event.httpMethod ?? event.requestContext?.http?.method ?? "GET";
  const path   = event.path ?? event.rawPath ?? "/scores";

  // Preflight
  if (method === "OPTIONS") return respond(200, {});

  try {
    // ── POST /scores ─────────────────────────────────────────────────────────
    if (method === "POST") {
      const body = JSON.parse(event.body ?? "{}");
      const { nickname, category, categoryEmoji, score, total } = body;

      if (!nickname || category === undefined || score === undefined) {
        return respond(400, { error: "nickname, category, score are required" });
      }

      const item = {
        scoreId:       randomUUID(),
        nickname:      String(nickname).slice(0, 30),
        category:      String(category),
        categoryEmoji: String(categoryEmoji ?? "☁️"),
        score:         Number(score),
        total:         Number(total ?? 10),
        percentage:    Math.round((Number(score) / Number(total ?? 10)) * 100),
        playedAt:      new Date().toISOString(),
      };

      await ddb.send(new PutCommand({ TableName: TABLE, Item: item }));
      return respond(201, { message: "Score saved", item });
    }

    // ── GET /scores ──────────────────────────────────────────────────────────
    if (method === "GET") {
      const category = event.queryStringParameters?.category;
      const limit    = Math.min(
        parseInt(event.queryStringParameters?.limit ?? "50", 10),
        100
      );

      let items;

      if (category) {
        // Query the GSI for a specific category, sorted by score desc
        const result = await ddb.send(
          new QueryCommand({
            TableName:              TABLE,
            IndexName:              "ByScore",
            KeyConditionExpression: "category = :cat",
            ExpressionAttributeValues: { ":cat": category },
            ScanIndexForward:       false, // descending score
            Limit:                  limit,
          })
        );
        items = result.Items ?? [];
      } else {
        // Full scan — fine for trivia night scale (<10k rows)
        const result = await ddb.send(
          new ScanCommand({ TableName: TABLE, Limit: 500 })
        );
        items = (result.Items ?? [])
          .sort((a, b) => b.score - a.score || b.percentage - a.percentage)
          .slice(0, limit);
      }

      return respond(200, { scores: items });
    }

    return respond(404, { error: "Not found" });
  } catch (err) {
    console.error(err);
    return respond(500, { error: "Internal server error" });
  }
};
