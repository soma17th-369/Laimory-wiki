---
title: 369팀 스페이스 회의 요약 - 2026-08-04
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260804/회의 요약_369팀 스페이스_20260804.md
transcript_path: raw/meetings/369팀 스페이스_20260804/대화 내용_369팀 스페이스_20260804.md
meeting_date: 2026-08-04
ingest_date: 2026-08-09
duration: 01:43:38
transcript_type: auto-generated
speaker_attribution: transcript-provided
status: ingested
tags: [meeting, transcript, 369-team, laimory, privacy, on-device-ai, timeline-ux]
---

# 369팀 스페이스 회의 요약 - 2026-08-04

## 개요

이 회의는 개인정보·위치정보 관련 법률 mentoring 직후 팀이 받은 조언을 해석하고 제품 흐름에 반영하는 장시간 후속 논의였다. 팀은 알림·위치·calendar·사진 같은 raw data를 외부 LLM API에 보내는 행위가 제3자 제공으로 이해될 수 있다는 점을 핵심 위험으로 받아들였다. Mentor가 모든 처리를 on-device SLM으로 옮기라고 권한 것으로 참석자들이 해석했지만, 전사에는 mentor 원문이 포함돼 있지 않으므로 이 해석을 법률 판단이나 공식 요구사항으로 취급할 수 없다. (`00:04-15:09`)

팀은 전체 생성 pipeline을 SLM으로 대체하기보다, on-device model을 외부 전송 전 privacy filter·요약·warning layer로 활용하는 절충안을 탐색했다. 사용자는 timeline window와 사진을 고른 뒤 알림·위치·calendar 항목의 개수와 상세를 보고 제외할 수 있고, 민감 가능성이 있는 정보는 SLM이 경고하는 흐름이 제안됐다. 다만 어떤 동의 방식이 법적으로 충분한지, SLM이 민감정보를 얼마나 안정적으로 분류할 수 있는지는 검증되지 않았다. (`01:13:21-01:35:26`)

제품 UX에서는 생성된 timeline을 `DRAFT` 편집 상태와 `SAVED` 완성 상태로 나누고, 저장 후에는 파편화된 card가 아니라 하나의 기록처럼 읽히는 화면을 제공하는 방향에 대체로 합의했다. 저장 시점은 User Memory 갱신과 funnel 측정의 trigger로도 활용한다. Event별 회고 질문, calendar의 감정 thumbnail, inline memo와 photo deletion 등 후속 기능도 논의했다. (`23:41-01:13:20`)

## 상세 요약

### 법률 mentoring 해석과 불확실성

- 참석자들은 외부 LLM API로 raw data를 보내는 것이 제3자 제공에 해당하고, 단순 약관 동의만으로 사용자가 실제 전송 범위를 충분히 인지하지 못할 수 있다는 조언을 받은 것으로 회고했다. (`00:44-05:37`, `09:41-11:32`)
- 처음에는 on-device SLM이 raw data를 정제하고 사용자가 전송 항목을 확인한 뒤 LLM으로 보내는 한 단계 추가 구조로 이해했지만, 후반 조언은 server와 external LLM 자체를 없애고 모든 처리를 SLM으로 하라는 권고처럼 들렸다고 해석했다. (`04:03-07:50`)
- server 저장 자체가 법적으로 금지된 것인지, 단지 breach·운영비 위험을 줄이라는 보수적 조언인지 참석자들 사이에서도 명확히 정리되지 않았다. (`07:50-10:39`)
- 위치 기반 사업자 신고가 필요할 가능성도 언급됐지만 사업자번호, 신고 기관과 절차는 깊게 확인하지 못했다. 공식 법률 검토가 필요한 항목이다. (`22:44-23:41`)

### On-device SLM 활용 방향

- 전체 product를 SLM만으로 돌리는 것은 현재 기술 목표와 성능 제약 때문에 어렵다는 의견이 우세했다. 대신 Gemma 계열로 들리는 on-device model을 외부 전송 전 필터로 사용하는 방향을 조사하기로 했다. (`11:36-14:22`)
- 기기 지원 범위와 image 처리 성능에 대해 과거 mentor 의견과 최근 공개 사례가 충돌하는 듯해, 실제 Android target device에서 feasibility를 다시 확인해야 한다. (`12:43-13:37`)
- 위치 raw data를 방문 장소·이동 구간으로 정제하고, 알림을 사건 단위로 요약한 뒤 사용자가 묶음 단위로 제외하게 하는 아이디어가 제시됐다. (`01:15:45-01:28:58`)
- 민감정보 가능성이 있는 항목을 개인정보보호 기준으로 warning하고 mask 또는 filter하는 `개인정보 지킴이` 역할을 SLM이 담당하는 구상이 나왔다. 이는 기획 아이디어이며 detection recall·false negative에 대한 검증은 없다. (`01:29:01-01:35:26`)

