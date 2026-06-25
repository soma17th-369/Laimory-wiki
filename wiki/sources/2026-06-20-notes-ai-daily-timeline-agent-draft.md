---
title: AI Daily Timeline Agent Draft
source_type: notes
source_path: raw/notes/2026-06-20-ai-daily-timeline-agent-draft.md
ingest_date: 2026-06-20
status: revised draft
tags: [laimory, ai-agent, timeline, input-output, agent-architecture]
---

# AI Daily Timeline Agent Draft

## Summary

Revised design note for the Laimory AI daily timeline Agent.

The current draft is scoped as a design document, not an implementation contract. It focuses on the input data the Agent receives, the expected timeline draft output, the high-level Agent structure, and the core design principles.

The design uses data-specific Event Agents to interpret different source types, then a Timeline Agent to combine those results into a user-editable daily timeline. Internal schemas, patch formats, reflection loops, and evaluation metrics are intentionally left for implementation-time design.

## Sections

- Overview
- Input
- Expected Output
- Agent Structure
- Processing Direction
- Design Principles
- MVP Success Criteria

## Caveats

- Input was drafted by the user and still needs encoding cleanup in the local file display.
- Exact DTO names and API payload compatibility still need reconciliation with implementation.
- Internal Agent schemas, orchestration details, validation metrics, and model choices are intentionally not finalized in this design note.

## Key Claims

- The design document should primarily define input and expected output, not implementation-internal schemas.
- Input data includes location, calendar, photo, sleep, activity, notification, and user memory data.
- Expected output is a user-editable timeline draft with events, questions, and warnings.
- Data-specific Event Agents interpret each data type and produce event-level interpretations.
- The Timeline Agent combines data-specific interpretations into a single daily timeline draft.
- User Memory Data is treated as supporting context and should not independently confirm real-world events.
- Uncertain or conflicting evidence should be represented as uncertainty, user questions, or warnings rather than invented events.
- Implementation details such as internal contract fields, reflection loops, patches, and evaluation metrics should be decided during implementation.

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-16-notes-timeline-card-grouping-design]]
- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[2026-06-19-notes-timeline-implementation-reconciliation]]
