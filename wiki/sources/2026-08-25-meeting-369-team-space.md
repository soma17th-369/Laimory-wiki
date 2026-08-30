---
title: 369팀 스페이스 회의 요약 - 2026-08-25
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260825_2300/회의 요약_369팀 스페이스_20260825.md
transcript_path: raw/meetings/369팀 스페이스_20260825_2300/대화 내용_369팀 스페이스_20260825.md
meeting_date: 2026-08-25
ingest_date: 2026-08-31
duration: 01:08:04
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory, agentcore, timeline-ui, onboarding, notification-filter, ai-model]
---

# 369팀 스페이스 회의 요약 - 2026-08-25

## 개요

AgentCore 배포, production timezone, Android timeline 읽기·편집 UX, onboarding initializer API, Bedrock model region, notification filter 검수를 논의한 회의다. 특히 AI 초안 편집과 저장된 기록 열람을 어떤 화면 상태로 분리할지 장시간 검토했다.

## 핵심 내용

- AgentCore 자체 배포는 되었고 application 연결과 end-to-end test가 남았다. branch/version 운영 방식도 설명되었으나 branch 이름은 전사가 불명확하다. (`00:24-01:54`)
- 자정 notification 문제에는 production timezone 설정 영향이 있었고, mentor feedback과 함께 거의 수정했다고 보고했다. (`04:25-04:56`)
- card 느낌을 줄인 dot·line 기반 timeline 읽기 화면을 제시했다. title·시간 크기, 사용자 메모 강조, photo size·순서, 오전·오후 표기 등이 개선 과제로 남았다. (`05:14-23:33`)
- AI 초안에는 명백한 edit affordance가 필요하고 저장된 결과는 읽기에 집중해야 한다는 공감대가 있었다. 읽기와 편집 mode를 분리하되 visual gap을 줄여 먼저 구현하고 beta test에서 과거 기록 열람·수정률을 확인하기로 했다. (`26:35-45:12`, `50:17-54:37`)
- user가 처음 가입했는지와 약관 등 초기 상태를 반환하는 initializer API를 만들고 onboarding을 최초 한 번 제공하기로 했다. (`45:15-47:23`)
- `GPT 5.6 Luna`로 들리는 Bedrock model은 Seoul region 제약이 있는 것으로 보여 cross-region 사용 가능성을 다시 확인하기로 했다. (`47:27-49:59`)
- category별 notification filter 후보를 database에 넣었지만 실제 app package·field와 맞는지 debug data로 검수해야 한다. (`01:01:43-01:06:36`)
- debug mode 수집 data는 삭제하지 않는 한 365일 유지된다고 설명되어 최근 사례를 model 비교에 활용할 수 있다. (`01:06:40-01:07:16`)

## 상태 구분

| 분류 | 내용 | 근거 |
|---|---|---|
| 진행 중 | AgentCore 연결·test, timezone·mentor feedback 반영 | `00:24-04:56` |
| 잠정 결정 | 읽기·편집 mode 분리와 visual consistency 개선 | `41:37-45:12`, `50:17-54:37` |
| 결정 | initializer API와 최초 1회 onboarding | `45:15-47:23` |
| 검토 중 | Luna model region·cross-region 호출 | `47:27-49:59` |
| 진행 중 | notification filter 실제 수집 검수 | `01:01:43-01:06:36` |
| 미결 | AI 질문·메모 배치, 시간 표기, 저장 후 편집 진입 방식 | 여러 구간 |

## 주의 사항

- UI 논의는 화면 공유를 전제로 해 전사만으로 실제 배치와 색상을 복원할 수 없다.
- model명, initializer endpoint, branch 이름, 경쟁 app 이름은 자동 전사 오류 가능성이 있다.
- AWS region·가격 정보는 확인 단계였고 공식 검증 결과가 아니다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-ai-runtime-and-observability]]
- [[laimory-ai-model-evaluation]]
- [[ai-daily-timeline-generation]]
- [[android-life-logging-data-collection]]
