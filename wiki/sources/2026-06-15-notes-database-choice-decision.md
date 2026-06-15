---
title: Database choice decision - MySQL
source_type: notes
source_path: raw/notes/2026-06-15-database-choice-decision.md
ingest_date: 2026-06-15
status: ingested
tags: [backend, database, mysql, postgresql, json, decision]
---

# Database Choice Decision - MySQL

## Summary

Decision note comparing MySQL, PostgreSQL, and NoSQL as Laimory's primary database.

The final decision is MySQL 8.4 LTS.

## Key Claims

- Laimory's MVP data is primarily relational: users, daily records, timeline items, photos, locations, AI outputs, permissions, and subscriptions.
- PostgreSQL is attractive because JSONB is stronger for database-side JSON search and indexing.
- MySQL also supports JSON storage, which is enough if JSON is used for raw AI responses, mobile event payloads, and optional metadata rather than as the main query surface.
- The team does not expect the MVP to search deeply inside JSON documents.
- AI can receive selected timeline items with explicit timeline IDs and return related IDs, reducing the need for database-side JSON internal search.
- Frequently searched, filtered, sorted, or joined fields should be normal columns; flexible or changing payloads can be JSON.
- If a JSON field becomes a repeated query condition, it should be promoted to a column or generated column.
- NoSQL may be useful later for auxiliary logs, caches, embeddings, or AI memory artifacts, but it is not the right primary MVP database.

## Caveats

- PostgreSQL may become a better choice if JSONB-heavy search, analytics, PostGIS-style geospatial queries, or complex semi-structured querying become core product requirements.
- The decision is based on MVP speed, team familiarity, and expected query patterns, not direct benchmark testing.

## Related Pages

- [[2026-06-15-notes-backend-version-decision]]
- [[2026-06-15-markdown-notion-tech-spec]]
- [[2026-06-15-markdown-notion-erd]]
- [[laimory]]
