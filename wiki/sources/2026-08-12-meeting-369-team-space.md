---
title: 369팀 스페이스 회의 요약 - 2026-08-12
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260812_2259/회의 요약_369팀 스페이스_20260812.md
transcript_path: raw/meetings/369팀 스페이스_20260812_2259/대화 내용_369팀 스페이스_20260812.md
meeting_date: 2026-08-12
ingest_date: 2026-08-31
duration: 02:09:27
transcript_type: auto-generated
speaker_attribution: available
status: ingested
tags: [meeting, transcript, 369-team, laimory, midterm-report, privacy, location-data, consent-ux, retention, goal-tracking]
---

# 369팀 스페이스 회의 요약 - 2026-08-12

## 개요

이번 회의는 중간 발표 보고서 작성, AI evaluation system, 사용자 data 비식별화, 개인정보 동의 UX, 위치·이동 data의 선택적 제외, on-device AI의 필요성, 핵심 persona, 회고 기능을 대체할 목표 관리 기능을 약 2시간 9분 동안 폭넓게 논의한 회의다.

개발 현황으로는 AI evaluation system이 PR 확인 단계에 가까워졌고, server에서는 user ID를 secret key로 단방향 hash한 값과 별도 subject ID를 mapping하는 구조를 만들고 기존 data migration을 진행 중이라고 보고했다. mobile에서는 timeline 생성 직전의 동의 flow, edit mode와 saved 처리, 감정별 calendar view의 Figma 및 issue 작업을 진행했다. (`01:10-05:45`)

중간 발표 문서에서는 기존 기획심의 내용을 옮기되, 회고 기능을 대신할 목표 추적 기능, persona, on-device AI와 개인정보 보호 설명을 다시 정해야 한다고 보았다. persona는 나이 자체보다 “이제 막 직장 생활을 시작했고 기록을 적극적으로 하는 사람”으로 좁히는 방향에 합의했다. 목표 기능은 todo보다 월 단위 목표를 먼저 받고, timeline에서 목표와 관련된 행동을 찾아 사용자가 확인하게 하며, progress와 reminder를 제공하는 방향으로 정리되었다. 이 기능의 주된 설명 근거는 추상적인 “성장”보다 재방문과 retention을 높이는 데 두기로 했다. (`06:02-14:41`, `42:30-50:56`, `1:55:02-2:03:32`)

개인정보·위치 처리에서는 사용자가 빼고 싶은 장소를 선택하면 그 장소 자체와 연관된 movement record를 mobile에서 제거해 server로 아예 보내지 않는 방향을 정했다. 반복 동의 UX는 매번 받아야 하는지, onboarding에서 한 번만 받으면 되는지 법적·정책적 확인이 필요해 미결로 남았다. 현재 flow에는 on-device AI가 필수적이지 않다는 결론을 내렸지만, 발표에서 개인정보 질문에 답할 수 있도록 정규식 masking, 사용자 확인, hash·mapping 분리 구조를 명확히 설명해야 한다고 정리했다. (`51:06-1:13:35`, `1:25:05-1:29:14`)

## 상세 요약

### 개발과 보고서

- 기존 기획심의 내용을 중간 발표 문서로 옮기고 수정할 부분을 표시했다. AI evaluation system은 PR 확인 단계에 가까워졌다고 보고했다. (`01:10-02:38`)
- server에서는 user ID를 단방향 hash하고 hashed ID와 subject ID를 mapping하는 구조를 만든 뒤 기존 data migration을 진행 중이다. (`03:09-04:17`)
- mobile에서는 timeline 생성 동의, edit mode·saved 처리, 감정별 calendar view의 Figma와 issue 작업을 진행했다. (`04:21-05:45`)
- 수행 방법은 주요 기능보다 AI·Android·backend·협업 process·통합·배포처럼 영역별로 나누고, 개발 진행 현황에는 MVP와 각 분야의 실제 문제 해결을 담기로 했다. (`15:50-23:15`)
- free·paid tier는 기능 차이보다 횟수나 목표 개수로 제한하는 편이 현실적이라는 의견이 있었고, 하루 AI 호출 비용 약 70원을 잠정 목표로 검토했다. (`23:50-27:58`)

### 목표 기능과 Persona

- 회고 대신 사용자가 목표를 입력하고 timeline을 바탕으로 목표에 가까워졌는지 질문·확인하며 progress를 보여주는 기능이 제안되었다. (`06:11-09:51`)
- 자동 정량 판정이 어렵고 data가 부족할 수 있어 LLM이 관련 사건을 찾고 사용자가 `yes/no`로 확인하는 흐름을 검토했다. (`07:46-09:41`, `33:03-42:24`)
- persona는 `30대 직장인`이라는 연령 중심 표현보다, 기록을 적극적으로 하는 사회 초년생 직장인으로 정리했다. (`42:30-50:56`)
- todo는 입력 부담이 크므로 월 단위 목표에서 시작하고, timeline 분석·사용자 확인·progress·조절 가능한 reminder를 제공하는 방향으로 정리했다. (`1:55:02-2:02:40`)
- 목표 기능의 핵심 설명 목적은 추상적인 성장보다 timeline 작성 이후의 재방문과 retention으로 두기로 했다. (`2:01:41-2:03:32`)

### 동의와 Location privacy

