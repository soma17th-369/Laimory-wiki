---
title: 369팀 스페이스 회의 요약 - 2026-09-02
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260902_2300/회의 요약_369팀 스페이스_20260902.md
transcript_path: raw/meetings/369팀 스페이스_20260902_2300/대화 내용_369팀 스페이스_20260902.md
meeting_date: 2026-09-02
ingest_date: 2026-09-04
duration: 00:57:09
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory, onboarding, timeline-editing, empty-state, release, ai-evaluation]
---

# 369팀 스페이스 회의 요약 - 2026-09-02

## 개요

AI prompt metric과 server cache 작업을 공유하고, onboarding을 고정한 뒤 읽기·편집 mode, AI 질문 표시, 완전 무입력 user의 첫 Timeline 경험을 논의한 회의다.

## 핵심 내용

- Timeline prompt의 모호한 표현을 정량 기준으로 바꾸고 모순·불필요 instruction을 정리하는 작업을 진행했다. server에서는 query 증가를 줄이기 위해 cache 적용을 학습·구현 중이라고 보고했다. (`00:33-02:30`)
- onboarding은 photo 의미 분석 문구, 일정이 채워진 calendar, 직사각형 map과 여러 marker, notification·reminder 설명을 반영했고 현재 상태로 고정했다. (`04:02-16:44`)
- 14세 이상 확인은 Kakao에서 나이를 가져오지 못해 login 또는 onboarding의 self-attestation으로 받는 안이 제시되었지만 위치와 문구는 미결이다. (`11:45-13:30`)
- 읽기 mode에서는 AI 질문을 숨기고, 편집 button으로 기존 event 편집 화면에 진입하는 별도 depth를 유지하기로 했다. AI 질문은 우선 미작성 memo placeholder로 둔다. (`14:00-34:46`)
- input이 없을 때 생성 차단과 AI를 거치지 않는 manual blank Timeline이 대립했으나, data 부족 이유와 권한·입력 개선 방법을 설명해야 한다는 방향에는 합의했다. (`34:48-50:52`)
- event 추가 기능은 구현되어 있다고 보고됐지만 empty state 연결과 이번 release 포함 여부는 확정되지 않았다. (`42:03-50:52`)

## 상태 구분

| 분류 | 내용 | 근거 |
|---|---|---|
| 진행 중 | prompt 정량화·정리, server cache 적용 | `00:33-02:30` |
| 구현 보고 | 전날 feedback을 반영한 onboarding | `04:02-13:34` |
| 결정 | onboarding 고정, 읽기·편집 mode 우선 | `13:30-16:44` |
| 잠정 결정 | 별도 depth 편집과 edit-mode 질문 placeholder 유지 | `17:50-34:12` |
| 구현 보고 | event 추가 기능·API | `42:03-44:30` |
| 방향 | 저입력 결과에 원인과 개선 방법 안내 | `42:46-50:30` |
| 미결 | 완전 무입력 first experience와 release 포함 범위 | `34:48-50:52` |

## 주의 사항

- 14세 self-attestation은 법률 검토 결과가 아니다.
- cache 대상과 query 유형은 자동 전사만으로 확정할 수 없다.
- 구현 보고는 source code나 release artifact로 검증하지 않았다.
- release 일정과 empty-state 반영은 목표·제안이며 완료가 아니다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-planning-and-validation]]
- [[laimory-ai-model-evaluation]]
- [[laimory-data-privacy-and-consent]]
