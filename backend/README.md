# CloudEscape Backend — AWS Setup Guide

## Architecture

```
Flutter App  ──►  API Gateway (HTTP API)  ──►  Lambda  ──►  DynamoDB
```

---

## Step 1 — Create the DynamoDB Table

1. Open **AWS Console → DynamoDB → Create table**
2. Settings:
   - **Table name**: `CloudEscapeLeaderboard`
   - **Partition key**: `scoreId` (String)
3. After creation, add a **Global Secondary Index (GSI)**:
   - Go to the table → **Indexes** tab → **Create index**
   - **Partition key**: `category` (String)
   - **Sort key**: `score` (Number)
   - **Index name**: `ByScore`
   - Projected attributes: **All**

---

## Step 2 — Create the Lambda Function

1. Open **AWS Console → Lambda → Create function**
2. Settings:
   - **Name**: `CloudEscapeLeaderboard`
   - **Runtime**: Node.js 22.x
   - **Architecture**: arm64 (cheaper)
3. Upload the code:
   - In the Lambda code editor, replace the default code with the contents of `lambda/index.mjs`
   - Make sure the file is named `index.mjs`
4. **Environment variable**:
   - Key: `TABLE_NAME` | Value: `CloudEscapeLeaderboard`
5. **Execution role** — add this IAM policy to the Lambda role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      "Resource": [
        "arn:aws:dynamodb:*:*:table/CloudEscapeLeaderboard",
        "arn:aws:dynamodb:*:*:table/CloudEscapeLeaderboard/index/*"
      ]
    }
  ]
}
```

---

## Step 3 — Create the API Gateway

1. Open **AWS Console → API Gateway → Create API**
2. Choose **HTTP API** (cheaper and simpler than REST API)
3. Settings:
   - **Name**: `CloudEscapeAPI`
   - **Integration**: Lambda → select `CloudEscapeLeaderboard`
4. **Routes** — add two:
   - `POST /scores`
   - `GET  /scores`
5. **CORS** — Enable CORS:
   - Allow origins: `*` (or your Amplify URL for production)
   - Allow methods: `GET, POST, OPTIONS`
   - Allow headers: `Content-Type`
6. **Deploy** — create a stage called `prod`
7. Copy the **Invoke URL** — it looks like:
   `https://abc123xyz.execute-api.us-east-1.amazonaws.com`

---

## Step 4 — Add the URL to Flutter

Open `lib/api_config.dart` and replace the placeholder:

```dart
const String apiBaseUrl = 'https://YOUR_API_ID.execute-api.YOUR_REGION.amazonaws.com';
```

---

## Step 5 — Test the API

```bash
# Save a score
curl -X POST https://YOUR_URL/scores \
  -H "Content-Type: application/json" \
  -d '{"nickname":"Alex","category":"aws","categoryEmoji":"☁️","score":9,"total":10}'

# Get top scores
curl https://YOUR_URL/scores

# Get AWS scores only
curl https://YOUR_URL/scores?category=aws
```
