# Log

[2026-06-13] bootstrap | initialize LLM Wiki folder structure, index, and log from AGENTS.md
[2026-06-13] maintenance | move reference documents into references/ and update index links
[2026-06-14] maintenance | move team-facing explanation documents to repository root and update index
[2026-06-14] maintenance | add CLAUDE.md pointer to AGENTS.md and update index
[2026-06-15] source-capture | capture selected Notion 369 team and Laimory materials into raw/markdown/notion/369-team, excluding mentoring and special lecture pages
[2026-06-15] ingest | ingest Notion 369 team and Laimory raw captures into wiki source, entity, and topic pages
[2026-06-15] decision-note | record backend version decision rationale for Spring Boot 3.5.x and Java 21
[2026-06-15] decision-note | record database choice rationale for MySQL 8.4 LTS
[2026-06-16] raw-design-note | draft Laimory timeline card grouping ERD and server-side grouping sequence
[2026-06-16] raw-design-note | revise timeline card grouping draft with simplified timeline_items and example data
[2026-06-16] raw-design-note | add typed-table alternative for timeline item polymorphism
[2026-06-16] raw-design-note | replace timeline DB drafts with typed payload JSON design and option comparison
[2026-06-16] raw-design-note | revise timeline design so source candidates become timeline_items only after AI card acceptance
[2026-06-16] raw-design-note | rename AI card generation contract from candidates to request-scoped itemIds and reject nullable pre-insert items
[2026-06-16] raw-design-note | define AI request itemId as source item array index before DB insert
[2026-06-16] ingest | ingest timeline card grouping and typed payload design into wiki source page
[2026-06-16] documentation | add Laimory DDD ubiquitous language glossary
[2026-06-16] documentation | remove ubiquitous language glossary from wiki repo; keep it for development project context only
[2026-06-18] ingest | ingest timeline draft API thought-process note as source page for server-to-server auth answer
[2026-06-18] answer | document server-to-server auth options and Laimory recommendation for app server and AI callbacks
[2026-06-18] answer-update | clarify private-zone AI server auth and per-task callback token tradeoff
[2026-06-18] answer-update | switch Laimory MVP recommendation from X-Internal-Secret to one-time Callback-Token
[2026-06-19] maintenance | reconcile timeline draft API and storage notes with current server implementation
[2026-06-19] answer | add sequence diagrams for current timeline draft create, callback, and polling APIs
