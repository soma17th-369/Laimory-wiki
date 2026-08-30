---
title: 369팀 스페이스 회의 요약 - 2026-08-19
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260819_2300/회의 요약_369팀 스페이스_20260819.md
transcript_path: raw/meetings/369팀 스페이스_20260819_2300/대화 내용_369팀 스페이스_20260819.md
meeting_date: 2026-08-19
ingest_date: 2026-08-31
duration: 00:52:51
transcript_type: auto-generated
speaker_attribution: transcript-provided
status: ingested
tags: [meeting, transcript, 369-team, laimory, presentation-rehearsal, beta-test, ai-agent, demo-video]
---

# 369팀 스페이스 회의 요약 - 2026-08-19

## Summary

다음 날 중간 발표를 앞두고 약 4분 50초의 원본 app demo를 30초로 편집한 version을 검토했다. 빠른 자막 대신 발표자가 data 확인·선택, loading, timeline 편집과 emotion 선택을 narration하기로 했고, 저장 완료와 calendar 재진입을 추가해 영상을 조금 늘릴지는 미결로 남았다. (`01:34-07:10`)

전체 rehearsal은 interruption을 포함해 약 18분 17초였다. 20분 제한에는 들어왔지만 기술 section의 pace가 빠르고 topic transition이 갑작스럽다는 feedback이 있었다. Section title slide와 전환 문장을 추가하고, 기존 문제 정의와 연결이 약한 `기록을 통한 성장` 연구 근거는 기획 의도에서 빼기로 했다. (`28:20-49:35`)

Rehearsal script에는 login부터 timeline generation·editing·save까지 동작한다는 MVP 상태, mobile normalization·batch, API server의 data·job 관리, multi-agent AI pipeline, model comparison·evaluation, 8월 말 beta와 9월 release, marketing KPI와 revenue assumption이 포함되었다. 이는 발표 draft의 주장으로 code, test, external source를 이 회의에서 독립 검증하지 않았다. (`10:06-28:14`)

## Key Claims

- Minimum MVP는 daily timeline이며 수집·생성·편집·저장까지 실제 기기에서 동작한다고 발표했다. (`13:14-13:29`, `16:21-17:43`)
- Mobile은 source별 data를 공통 구조로 normalize하고 일부 source 실패를 허용하며 stay·movement 정보를 batch로 처리한다고 설명했다. (`18:44-19:32`)
- 약 40초 이상 걸리는 AI job은 key 보관, polling과 FCM으로 완료를 알리고 app 재실행 뒤 continuity를 확인한다고 설명했다. (`19:33-19:55`)
- API server는 authentication, validation, masking, location·job status·result를 관리하고 외부 장소 API를 병렬 처리한다고 발표했다. (`19:56-20:30`)
- AI pipeline은 source별 agent, timeline integration, 검증·improvement agent, question agent로 구성되며 LangGraph를 사용하고 GPT·Gemini·Amazon Nova 계열을 비교할 예정이라고 설명했다. (`21:12-22:49`)
- Beta 계획은 약 20명 대상 8월 24~30일 또는 24~31일로 서로 다르게 언급되었다. (`16:21-16:43`, `25:20-25:43`)
- 회의 말미에 beta tester 한 명을 추가 모집했다고 보고했다. (`51:21-52:17`)

## Decisions and Open Items

| 분류 | 내용 | 근거 |
|---|---|---|
| 시연 방향 | 자막 대신 발표자의 압축 narration 사용 | `03:06-07:10` |
| 발표 수정 | Section title slide와 transition 문장 추가 | `29:19-31:38` |
| 발표 수정 | Problem definition과 연결이 약한 성장 연구 근거 제거 | `34:36-43:41` |
| 발표 운영 | 예상 질문 slide 설명은 남은 시간에 따라 optional | `47:49-49:35` |
| 미결 | Demo final screen·calendar 추가 여부와 최종 길이 | `05:02-06:11` |
| 미결 | Beta 종료일 30일 또는 31일 | `16:21-16:43`, `25:20-25:43` |

## Caveats

- 기술·시장·비용 수치는 발표 rehearsal 문구이며 독립 검증되지 않았다.
- `구현 완료`, `구축`을 production readiness와 동일시하면 안 된다.
- 검증 agent, monitoring tool, deployment environment, identifier transform algorithm 명칭이 자동 전사에서 불확실하다.
- Beta 일정은 같은 회의 안에서도 상충한다.
- 원문에는 개인 이동·숙박 일정이 포함되어 있으므로 공개 범위를 제한해야 한다.

## Related Pages

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-planning-and-validation]]
- [[laimory-ai-runtime-and-observability]]
- [[laimory-ai-model-evaluation]]
- [[laimory-user-memory]]
- [[android-life-logging-data-collection]]