### Timeline 품질과 User Memory 구조

- timeline 문장을 더 간결하고 부드럽게 바꾸는 prompt 개선이 반영됐고, 팀원들이 이전보다 간소화됐다고 관찰했다. (`23:41-24:51`)
- User Memory는 vector database를 새로 추가하기보다 기존 RDB에 별도 table 또는 column으로 저장하는 안이 검토됐다. timeline을 사용자가 편집해 완성했다고 판단되는 시점에 API server가 AI server로 비동기 요청하고, AI server가 daily record와 user 정보를 읽어 갱신 값을 다시 API로 저장하는 구조가 설명됐다. (`24:51-26:32`)
- callback은 필요 없을 수 있다는 의견이 있었고, API endpoint와 저장 방식은 구현 단계에서 확정할 부분으로 남았다. (`25:35-26:32`)

### Draft와 Saved UX

- 생성 직후 timeline은 기본적으로 편집 mode인 `DRAFT`, 사용자가 명시적으로 저장하면 `SAVED`로 전환하는 방향에 합의했다. Server에서는 status column이 single source of truth가 되어 app restart 후에도 상태를 유지한다. (`38:31-49:49`)
- `SAVED` 화면은 edit icon과 input placeholder를 제거하고 하나로 연결된 minimal timeline처럼 보여 완성된 기록이라는 느낌을 주자는 방향이었다. 필요하면 다시 edit mode로 들어갈 수 있지만, 편집 중 변경을 server status까지 다시 `DRAFT`로 바꿀 필요는 없다는 의견이 모였다. (`38:31-52:12`)
- 명시적 저장은 사용자가 결과를 최종 확인했다는 기준이 되어 funnel 측정과 User Memory 갱신 trigger로 활용할 수 있다. 나중에 회고 기능이 생기면 `SAVED` 기록만 집계하는 근거도 된다. (`27:47-28:15`, `41:20-41:58`, `48:42-49:49`)
- 사용자가 저장을 잊거나 `완료 후 수정 불가`로 오해할 수 있다는 UX 위험은 남아 있다. (`28:19-28:37`)

### Event 질문과 메모

- 각 event에 사용자가 기억을 보충할 수 있도록 AI가 질문을 함께 생성하는 아이디어가 구체화됐다. 예를 들어 식사 event에 맛이나 느낌을 물어 일기 작성을 유도한다. (`01:05:06-01:08:00`)
- 질문은 memo와 별도 의미를 가지지만 UI에서는 빈 memo field의 placeholder로 보여주는 compact한 방식에 동의했다. 사용자가 입력하면 질문은 사라지고, 완성 화면에는 질문을 표시하지 않는다. (`01:08:28-01:13:20`)
- Data model에서는 AI question과 user memo를 구분할 field 또는 key-value가 필요하다는 점이 확인됐다. (`01:11:29-01:13:20`)

### Calendar와 감정 표현

- Calendar의 각 날짜에 timeline 존재 여부와 그날의 감정을 작은 thumbnail로 보여주는 아이디어가 논의됐다. 색상만으로는 의미가 모호하므로 표정 icon을 함께 쓰자는 방향이었다. (`56:00-01:02:36`)
- 감정은 사용자 입력을 기본으로 하고, 이후 추론이 신뢰할 수 있으면 initial value만 AI가 제안하는 안이 나왔다. 감정 저장 API는 아직 없지만 icon 선택 시 즉시 update하는 단순 API가 가능하다고 했다. (`59:43-01:03:15`)
- Calendar 아래의 큰 summary thumbnail 또는 하루 회고 표현은 결론 없이 추후 과제로 남겼다. (`01:03:20-01:05:06`)

### 구현 현황과 부하 테스트

- Timeline을 보며 바로 memo를 작성할 수 있는 inline memo UI를 구현했다고 보고했다. (`29:04-29:57`)
- Event의 photo item만 item ID로 삭제할 수 있는 API를 구현했으며 다른 item type이면 400 error가 나도록 했다고 보고했다. (`29:59-30:28`)
- K6 load test는 실제 AI server를 호출하면 비용과 외부 처리 자체가 bottleneck이 되므로 test 구조와 fake database data를 다시 설계해야 하는 상태였다. (`30:33-31:14`)
- Saved 전환은 daily record status 값을 `DRAFT`에서 `SAVED`로 바꾸는 repository·service 함수가 아직 필요하다고 확인했다. (`45:51-47:20`)
- Photo 순서 변경은 현재 time order와 다른 item type이 섞인 구조 때문에 order column을 전체 item에 추가해야 할 수 있어 보류됐다. (`01:40:33-01:42:32`)

