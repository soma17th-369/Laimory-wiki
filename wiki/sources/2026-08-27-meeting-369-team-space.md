---
title: 369팀 스페이스 회의 요약 - 2026-08-27
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260827_2301/회의 요약_369팀 스페이스_20260827.md
transcript_path: raw/meetings/369팀 스페이스_20260827_2301/대화 내용_369팀 스페이스_20260827.md
meeting_date: 2026-08-27
ingest_date: 2026-08-31
duration: 00:28:30
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory, ai-model, timeline-quality, data-retention, onboarding, notification-filter]
---

# 369팀 스페이스 회의 요약 - 2026-08-27

## 개요

Bedrock model 전환 장애, timeline 품질, production backup과 data lifecycle, Android onboarding·감정·event UI, 초기 release 병목을 점검했다. messenger notification을 대화 event로 과도하게 만드는 사례를 바탕으로 AI 판단과 event 수 제한을 먼저 개선하기로 했다.

## 핵심 내용

- Bedrock model의 JSON output mechanism과 max token 문제가 의심되었으나 log 부족으로 원인이 확정되지 않았다. `GPT 5.6 Luna`로 들리는 model은 조직 SCP에 막힌 것으로 추정해 권한 요청을 다시 제출했다. (`00:37-02:28`, `09:27-09:56`)
- Laimory의 차별점을 장소·사진 나열보다 `왜 갔는지`, `무엇을 했는지`, 사진 의미까지 하루 맥락으로 정리하는 데 두고 user memory 유무의 결과 차이를 확인 중이었다. (`02:31-03:58`)
- production MySQL backup, 회원 탈퇴 7일 후 data 삭제, orphan item cleanup scheduler를 작업했으며 거의 완료됐다고 보고했다. production 배포 완료는 확인되지 않았다. (`05:49-06:42`)
- onboarding permission flow는 구현했다고 보고했고, image·text는 남았다. 감정 표시와 event 추가 진입 UI도 반영했다. (`06:48-09:07`)
- model 문제는 기존 API key 방식으로 우회할 수 있어 release를 즉시 막지는 않으며, 가장 큰 남은 병목은 Android onboarding, draft/saved UI, notification 설정, 약관 연동으로 정리되었다. (`11:37-18:04`)
- messenger notification 클릭을 대화 event로 해석하면 중요하지 않거나 민감한 대화를 과도하게 노출할 수 있다는 문제가 제기되었다. (`19:40-22:27`)
- call log는 향후 대안으로 언급되었지만 당장 scope에 넣지 않고, AI 선택 rule과 max event 수를 보수적으로 조정한 뒤 beta test에서 삭제 pattern을 관찰하기로 했다. (`24:23-26:35`)

## 상태 구분

| 분류 | 내용 | 근거 |
|---|---|---|
| 진행 중 | Bedrock output 오류와 SCP 권한 요청 | `00:37-02:28`, `09:27-09:56` |
| 진행 중 | user memory와 prompt/context 품질 비교 | `02:31-03:58` |
| 구현 중 | backup·탈퇴 data 삭제·orphan cleanup scheduler | `05:49-06:42` |
| 구현 보고 | onboarding permission flow, 감정 표시, event 추가 UI | `06:48-09:07` |
| 결정 | call log는 즉시 추가하지 않고 notification 판단과 event 제한 먼저 개선 | `24:23-26:35` |
| 제안 | beta test에서 불필요 event 삭제 pattern 측정 | `25:25-26:11` |

## 주의 사항

- 문제 timeline이 어떤 model에서 생성됐는지는 회의 중 정정되었으므로 Bedrock 결과로 단정하면 안 된다.
- scheduler는 완료 예상이며 production 실행 검증이 확인되지 않았다.
- call log는 아이디어일 뿐 scope 결정이 아니며 privacy·법적 검토가 선행되어야 한다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[android-life-logging-data-collection]]
- [[laimory-data-privacy-and-consent]]
