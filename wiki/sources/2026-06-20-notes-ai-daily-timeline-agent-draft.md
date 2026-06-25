---
title: AI Daily Timeline Agent Draft
source_type: notes
source_path: raw/notes/2026-06-20-ai-daily-timeline-agent-draft.md
ingest_date: 2026-06-20
status: draft
tags: [laimory, ai-agent, timeline, multi-agent, memory-schema, tools, prompt, evaluation]
---

# AI Daily Timeline Agent Draft

## Summary

Draft planning note for the Laimory AI daily timeline Agent.

The current design centers on a Main Timeline Agent that owns the entire generation flow from the beginning. The Main Agent inspects raw daily data, selectively calls data-specific Sub Agents when specialist interpretation is needed, verifies their outputs, and creates editable daily timeline events.

The updated draft defines `userMemory` as concrete persisted variables rather than a vague context layer, expands tool roles and input/output responsibilities, and records an initial LLM/API/framework decision.

## Sections

- Overview
- Input
- Memory
- Reasoning
- Tools
- Output
- Prompt
- Failure Handling
- Evaluation

## Caveats

- Input was drafted by the user and still needs encoding cleanup in the local file display.
- Exact DTO names and API payload compatibility still need reconciliation with the implementation.
- Concrete model names should be selected at implementation time based on current price, latency, and quality.
- LangGraph and CrewAI were evaluated at a design level only; no prototype comparison has been run yet.

## Key Claims

- The Agent should use a Main-led orchestration architecture rather than a sequential Sub-Agent-first pipeline.
- Sub Agents should exist for location, calendar, photo, sleep, activity, notification, and user memory data.
- Sub Agents should be called selectively by the Main Agent when specialist interpretation is needed.
- Sub Agents should not create the final timeline; they should return bounded evidence with confidence, source references, and uncertainty.
- The Main Timeline Agent should inspect raw data, decide which Sub Agents to call, verify their outputs, resolve conflicts, generate events, and produce questions for unclear time ranges.
- Memory should be stored as explicit variables such as `places`, `people`, `routines`, `preferences`, `eventCorrectionStats`, `expressionPreferences`, and `privacyPreferences`.
- Memory should help interpret user-specific places, people, routines, and correction patterns, but should not create events by itself.
- Tools should handle deterministic or verifiable work such as time normalization, location clustering, movement segmentation, reverse geocoding, schema validation, source-reference checking, and groundedness scoring.
- The recommended MVP path is a Python AI server using OpenAI Responses API, Pydantic schema validation, and direct Main-led orchestration code.
- LangGraph should be considered in a later iteration if durable execution, retries, human-in-the-loop, or evaluation loops become complex enough.
- CrewAI is better treated as a prototype comparison candidate than the default architecture because the product needs Main-led control more than autonomous agent-team collaboration.
- Failure handling should degrade gracefully when one Sub Agent fails.
- Evaluation should prioritize Main Agent orchestration quality while separately checking Sub Agent specialist quality.

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-16-notes-timeline-card-grouping-design]]
- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[2026-06-19-notes-timeline-implementation-reconciliation]]