- 매번 필수 동의를 다시 받을지 onboarding에서 한 번만 받을지 해석이 엇갈렸다. 매번 data는 보여주되 동의 빈도는 정책을 조사한 뒤 정하기로 했다. (`53:14-1:06:32`)
- 사용자가 전송될 data를 직접 보고 원하지 않는 항목을 제외할 수 있게 하는 것은 핵심 UX로 유지했다. (`56:20-58:18`, `1:08:12-1:08:54`)
- movement와 stay를 모두 노출하기보다 장소 중심으로 보여주고 중복 장소를 합치며 map pin을 제공하는 방안을 검토했다. (`1:09:03-1:15:40`)
- 사용자가 특정 장소를 제외하면 그 장소와 관련된 출발·도착 movement까지 mobile에서 제거해 server에 보내지 않기로 했다. (`1:10:17-1:13:35`)
- 체류 20분 기준과 위치 update 방식에서 noise가 발생한 것으로 보고, location logic을 개선한 뒤 재확인하기로 했다. (`1:16:18-1:17:31`)

### On-device AI와 비식별화

- 현재 data 검토·제외 flow에는 on-device AI가 필수적이지 않다는 결론을 내렸다. (`1:25:05-1:25:29`)
- 기획심의 때 on-device AI로 개인정보를 미리 처리한다고 설명했기 때문에, 이를 빼면 정규식 masking·민감정보 동의·사용자와 AI data의 연결 관계 분리로 대체 설명해야 한다. (`1:25:29-1:27:08`)
- user ID를 AWS Secrets Manager의 secret으로 단방향 hash하고, hash를 mapping table key로 사용해 subject ID를 얻는 구조가 설명되었다. DB와 secret이 모두 유출되면 식별 가능할 수 있다는 한계도 언급했다. (`1:27:09-1:29:14`)

### Retention과 Monetization

- data 권한별 생성 결과 예시를 onboarding에서 보여주어 민감한 권한을 허용할 가치를 체감시키자는 제안이 있었다. (`1:39:11-1:40:50`)
- LLM context inference와 user memory 누적으로 제한된 자동 수집 data를 더 사용자 친화적인 결과로 바꿀 수 있다는 설명을 보고서에 넣기로 했다. (`1:43:02-1:44:24`)
- 무료 횟수를 다 쓴 사용자가 생성 직전에 도달했을 때 upgrade를 제안해 지불 의사를 측정하는 방안이 나왔다. 실제 구현 확정 여부는 불분명하다. (`1:48:18-1:50:23`)

### 보고서 분담

- 8월 15일에 문서를 올리고 feedback을 기다릴 수 있도록 금요일까지 최대한 완성하기로 했다. (`2:03:41-2:05:02`)
- 이동건은 문제 인식·기획 의도·persona·AI 구조·AI 활용 전략을, 정수현은 system 구성도와 결과물 활용 방안 검토를, 전형선은 추진 일정 보완을 맡는다고 명시했다. (`2:06:51-2:09:04`)

## 결정·제안·미결 사항

| 분류 | 내용 | 근거 |
|---|---|---|
| Persona 결정 | 기록을 적극적으로 하는 사회 초년생 직장인을 핵심 persona로 표현 | `49:38-50:56` |
| Data 처리 결정 | 제외 장소와 연관 movement를 mobile에서 제거하고 server에 보내지 않음 | `1:12:29-1:13:35` |
| 기술 방향 결정 | 현재 data 검토·제외 flow에는 on-device AI가 필수적이지 않음 | `1:25:05-1:25:29` |
| 기능 방향 결정 | 월 단위 목표에서 시작해 timeline 기반 확인·progress·reminder 제공 | `1:55:02-2:02:40` |
| 제품 설명 결정 | 목표 기능의 주된 목적을 retention으로 설명 | `2:02:40-2:03:32` |
| 미결 | 반복 동의 빈도, 목표 progress 표현, map UI, location noise 정확도 | `53:14-1:06:32`, `1:14:03-1:24:47`, `1:56:43-2:02:40` |

## 액션 아이템

| 작업 | 담당자 | 기한 | 상태 | 근거 |
|---|---|---|---|---|
| 문제 인식·기획 의도·persona·AI section 수정 | 이동건 | 2026-08-15 이전 | 예정 | `2:06:51-2:07:43` |
| system 구성도와 결과물 활용 방안 검토 | 정수현 | 2026-08-15 이전 | 진행 중·예정 | `2:07:22-2:07:30`, `2:08:42-2:09:04` |
| 추진 일정 보완 | 전형선 | 2026-08-15 이전 | 예정 | `2:07:43-2:07:59` |
| 반복 동의의 법적·정책적 요구 조사 | 전형선 | 미확인 | 확인 필요 | `59:20-1:01:08` |
| 제외 장소 관련 movement를 mobile에서 제거하고 test | 전형선 | 미확인 | 예정 | `1:12:29-1:13:35` |
| 체류·이동 noise 개선 후 실제 data 재확인 | 전형선 | 미확인 | 예정 | `1:16:18-1:17:31` |

## 열린 질문

- 목표 progress와 reminder 빈도를 어떻게 설계할 것인가?
- 반복 동의와 data 고지의 실제 법적 요구는 무엇인가?
- 장소를 제외한 뒤 photo·calendar data와의 맥락 불일치를 어떻게 검증할 것인가?
- on-device AI를 보고서와 실제 MVP에서 각각 어떻게 설명하고 구현할 것인가?
- 하루 AI 호출 비용 70원 목표는 어떤 가정에서 나온 것인가?

## 주의 사항

- 화자 label이 있지만 자동 전사이므로 이름·전문 용어·문장 경계 오류가 있다. 명시적 발언과 분담만 기록했다.
- 개인정보 동의와 비식별화 설명은 내부 설계 논의이며 법률 자문이나 security audit 결과가 아니다.
- one-way hash 구조는 algorithm, secret rotation, access control, threat model을 확인해야 평가할 수 있다.
- persona, 목표 기능, monetization은 상세 명세와 구현 상태가 아직 미확정이다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-data-privacy-and-consent]]
- [[laimory-user-memory]]
- [[android-life-logging-data-collection]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
