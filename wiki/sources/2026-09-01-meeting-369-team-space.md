---
title: 369팀 스페이스 회의 요약 - 2026-09-01
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260901_2300/회의 요약_369팀 스페이스_20260901.md
transcript_path: raw/meetings/369팀 스페이스_20260901_2300/대화 내용_369팀 스페이스_20260901.md
meeting_date: 2026-09-01
ingest_date: 2026-09-04
duration: 00:46:50
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory, onboarding, permissions, release, ai-evaluation]
---

# 369팀 스페이스 회의 요약 - 2026-09-01

## 개요

약관 web posting 전환과 AI Timeline 정량 평가 준비 상황을 공유하고, 실제 기기의 onboarding을 검토해 permission 설득·data 활용 설명·release 범위를 정리한 회의다.

## 핵심 내용

- 약관 제공을 web posting 방식으로 전환했다고 보고했고, AI Timeline prompt의 정량 metric을 정해 개선 전후 점수를 비교할 준비를 진행했다. (`00:17-01:13`)
- onboarding은 best Timeline 기대를 먼저 만든 뒤 photo·calendar·location·notification·reminder 관련 안내와 permission으로 이어지는 구조였다. (`03:37-09:11`)
- photo의 시간·위치뿐 아니라 AI가 의미를 해석한다는 점, 빼곡한 calendar 일정, 여러 지점이 이어지는 location route를 더 구체적으로 보여주기로 했다. (`12:27-19:47`, `24:44-28:37`)
- 큰 3D emoji와 감성적 문구가 기능을 가린다는 피드백에 따라, 수집 대상·처리 방식·사용자 이익을 직접 설명하는 문구를 우선하기로 했다. (`28:37-42:47`)
- onboarding asset을 server에서 내려주는 대안도 논의했지만 beta에서는 client 구현을 유지하고 후속 검토하기로 했다. (`20:08-24:44`)
- 전면 재설계 대신 문구와 필수 visual을 다듬어 9월 4일 release를 시도한다는 일정이 제시되었다. 실제 release 완료는 확인되지 않았다. (`39:35-46:50`)

## 상태 구분

| 분류 | 내용 | 근거 |
|---|---|---|
| 구현 보고 | 약관 web posting 전환 | `00:17-00:35` |
| 진행 중 | AI Timeline 정량 metric·prompt 분석 | `00:55-01:13` |
| 방향 | onboarding을 permission 설득과 data 활용 설명 중심으로 구성 | `13:04-14:43`, `38:13-42:47` |
| 수정 결정 | 구체 문구, 작은 emoji, photo·calendar·location 정보 보강 | `12:27-19:47`, `24:44-42:47` |
| 잠정 결정 | beta에서는 onboarding asset을 client에 유지 | `20:08-24:44` |
| 목표 | 9월 4일 release 시도 | `39:35-40:20` |

## 주의 사항

- Figma와 실제 기기 화면이 전사에 없어 세부 UI는 확인할 수 없다.
- server-driven onboarding과 code push는 가능성을 논의한 것이며 구현 결정이 아니다.
- release 일정은 목표일 뿐 완료 보고가 아니다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[android-life-logging-data-collection]]
- [[laimory-planning-and-validation]]
- [[laimory-ai-model-evaluation]]
- [[laimory-data-privacy-and-consent]]

