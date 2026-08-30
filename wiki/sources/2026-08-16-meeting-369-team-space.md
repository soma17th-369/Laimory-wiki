---
title: 369팀 스페이스 회의 요약 - 2026-08-16
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260816_2229/회의 요약_369팀 스페이스_20260816.md
transcript_path: raw/meetings/369팀 스페이스_20260816_2229/대화 내용_369팀 스페이스_20260816.md
meeting_date: 2026-08-16
ingest_date: 2026-08-31
duration: 00:35:13
transcript_type: auto-generated
speaker_attribution: transcript-provided
status: ingested
tags: [meeting, transcript, 369-team, laimory, beta-test, notification-filtering, terms, presentation]
---

# 369팀 스페이스 회의 요약 - 2026-08-16

## Summary

Timeline 저장 상태와 calendar 월별 API를 merge했다는 보고와 함께, 약관은 server가 DB 본문이나 external document link를 추상화해 client에 제공하는 구조가 제안되었다. 실제 app 시연은 login 이후 data 확인·선택, AI loading, timeline 편집과 save까지 보여주며, prototype보다 실제 기기 data를 우선 사용하기로 했다. (`04:40-12:38`)

핵심 논의는 notification filtering이었다. 결제·예약·배송 같은 keyword·category와 주요 app을 기준으로 유의미한 notification을 우선 수집하는 방안이 설명되었으나 아직 구현되지 않았다. 기존 local data를 삭제하는 임시안보다 beta/release user flow를 완성하는 것이 목적임을 확인했고, 사용자가 app별 filter를 직접 조작하지 않도록 제품이 자동 선택하는 기능을 Kotlin migration과 logging 정리보다 우선하기로 했다. (`12:40-24:00`)

Mentor의 “기록보다 높은 지속 가치” feedback에는 공유, 목표 관리, AI memory·assistant가 아이디어로 나왔지만 결론은 없었다. 중간 보고서에 성급한 답을 넣지 않고 이후에도 해결할 project-level question으로 남겼다. (`28:21-34:49`)

## Key Claims

- Timeline 저장 상태와 calendar 월별 API를 완료해 merge했다는 구현 보고가 있었다. (`04:40-04:57`)
- 약관 storage를 server가 추상화하면 client update 없이 내용 변경을 반영할 수 있다는 설계가 제시되었다. (`05:01-05:58`)
- Notification filter는 아직 적용되지 않았으며 keyword·category·app·click 여부를 활용하는 1차 방안이 검토되었다. (`12:40-14:31`)
- Filter는 demo 편의를 넘어 timeline 생성 flow의 핵심이며, 사용자가 수동으로 app을 거르는 조작을 없애는 방향으로 정리되었다. (`17:47-22:39`)
- 사용자에게 자연스러운 flow와 notification filter를 먼저 진행하고 Kotlin migration·module 정리는 beta 기간으로 미루기로 했다. (`22:41-24:00`)
- 보고서와 발표자료 제출 목표는 8월 17일 12시로 정리되었다. (`34:07-34:49`)

## Decisions and Open Items

| 분류 | 내용 | 근거 |
|---|---|---|
| 설계 방향 | 약관 저장 위치를 server가 추상화하고 client는 API로 수신 | `05:01-05:58` |
| 우선순위 | Notification 자동 filtering과 beta UX를 기술 migration보다 먼저 처리 | `21:25-24:00` |
| 임시 제안 | 시연용으로 기존 notification을 수동 삭제할 기능 | `16:55-17:43` |
| 미결 | 기존 local notification data migration 방식 | `16:02-18:29` |
| 미결 | 기록 누적이 주는 장기 가치와 지속 사용 동기 | `28:21-34:03` |

## Caveats

- Notification `100개`는 예시로 들린 수치이며 확정 platform limit인지 확인되지 않았다.
- Filtering rule은 keyword, category, app, click 여부가 섞인 아이디어 단계다.
- API merge는 발언 기준이며 deployment와 integration test 완료를 뜻하지 않을 수 있다.
- AI memory·character·assistant는 brainstorming이며 roadmap 결정이 아니다.
- 원문에는 개인 일정이 포함되어 있으므로 공개 범위를 제한해야 한다.

## Related Pages

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-planning-and-validation]]
- [[android-life-logging-data-collection]]
- [[laimory-user-memory]]
- [[laimory-data-privacy-and-consent]]
