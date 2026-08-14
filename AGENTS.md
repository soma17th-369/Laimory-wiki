# AGENTS.md

This vault follows an LLM Wiki operating model:
raw sources are preserved, and the wiki is maintained as a compounding knowledge layer.

This file is the operating schema for this vault. It defines:

- the layer structure
- the ingest workflow
- the decision rules
- the maintenance behavior expected from the LLM

## Purpose

This vault is a personal research and knowledge system with three primary uses:

1. a personal research wiki across mixed source types
2. an archive of coding, AI agent, tooling, and adjacent technical patterns
3. a tracking layer for how AI changes jobs, work design, and labor-market narratives when those sources are substantive

The goal is not to answer questions by rediscovering everything from scratch every time.
The goal is to accumulate and maintain a persistent, structured wiki that improves over time.

## System Model

There are two main content layers and one reference layer:

1. source layer
   - human-supplied original materials
   - includes `Clippings/` and `raw/`

2. wiki layer
   - LLM-maintained knowledge pages
   - stored in `wiki/`

3. reference layer
   - conceptual and operating references
   - stored in `references/`

This vault also includes control files:

- `AGENTS.md`: schema and operating rules
- `index.md`: primary wiki catalog
- `log.md`: append-only maintenance log

## Structure Definition

### Source Layer

Original files provided or captured by the human.

- `Clippings/`: web clips and captured articles
- `raw/pdf/`: PDFs and PDF-adjacent raw materials
- `raw/social/`: social posts, threads, copied discussions
- `raw/social/threads/`: saved Threads captures kept one-file-per-post when accepted
- `raw/web/`: manually collected web pages or exports
- `raw/github/`: repository notes, README captures, GitHub-adjacent source notes
- `raw/markdown/`: Markdown exports, local documentation snapshots, converted documents, and folder-based Markdown source collections
- `raw/meetings/`: meeting transcript exports plus their LLM-derived raw summary files
- `raw/notes/`: personal notes, scratch notes, idea fragments

Rules:

- treat source files as the original record
- do not edit source files unless the human explicitly asks for correction
- preserve source path references in wiki pages

### Wiki Layer

The maintained knowledge layer.

- `wiki/sources/`: one page per ingested source, created first
- `wiki/topics/`: synthesis pages spanning multiple sources
- `wiki/entities/`: people, companies, products, repositories, libraries, organizations
- `wiki/answers/`: durable question answers worth keeping
- `wiki/domains/`: larger thematic clusters promoted only when they become substantial

### References

- `references/`: conceptual references, operating notes, and framing documents

Rules:

- treat `references/` as operating context, not as primary source material
- do not use `references/` as a substitute for `wiki/sources/` when ingesting external material
- use `references/` for schemas, conceptual framing, and local operating interpretations
- when a reference materially shapes the vault's behavior, keep it linked from `index.md`

## Ingest Workflow

When a new source is added, follow this workflow:

1. identify the source type and original path
2. read the source directly from `Clippings/` or `raw/`
3. create or update a page in `wiki/sources/`
4. extract key claims, entities, themes, dates, and useful links
5. update relevant pages in `wiki/topics/` and `wiki/entities/`
6. if the source materially contributes to an existing larger cluster, consider updating `wiki/domains/`
7. update `index.md` if pages were created or materially changed
8. append a concise entry to `log.md`

Rule:
Always create or update `wiki/sources/` before changing topic, entity, answer, or domain pages.

## Meeting Transcript Workflow

When meeting transcript files are added to `raw/meetings/`:

1. when the human drops in a `.txt` transcript, change only its extension to `.md` so Obsidian can display it; preserve the transcript body exactly
2. treat `대화 내용_*.md` as the original transcript and do not clean up or rewrite its body
3. create a separate `회의 요약_*.md` beside the transcript in the same meeting folder; this is the derived raw summary used as the ingest input
4. identify unprocessed transcripts by checking whether a `wiki/sources/` page references the summary as `source_path` and the original as `transcript_path`
5. derive `meeting_date` from an unambiguous date in the filename or content; keep `summary_date` and `ingest_date` separate
6. create or update one `wiki/sources/YYYY-MM-DD-meeting-<slug>.md` page from the raw summary before changing synthesis pages
7. set the wiki source page's `source_path` to `회의 요약_*.md` and `transcript_path` to `대화 내용_*.md`
8. treat the raw `회의 요약_*.md` as the detailed derived ingest input; the wiki source body may mirror it but must not contain material claims or detail absent from the raw summary
9. use `개요` and `상세 요약` as the main summary sections, followed when useful by decisions, proposals, action items, open questions, and caveats with timestamp evidence
10. distinguish explicitly between confirmed decisions, work reported as in progress, proposed alternatives, and unresolved questions
11. do not infer speaker identity, ownership, deadlines, or implementation status when the transcript does not establish them
12. preserve transcription uncertainty and flag terms that require checking against audio, code, issues, or another primary record
13. update existing topic and entity pages only when the meeting materially adds durable information
14. treat raw transcripts and summaries as potentially sensitive because they may contain personal schedules, locations, or operational details

