---
title: AI Daily Timeline Agent Draft
source_type: notes
source_path: raw/notes/2026-06-20-ai-daily-timeline-agent-draft.md
ingest_date: 2026-06-27
status: ingested
tags: [laimory, ai-agent, timeline, input-output, agent-architecture]
---

# AI Daily Timeline Agent Draft

## Summary

Revised design note for the Laimory AI daily timeline Agent.

The current draft is scoped as a design document, not an implementation contract. It focuses on the input data the Agent receives, the shared `Event` normalization unit, the expected timeline draft output, the high-level Agent structure, and the core design principles.

The design uses data-specific Event Agents to interpret different source types into common `Event` candidates, then a Timeline Agent to combine those results into a user-editable daily timeline. The current architecture choice is `Batch Synthesis + Reflection-driven Re-orchestration`: baseline generation runs available data-specific agents in a deterministic parallel workflow, then Reflection, Repair Agent follow-up planning, selected sub-agent recall, and timeline reconstruction repeat as a bounded repair loop until the timeline can finish or unresolved issues become warnings/questions.

The revised note also defines a test-suite-based evaluation and observability plan for collecting Agent/workflow traces during development.

## Sections

- Overview
- Input
- Event
- Expected Output
- Agent Structure
- Processing Direction
- Design Principles
- MVP Success Criteria
- Evaluation and Observability

## Caveats

- Exact DTO names and API payload compatibility still need reconciliation with implementation.
- The `Event` schema is a design-level shared candidate shape, not yet a final API or database contract.
- Internal Agent schemas, validation metrics, model choices, and follow-up implementation details are intentionally not finalized in this design note.

## Key Claims

- The design document should primarily define input and expected output, not implementation-internal schemas.
- Input data includes location, calendar, photo, sleep, activity, notification, and user memory data.
- Different raw data types are normalized into common `Event` candidates before timeline synthesis.
- Raw and derived input items should have stable `sourceId` values so repair orchestration can target only relevant sources instead of resending all data.
- `Event` candidates carry source references, confidence, inference level, and uncertainty.
- Event type candidates are documented with usage criteria, including conservative handling for calendar attendance, meal inference, social context, rest, and unknown activity.
- AI `Event` candidates are not saved directly; the Timeline Agent merges them into a timeline draft that the app server can validate and map to the backend timeline model.
- Expected output is a user-editable timeline draft with events, questions, and warnings.
- Data-specific Event Agents interpret each data type and produce event-level interpretations.
- The Timeline Agent combines data-specific interpretations into a single daily timeline draft.
- Reflection Agent evaluates the initial timeline for conflicts, missing evidence, overconfident inference, and hallucination risk.
- Reflection Agent returns structured `ReflectionIssue[]` results so the Repair Agent can decide whether to recall sub-agents, re-synthesize, ask the user, warn, or ignore.
- ReflectionIssue can include `targetSourceRefs` so follow-up calls can be scoped to specific source ids and time ranges.
- The selected MVP processing direction is deterministic parallel baseline execution plus Reflection-driven selective sub-agent re-orchestration by the Repair Agent.
- Re-orchestrated timeline changes go back into the Reflection loop until no important issue remains, only user-question/warning issues remain, or the loop limit is reached.
- Development evaluation should use hand-written test cases with expected behavior and LLM judge scoring.
- Runtime observability should capture run-level and node-level traces, including Agent inputs/outputs, ReflectionIssue results, follow-up plans, latency, token usage, model calls, warnings, and errors.
- User Memory Data is treated as supporting context and should not independently confirm real-world events.
- Uncertain or conflicting evidence should be represented as uncertainty, user questions, or warnings rather than invented events.
- Implementation details such as internal contract fields, reflection loops, patches, and evaluation metrics should be decided during implementation.

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[ai-daily-timeline-generation]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-16-notes-timeline-card-grouping-design]]
- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[2026-06-19-notes-timeline-implementation-reconciliation]]

