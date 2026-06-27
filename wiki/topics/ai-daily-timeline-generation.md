---
title: AI Daily Timeline Generation
kind: topic
status: active
updated: 2026-06-27
tags: [laimory, ai-timeline, ai-agent, event-normalization, lifelogging]
---

# AI Daily Timeline Generation

## Scope

Laimory에서 하루 동안 수집된 모바일 생활 데이터를 AI가 사용자 수정 가능한 timeline draft로 변환하는 설계 주제.

## Current Synthesis

AI 하루 타임라인 생성의 핵심은 사진, 위치, 캘린더, 수면, 활동량, 알림처럼 서로 다른 source를 바로 최종 기록으로 저장하지 않고, 먼저 공통 `Event` 후보로 정규화하는 것이다. 각 데이터별 Event Agent는 자기 source에서 직접 설명 가능한 사건 후보와 근거를 만들고, Timeline Agent가 이를 병합해 사용자가 검토할 수 있는 timeline draft를 만든다.

현재 설계의 기본 구조는 `Batch Synthesis + Selective Re-orchestration`이다. 초기 생성에서는 사용 가능한 Data-specific Event Agent를 고정 규칙으로 병렬 실행한다. 이후 Reflection Agent가 timeline draft의 충돌, 누락, 과한 추론, 낮은 confidence를 평가하고, 해결 가능한 issue가 있으면 Repair Agent가 필요한 Sub-Agent와 `targetSourceRefs`만 다시 호출한다. 재구성된 timeline은 다시 Reflection 평가를 거치며, 중요한 issue가 사라지거나 사용자 질문/warning으로 넘길 문제만 남거나 loop 한도에 도달하면 종료한다.

이 설계는 AI가 하루를 그럴듯하게 꾸미는 문제를 줄이기 위해 source reference, confidence, inference level, uncertainty를 event 단위로 보존한다. 캘린더 일정은 일정 존재를 의미할 뿐 실제 참석을 확정하지 않고, 위치만으로 식사나 만남을 단정하지 않으며, 사용자 기억 데이터는 보조 context로만 사용한다.

## Key Points

- 입력 source는 location, calendar, photo, sleep, activity, notification, user memory로 나뉜다.
- raw data와 derived data는 `sourceId`를 가져야 Repair Agent가 전체 데이터를 다시 넘기지 않고 특정 source만 재분석할 수 있다.
- 공통 `Event` 후보는 event type, 시간 범위, source references, confidence, inference level, uncertainty를 포함한다.
- Event type은 `WAKE_UP`, `SLEEP`, `STAY`, `MOVEMENT`, `CALENDAR_EVENT`, `MEAL`, `PHOTO_MOMENT`, `MEETING`, `CLASS`, `WORK`, `EXERCISE`, `SOCIAL`, `REST`, `UNKNOWN` 같은 내부 분류로 정리된다.
- Timeline Agent는 여러 Event 후보를 병합/정렬/검증해 backend timeline model로 변환 가능한 draft를 만든다.
- Reflection Agent는 직접 수정을 수행하기보다 `ReflectionIssue[]`를 만들어 Repair Agent가 실행 가능한 follow-up plan을 세우게 한다.
- Repair Agent는 Reflection 이후에만 의미가 있으며, baseline 생성이 아니라 selective re-orchestration을 담당한다.
- 개발 검증은 직접 작성한 test suite와 LLM judge 평가, run/node 단위 trace 수집을 함께 사용한다.

## Open Questions

- `Event` schema를 실제 AI server DTO와 app server validation model로 어떻게 나눌 것인가?
- Reflection loop의 최대 반복 횟수와 종료 기준을 어떤 기준으로 둘 것인가?
- LLM judge 평가 점수와 사람이 보는 품질 기준을 어떻게 맞출 것인가?
- 어떤 uncertainty와 warning을 UI에 직접 노출하고, 어떤 것은 내부 디버깅 정보로만 둘 것인가?

## Linked Sources

- [[2026-06-20-notes-ai-daily-timeline-agent-draft]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-16-notes-timeline-card-grouping-design]]
- [[2026-06-17-notes-timeline-draft-api-thought-process]]
- [[2026-06-19-notes-timeline-implementation-reconciliation]]

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[android-life-logging-data-collection]]
