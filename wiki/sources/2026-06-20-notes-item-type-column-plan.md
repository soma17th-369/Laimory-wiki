---
title: Timeline Backend Change Plan
source_type: notes
source_path: raw/notes/2026-06-20-item-type-column-plan.md
ingest_date: 2026-06-20
status: planned
tags: [backend, timeline, jpa, jackson, payload, auditing]
---

# Timeline Backend Change Plan

## Summary

Planning note for backend changes discussed in the current session.

The first change is to make `timeline_items.item_type` the persisted discriminator and remove `itemType` from payload JSON.

The corrected design is that `payload` does not need its own discriminator when the application reads a full `timeline_items` row. The row's `item_type` column can be combined with the payload JSON to restore the correct `TimelineItemPayload` subtype.

The second change is to add common audit fields through a JPA `BaseEntity`: `created_at`, `updated_at`, and `modified_by_type`. `modified_by_type` records whether the latest modification came from a user flow or an operation/server flow.

The third change is to keep Redis for short-lived draft task status while moving pre-refinement source items into MySQL. AI results should return through the callback in the MVP, and evaluation data should be exported to external storage rather than stored in the app MySQL database.

The fourth change is to rename the grouped timeline unit from `Timeline Card` to `Timeline Event`, keeping `card` as UI language only.

The fifth change is to rename generic database primary key columns from `id` to explicit names such as `daily_record_id`, so referenced primary keys and foreign keys share the same column name.

The sixth change is to standardize app-facing API responses with a generic envelope containing `header.code`, `header.message`, and `body`, while preserving meaningful HTTP status codes.

The seventh change is to define `record_date` as a Laimory record-day label whose local-day boundary is noon rather than midnight. The client should send source occurrence instants and the user's IANA time zone, and the server should calculate `record_date`.

## Key Claims

- `payload` should not contain `itemType`.
- API DTOs should expose `itemType` as a sibling of `payload`.
- `timeline_items.item_type` should be the persisted discriminator.
- Deserializing the payload column alone is not a supported path after removing `payload.itemType`.
- Reading a full row is valid because `item_type` and `payload` are available together.
- The current `@JdbcTypeCode(SqlTypes.JSON) private TimelineItemPayload payload` approach should be replaced or wrapped so row-level `itemType` can participate in payload restoration.
- `schema.sql` and tests must change because the project runs JPA with `ddl-auto=validate`.
- `modified_by_type` is clearer than `modified_by` for the current requirement because the value is an actor category such as `USER` or `OPERATION`.
- A `@MappedSuperclass` base entity is the right fit for common audit columns because it contributes mapped fields to child entities without creating its own table.
- Spring Data JPA auditing annotations should be used for timestamps and modifier type instead of manually setting these values in every service.
- App-server JPA auditing does not populate rows written directly by the AI server; AI-side writes must follow the same audit contract explicitly or with its own auditing setup.
- Redis should remain the MVP source for short-lived draft task status, callback token hashes, and app polling.
- MySQL should store `timeline_draft_source_items` so pre-AI source payloads are not lost when the AI server dies.
- Final timeline tables should only receive validated accepted data from the app server.
- A separate AI results table is not necessary for the MVP because AI results can return through the callback and be validated immediately by the app server.
- App-server callback crash handling should rely on AI callback retry, transaction rollback, and idempotent callback handling.
- Evaluation data should be exported to external storage, not stored in the app MySQL database.
- Stale Redis `PROCESSING` tasks still need timeout/retry handling so failed AI workers do not leave ambiguous user-facing state.
- `Timeline Event` is a better backend domain term than `Timeline Card` because the unit is persisted domain data, while card is only a UI presentation shape.
- Use `TimelineEvent` instead of bare `Event` to avoid confusion with calendar events, analytics events, application events, or domain events.
- Database primary keys should use explicit names such as `daily_record_id`, `timeline_event_id`, and `timeline_item_id` rather than generic `id`.
- Foreign key columns should use the same name as the referenced primary key, such as `timeline_events.daily_record_id` referencing `daily_records.daily_record_id`.
- App-facing APIs can use a generic `ApiResponse<T>` envelope, but should not convert every outcome into HTTP 200.
- `header.code` should be a stable app-specific machine-readable code, while `header.message` remains human-readable and not parsed for client logic.
- Error responses should be centralized through controller advice.
- RFC 9457 Problem Details is the public HTTP standard for error bodies, so the envelope is a deliberate mobile-app/team convention rather than a universal best practice.
- `record_date` should be computed from the user's local time zone using a noon boundary: local times before 12:00 belong to the previous `record_date`.
- Use IANA time zone IDs such as `Asia/Seoul`, not fixed offsets such as `UTC+9`, so global users and daylight saving rules can be handled correctly.
- The client should provide source occurrence/start instants plus `recordTimeZone`; the server should calculate and validate `record_date`.
- Server receive time should not be the normal basis for `record_date`, because uploads may be delayed relative to actual source occurrence.

## Caveats

- This note supersedes earlier notes that treated `payload.itemType` as the single authority.
- If old rows exist, a migration must backfill `item_type` from `payload.itemType` and remove `itemType` from payload JSON.
- The exact implementation can use a mapper/service method or a more custom Hibernate mapping, but the domain contract remains the same: type lives outside payload.
- Existing rows need a backfill before enforcing `NOT NULL` audit columns.
- The current Redis-only `TimelineDraftTask` record is out of scope for `BaseEntity` unless it becomes a JPA entity.
- Endpoint-prefix-based actor detection is acceptable for the MVP, but authentication context should become the better source once authenticated user flows are implemented.
- Raw source retention needs an explicit privacy policy; successful requests can delete raw data after evaluation export, while failed requests may need short-term debug retention.
- If the AI server reads directly from MySQL, it should read draft source rows, not write final `daily_records`, `timeline_cards`, or `timeline_items`.
- Renaming `TimelineCard` to `TimelineEvent` affects DB schema, Java class names, repository/service/DTO names, JSON fields, tests, glossary, and AI callback contract.
- PK/FK renaming affects DDL, JPA `@Column` mappings, repository assumptions, DTO mapping, tests, indexes, and foreign key constraint names.
- API response wrapping affects every controller return type and test assertion; health, actuator, file/download, and server-to-server callback endpoints may be excluded if appropriate.
- The noon-based `record_date` rule must be centralized and tested; server timezone, UTC midnight, or ordinary local midnight should not be used by accident.

## Related Pages

- [[2026-06-19-notes-timeline-implementation-reconciliation]]
- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[2026-06-16-notes-timeline-card-grouping-design]]
