---
title: 369팀 스페이스 회의 요약 - 2026-08-26
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260826_2300/회의 요약_369팀 스페이스_20260826.md
transcript_path: raw/meetings/369팀 스페이스_20260826_2300/대화 내용_369팀 스페이스_20260826.md
meeting_date: 2026-08-26
ingest_date: 2026-08-31
duration: 00:40:45
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory, agentcore, alb, onboarding, policy, beta-release]
---

# 369팀 스페이스 회의 요약 - 2026-08-26

## 개요

AgentCore와 application server 사이 callback 장애를 실제 요청으로 진단하고 ALB callback 방향을 정한 회의다. initializer API, monitoring subdomain, 약관·privacy policy, Android onboarding, Figma billing, beta release 일정과 사업자 등록도 점검했다.

## 핵심 내용

- mobile에서 AgentCore dispatch는 성공했지만 AgentCore가 application server로 보내는 callback이 실패했다. private DNS·IP, security group, VPC endpoint, environment 분기를 검토했다. (`00:24-12:23`)
- AgentCore가 instance IP와 environment를 직접 고르지 않도록 callback을 ALB endpoint로 보내기로 했다. server-to-server authentication·encryption은 후속 확인이 필요하다. (`11:23-13:16`)
- 특정 device의 `초안 만들기` 먹통은 공통 장애가 아니었고 local log나 대면 점검으로 원인을 찾기로 했다. (`13:20-15:20`)
- initializer 조회와 onboarding 완료 기록 API를 추가했다. onboarding은 완료 button 시점에 true로 기록하고 최초 한 번 제공하는 구조다. (`15:29-16:48`)
- Kibana·Grafana를 각각 subdomain으로 분리하고 ALB에서 monitoring EC2로 연결했다고 보고했다. (`16:49-17:20`)
- Android는 onboarding, typography·thumbnail, 감정·event 추가 UI를 진행했고 읽기 mode 개편안을 다시 공유할 예정이었다. (`20:14-21:49`, `28:18-28:52`)
- Figma 권한·seat 설정으로 약 65~66달러가 청구된 것으로 추정해 support 환불과 비용 지원 문의를 검토했다. 실제 원인·환불 결과는 미확인이다. (`21:51-26:50`)
- 주말쯤 Play Store 심사 요청을 시도하고 9월부터 beta 운영을 시작하는 목표를 공유했다. (`32:14-34:28`)
- 사업자 등록 처리 완료와 증명서 출력 가능 상태를 확인해 PDF를 공유하기로 했다. (`34:47-39:17`)

## 상태 구분

| 분류 | 내용 | 근거 |
|---|---|---|
| 결정 | AgentCore application callback을 ALB endpoint로 전송 | `11:23-13:16` |
| 구현 보고 | initializer API와 onboarding 완료 기록 | `15:29-16:48` |
| 구현 보고 | monitoring subdomain과 ALB routing | `16:49-17:20` |
| 진행 중 | Android onboarding과 timeline UI | `20:14-21:49`, `28:18-28:52` |
| 목표 | 주말 Play Store 심사 요청 | `32:14-34:28` |
| 확인 | 사업자 등록 민원 처리 완료 | `37:17-39:17` |
| 미결 | callback 보안, device 먹통 원인, 약관 완성도 | 여러 구간 |

## 주의 사항

- AWS network 논의는 troubleshooting 가설과 임시 변경을 포함해 IaC·console·deployment log 확인이 필요하다.
- Figma billing 금액과 원인은 invoice나 support 답변으로 검증되지 않았다.
- release와 mentoring 일정은 목표이며 실제 심사 요청·승인 상태가 아니다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-ai-runtime-and-observability]]
- [[android-life-logging-data-collection]]
- [[laimory-planning-and-validation]]
- [[laimory-data-privacy-and-consent]]
