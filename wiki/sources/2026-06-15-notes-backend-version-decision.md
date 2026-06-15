---
title: Backend version decision - Spring Boot and Java
source_type: notes
source_path: raw/notes/2026-06-15-backend-version-decision.md
ingest_date: 2026-06-15
status: ingested
tags: [backend, tech-spec, spring-boot, java, decision]
---

# Backend Version Decision - Spring Boot and Java

## Summary

Decision note comparing three backend version candidates for the Laimory project:

- Spring Boot 4.0.x + Java 25
- Spring Boot 3.5.x + Java 25
- Spring Boot 3.5.x + Java 21

The final decision is Spring Boot 3.5.x + Java 21, with MySQL 8.4 LTS.

## Key Claims

- The project has a short development period, so minimizing environment and compatibility friction is a primary decision criterion.
- Spring Boot 4.0.x + Java 25 has the strongest latest-stack portfolio appeal, but also the highest expected compatibility and troubleshooting risk.
- Spring Boot 3.5.x + Java 25 is a balanced option, but Java 25 still requires extra toolchain verification.
- Spring Boot 3.5.x + Java 21 best matches the team's current constraints because Java 21 is LTS and broadly supported across common backend tooling.
- The team considers an LTS release older than roughly half a year to be sufficiently stable in principle, but project-specific delivery constraints are more important than version freshness.

## Caveats

- This is a team decision note, not a benchmark or production incident analysis.
- The decision is based on development timeline, portfolio needs, and expected ecosystem friction rather than direct performance testing.

## Related Pages

- [[2026-06-15-markdown-notion-tech-spec]]
- [[laimory]]
