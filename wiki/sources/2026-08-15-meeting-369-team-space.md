---
title: 369팀 스페이스 회의 요약 - 2026-08-15
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260815_2331/회의 요약_369팀 스페이스_20260815.md
transcript_path: raw/meetings/369팀 스페이스_20260815_2331/대화 내용_369팀 스페이스_20260815.md
meeting_date: 2026-08-15
ingest_date: 2026-08-31
duration: 00:27:29
transcript_type: auto-generated
speaker_attribution: transcript-provided
status: ingested
tags: [meeting, transcript, 369-team, laimory, beta-test, presentation, analytics, account-deletion]
---

# 369팀 스페이스 회의 요약 - 2026-08-15

## Summary

중간 보고서와 발표자료를 8월 16일까지 초안 수준으로 마무리하고 19일까지 수정한 뒤 21일 발표하는 계획이 정리되었다. 발표 준비와 동시에 app UX를 release 가능한 수준으로 끌어올리고 외부 tester를 모집하며 측정 지표를 구체화하기로 했다. 이상적인 beta 일정은 8월 23~29일, app review 병행, 9월 초·중순 release였지만 일정 지연 가능성이 있어 최소 3일이라도 실행하는 목표가 함께 언급되었다. (`03:17-10:53`)

개발 측면에서는 scheduler multi-process와 load script 정리 완료, date-time picker와 timeline 생성 UX 작업, GA4 business metric과 Firebase 계열 crash log 도입 계획이 공유되었다. 회원 탈퇴 후 재가입을 soft-deleted user 복구로 처리할지 신규 user로 만들지, 탈퇴 data를 언제 완전 삭제하고 어떻게 안내할지는 미결로 남았다. (`01:08-02:49`, `11:13-16:47`)

## Key Claims

- Scheduler multi-process와 load script를 마쳤고 API를 작업 중이라는 보고가 있었다. (`01:08-01:21`)
- Laimory component로 date-time picker를 설계하고 beta tester의 timeline 생성 UX에 적용하려 했다. (`01:25-02:24`)
- Beta는 개발진 외부 사용자가 실제로 쓰는 것이 핵심이며 약 10명도 유의미하다는 의견이었으나 확정 인원은 아니다. (`06:18-07:00`)
- Onboarding·권한 설명, login, 행동 지표, crash log가 release 전 주요 과제로 제시되었다. (`09:00-09:31`, `14:14-16:47`)
- Business metric과 crash/error log를 우선 적용하고 performance log는 후순위로 두는 방향이 제시되었다. (`15:17-16:47`)
- 발표 시연은 live demo보다 실제 app flow를 사전 녹화한 영상을 우선 사용하기로 했다. (`18:33-21:14`)

## Decisions and Open Items

| 분류 | 내용 | 근거 |
|---|---|---|
| 실행 방향 | 발표 준비와 beta test 준비를 병렬 진행 | `07:21-10:40` |
| 일정 목표 | 16일까지 보고서·발표 초안, 19일까지 수정, 21일 발표 | `10:03-10:28` |
| 시연 방향 | Live demo보다 사전 녹화 영상 우선 검토 | `19:03-21:14` |
| 미결 | 탈퇴 후 재가입의 identity·data 처리 | `11:13-12:31` |
| 미결 | 탈퇴 data 보존·삭제·사용자 안내와 app review 요건 | `12:36-14:03` |

## Caveats

- Beta·release 일정은 목표안이며 확정 일정이 아니다.
- 회원 탈퇴 data 보존과 store review 관련 발언은 법률·platform policy 확인 결과가 아니다.
- 완료·진행 상태는 발언자의 보고 기준이며 merge, deployment, test 상태는 repository에서 별도 확인해야 한다.
- AI model 비교 부분과 일부 tool 명칭은 자동 전사가 불명확하다.
- 원문에는 개인 일정과 이동 정보가 포함되어 있으므로 공개 범위를 제한해야 한다.

## Related Pages

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-planning-and-validation]]
- [[android-life-logging-data-collection]]
- [[laimory-ai-model-evaluation]]
- [[laimory-data-privacy-and-consent]]
