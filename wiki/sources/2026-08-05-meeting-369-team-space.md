---
title: 369팀 스페이스 회의 요약 - 2026-08-05
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260805/회의 요약_369팀 스페이스_20260805.md
transcript_path: raw/meetings/369팀 스페이스_20260805/대화 내용_369팀 스페이스_20260805.md
meeting_date: 2026-08-05
ingest_date: 2026-08-09
duration: 00:31:58
transcript_type: auto-generated
speaker_attribution: transcript-provided
status: ingested
tags: [meeting, transcript, 369-team, laimory, user-memory, load-test, marketing]
---

# 369팀 스페이스 회의 요약 - 2026-08-05

## 개요

회의에서는 User Memory 저장과 event question field 구현, Langfuse 실행 결과를 고급 모델로 평가하는 local quality evaluation program, Kakao 계열 외부 API가 포함된 load test 설계, Android 위치 noise와 photo deletion 작업을 공유했다. User Memory는 인증 과정에서 자주 읽히는 User table과 분리하기 위해 별도 table로 구성했다는 구현 보고가 있었고, event당 nullable question field를 추가했다고 설명했다. (`00:45-11:38`, `25:20-26:36`)

K6 load test에서는 AI callback은 1~2분 뒤 비동기로 오기 때문에 timeline 생성 요청의 즉시 병목과 직접 연결되지 않는 반면, 외부 장소 API를 호출하는 WebClient connection pool이 동시 요청에서 병목이 될 수 있다는 가설이 제시됐다. 실제 외부 API와 같은 명세의 temporary fake server를 만들어 connection pool과 batch 크기를 탐색하기로 했다. 이 분석은 발언자도 fact-check가 필요하다고 명시했다. (`05:00-08:09`)

후반에는 중간 점검과 marketing mentor에게 전달할 자료를 검토했다. 기존 기획서의 persona와 일정이 현재 방향에 맞는지 점검하고, 현재 상태를 `MVP 개발 이후 alpha test 중`으로 설명하며 marketing 시작 방법, 광고물 제작·배포와 예산 집행을 핵심 질문으로 전달하기로 했다. (`12:25-25:18`)

## 상세 요약

### User Memory와 event question

- User Memory 저장과 API·AI server 연동 작업이 진행 중이라고 보고했다. (`01:49-02:14`)
- Event별로 하나의 nullable `question` field를 database에 추가했다고 설명했다. 영향을 받는 API에는 field 추가를 별도 전달하되 nullable이므로 큰 breaking change는 아닐 것으로 예상했다. (`02:14-02:50`)
- User Memory에는 관심사, 대략적 연령대·성별, 최근 진행 중인 일, 집 위치 등 timeline에서 추출될 수 있는 비정형 정보가 예시로 언급됐다. 실제 필수 field와 privacy 정책은 이 회의에서 확정되지 않았다. (`25:20-25:58`)
- 인증 과정에서 User가 자주 조회되므로 User table column에 합치지 않고 별도 table로 분리했다고 구현 상태를 보고했다. (`25:58-26:36`)

### AI 품질 평가 프로그램

- Prompt 품질을 측정·개선하기 위해 별도 repository를 만들고, Langfuse API로 실제 실행 결과를 가져와 더 높은 등급의 GPT 계열 model로 평가·채점하는 local Python program을 계획했다. (`03:05-04:14`)
- 별도 server instance는 띄우지 않고 필요할 때 local에서 실행하며, timeline 외 다른 AI output까지 확장 가능한 evaluation framework를 목표로 한다. (`03:21-04:14`)
- 평가 rubric, judge model bias, 비용, human validation 방법은 아직 언급되지 않았다.

### On-device SLM 개발 방식

- Android Studio를 설치해 AI agent와 직접 on-device model 부분을 작업할지, Android 담당자가 code를 맡고 model module만 전달할지 역할 분담을 고민 중이라고 했다. (`04:14-04:46`)
- 구체적인 model, device requirement와 interface는 아직 결정되지 않았다.

### K6 load test와 외부 API 병목

- Timeline 생성 load test에서 Kakao 계열 장소 API와 AI server callback을 어떻게 대체할지 두 가지 문제가 있었다. (`05:00-05:52`)
- AI callback은 1~2분 뒤 도착하므로 initial request latency에 직접적인 부하가 아닐 수 있고, 외부 장소 API call의 latency가 더 중요한 병목일 수 있다는 방향으로 판단을 바꿨다. (`05:52-06:29`)
- WebClient connection pool을 process 전체가 공유하며, 예시로 1,000 requests가 20 connections를 공유하면 timeout이 날 수 있다는 가설이 제시됐다. 발언자가 fact-check 필요성을 직접 언급했다. (`06:29-07:08`)
- 외부 API와 동일한 명세를 가진 temporary fake server를 띄워 실제 async call 구조를 유지하면서 connection pool size와 한 번에 보내는 request 수를 찾기로 했다. Test 때만 켜므로 비용은 1달러 미만일 것으로 예상했지만 실측값은 아니다. (`07:08-08:09`)

### Android photo와 위치 noise

- Event 편집 화면에서 사용자가 이미 선택한 photo를 한 건씩 삭제할 수 있게 구현했다고 보고했다. 전체 일괄 삭제는 필요성이 낮다고 판단했다. (`08:13-09:22`)
- 위치 개선은 아직 구현 전이며, privacy 확인 flow와 함께 설계를 진행 중이라고 했다. (`09:22-09:50`)
- 사용자가 자는 동안 새벽 5시 이동 후 8시 복귀처럼 보이는 false movement가 며칠 반복됐다는 사례가 있었다. GPS가 튀고 대략적 위치 mode를 사용한 영향일 수 있다는 가설이 제시됐다. (`09:50-10:47`)
- 짧은 이동으로 체류가 쪼개지는 문제를 줄이기 위해 이전 30분 논의에서 20분 threshold로 먼저 시험하고, noise가 계속되면 기준을 올리기로 했다. 이 값의 정확한 의미와 code 반영 상태는 확인이 필요하다. (`10:47-11:29`)

