---
title: AI Daily Timeline Generation
kind: topic
status: active
updated: 2026-08-17
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

2026-08-17 공식 중간보고서는 같은 pipeline을 프로젝트 중간 상태의 대표 구현으로 설명하고, App Tester alpha에서 생성·편집·확정까지 연동했다고 보고한다. 문서상 생성 시간은 약 40초이며 앱은 task 식별자, foreground polling과 background FCM 알림으로 비동기 완료를 처리한다. 이는 팀의 공식 상태 보고이지만 세부 구현 계약은 2026-08-09 source commit 문서가 더 구체적이고, 실제 latency 분포와 failure recovery는 아직 검증 결과가 없다.

2026-07-28부터 08-05까지의 회의는 현재 구조로 수렴하는 통합 과정을 기록한다. `source_id`와 `row_id` 불일치, JSON 필수 필드 실패, callback 저장과 FCM·polling 문제를 발견한 뒤 structured output과 App Server 경유 저장을 강화했고, alpha test에서 하루 경계와 UTC/KST 해석 문제를 확인했다. 08-04에는 생성물을 `DRAFT` 편집 상태와 `SAVED` 기록 상태로 구분하고 저장을 User Memory 갱신 trigger로 삼는 방향이 논의됐다. 이 회의 기록은 당시 진행 상황이며 최종 구현 계약은 2026-08-09 AI 시스템 문서를 우선한다.

## Key Points

- 제품 source는 location, calendar, photo, sleep/activity, notification이며 User Memory는 source 목록에서 분리한다.
- Event Agent는 담당 source가 없으면 LLM을 호출하지 않고, 호출·파싱 실패는 빈 결과와 warning으로 격리한다.
- Calendar 누락, source 무결성, request window, MEAL·Sleep·Location 시간, Photo 단일 귀속과 최종 ID는 결정론 계층이 검사한다.
- Timeline 결과 저장 성공 뒤에만 SUCCESS callback을 보낸다.
- Question Agent는 Repair 뒤 모든 event에 질문 하나를 시도하며 누락은 Timeline 저장을 막지 않는다.
- Prompt version은 모든 Agent가 공유하고, v1/v2는 일부 Agent의 호출 graph까지 바꾼다.
- Langfuse는 main graph, Agent, Repair cycle과 generation의 provider·model·prompt version·latency·token을 관측한다.
- 공식 중간보고서는 source 근거, request window, Calendar 보존, Photo 귀속과 시간·길이 기준을 prompt metric과 결정론적 code로 이중 검사하고, 문제 사례를 평가 fixture로 되돌리는 개선 loop를 구축 중이라고 설명한다.

## Open Questions

- FastAPI BackgroundTasks를 durable queue나 복구 가능한 실행 계층으로 바꿀 필요가 있는가?
- multi-worker 또는 AgentCore replica 환경에서 inflight와 drain을 어떻게 전역적으로 보장할 것인가?
- endpoint에서 역전된 request window를 언제 명시적으로 거절할 것인가?
- provider별 실제 Timeline 품질과 운영 비용은 공통 fixture 평가에서 어떻게 달라지는가?
- 어떤 uncertainty와 warning을 UI에 직접 노출할 것인가?

## Linked Sources

- [[2026-08-17-pdf-laimory-midterm-report]]
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
- [[2026-07-28-meeting-369-team-space]]
- [[2026-07-30-meeting-369-team-space]]
- [[2026-08-03-meeting-369-team-space]]
- [[2026-08-04-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[android-life-logging-data-collection]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
