---
source_type: notes
title: Database choice decision - MySQL
captured_at: 2026-06-15
status: raw-decision-note
---

# Database Choice Decision - MySQL

## Context

The team needed to decide whether Laimory should use MySQL, PostgreSQL, or a NoSQL database as the primary database.

The backend stack decision already favored fast development and low environment friction:

- Spring Boot 3.5.x
- Java 21
- MySQL 8.4 LTS as the initial database candidate

The main open question was whether PostgreSQL would be a better fit because Laimory may handle flexible data such as AI responses, mobile event metadata, photo metadata, location context, and timeline enrichment data.

## Decision Criteria

The team prioritized:

1. Fast MVP development within a short schedule
2. Low setup and troubleshooting friction
3. Stable compatibility with Spring Boot, JPA, migration tools, Docker, and common examples
4. A relational model that fits users, timelines, photos, locations, daily records, AI outputs, and subscriptions
5. Enough JSON flexibility for changing AI/mobile metadata without making JSON querying the center of the system

## Candidate Comparison

### MySQL 8.4 LTS

Pros:

- Strong fit for relational MVP data such as users, daily records, timeline items, photos, locations, subscriptions, and AI generation logs
- Familiar and common in Spring Boot/JPA examples
- Lower expected team learning and troubleshooting cost
- MySQL supports a native JSON type, so flexible metadata and raw AI/mobile payloads can still be stored
- MySQL 8.4 is an LTS line, which matches the team's stability criterion

Cons:

- PostgreSQL has stronger and more natural support for querying and indexing inside JSON documents
- JSON-heavy analytics or flexible internal search patterns may require generated columns, multi-valued indexes, or promoting fields into normal columns

Assessment:

MySQL is a strong fit if JSON is used mainly for raw AI responses, mobile event payloads, optional metadata, and fields that are not frequently searched directly inside the database.

### PostgreSQL

Pros:

- Strong JSONB support for storing, searching, indexing, and querying inside JSON documents
- Attractive long-term fit if Laimory heavily searches AI-inferred emotion, activity, place, context, or pattern data stored inside JSON
- Rich extension ecosystem, including strong geospatial options such as PostGIS if location analysis becomes central

Cons:

- Basic Spring Boot/JPA CRUD usage is not difficult, but using PostgreSQL well introduces more PostgreSQL-specific concepts
- The team may need to understand JSONB, GIN indexes, jsonpath, extension behavior, timestamp/time zone details, explain plans, and PostgreSQL-specific tuning earlier than planned
- AI and ORM tools reduce manual SQL writing, but they do not remove database design, indexing, migration, and query debugging responsibilities

Assessment:

PostgreSQL is technically attractive, especially for JSONB and long-term location or semi-structured data use cases. However, its strongest advantages matter less if the MVP does not need to search deeply inside JSON documents.

### NoSQL

Pros:

- Flexible document storage
- Useful for rapidly changing event-shaped or AI-shaped data

Cons:

- Laimory's core data has important relationships: users, daily records, timeline items, photos, locations, AI outputs, permissions, and subscriptions
- Relational consistency and transactional behavior are more important than document flexibility for the primary MVP database
- Adds unnecessary architectural complexity if used as the main database at this stage

Assessment:

NoSQL may become useful later as an auxiliary store for logs, caches, embeddings, or AI memory artifacts, but it is not the right primary database for the MVP.

## Key Product Assumption

The team does not expect the MVP to search deeply inside JSON documents.

Instead, Laimory can model the main timeline as relational data and pass selected timeline items to AI with stable identifiers:

```json
[
  {
    "timelineItemId": "tl_123",
    "time": "18:30",
    "type": "photo",
    "summary": "Photos taken at a cafe",
    "place": "Seongsu cafe"
  }
]
```

The AI can return related timeline IDs:

```json
{
  "answer": "The cafe visit looks like the key memory from the evening.",
  "relatedTimelineItemIds": ["tl_123"]
}
```

With this structure, the database mostly needs to query by user, date, timeline ID, source type, and time order. These are normal relational access patterns that MySQL handles well.

## Design Rule

The team should use this rule to avoid painting itself into a corner:

```text
Frequently searched, filtered, sorted, or joined values should be normal columns.
Flexible AI responses, original mobile event payloads, and optional metadata can be JSON.
If a JSON field becomes important for repeated filtering or sorting, promote it to a column or generated column.
```

Possible relational core tables:

- users
- daily_records
- timeline_items
- photos
- locations
- ai_generation_logs
- subscriptions

Possible JSON use cases:

- original AI response payload
- raw mobile event payload
- photo EXIF subset
- location inference candidates
- model confidence scores
- optional metadata that may change often

## Final Decision

Final database decision:

- MySQL 8.4 LTS as the primary database

## Rationale

PostgreSQL is attractive because its JSONB support is stronger than MySQL's JSON support. However, Laimory's MVP is not expected to depend on database-side JSON internal search.

The product can keep the core domain model relational and use JSON only for flexible metadata or raw payload storage. AI can receive timeline items with explicit IDs and return those IDs, which reduces the need for complex JSON querying inside the database.

Given the short development timeline, the team values low environment friction, familiar Spring Boot/JPA examples, and predictable relational modeling more than PostgreSQL's stronger JSONB capabilities.

## Team-Facing Summary

We chose MySQL 8.4 LTS because Laimory's MVP data is primarily relational: users, daily records, timeline items, photos, locations, AI outputs, and subscriptions. PostgreSQL's JSONB is attractive, but the MVP does not require frequent database-side searching inside JSON documents. We can store flexible AI and mobile metadata in MySQL JSON columns while keeping frequently queried values as normal columns. This gives the team enough flexibility while preserving the low-friction, stable development environment needed for a short portfolio project.