Rule:
The human only needs to drop transcript files into `raw/meetings/`; Markdown conversion, adjacent raw summary creation, and wiki ingest are LLM-maintained work.

## Social Source Verification Workflow

When ingesting social posts that mention a repository, product, library, company, API, benchmark, or quantitative performance claim:

1. preserve the social post in `raw/` and create the corresponding `wiki/sources/` page first
2. treat the social post as a claim source, not as sufficient proof of tool quality or performance
3. check the primary source when reasonably possible before expanding topic or entity synthesis
   - preferred primary sources are official repositories, README files, docs sites, papers, or vendor pages
4. distinguish clearly between what was verified and what remains unverified
   - repository existence, README scope, and documented features may be recorded as checked
   - benchmark numbers, savings claims, adoption claims, and broad quality judgments should remain marked as unverified unless independently confirmed
5. if primary-source checking is not possible in the current run, keep the `wiki/sources/` page narrow and caveated
6. do not generalize a social-post claim into `wiki/topics/` or `wiki/entities/` as settled synthesis unless the underlying primary source has been checked or the uncertainty is made explicit

Rule:
For social sources with concrete repo, product, or performance claims, prefer a conservative source page over broad synthesis until primary-source verification has been done.

## Query Workflow

When answering a question:

1. read `index.md` first
2. read relevant pages in `wiki/`
3. consult `references/` when operating context, schema intent, or conceptual framing is needed
4. synthesize the answer from maintained wiki pages
5. consult raw sources when the wiki lacks detail, verification is needed, or the user explicitly asks for source-level checking
6. if the answer is durable and likely to be reused, save it in `wiki/answers/`
7. update `index.md` and `log.md` when durable artifacts are added

## Reference Workflow

Use `references/` for materials that help interpret or operate the vault itself.

Examples:

- LLM Wiki framing notes
- schema explanations
- operating conventions
- comparison notes about maintenance approaches

Rules:

- prefer `references/` when the file teaches the LLM how to work in the vault
- prefer `wiki/sources/` when the file is an external source being incorporated into the knowledge graph
- if a reference begins to accumulate substantive claims that should be cited in synthesis, ingest the original material into `wiki/sources/` and cross-link it
- keep references concise and link back to the original source when one exists

## Social Saved Capture State

Use provider-specific control files for each saved-post surface, for example:

- `references/social-saved-capture/threads-processing-mark.md`
- `references/social-saved-capture/threads-capture-checkpoint.md`
- `references/social-saved-capture/linkedin-processing-mark.md`
- `references/social-saved-capture/linkedin-capture-checkpoint.md`

Use two distinct control modes per provider.

- backlog mode:
  use `<provider>-capture-checkpoint.md` to resume deep historical review near the last processed scroll position
- frontier mode:
  use `<provider>-processing-mark.md` after the historical backlog has been fully reviewed

Rules:

- keep state files separate per provider; never share frontiers across platforms
- in frontier mode, start from the top of the provider's saved page and stop when the `newest_processed_post_url` becomes visible
- update the provider frontier file after each new batch so it points to the newest already-reviewed post below the new batch
- keep dedupe based on `source_url` and raw file presence even when a provider frontier file is present
- do not rely on scroll position alone once backlog review has been completed

## Page Creation Heuristics

### Create or update a source page when

- a new source enters the vault
- an existing source becomes relevant to new topics or entities
- an existing source page is too thin to support current synthesis

### Create or expand a topic page when

- multiple sources contribute to the same theme
- a recurring pattern, comparison, workflow, debate, or capability emerges
- a question keeps recurring across separate sources

### Create an entity page when

- a person, repository, company, product, library, or organization appears repeatedly
- the entity has enough importance to deserve stable context across multiple pages

### Create an answer page when

- a question result is likely to be useful again
- the answer synthesizes multiple wiki pages into a durable conclusion
- the answer would otherwise have to be re-derived repeatedly

### Create or update a domain page when

- a larger personal interest area grows beyond a few isolated topics
- several topic and entity pages naturally cluster into a durable domain
- the domain improves navigation more than it increases complexity

If in doubt:
prefer a stronger source page and update an existing topic or entity page instead of creating a thin new page.

## Page Conventions

Use concise markdown. Prefer light frontmatter only when it improves utility.

## Naming Convention

Use stable, descriptive filenames so pages remain easy to navigate and deduplicate.

### General Rules

- prefer lowercase kebab-case for slugs
- avoid vague names such as `notes`, `misc`, `temp`, or `new-page`
- rename cautiously once a page is already linked in multiple places
- keep filenames descriptive of the page itself, not of the current chat request

### Source Pages

- format: `wiki/sources/YYYY-MM-DD-<source_type>-<slug>.md`
- `source_type` should usually be one of: `web`, `social`, `github`, `pdf`, `markdown`, `notes`, `meeting`
- `slug` should describe the source artifact, repository, post, article, or topic
- keep the filename consistent with the `source_path` and page title

