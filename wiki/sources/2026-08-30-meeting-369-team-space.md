---
title: 369팀 스페이스 회의 요약 - 2026-08-30
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260830_2259/회의 요약_369팀 스페이스_20260830.md
transcript_path: raw/meetings/369팀 스페이스_20260830_2259/대화 내용_369팀 스페이스_20260830.md
meeting_date: 2026-08-30
ingest_date: 2026-08-31
duration: 00:29:51
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory, ai-model-routing, llm-evaluation, policy, onboarding, empty-state]
---

# 369팀 스페이스 회의 요약 - 2026-08-30

## 개요

AI model routing과 평가 비용, promotion·onboarding asset, 약관 작성·배포, load test server, Android permission·notification 설정, input이 없는 날의 timeline empty state를 논의한 회의다.

## 핵심 내용

- `Nova Lite`로 들리는 model은 message에서 실제 행동을 추론하는 성능이 부족해 주력 후보에서 제외하기로 했다. (`00:39-01:21`)
- 간단한 event 처리에는 저렴한 `5.6 Luna`, 핵심 timeline에는 전사상 `5.3 mini`로 들리는 상위 model을 쓰는 단계별 routing을 계획했다. 정확한 model명과 실제 배포 상태는 확인이 필요하다. (`01:22-04:15`)
- 반복 평가 API 비용을 줄이기 위해 local evaluation program을 이미 구독한 Codex CLI와 연결해 LLM judge로 쓰는 방향을 시험했다. (`02:46-03:50`)
- promotion과 onboarding은 photo·calendar·location·notification이 timeline으로 정리되는 흐름을 맞추고, 개인정보가 없는 AI 생성 best example을 사용하려 했다. (`05:42-10:36`)
- 데이터 처리 국가와 항목을 보수적으로 적은 약관을 database에 반영했다고 보고했다. (`11:37-12:17`)
- development 중단을 피하도록 dev를 복제한 on-demand load test server를 계획했다. database·Redis 공유에 따른 isolation은 별도 검증이 필요하다. (`12:19-12:53`)
- mobile은 initializer API에서 최신 약관 URL을 받아 WebView로 보여주기로 했다. 현재 Spring이 HTML을 서빙하지만 landing page와 함께 static hosting으로 옮기고 backend URL만 바꾸는 방향을 정했다. (`14:59-22:18`)
- 사진이 없는 loading 화면에는 icon 기반 motion visual이 필요하고, 모든 input과 user memory가 없는 신규 user에게는 설명·기본 질문·입력 field를 제공하는 empty state가 필요하다는 결론에 가까운 방향이 제시되었다. 최종 구현은 미결이다. (`24:02-29:12`)

## 상태 구분

| 분류 | 내용 | 근거 |
|---|---|---|
| 결정 | Nova Lite 주력 후보 제외 | `00:39-01:21` |
| 잠정 결정 | event와 timeline 단계별 model routing | `01:48-04:15` |
| 진행 중 | Codex CLI 기반 local LLM judge | `02:46-03:50` |
| 구현 보고 | 보수적 약관 database 반영 | `11:37-12:17` |
| 계획 | on-demand load test server | `12:19-12:53` |
| 결정 | 약관 URL을 API로 받아 WebView 표시, 이후 static hosting으로 이전 | `15:51-22:18` |
| 제안·미결 | 사진 없는 loading visual과 완전 무입력 empty state | `24:02-29:12` |

## 주의 사항

- model명·가격·성능 비교는 전사가 불안정하고 공식 benchmark가 아니므로 code·deployment config·billing 확인이 필요하다.
- 약관 논의는 법률 자문이 아니며 중요한 변경의 재동의 기준은 별도 검토해야 한다.
- load test server 비용 추정은 공유 infrastructure를 전제로 한 대략값이다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
- [[ai-daily-timeline-generation]]
- [[android-life-logging-data-collection]]
- [[laimory-planning-and-validation]]
- [[laimory-data-privacy-and-consent]]
