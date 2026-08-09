---
title: AI Daily Timeline Generation
kind: topic
status: active
updated: 2026-08-09
tags: [laimory, ai-timeline, ai-agent, event-normalization, lifelogging]
---

# AI Daily Timeline Generation

## Scope

Laimory에서 하루 동안 수집된 모바일 생활 데이터를 AI가 사용자 수정 가능한 timeline draft로 변환하는 설계 주제.

## Current Synthesis

AI 하루 타임라인 생성의 핵심은 사진, 위치, 캘린더, 수면·활동량, 알림 source를 바로 최종 기록으로 저장하지 않고 domain별 Event Agent가 Candidate와 Fragment로 해석한 뒤 Timeline Agent가 실제 사건 단위로 병합하는 것이다. source reference, confidence, inference level과 uncertainty를 보존해 그럴듯한 문장보다 근거 추적을 우선한다.

2026-08-09 구현 기준 main graph는 `run_event_agents → merge_results → run_timeline_agent → run_repair_agent → run_question_agent`다. 다섯 Event Agent는 첫 node 안에서 병렬 실행된다. Repair Agent는 별도 Reflection node의 결과를 기다리는 구조가 아니라, 결정론적 confirm과 제한된 LLM 분석·도구 실행을 결합해 반복한다. 각 반복의 끝에서 source, 시간, 장소, 병합, privacy와 ID 불변식을 코드로 다시 확정한다.

과거 설계 노트의 `Reflection Agent + ReflectionIssue + selective re-orchestration`은 구현으로 그대로 유지된 계약이 아니다. 선택적 상류 재실행이라는 아이디어는 Repair 도구의 `rerun_event_agent`와 `rerun_timeline_agent`로 남았지만, 현재 graph에는 독립 Reflection Agent가 없다. 이 차이는 설계 변화로 명시적으로 보존한다.

User Memory는 Timeline 문체와 중요도, Question의 결을 조정하는 보조 context일 뿐 오늘 사건의 근거가 아니다. Event Agent와 Repair Agent에는 주입하지 않고, source와 충돌하면 source가 우선한다.

## Key Points

- 제품 source는 location, calendar, photo, sleep/activity, notification이며 User Memory는 source 목록에서 분리한다.
- Event Agent는 담당 source가 없으면 LLM을 호출하지 않고, 호출·파싱 실패는 빈 결과와 warning으로 격리한다.
- Calendar 누락, source 무결성, request window, MEAL·Sleep·Location 시간, Photo 단일 귀속과 최종 ID는 결정론 계층이 검사한다.
- Timeline 결과 저장 성공 뒤에만 SUCCESS callback을 보낸다.
- Question Agent는 Repair 뒤 모든 event에 질문 하나를 시도하며 누락은 Timeline 저장을 막지 않는다.
- Prompt version은 모든 Agent가 공유하고, v1/v2는 일부 Agent의 호출 graph까지 바꾼다.
- Langfuse는 main graph, Agent, Repair cycle과 generation의 provider·model·prompt version·latency·token을 관측한다.

## Open Questions

- FastAPI BackgroundTasks를 durable queue나 복구 가능한 실행 계층으로 바꿀 필요가 있는가?
- multi-worker 또는 AgentCore replica 환경에서 inflight와 drain을 어떻게 전역적으로 보장할 것인가?
- endpoint에서 역전된 request window를 언제 명시적으로 거절할 것인가?
- provider별 실제 Timeline 품질과 운영 비용은 공통 fixture 평가에서 어떻게 달라지는가?
- 어떤 uncertainty와 warning을 UI에 직접 노출할 것인가?

## Linked Sources

- [[2026-06-20-notes-ai-daily-timeline-agent-draft]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-16-notes-timeline-card-grouping-design]]
- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[2026-06-19-notes-timeline-implementation-reconciliation]]
- [[2026-08-09-markdown-laimory-ai-system-architecture]]
- [[2026-08-09-markdown-laimory-timeline-graph-and-agents]]
- [[2026-08-09-markdown-laimory-prompt-engineering]]
- [[2026-08-09-markdown-laimory-deterministic-repair-and-tools]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[android-life-logging-data-collection]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