Examples:

- `wiki/sources/2026-04-18-web-karpathy-llm-coding-problems.md`
- `wiki/sources/2026-04-18-social-yogurtball-design-md.md`
- `wiki/sources/2026-04-18-github-claude-usage-tracker.md`

### Topic Pages

- format: `wiki/topics/<topic-slug>.md`
- use the recurring theme, workflow, comparison, or capability as the slug

### Entity Pages

- format: `wiki/entities/<entity-slug>.md`
- use the stable name of the person, repository, company, product, library, or organization

### Answer Pages

- format: `wiki/answers/<answer-slug>.md`
- use the durable question or conclusion as the slug, not conversational phrasing

### Domain Pages

- format: `wiki/domains/<domain-slug>.md`
- use broad, durable thematic names

### Source pages should usually include

- title
- source type
- source path
- ingest date
- status
- tags

Suggested body sections:

- Summary
- Key Claims
- Caveats
- Related Pages

### Topic, entity, answer, and domain pages should usually include

- title
- kind
- status
- updated
- tags

Suggested body sections:

- Scope
- Current Synthesis
- Key Points or Key Claims
- Open Questions
- Linked Sources
- Related Pages

## Decision Rules

1. Treat `Clippings/` and `raw/` as source-of-truth inputs.
2. Treat `wiki/` as the maintained knowledge layer.
3. Prefer updating existing wiki pages over creating near-duplicates.
4. Be conservative with page creation and aggressive about cross-linking.
5. Preserve uncertainty explicitly.
6. Call out contradictions instead of flattening them away.
7. Record meaningful maintenance work in `log.md`.
8. Keep `index.md` current enough to serve as the primary navigation layer.
9. Build synthesis pages from sources, not from vague memory.
10. When source detail matters, go back to the raw source instead of guessing.
11. Treat substantive AI labor-market and work-transition material as in-scope, not as off-topic general news.
12. Treat social posts about tools, repos, and performance as provisional until primary sources are checked or the uncertainty is stated explicitly.

## Maintenance Workflow

Periodically check for:

- orphan wiki pages
- references that affect behavior but are missing from `index.md`
- missing links between source, topic, entity, answer, and domain pages
- stale summaries
- duplicated topic pages
- entities mentioned repeatedly but not promoted into entity pages
- domains that should be promoted or split
- important answers that should be turned into durable pages

Document meaningful maintenance work in `log.md`.

## README Status Workflow

Treat the `현재 위키 상태` section in `README.md` as the human-facing freshness checkpoint and `log.md` as the complete append-only history.

After meaningful ingest, maintenance, or review-draft work:

1. append the detailed operation to `log.md` when required by the logging convention
2. update the README status in the same work unit
3. keep `마지막 상태 확인`, `main에 반영된 위키 기준`, `상태`, and `최근 작업` accurate
4. keep only a short recent-history summary in README and link to `log.md` for the full history
5. list material `status: awaiting-human-review` drafts that still require human action

Status rules:

- use a current or verified status only after the relevant vault lint checks have completed
- if unprocessed sources, uncommitted maintenance work, or review drafts exist, state that explicitly instead of claiming the wiki is fully current
- distinguish the last status-check date from the date through which approved wiki content is reflected on `main`
- whenever a change makes the README status inaccurate, updating that status is part of completing the change

## Lint Workflow

Run a lightweight vault check during maintenance or after meaningful ingest work.

1. read `index.md`
2. convert leftover `.txt` transcripts under `raw/meetings/` to body-identical Markdown, verify every canonical `대화 내용_*.md` has one adjacent `회의 요약_*.md`, and verify each pair is referenced by a `wiki/sources/` page through `source_path` and `transcript_path`; then check remaining source files in `Clippings/` or `raw/`, including folder-based Markdown collections under `raw/markdown/`
3. check for `wiki/` pages that are missing from `index.md`
4. check for weak or missing cross-links between source, topic, entity, answer, domain, and reference pages
5. check for stale, duplicate, orphan, or overly thin pages that should be expanded, merged, or better linked
6. update `index.md` and append a concise maintenance entry to `log.md` if meaningful changes were made

## Logging Convention

Append concise entries to `log.md` in a stable chronological format.

Suggested format:

`[YYYY-MM-DD] <operation> | <summary>`

Examples:

- `[2026-04-18] bootstrap | initialize javis vault structure`
- `[2026-04-18] ingest | ingest Threads post on agent skills`
- `[2026-04-18] maintenance | merge overlapping topic pages for agent instruction files`

## Preferred Behavior

- Build compounding knowledge, not chat residue
- Keep the wiki navigable
- Use the wiki first during answering
- Return to raw sources when verification is needed
- Favor synthesis over accumulation
- Favor explicit uncertainty over false confidence

## Summary

The shortest correct interpretation of this file is:

- `Clippings/` and `raw/` are the source layer
- `wiki/` is the maintained knowledge layer
- `AGENTS.md` defines the structure, workflow, and decision rules
- ingest goes from source to wiki
