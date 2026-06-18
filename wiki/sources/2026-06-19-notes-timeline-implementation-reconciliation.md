---
title: Timeline Implementation Reconciliation
source_type: notes
source_path: raw/notes/2026-06-19-timeline-implementation-reconciliation.md
ingest_date: 2026-06-19
status: ingested
tags: [backend, timeline, implementation, api, callback, redis]
---

# Timeline Implementation Reconciliation

## Summary

Implementation reconciliation note comparing the earlier timeline storage and draft API design notes with the current server implementation.

The current implementation keeps the three-table timeline model but changes the draft API surface to `timeline/drafts`, replaces global internal secret callback auth with per-task `Callback-Token`, and stores callback token hashes in Redis task state.

## Key Claims

- Public draft endpoints are now `POST /api/{applicationVersion}/timeline/drafts` and `GET /api/{applicationVersion}/timeline/drafts/{taskId}`.
- AI callback is now `POST /s/api/{applicationVersion}/timeline/drafts/{taskId}/callback`.
- AI callback authentication uses a task-scoped one-time `Callback-Token`, not `X-Internal-Secret`.
- Redis task state is `status`, `recordDate`, `error`, and `callbackTokenHash`; it does not store `dailyRecordId`.
- Callback body includes `status`, `error`, `sourceItems`, and `cards`.
- `timeline_items` has no v1 `item_type` column; item type lives in payload JSON and is projected into response DTOs.
- Timeline entities use plain FK IDs rather than JPA object relationships/cascade.
- The real AI dispatcher is still a no-op stub.

## Caveats

- This note reconciles against the server implementation as inspected on 2026-06-19.
- The implementation may continue changing quickly while the MVP API is still being shaped.
- The note does not replace the earlier design thought-process documents; it records which parts are superseded by implementation.

## Related Pages

- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[2026-06-16-notes-timeline-card-grouping-design]]
- [[server-to-server-auth-for-laimory]]

