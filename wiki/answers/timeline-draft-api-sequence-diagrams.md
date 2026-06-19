---
title: Timeline Draft API Sequence Diagrams
kind: answer
status: active
updated: 2026-06-19
tags: [backend, timeline, api, sequence-diagram, redis, ai-server]
---

# Timeline Draft API Sequence Diagrams

## Scope

Current sequence diagrams for the three implemented Laimory timeline draft API surfaces:

- `POST /api/{applicationVersion}/timeline/drafts`
- `GET /api/{applicationVersion}/timeline/drafts/{taskId}`
- `POST /s/api/{applicationVersion}/timeline/drafts/{taskId}/callback`

These diagrams reflect the 2026-06-19 implementation reconciliation. The real AI dispatcher is still a no-op stub, but the intended server boundary and task state behavior are represented.

## 1. Create Timeline Draft Task

```mermaid
sequenceDiagram
    autonumber
    participant Android
    participant App as App Server
    participant Redis
    participant DB as MySQL
    participant AI as AI Server

    Android->>App: POST /api/{version}/timeline/drafts<br/>recordDate + sourceItems
    App->>DB: Check daily_record for user/date

    alt daily_record is already SAVED
        App-->>Android: 409 Conflict
    else draft can be created
        App->>App: Generate taskId
        App->>App: Generate one-time Callback-Token
        App->>App: Hash Callback-Token with SHA-256
        App->>Redis: SET timeline:draft-task:{taskId}<br/>status=PROCESSING, recordDate, callbackTokenHash<br/>TTL=1h
        App->>AI: Dispatch taskId + sourceItems + callbackUrl + raw Callback-Token

        alt AI dispatch throws synchronously
            App->>Redis: Mark task FAILED with error<br/>TTL=24h
        end

        App-->>Android: 202 Accepted<br/>{ taskId }
    end
```

## 2. AI Callback Completes Task

```mermaid
sequenceDiagram
    autonumber
    participant AI as AI Server
    participant App as App Server
    participant Redis
    participant DB as MySQL

    AI->>App: POST /s/api/{version}/timeline/drafts/{taskId}/callback<br/>Callback-Token + status + error + sourceItems + cards
    App->>Redis: GET timeline:draft-task:{taskId}

    alt task not found or expired
        App-->>AI: 404 Not Found
    else Callback-Token missing or invalid
        App-->>AI: 401 Unauthorized
    else task already SUCCESS or FAILED
        App-->>AI: 200 OK no-op
    else callback status is FAILED
        App->>Redis: Mark task FAILED with error<br/>clear callbackTokenHash, TTL=24h
        App-->>AI: 200 OK
    else callback status is SUCCESS
        App->>App: Validate sourceItems and cards.itemIds
        App->>DB: Check daily_record is not SAVED

        alt validation fails or daily_record is SAVED
            App->>Redis: Mark task FAILED with error<br/>clear callbackTokenHash, TTL=24h
            App-->>AI: 200 OK
        else validation passes
            App->>DB: Transactionally append daily_record timeline data
            DB-->>App: Save timeline_cards
            DB-->>App: Save accepted sourceItems as timeline_items
            App->>Redis: Mark task SUCCESS<br/>clear callbackTokenHash, TTL=24h
            App-->>AI: 200 OK
        end
    else invalid callback status
        App-->>AI: 400 Bad Request
    end
```

## 3. Poll Timeline Draft Task

```mermaid
sequenceDiagram
    autonumber
    participant Android
    participant App as App Server
    participant Redis
    participant DB as MySQL

    Android->>App: GET /api/{version}/timeline/drafts/{taskId}
    App->>Redis: GET timeline:draft-task:{taskId}

    alt task not found or TTL expired
        App-->>Android: 404 Not Found
    else status is PROCESSING
        App-->>Android: 200 OK<br/>{ status: "PROCESSING", result: null, error: null }
    else status is FAILED
        App-->>Android: 200 OK<br/>{ status: "FAILED", result: null, error }
    else status is SUCCESS
        App->>DB: Query generated timeline by DEFAULT_USER_ID + recordDate
        DB-->>App: daily timeline cards + items
        App-->>Android: 200 OK<br/>{ status: "SUCCESS", result, error: null }
    end
```

## Notes

- Redis task state stores `status`, `recordDate`, `error`, and `callbackTokenHash`.
- Redis does not store `dailyRecordId` or the original `sourceItems`.
- The AI server does not write directly to MySQL.
- Final validation and persistence happen on the app server callback path.
- `sourceItems` are echoed app server -> AI server -> app server callback for the MVP.
- On successful polling, the app server resolves the result by `(DEFAULT_USER_ID, recordDate)`.

## Linked Sources

- [[2026-06-19-notes-timeline-implementation-reconciliation]]
- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[server-to-server-auth-for-laimory]]