### 중간 점검과 기획서 검토

- 중간 점검 발표는 기존 작업을 정리해 약 1주일 준비하면 가능할 것으로 예상했고, mentor에게 형식과 요구사항을 문의할 필요가 있다고 했다. (`00:55-01:45`)
- Marketing mentor에게 기존 기획서, 팀의 현재 단계, 가장 고민되는 질문을 전달하기로 했다. (`12:25-13:08`)
- 오래된 기획서의 30대 직장인 persona가 여전히 적절한지 검토가 필요하다는 문제 제기가 있었지만, 근간이 바뀐 것은 없다는 의견도 있었다. 기존 문서는 그대로 보내고 현재 진행 상황을 보충하는 방향으로 정리됐다. (`13:08-19:14`)
- 현재 단계는 `MVP 개발 완료 이후 alpha test 중`으로 설명하고, marketing 관련 실작업은 아직 없다고 전달하기로 했다. (`19:21-20:20`)

### Marketing 예산과 질문

- Marketing에 사용할 수 있는 금액은 400만원 전체보다 적고 약 300만~320만원 수준이라는 추정이 언급됐다. 뒤이은 숫자는 자동 전사가 불명확해 확정 예산으로 기록할 수 없다. (`20:27-21:45`)
- 직접 광고물을 만들어 Instagram 등 platform에 게시하려고 하지만, 첫 시작, channel 선택, 예산 배분, 소재 제작과 배포 방식을 모르겠다는 점을 mentor에게 전달할 핵심 질문으로 정리했다. (`21:49-25:18`)

## 진행 상황

- User Memory 별도 table과 event question field를 개발 중이거나 반영했다. (`01:49-02:50`, `25:20-26:36`)
- Local AI quality evaluation repository와 실행 계획을 만들고 있다. (`03:05-04:14`)
- External API bottleneck을 재현할 fake server 기반 K6 test를 설계 중이다. (`05:00-08:09`)
- Photo item 개별 삭제를 Android UI에 반영했고 위치 noise 개선을 준비 중이다. (`08:13-11:29`)
- Marketing mentor에게 전달할 기획·현황·질문을 정리했다. (`12:25-25:18`)

## 결정·제안·미결 사항

| 분류 | 내용 | 근거 |
|---|---|---|
| 구현 보고 | Event당 nullable question field를 database에 추가 | `02:14-02:50` |
| 구현 보고 | User Memory를 User table과 분리한 별도 table로 구성 | `25:20-26:36` |
| 구현 보고 | Event photo를 한 건씩 삭제하는 client flow 반영 | `08:13-09:22` |
| 실행 방향 | External API 명세를 흉내 낸 temporary server로 connection pool과 load pattern 시험 | `06:29-08:09` |
| 전달 합의 | 기존 기획서와 현재 alpha test 상태, marketing 시작 질문을 mentor에게 전달 | `18:26-25:18` |
| 제안 | 위치 movement 판단 threshold를 20분으로 시험한 뒤 noise에 따라 상향 | `10:47-11:29` |
| 미결 | On-device SLM의 Android code ownership과 module interface | `04:14-04:46` |

## 액션 아이템

| 작업 | 담당 | 기한 | 상태 | 근거 |
|---|---|---|---|---|
| Question field가 추가되는 API 목록과 nullable contract 공유 | 발언자 본인 | 미확인 | 예정 | `02:14-02:50` |
| Langfuse 실행을 가져와 평가하는 local program 설계·구현 | 발언자 본인 | 미확인 | 계획 중 | `03:05-04:14` |
| Temporary fake external API server로 K6 load test 수행 | 발언자 본인 | 미확인 | 진행 중 | `05:00-08:09` |
| GPS false movement와 20분 threshold를 실제 data로 검증 | 관련 발언자 | release 전 | 예정 | `09:50-11:29` |
| 기존 기획서와 현재 단계, marketing 질문을 mentor에게 전달 | 발언자 본인 | 회의 당일 | 예정 | `18:26-25:18` |
| 중간 점검 형식과 mentor 일정 확인 | 팀 | 미확인 | 예정 | `00:55-01:45` |

## 열린 질문

- LLM-as-judge 평가 점수와 사람이 보는 timeline 품질은 어떻게 교정할 것인가?
- User Memory에 집 위치·성별 등 민감하거나 추론된 profile을 저장할 때 consent·삭제·정정 정책은 무엇인가?
- WebClient connection pool 가설은 실제 metrics와 thread model로 확인됐는가?
- 20분 threshold가 GPS noise는 줄이면서 실제 짧은 방문을 보존하는가?
- Marketing persona는 30대 직장인으로 유지할지 alpha test 결과에 따라 넓힐지?

## 주의 사항

- `K6`, `Langfuse`, `Kakao API`, `WebClient`, `SLM` 등 기술명이 자동 전사에서 왜곡됐을 수 있다.
- Connection pool 동작과 비용 수치는 발언자의 가설 또는 rough estimate이며 측정·문서 확인이 필요하다.
- User Memory에 언급된 profile field는 예시이며 확정 schema로 취급하면 안 된다.
- Marketing 가능 예산은 숫자 전사가 불명확하므로 원 예산표를 확인해야 한다.
- Transcript attribution을 따랐지만 담당자와 완료 상태는 발언에서 명시된 범위 밖으로 추론하지 않았다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[android-life-logging-data-collection]]
- [[laimory-ai-runtime-and-observability]]
