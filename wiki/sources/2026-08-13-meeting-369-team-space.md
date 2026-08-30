---
title: 369팀 스페이스 회의 요약 - 2026-08-13
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260813_2258/회의 요약_369팀 스페이스_20260813.md
transcript_path: raw/meetings/369팀 스페이스_20260813_2258/대화 내용_369팀 스페이스_20260813.md
meeting_date: 2026-08-13
ingest_date: 2026-08-31
duration: 00:09:29
transcript_type: auto-generated
speaker_attribution: available
status: ingested
tags: [meeting, transcript, 369-team, laimory, midterm-report, scheduler, redis, calendar-ui, timeline-status, android-location]
---

# 369팀 스페이스 회의 요약 - 2026-08-13

## 개요

이번 회의에서는 중간 또는 주간 보고서 작성 진행, server scheduler·API·Redis script 정리, mobile calendar UI와 timeline loading 수정, 20분 미만 movement data 처리, draft·saved timeline의 API response policy를 점검했다.

보고서는 현재 28page까지 늘어났으며, 먼저 필요한 내용을 모두 넣은 뒤 나중에 한꺼번에 줄이는 방식으로 작업하기로 했다. AI 관련 수행 방안과 개발 진행 현황을 8월 13일까지 1차 마무리하고, 8월 14일에는 marketing 부분을 마무리해 8월 15일까지 전체를 끝내는 목표가 공유되었다. (`01:15-02:50`)

server에서는 multi-process 환경의 scheduler, 요청받은 API, project 전반에 흩어진 Redis script 정리를 진행하고 있다고 보고했다. mobile에서는 calendar API가 완성되기 전 전체 data를 받아 월별로 mapping하는 임시 UI를 구현했고, saved·draft 상태에서 loading 처리가 이상한 문제를 수정했다. movement는 20분 미만이면 저장하지 않도록 변경했다고 보고했으나, 이 기준이 모든 edge case에 적절한지는 별도 검증이 필요하다. (`02:55-05:33`)

draft와 saved timeline을 조회할 때 어느 상태를 보낼지 논의한 결과, 둘 다 보내고 감정 값이 없는 경우 `null`로 전달하기로 했다. 상태 값도 함께 제공해 향후 saved data만 user memory에 반영하는 등 business logic이 달라질 때 활용할 수 있도록 하는 방향이다. (`05:36-07:30`)

## 상세 요약

### 보고서

- 보고서가 28page까지 늘었지만 현재는 필요한 내용을 모두 넣고 마지막에 줄이기로 했다. (`01:15-02:09`)
- AI 관련 수행 방안과 진행 현황은 8월 13일, marketing 부분은 8월 14일에 정리해 8월 15일까지 전체를 마무리할 목표다. (`02:10-02:50`)
- mobile 관련 보고서 내용은 다음 날 아침에 다른 구성원들과 맞추며 작성하기로 했다. (`05:09-05:33`)

### Server 작업

- multi-process 환경에서 scheduler가 동작하도록 하는 작업, 요청 API, project에 흩어진 Redis script 정리를 진행 중이라고 보고했다. (`03:09-03:24`)
- 전사상 관련 파악 또는 설계가 끝나 하나씩 AI를 활용해 code를 변경하면 될 것 같다고 했으나, 정확한 완료 범위는 불명확하다. (`03:24-03:36`)

### Mobile과 location

- calendar API 전에는 전체 data를 조회해 월별로 mapping하는 임시 구현을 만들었고, calendar 감정 view UI도 구현했다. (`03:41-04:10`, `04:57-05:09`)
- saved와 draft 화면의 loading 문제를 수정했다. (`04:11-04:31`)
- movement data는 20분 미만이면 저장하지 않도록 변경했다. edge case가 많아 우선 단순 rule을 적용한 상태이며 정확도 검증 완료 근거는 없다. (`04:31-04:57`)

### Draft·saved response

- timeline 단건 조회 response에 상태 값을 추가할 예정이다. (`05:41-06:01`)
- saved만 보낼지 draft와 saved를 모두 보낼지 논의한 결과 둘 다 보내기로 했다. draft에 감정이 없으면 `null`로 전달한다. (`06:03-06:38`)
- 상태 값은 향후 saved data만 user memory에 반영하는 등 business logic을 구분할 때 활용할 수 있다는 이유로 함께 제공하기로 했다. (`06:36-07:30`)

## 결정·제안·미결 사항

| 분류 | 내용 | 근거 |
|---|---|---|
| API 결정 | draft와 saved timeline을 모두 보내고 상태 값을 포함 | `06:03-07:30` |
| Data 표현 결정 | draft의 감정 값이 없으면 `null`로 전달 | `06:27-06:38` |
| 구현 보고 | 20분 미만 movement를 저장하지 않도록 변경 | `04:31-04:57` |
| 일정 목표 | AI·marketing section을 순차 마무리해 8월 15일까지 보고서 완료 | `02:10-02:50` |
| 미결 | 20분 rule의 edge case 적합성과 scheduler·Redis 정리의 완료 범위 | `03:09-03:36`, `04:31-04:57` |

## 액션 아이템

| 작업 | 담당자 | 기한 | 상태 | 근거 |
|---|---|---|---|---|
| 보고서 AI 부분 1차 마무리 | 이동건 | 2026-08-13 | 진행 중 | `02:10-02:31` |
| 보고서 marketing 부분 마무리와 전체 다듬기 | 이동건 | 2026-08-14~15 | 예정 | `02:31-02:50` |
| multi-process scheduler, 요청 API, Redis script 정리 | 정수현 | 미확인 | 진행 중 | `03:09-03:36` |
| calendar 조회용 API 작성 | 정수현 | 미확인 | 예정 | `03:41-04:10` |
| timeline response에 상태 추가하고 draft·saved 모두 반환 | 정수현 | 미확인 | 합의됨 | `05:49-07:30` |
| 다음 날 mobile 보고서 내용을 함께 조정 | 팀 구성원 | 2026-08-14 | 예정 | `05:09-05:33` |

## 열린 질문

- 20분 미만 movement 제외가 짧지만 의미 있는 이동까지 누락시키지 않는가?
- multi-process scheduler는 어떤 중복 실행·lock·failure recovery 정책을 사용하는가?
- calendar API의 date range, status filter, emotion field schema는 무엇인가?
- draft와 saved data가 user memory와 downstream logic에서 각각 어떻게 사용되는가?

## 주의 사항

- 화자 label이 제공되지만 자동 전사이므로 이름과 기술 용어가 일부 잘못 인식되었다. 명시된 작업 보고와 합의만 사용했다.
- 20분 rule은 구현 보고일 뿐 정확도 검증이 완료되었다는 근거가 없다.
- 개인 일정과 학업 정보가 포함되어 있으므로 공개 범위를 제한해야 한다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-user-memory]]
- [[android-life-logging-data-collection]]
- [[laimory-ai-runtime-and-observability]]
