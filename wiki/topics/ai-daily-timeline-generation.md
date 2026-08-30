---
title: AI Daily Timeline Generation
kind: topic
status: active
updated: 2026-08-31
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

2026-08-20에 인제스트한 prompt·alpha 기록 collection은 현재 구조 이전과 전환기의 품질 문제를 구체적으로 보여준다. timezone·하루 경계, 장거리 이동 과분할, 사진 누락·중복 귀속, Calendar·Location 결합 실패, 알림 분절과 귀가 누락이 반복됐고, 개선안은 raw item 처리 상태, 상위 journey, Candidate·Fragment 계약, 사진 단일 귀속과 privacy를 prompt와 validator 양쪽에 두도록 요구했다. 이 collection의 `prompt.md`는 보존 snapshot의 current일 뿐 현재 repository active prompt와 동일하지 않으므로 구현 판단에는 code와 이후 system document를 우선한다.

2026-07-28부터 08-05까지의 회의는 현재 구조로 수렴하는 통합 과정을 기록한다. `source_id`와 `row_id` 불일치, JSON 필수 필드 실패, callback 저장과 FCM·polling 문제를 발견한 뒤 structured output과 App Server 경유 저장을 강화했고, alpha test에서 하루 경계와 UTC/KST 해석 문제를 확인했다. 08-04에는 생성물을 `DRAFT` 편집 상태와 `SAVED` 기록 상태로 구분하고 저장을 User Memory 갱신 trigger로 삼는 방향이 논의됐다. 이 회의 기록은 당시 진행 상황이며 최종 구현 계약은 2026-08-09 AI 시스템 문서를 우선한다.

2026-08-13~30 회의에서는 제품 flow와 품질 failure가 더 구체화됐다. 단건 조회는 draft와 saved를 모두 반환하고 status와 nullable emotion을 포함하는 방향으로 정리됐으며, saved-read와 edit mode를 분리하되 시각적 간격은 줄이기로 했다. 실제 사례에서는 messenger notification이 중요하지 않거나 민감한 event를 과도하게 만드는 문제가 나타나 call log로 scope를 넓히기보다 notification 판단과 최대 event 수를 먼저 보수적으로 조정하기로 했다. 08-30에는 입력 source와 User Memory가 모두 없는 날을 빈 결과로 끝내지 않도록 설명·질문·기본 입력을 제공하는 empty state가 열린 설계 과제로 추가됐다.

## Key Points

- 제품 source는 location, calendar, photo, sleep/activity, notification이며 User Memory는 source 목록에서 분리한다.
- Event Agent는 담당 source가 없으면 LLM을 호출하지 않고, 호출·파싱 실패는 빈 결과와 warning으로 격리한다.
- Calendar 누락, source 무결성, request window, MEAL·Sleep·Location 시간, Photo 단일 귀속과 최종 ID는 결정론 계층이 검사한다.
- Timeline 결과 저장 성공 뒤에만 SUCCESS callback을 보낸다.
- Question Agent는 Repair 뒤 모든 event에 질문 하나를 시도하며 누락은 Timeline 저장을 막지 않는다.
- Prompt version은 모든 Agent가 공유하고, v1/v2는 일부 Agent의 호출 graph까지 바꾼다.
- Langfuse는 main graph, Agent, Repair cycle과 generation의 provider·model·prompt version·latency·token을 관측한다.
- 공식 중간보고서는 source 근거, request window, Calendar 보존, Photo 귀속과 시간·길이 기준을 prompt metric과 결정론적 code로 이중 검사하고, 문제 사례를 평가 fixture로 되돌리는 개선 loop를 구축 중이라고 설명한다.
- alpha 개선 기록은 모든 유효 raw item을 candidate·fragment·noise·failure 중 하나로 추적하고, 최종 사용 여부를 검증 가능한 상태로 남길 것을 요구한다.
- Timeline·Location은 작은 source 단위를 그대로 나열하기보다 하루 중심 사건과 연속 journey로 재구성하되, 의미 판단과 rawId·시간·privacy 같은 hard gate를 분리한다.
- Draft와 saved는 조회 가능 상태로 함께 다루되, 생성 직후 편집과 저장 후 읽기·재편집의 affordance를 구분하는 방향이다.
- Messenger notification 과잉 event는 source 확대보다 선택 기준과 event 수 제한을 먼저 조정하고, beta의 삭제 pattern으로 회귀를 찾는다.
- 완전 무입력 날에는 AI 호출 여부, User Memory 활용과 기본 질문을 함께 고려한 명시적 empty state가 필요하다.

## Open Questions

- FastAPI BackgroundTasks를 durable queue나 복구 가능한 실행 계층으로 바꿀 필요가 있는가?
- multi-worker 또는 AgentCore replica 환경에서 inflight와 drain을 어떻게 전역적으로 보장할 것인가?
- endpoint에서 역전된 request window를 언제 명시적으로 거절할 것인가?
- provider별 실제 Timeline 품질과 운영 비용은 공통 fixture 평가에서 어떻게 달라지는가?
- 어떤 uncertainty와 warning을 UI에 직접 노출할 것인가?
- prompt collection의 역사적 regression case를 현재 schema와 fixture로 어떻게 안전하게 이관할 것인가?
- 저장된 기록의 read/edit 상태와 수정 가능 API를 어떤 단일 상태 machine으로 고정할 것인가?
- Notification event의 민감도·중요도와 max count를 어떤 fixture와 사용자 삭제 신호로 검증할 것인가?
- source와 User Memory가 모두 없는 날의 기본 결과를 server와 AI 중 어디서 만들 것인가?

## Linked Sources

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-20-markdown-laimory-ai-agent-prompt-collection]]
- [[2026-08-20-markdown-laimory-ai-timeline-core-improvement-requirements]]
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
- [[2026-08-13-meeting-369-team-space]]
- [[2026-08-19-meeting-369-team-space]]
- [[2026-08-24-meeting-369-team-space]]
- [[2026-08-25-meeting-369-team-space]]
- [[2026-08-27-meeting-369-team-space]]
- [[2026-08-30-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[android-life-logging-data-collection]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
- [[laimory-data-privacy-and-consent]]
