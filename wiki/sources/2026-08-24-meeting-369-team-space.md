---
title: 369팀 스페이스 회의 요약 - 2026-08-24
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260824_2300/회의 요약_369팀 스페이스_20260824.md
transcript_path: raw/meetings/369팀 스페이스_20260824_2300/대화 내용_369팀 스페이스_20260824.md
meeting_date: 2026-08-24
ingest_date: 2026-08-31
duration: 00:57:05
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory, beta-release, ga4, ai-model, android, notification-filter]
---

# 369팀 스페이스 회의 요약 - 2026-08-24

## 개요

베타 테스트와 Play Store 등록을 앞두고 GA4 지표·퍼널, 프로모션 팸플릿, AI 인프라·모델 전환, backend API, Android 읽기·편집 UX, 자동 데이터 수집, 지도 표시, 알림 filter를 점검한 회의다. 상세 근거와 상태 구분은 raw 회의 요약에 보존되어 있다.

## 핵심 내용

- 설치 가능한 release가 나온 뒤 beta tester에게 실제 연락하고, 그 전에는 후보자를 정리해 두는 방향이 제시되었다. (`01:43-02:45`)
- 첫 가치 행동은 설치 후 이틀 안을 목표로 하되 최대 7일까지 추적하고, retention·funnel 이탈·입력 데이터 제외·AI 결과 수정·메모·permission 허용을 GA4 후보 지표로 삼았다. 산식과 event naming은 미완성이다. (`04:28-12:26`)
- 팸플릿은 사진·캘린더·위치·알림을 하루 기록으로 모으는 흐름과 AI 초안·사용자 수정·재열람을 설명하며, Figma에서 디자인을 보완하기로 했다. (`13:35-16:47`)
- AgentCore 전환과 PR 검수·연결 test가 진행 중이었다. 전사상 `노바트 라이트`로 들리는 Bedrock model로 먼저 바꿔 비교하고, 품질이 부족하면 GPT로 되돌리는 잠정 방향을 잡았다. (`02:50-03:20`, `17:11-23:23`)
- event 생성 API는 optional photo 정보를 함께 받고 S3 file name을 전달하도록 정리했다. (`24:18-26:02`)
- Android는 notification field 보완, 회원 탈퇴 확인 UI, 앱 진입·날짜 선택 시 calendar·건강 데이터 갱신을 진행했다. 읽기와 편집 mode의 경계는 미결이었다. (`27:25-34:36`, `41:27-45:59`)
- 생성 전 위치 확인 지도는 우선 Google Maps로 유지하고 beta feedback 후 재평가하기로 했다. (`29:47-40:42`)
- notification filter는 사용자별 pattern이 달라 공유 문서에서 app·keyword rule을 지속 관리하기로 했다. (`46:09-50:49`)
- 8월 28일까지 Play Store 등록을 시도하되 logging·GA4·deep link·mobile UI 때문에 지연될 수 있음을 인정했다. (`51:41-54:09`)

## 상태 구분

| 분류 | 내용 | 근거 |
|---|---|---|
| 결정·방향 | 첫 가치 행동 이틀 목표, 7일 관찰 | `04:48-06:35` |
| 결정 | 사진을 포함할 수 있는 event 생성 API | `24:18-26:02` |
| 잠정 결정 | Bedrock model 전환 test 후 필요 시 GPT 복귀 | `21:46-23:23` |
| 진행 중 | AgentCore, Android 자동 수집, onboarding, 읽기·편집 UX | `02:50-03:20`, `27:06-45:59` |
| 제안 | notification filter rule 공동 관리 | `47:00-50:49` |
| 미결 | GA4 세부 산식, model 확정, 읽기·편집 전환, 지도 약관·비용 | 여러 구간 |

## 주의 사항

- `노바트 라이트`, `로버트 라이트`로 적힌 model명과 AWS 용어는 전사 오류 가능성이 있어 code·console 확인이 필요하다.
- 일정, Play Store 심사 기간, 지도 호출 비용은 회의 중 추정이며 확정된 외부 정책이 아니다.
- 화자명이 있으나 실제 owner·승인 권한은 별도 record 없이 확대 추론하지 않았다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-ai-runtime-and-observability]]
- [[laimory-ai-model-evaluation]]
- [[ai-daily-timeline-generation]]
- [[android-life-logging-data-collection]]
- [[laimory-planning-and-validation]]
