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
[2026-06-20] answer | document why AWS root user should not be used for daily work and summarize IAM/Identity Center guidance
[2026-06-20] answer | document AWS Organizations and IAM Identity Center account/resource model
[2026-06-20] answer-update | add staged guidance for existing AWS workload resources in a management account
[2026-06-20] answer-update | add alternative path to create a new empty management account and invite the existing resource account
[2026-06-20] planning-note | record itemType column plan and payload discriminator correction
[2026-06-20] planning-note | fold BaseEntity auditing plan into the current timeline backend change note
[2026-06-20] planning-note | add MySQL draft persistence and evaluation table plan for AI failure recovery
[2026-06-20] planning-note | revise draft persistence plan to remove AI result DB table and move evaluation storage outside app MySQL
[2026-06-20] planning-note | keep Redis task state and scope MySQL persistence to draft source items with callback retry guidance
[2026-06-20] planning-note | add Timeline Card to Timeline Event domain rename plan
[2026-06-20] planning-note | add explicit primary key and foreign key naming plan
[2026-06-21] planning-note | add generic API response envelope plan with HTTP status and app code guidance
[2026-06-21] planning-note | define record_date as a noon-boundary local record day with timezone guidance
[2026-06-21] planning-note | clarify client sends occurrence instant and timezone while server computes record_date
[2026-06-21] ingest | ingest VPC cost investigation note (SSM interface endpoints) as source page and cross-link AWS answer pages
[2026-06-21] answer | document how Laimory backend mentor feedback maps to planned server code changes
[2026-06-26] design-note | revise AI daily timeline Agent draft around input, expected output, and high-level Agent structure
[2026-06-26] design-note | add Event normalization and batch synthesis plus selective re-orchestration rationale to AI daily timeline Agent draft
[2026-06-26] design-note | clarify Reflection-driven Main Agent orchestration and remove USER_PROVIDED from AI inference levels
[2026-06-26] design-note | update AI daily timeline parallel architecture diagram to include Reflection and re-orchestration loop
[2026-06-26] design-note | clarify revised timelines are re-evaluated by Reflection after re-orchestration
[2026-06-26] design-note | revise AI daily timeline repair path into an explicit bounded Reflection loop
[2026-06-27] design-note | add ReflectionIssue schema as Main Agent re-orchestration input for AI daily timeline Agent
[2026-06-27] design-note | add test-suite evaluation and observability plan for AI daily timeline Agent workflow traces
[2026-06-27] design-note | document Event type meanings and usage criteria for AI daily timeline Agent
[2026-06-27] design-note | rename Main Agent to Repair Orchestrator to scope it to the Reflection repair loop
[2026-06-27] design-note | add sourceId and targetSourceRefs guidance for scoped repair orchestration
[2026-06-27] design-note | rename Repair Orchestrator to Repair Agent in AI daily timeline Agent design
[2026-06-27] design-note | reorder Agent structure so Repair Agent appears after Reflection and ReflectionIssue
[2026-06-27] design-note | translate AI daily timeline structure explanation labels to Korean while preserving Agent and schema names
[2026-06-27] ingest | ingest AI daily timeline Agent draft into source, topic, entity, and index pages
[2026-06-27] ingest | document Laboratory mobile data extraction code and propose JSON/table payload structure for timeline source item upload
[2026-06-27] answer-update | add field importance tiers to Laboratory mobile data extraction payload documentation
[2026-06-27] answer-update | reorganize mobile extraction payload docs by photo, sleep, calendar, notification, and expected stay/move location item formats
[2026-06-27] maintenance | rewrite README as a human-facing guide for using the LLM Wiki vault