## 진행 상황

- 개인정보 제3자 제공 UX와 on-device SLM filter 구조를 탐색 중이다. (`01:13:21-01:35:26`)
- Timeline 문장 품질을 개선했고 User Memory RDB 구조를 설계 중이다. (`23:41-26:32`)
- Inline memo와 photo delete API를 구현했다. (`29:04-30:28`)
- `DRAFT`·`SAVED` 상태와 완성 화면 UX를 구체화했다. (`31:18-52:12`)
- Event별 AI question과 calendar 감정 thumbnail을 설계 중이다. (`56:00-01:13:20`)

## 결정·제안·미결 사항

| 분류 | 내용 | 근거 |
|---|---|---|
| 방향 합의 | 생성 직후는 `DRAFT` 편집 mode, 명시적 저장 후 `SAVED` 완성 mode로 운영 | `38:31-52:12` |
| 방향 합의 | AI question을 event에 별도 data로 두고 빈 memo의 placeholder처럼 표시 | `01:05:06-01:13:20` |
| 구현 보고 | Inline memo와 photo item 삭제 API 구현 | `29:04-30:28` |
| 제안 | 외부 전송 전 사용자가 알림·위치·calendar 항목을 보고 제외하는 한 단계 추가 | `01:27:30-01:35:26` |
| 제안 | On-device SLM으로 민감정보 warning·masking·요약 수행 | `01:24:45-01:35:26` |
| 미결 | 위 flow가 개인정보·제3자 제공 요건을 충족하는지 여부 | `01:13:21-01:35:26` |
| 미결 | Calendar의 큰 summary thumbnail과 하루 회고 표현 | `01:03:20-01:05:06` |
| 미결 | Photo 및 전체 item 정렬 방식 | `01:40:33-01:42:32` |

## 액션 아이템

| 작업 | 담당 | 기한 | 상태 | 근거 |
|---|---|---|---|---|
| On-device model 지원 범위와 Android 적용 방식 조사 | 관련 발언자 | 미확인 | 조사 예정 | `12:43-14:22` |
| 개인정보 확인 화면 구성안 작성 | 관련 발언자 | 미확인 | 예정 | `01:33:42-01:35:05` |
| Raw data를 SLM이 가공하는 방식과 prompt 설계 | 관련 발언자 | 미확인 | 예정 | `01:33:42-01:35:26` |
| `DRAFT`를 `SAVED`로 전환하는 repository·service·API 구현 | 담당 미확인 | 미확인 | 필요 | `45:51-47:20` |
| Event question field와 생성 prompt 반영 | 관련 발언자 | 미확인 | 예정 | `01:12:34-01:13:20` |
| K6 test에서 AI server와 fake data 처리 구조 재설계 | 관련 발언자 | 미확인 | 진행 중 | `30:33-31:14` |

## 열린 질문

- 외부 LLM 전송 전 상세 항목을 열람·제외할 수 있게 하는 것으로 적법하고 충분한 동의가 되는가?
- On-device SLM이 민감정보를 놓치는 경우에 대한 안전장치와 책임 경계는 무엇인가?
- 지원 device 범위, latency, battery, model size를 고려할 때 SLM 도입이 현실적인가?
- 사용자가 `SAVED`를 누르지 않거나 저장 후 다시 편집할 때 User Memory trigger는 어떻게 동작하는가?
- 하루 감정은 사용자 입력, AI initial value, 둘의 혼합 중 어떤 정책으로 저장할 것인가?

## 주의 사항

- 이 문서는 법률 mentoring 원문이 아니라 참석자들의 직후 회고를 요약한 것이다. 법률 해석이나 compliance 결정의 근거로 단독 사용하면 안 된다.
- `SLM`, `SSLM`, `Gemma`로 들리는 용어가 혼용되며 자동 전사 오류가 있다.
- 개인정보보호법상 민감정보 범위, 제3자 제공 동의, 위치기반사업 신고는 공식 법률 검토가 필요하다.
- 참석자 이름은 원문 attribution을 따랐고, 업무 ownership이나 최종 결정권을 추가 추론하지 않았다.
- 원문에는 위치·사진·관계·알림 등 민감한 예시가 포함되어 있어 공개 범위를 제한해야 한다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[android-life-logging-data-collection]]
- [[laimory-ai-runtime-and-observability]]
