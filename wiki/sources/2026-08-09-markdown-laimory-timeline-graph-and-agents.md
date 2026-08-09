---
title: Timeline LangGraph와 Agent 엔지니어링
source_type: markdown
source_path: raw/markdown/ai system document/02-timeline-graph-and-agents.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, timeline, langgraph, event-agent, repair-agent, question-agent]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# Timeline LangGraph와 Agent 엔지니어링

## Summary

현재 Timeline main graph는 `run_event_agents → merge_results → run_timeline_agent → run_repair_agent → run_question_agent`의 고정 구조다. Location, Calendar, Photo, Sleep/Activity, Notification Event Agent는 첫 node 안에서 병렬 실행되고 Candidate와 Fragment를 만든다. Timeline Agent가 이를 사건 단위로 의미 병합하고, Repair Agent가 결정론적 confirm과 제한된 도구 반복을 적용한 뒤 Question Agent가 확정 event에 회고 질문을 붙인다.

이 구현은 과거 설계 노트의 별도 Reflection Agent 중심 구조와 다르다. 현재는 Repair Agent 자체가 LLM 분석, 도구 실행, 결정론적 confirm을 결합한다.

## Key Claims

- Event Agent 실패는 빈 결과와 warning으로 격리하고 다른 domain의 결과를 계속 처리한다.
- Candidate는 event가 될 만한 근거, Fragment는 다른 source와 결합할 보조 단서다.
- Event Agent 이름은 Repair가 특정 Agent 결과를 교체하는 실행 key다.
- User Memory는 Timeline과 Question의 보조 context지만 Event Agent와 Repair에는 주입하지 않는다.
- Question Agent는 현재 모든 확정 event에 질문 하나를 시도하고, 누락 event만 한 번 재요청한다.
- 최종 result validation 실패는 task를 중단하지만 개별 질문 누락이나 Repair LLM 실패는 확정 가능한 draft를 보존한다.

## Caveats

- Event Agent 문장은 사실 보고이며 최종 사용자 일기 문체 계약과 동일하지 않다.
- Langfuse graph 설명은 trace 계층을 나타내며 관측 실패가 task 결과를 바꾸지는 않는다.

## Related Pages

- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-runtime-and-observability]]
- [[2026-06-20-notes-ai-daily-timeline-agent-draft]]

