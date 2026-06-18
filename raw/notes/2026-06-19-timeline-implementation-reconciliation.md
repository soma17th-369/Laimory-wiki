---
source_type: notes
title: Timeline Implementation Reconciliation
captured_at: 2026-06-19
status: implementation-reconciliation
---

# Timeline Implementation Reconciliation

## Context

The timeline storage and draft API design notes from 2026-06-16 and 2026-06-17 were written before the current server implementation settled. This note records the differences between those raw plans and the current `C:\suhyun444\dev\server` implementation.

The current server implementation is treated as the source of truth for this reconciliation.

## Current Implemented API

Public Android-facing draft API:

```text
POST /api/{applicationVersion}/timeline/drafts
GET  /api/{applicationVersion}/timeline/drafts/{taskId}
```

Server-to-server AI callback:

```text
POST /s/api/{applicationVersion}/timeline/drafts/{taskId}/callback
```

This supersedes the older sketches:

```text
POST /api/v1/timeline/daily-records/draft-tasks
GET  /api/v1/timeline/daily-records/draft-tasks/{taskId}
POST /internal/api/v1/timeline/daily-records/draft-tasks/{taskId}/callback
```

Rationale:

- The `timeline` domain remains visible.
- `drafts` is the client-facing resource.
- The async task nature is still expressed by `202 Accepted`, `taskId`, and polling.
- The server-to-server prefix is `/s/api/{applicationVersion}` rather than `/internal/api/v1`.

## Callback Authentication

The current implementation does not use a global internal secret header. AI callbacks are verified with a task-scoped one-time header:

```http
Callback-Token: <token>
```

Implementation details:

- The app server generates a 256-bit random token per task.
- The raw token is passed only to the AI dispatcher.
- Redis stores only `SHA-256(callbackToken)`.
- Callback validation compares the provided token hash with the stored hash using constant-time comparison.
- Missing or invalid callback token returns `401`.

This supersedes the earlier `X-Internal-Secret` / `CallbackSecretInterceptor` direction.

## Redis Task Shape

The implemented Redis task is represented by `TimelineDraftTask`:

```json
{
  "status": "PROCESSING",
  "recordDate": "2026-05-08",
  "error": null,
  "callbackTokenHash": "<sha256-base64>"
}
```

Terminal states clear the token hash:

```json
{
  "status": "SUCCESS",
  "recordDate": "2026-05-08",
  "error": null,
  "callbackTokenHash": null
}
```

The Redis key remains:

```text
timeline:draft-task:{taskId}
```

The implementation does not store `dailyRecordId` in Redis. On successful polling, the app server resolves the timeline result by `(DEFAULT_USER_ID, recordDate)`.

TTL policy remains aligned with the plan:

```text
PROCESSING: 1 hour
SUCCESS: 24 hours
FAILED: 24 hours
```

## Callback Body Shape

The callback body now includes explicit AI task status and error fields:

```json
{
  "status": "SUCCESS",
  "error": null,
  "sourceItems": [],
  "cards": []
}
```

Earlier sketches described callback payload as only `sourceItems + cards`. The implemented shape lets the AI server explicitly report `FAILED` without producing card suggestions.

`recordDate` is not included in the callback body. It is read from the Redis task.

## Callback Behavior

Implemented behavior:

```text
task not found -> 404
Callback-Token missing or invalid -> 401
terminal task already SUCCESS/FAILED -> 200 no-op
callback status FAILED -> mark Redis task FAILED and return 200
callback status SUCCESS -> validate, append timeline data, mark SUCCESS
validation or SAVED conflict during callback -> mark Redis task FAILED and return 200
invalid callback status -> 400
```

Draft task creation still rejects an already `SAVED` daily record with `409`.

If the AI dispatch call throws synchronously, the server marks the task `FAILED` but still returns the `taskId` so the client can observe failure through polling.

## Storage Model

The three-table timeline storage model remains:

```text
daily_records
timeline_cards
timeline_items
```

Implemented `timeline_items` columns:

```text
id
timeline_card_id
start_at
end_at
payload JSON
```

There is no `timeline_items.item_type` column in v1. Item type is stored inside the payload JSON discriminator and projected into response DTOs from the payload.

The implemented Java entity model uses plain FK IDs:

```text
TimelineCard.dailyRecordId
TimelineItem.timelineCardId
```

It does not use JPA object relationships or JPA cascade for `daily_records -> timeline_cards -> timeline_items`. Database FK constraints handle `ON DELETE CASCADE`.

## Payload Shape Notes

The implemented typed payload direction is still aligned with the plan:

```text
TimelineItemPayload sealed interface
PhotoPayload
CalendarPayload
LocationPayload
MovementPayload
```

One field-level difference from older sketches:

- Older sketches included `CalendarPayload.attendeesCount`.
- The current server `CalendarPayload` contains `title`, `calendarName`, and `locationText`.

## Response DTOs

`POST /timeline/drafts` returns:

```json
{
  "taskId": "..."
}
```

`GET /timeline/drafts/{taskId}` returns:

```json
{
  "status": "PROCESSING",
  "result": null,
  "error": null
}
```

On success, `result` is the generated daily timeline response. On failure, `error` contains the failure reason.

## Still Open

The real AI dispatcher is still a no-op stub. Remaining follow-ups:

```text
real AI server HTTP dispatch
short timeout and retry policy
HMAC request signing if Callback-Token becomes insufficient
save-complete endpoint for DRAFT -> SAVED and emotionType
concurrency guard for multiple tasks on the same user/date
```

