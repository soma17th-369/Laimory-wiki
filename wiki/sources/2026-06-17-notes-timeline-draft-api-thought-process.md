---
title: Timeline Draft API Thought Process
source_type: notes
source_path: raw/notes/2026-06-17-timeline-draft-api-thought-process.md
ingest_date: 2026-06-18
status: ingested
tags: [backend, timeline, async-api, ai-server, callback, security]
---

# Timeline Draft API Thought Process

## Summary

Raw design thought process for Laimory's asynchronous timeline draft API. It records the move from synchronous app-server-to-AI processing toward a task-based flow where Android creates a draft task, the app server dispatches source items to the AI server, the AI server returns a callback, and Android polls task status.

## Key Claims

- Timeline persistence is centered on `daily_records`, `timeline_cards`, and `timeline_items`.
- Android-provided inputs are treated as temporary source items until AI grouping and app server validation succeed.
- The app server should not keep the request thread blocked while waiting for LLM output.
- The app server returns `202 Accepted + taskId`, Redis tracks task status, and the AI server calls back with card suggestions.
- The AI server does not write to MySQL directly; final validation and persistence stay in the app server callback path.
- The current server implementation has superseded the internal secret header sketch: callbacks now use `/s/api/{applicationVersion}/timeline/drafts/{taskId}/callback` with a task-scoped one-time `Callback-Token`.
- Redis task state now includes `callbackTokenHash` and does not include `dailyRecordId`.
- Callback body now includes `status`, `error`, `sourceItems`, and `cards`.

## Caveats

- This is a design thought-process note, not a final API specification.
- The source text includes encoding artifacts in some Korean sections, so synthesis should cross-check against the server implementation and later task plans.
- The current sourceItems echo model trusts the first-party AI server and cannot fully compare callback source items against the original Android request unless staging is added later.
- For the latest implementation reconciliation, use [[2026-06-19-notes-timeline-implementation-reconciliation]].

## Related Pages

- [[2026-06-16-notes-timeline-card-grouping-design]]
- [[2026-06-19-notes-timeline-implementation-reconciliation]]
- [[2026-06-15-markdown-notion-epic-system-initial-setup]]
- [[server-to-server-auth-for-laimory]]
