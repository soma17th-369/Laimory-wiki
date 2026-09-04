---
title: 369팀 스페이스 회의 요약 - 2026-09-03
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260903_2300/회의 요약_369팀 스페이스_20260903.md
transcript_path: raw/meetings/369팀 스페이스_20260903_2300/대화 내용_369팀 스페이스_20260903.md
meeting_date: 2026-09-03
ingest_date: 2026-09-04
duration: 00:39:29
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory, release, timeline-generation, ai-evaluation, ai-cost, beta-test]
---

# 369팀 스페이스 회의 요약 - 2026-09-03

## 개요

marketing asset, AI 정량 평가·비용, Android release hardening을 점검하고, 같은 날 복수 Timeline 생성의 구현 gap을 확인해 beta 임시 운영 규칙을 정한 회의다.

## 핵심 내용

- AI Timeline 정량 metric을 거의 확정했고, prompt 변경 전후를 같은 기준으로 점수화하는 evaluation system에 반영할 계획이라고 보고했다. (`03:12-03:57`)
- Timeline 생성과 User Memory update 한 세트의 평균 비용을 약 `$0.1`로 추정했고, 100명·75일 가정을 바탕으로 prepaid credit을 검토했다. 이는 내부 추정이며 검증된 billing 수치가 아니다. (`05:41-10:40`)
- 읽기·편집 mode, event 추가, notification 설정, light·dark·system theme를 구현했다고 보고했다. release build·login·logging은 남아 있어 주말 release가 현실적일 수 있다고 보았다. (`11:00-20:03`)
- beta 만족도·불만 수집, onboarding User Memory experiment와 일일 call limit을 후속 검토하기로 했다. (`20:05-25:54`)
- server의 same-day draft append는 존재하지만 client의 generation window, previous record 조회와 cached history 연결이 완성되지 않아 복수 생성 UX가 불안정하다고 확인했다. (`26:33-33:14`)
- 초기 beta에서는 하루 한 번, 가능하면 오후 9시 이후 생성하도록 app과 별도 안내에서 유도하고 복수 생성 flow는 beta 중 재설계하기로 했다. (`33:18-35:13`)

## 상태 구분

| 분류 | 내용 | 근거 |
|---|---|---|
| 진행 중 | 정량 metric 기반 AI evaluation·prompt 개선 | `03:12-03:57` |
| 내부 추정 | Timeline+User Memory 평균 약 `$0.1` | `05:41-06:21` |
| 구현 보고 | 읽기·편집, event 추가, notification, theme | `11:00-16:43` |
| 진행 중 | release build·login·logging | `16:47-20:03` |
| 확인된 gap | 복수 생성의 client window·history와 server append 연동 | `26:33-33:14` |
| beta 임시 결정 | 하루 한 번, 오후 9시 이후 생성 안내 | `33:18-35:13` |

## 주의 사항

- 비용은 내부 계산이며 model·sample·billing export가 없어 추정치로만 사용해야 한다.
- 구현 보고와 server behavior는 source code·release artifact로 검증하지 않았다.
- 주말 release는 목표이며 완료가 아니다.
- User Memory experiment는 아이디어 단계로 참여자 동의와 privacy 검토가 필요하다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-planning-and-validation]]
- [[laimory-data-privacy-and-consent]]
