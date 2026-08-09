---
title: 369팀 회의 이력
kind: topic
status: active
updated: 2026-08-09
tags: [369-team, laimory, meetings, decision-history, project-history]
---

# 369팀 회의 이력

## Scope

369팀 회의 13건에서 Laimory의 제품 정의, 기획심의 준비, 구현 통합, alpha test와 기술 의사결정이 어떻게 변했는지를 시간순으로 연결한다. 각 항목은 `raw/meetings/`의 회의 요약본을 인제스트한 `wiki/sources/` page를 근거로 한다.

## Current Synthesis

회의 이력은 크게 세 단계로 나뉜다. 2026-05-16부터 05-23까지는 제품을 단순 AI 일기에서 모바일 life logging과 Personal AI Memory로 재정의하고, 기획심의를 위해 문제·MVP·permission·경쟁·수익화·검증 지표를 다듬은 시기다. 사진·위치·calendar를 우선 source로 삼는 축소안은 유력했지만 persona, permission을 감수할 즉시 가치와 AI 품질 검증은 미결이었다.

2026-07-28과 07-30에는 구현 통합과 alpha test가 중심으로 이동했다. source ID와 structured output, App Server 경유 저장, callback·FCM·polling, Langfuse 관측성, 사진·알림 수집과 UTC/KST 하루 경계 문제가 실제 장애와 개선 항목으로 나타났다.

2026-08-02부터 08-06까지는 모델 품질, User Memory, AWS와 AgentCore, privacy filter, DRAFT/SAVED UX, K6 부하 테스트, 위치·체류 데이터와 User Memory 동시 갱신으로 논의가 구체화됐다. 이 시기의 회의는 구현 진행 상황과 잠정 대안을 포함하므로 최종 계약은 2026-08-09 AI 시스템 문서를 우선하며, 수치·법률 해석·자동 전사 기술명은 별도 검증이 필요하다.

## Chronology

| 날짜 | 회의 성격 | 주요 변화와 쟁점 |
|---|---|---|
| 2026-05-16 | 제품 방향 | AI 일기에서 모바일 life logging으로 문제 범위를 확대하고 회고를 선택적 interface로 재배치 |
| 2026-05-17 | 문제 정의 | 파편화된 디지털 흔적을 하루 기록으로 복원하고 장기 second brain으로 확장하는 비전 구체화 |
| 2026-05-18 | 기획심의 준비 | 자동 하루 기록 중심 MVP, on-device·server hybrid, privacy와 AI 비용 검토 |
| 2026-05-19 | 기획심의 준비 | 경쟁 제품 조사, Android-first 차별화, permission·privacy와 beta·AI QA 쟁점 정리 |
| 2026-05-21 | 기획심의 준비 | 사진·위치·calendar 중심 축소 MVP, 단계적 permission, 유료 기능 가설 검토 |
| 2026-05-23 | 기획심의 점검 | 설명 문구, 위험 대응, 부하 테스트, 사용자 검증 지표와 community 확장안 검토 |
| 2026-07-28 | 통합 테스트 | row ID 정합성, structured output, App Server 경유 DB, FCM·callback·Redis 문제 점검 |
| 2026-07-30 | alpha test | Langfuse 도입, server token, 알림·사진 수집, 하루 경계와 UTC/KST 오류 확인 |
| 2026-08-02 | 품질·인프라 | 모델 비교, User Memory, AWS 비용, Android local cleanup와 수집 제한 논의 |
| 2026-08-03 | UX·runtime | prompt version, AgentCore, timeline window와 오전 6시 하루 경계 구체화 |
| 2026-08-04 | privacy·UX | 외부 LLM 제3자 제공 우려, on-device SLM filter, DRAFT/SAVED와 저장 trigger 검토 |
| 2026-08-05 | 평가·성능 | User Memory table, Langfuse evaluation, K6 외부 API 병목, 위치 noise와 marketing 준비 |
| 2026-08-06 | 동시성·위치 | User Memory 충돌 작업 재처리, AI 품질 도구, 외부 API 성능과 주소 표시 검증 |

## Durable Threads

- 제품 정의는 자동 기록 자체보다 파편화된 생활 데이터를 회고 가능한 기억으로 바꾸는 데 수렴했다.
- permission과 privacy는 onboarding UX, on-device 처리, 외부 LLM 전송, 신뢰 형성을 함께 다뤄야 하는 제품 문제다.
- Timeline 품질은 prompt만이 아니라 source ID, structured output, 시간대, callback과 수집량 제한 같은 시스템 정합성에 의존한다.
- User Memory는 장기 맥락 가치의 핵심이지만 저장 trigger, provenance, 동시 갱신 순서와 실패 복구가 남아 있다.
- Langfuse와 품질 평가 도구는 결과가 그럴듯한지를 넘어 source 충실도와 Agent 내부 동작을 검증하는 방향으로 발전했다.
- 외부 API와 cloud 비용 문제는 실제 traffic 목표와 측정 자료가 없으면 회의 중 관찰 또는 rough estimate로만 취급해야 한다.

## Open Questions

- 회의에서 나온 잠정 설계 중 현재 코드와 운영 환경에 실제 반영된 것은 무엇인가?
- 결정·액션 아이템의 담당자와 완료 상태를 어떤 issue tracker와 연결할 것인가?
- 법률 mentoring을 참석자가 재해석한 내용과 실제 법률 자문 원문을 어떻게 분리해 보존할 것인가?
- 회의별 성능 수치와 모델 품질 관찰을 재현 가능한 benchmark·trace·issue로 어떻게 승격할 것인가?

## Linked Sources

- [[2026-05-16-meeting-369-team-space]]
- [[2026-05-17-meeting-369-team-space]]
- [[2026-05-18-meeting-369-team-planning-review-preparation]]
- [[2026-05-19-meeting-369-team-planning-review-preparation]]
- [[2026-05-21-meeting-369-team-planning-review-preparation]]
- [[2026-05-23-meeting-369-team-space]]
- [[2026-07-28-meeting-369-team-space]]
- [[2026-07-30-meeting-369-team-space]]
- [[2026-08-02-meeting-369-team-space]]
- [[2026-08-03-meeting-369-team-space]]
- [[2026-08-04-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]
- [[2026-08-06-meeting-369-team-space]]

## Related Pages

- [[369-team]]
- [[laimory]]
- [[ai-life-logging]]
- [[laimory-planning-and-validation]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
- [[android-life-logging-data-collection]]
