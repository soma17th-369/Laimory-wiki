---
title: 369팀 스페이스 회의 요약 - 2026-08-18
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260818_2300/회의 요약_369팀 스페이스_20260818.md
transcript_path: raw/meetings/369팀 스페이스_20260818_2300/대화 내용_369팀 스페이스_20260818.md
meeting_date: 2026-08-18
ingest_date: 2026-08-31
duration: 00:29:37
transcript_type: auto-generated
speaker_attribution: transcript-provided
status: ingested
tags: [meeting, transcript, 369-team, laimory, push-notification, legal-risk, demo-video, presentation]
---

# 369팀 스페이스 회의 요약 - 2026-08-18

## Summary

약 50장의 중간 발표자료와 script를 technical owner가 검수하고, 20분 발표 안에 약 30초 demo를 넣도록 rehearsal하기로 했다. 발표용 promotion image와 실제 app video도 준비 중이었다. (`00:19-03:04`, `12:29-17:39`)

Push notification API는 1차 구현 후 review 단계라고 보고했지만, retention notification을 광고성 또는 정보성으로 분류하는 기준과 야간 발송 동의가 미결이었다. Current code는 광고 type에 광고 표시와 opt-out path를 붙이는 방식이었고, user flow에서 광고·야간 동의를 받는 방법을 별도 설계해야 했다. 회의의 법적 기준 설명과 타 app 사례는 공식 검토 결과가 아니다. (`03:14-10:17`)

Mobile에서는 timestamp spinner, calendar API, draft/saved별 저장 처리를 적용했다고 보고했다. Notification privacy·keyword·live update filtering은 issue로 정리했으나 미완료였고, loading 화면과 nickname 조회까지 연결한 뒤 demo recording과 tester build 배포를 준비하기로 했다. (`10:22-12:24`)

## Key Claims

- Push API 1차 구현을 완료해 review하면 되는 상태라고 보고했다. (`03:14-05:05`)
- 광고성 push라면 광고 표시와 수신 거부 경로를 붙이는 type별 code를 작성했지만 분류 기준은 불확실했다. (`03:30-04:42`)
- 약관 준비에 사업자 등록이 필요하다는 조사 결과가 공유되었고 목요일 신청이 제안되었다. (`05:05-05:30`)
- Timestamp spinner, calendar API, draft/saved 상태별 저장 flow 적용을 완료했다고 보고했다. (`10:22-10:59`)
- Notification filtering은 issue 단계이고 loading·nickname flow를 정리한 뒤 app tester에 build를 배포할 계획이었다. (`10:50-12:24`)
- Saved event 수정이 server에서 허용되는지 불확실해 code로 교차 검증하기로 했다. (`23:53-25:38`)

## Decisions and Open Items

| 분류 | 내용 | 근거 |
|---|---|---|
| 발표 준비 | 30초 내외 실제 app demo를 포함한 20분 발표로 rehearsal | `16:22-17:39` |
| 실행 계획 | Demo-ready flow를 만든 뒤 tester build 배포 | `11:29-12:24` |
| 제안 | Product promotion image를 8월 19일 15시까지 제작 | `13:58-16:20` |
| 미결 | Retention push의 광고성 분류와 광고·야간 수신 동의 | `03:30-10:17` |
| 미결 | Saved timeline event 수정 API의 허용 상태 | `23:53-25:38` |
| 미결 | 이번 주 mentoring 진행 또는 online·async 대체 | `17:45-21:23`, `26:00-26:48` |

## Caveats

- Push 광고성·야간 발송 요건은 법률 자문이나 공식 문서 확인 결과가 아니다.
- `21시`, `사업자 등록 이틀` 같은 수치는 별도 검증이 필요하다.
- 완료 보고는 integration·deployment까지 포함한다고 단정할 수 없다.
- FCM, Firebase와 API 명칭 일부가 자동 전사에서 왜곡되었다.
- 원문에는 개인 약속과 숙박·이동 계획이 포함되어 있으므로 공개 범위를 제한해야 한다.

## Related Pages

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-planning-and-validation]]
- [[android-life-logging-data-collection]]
- [[laimory-data-privacy-and-consent]]
