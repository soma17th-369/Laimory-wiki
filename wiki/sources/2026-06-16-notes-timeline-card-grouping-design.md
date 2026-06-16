---
title: Timeline Card Grouping And Typed Payload Design
source_type: notes
source_path: raw/notes/2026-06-16-timeline-card-grouping-design.md
ingest_date: 2026-06-16
status: ingested
tags: [laimory, timeline, database-design, ai-card-generation, ddd]
---

# Timeline Card Grouping And Typed Payload Design

## Summary

Raw design draft for Laimory's MVP timeline database model and AI-assisted card generation flow.

The current decision is a three-level model:

```text
daily_records
timeline_cards
timeline_items
```

Android/source data is first handled as temporary source items. The backend sends these source items to AI with request-scoped `itemId`s based on the source item array index. AI returns card proposals with `title`, `subtitle`, time range, and `itemIds`. After server validation, only source items included in valid cards are persisted as `timeline_items`.

## Key Claims

- `daily_records` represents one user's record for one date and should be unique by `(user_id, record_date)`.
- `timeline_cards` is the user-visible card unit and stores `title`, `subtitle`, and `memo`.
- `timeline_items` is not a raw source archive; it stores only AI-accepted source events under exactly one timeline card.
- `timeline_items.payload` is stored as JSON in MySQL, but Java should use typed payload objects, not `Map<String, Object>`.
- The recommended Java model is a sealed `TimelineItemPayload` interface with payload records such as `PhotoPayload`, `CalendarPayload`, `LocationPayload`, and `MovementPayload`.
- AI request `itemId` values are request-local 0-based array indexes, not database primary keys.
- Cards and items must be saved in one database transaction; AI calls should happen outside the transaction.
- `timeline_items.timeline_card_id` should be non-null and card deletion should cascade to child items.
- If additional source data arrives for an existing day, existing cards/items/title/subtitle/memo should not be automatically modified; new cards should be appended.

## Design Decisions

### Payload Storage

The document compares three options:

```text
1. Raw JSON with Map<String, Object>
2. DB inheritance / typed detail tables
3. Typed payload JSON
```

The current MVP decision is typed payload JSON because it preserves table simplicity and item-type extensibility while reducing Java-side human error.

### Card-Item Relationship

The document compares:

```text
1. Card owns items directly
2. Daily record owns items and cards separately with a join table
```

The current MVP decision is direct ownership:

```text
timeline_cards -> timeline_items
```

because each persisted timeline item belongs to exactly one card, and omitted source items have no persisted timeline item identity.

## Caveats

- Payload JSON shape is not fully enforced by the database.
- Source items omitted by AI are not preserved in MVP.
- Regeneration policy for memo-bearing cards still needs a final decision.
- Card-level visibility and title/subtitle editability are still open questions.
- If raw source preservation, multi-card references, or AI generation history become important, the model may need a source archive table or card-item join table later.

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[2026-06-15-notes-database-choice-decision]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-15-markdown-notion-erd]]

