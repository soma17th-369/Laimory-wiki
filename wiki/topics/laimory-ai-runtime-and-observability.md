---
title: Laimory AI Runtime and Observability
kind: topic
status: active-with-roadmap
updated: 2026-08-09
tags: [laimory, deployment, runtime, ec2, agentcore, observability]
---

# Laimory AI Runtime and Observability

## Scope

Laimory AI server의 EC2·AgentCore 배포 경로, background task 수명, health와 rollback, Elasticsearch 운영 이벤트와 Langfuse AI trace의 결합.

## Current Synthesis

현재 `dev` 자동 배포는 EC2 amd64 단일 컨테이너이며 AgentCore arm64는 수동 배포·rollback 경로다. 하나의 Dockerfile과 `/ping`, `/invocations` 계약을 공유하지만 AgentCore 기본 전환은 아직 계획이다. EC2 배포는 OIDC, immutable ECR tag, SSM, idle 대기와 health 기반 rollback을 사용한다.

배포 안전성은 process-local inflight counter와 single worker에 의존한다. `/ping`이 `HealthyBusy`이면 기존 container를 최대 20분 기다려 background task 유실을 피한다. 하지만 durable queue나 drain, multi-replica busy 합산은 없으므로 AgentCore scale-in과 runtime 교체에서 같은 보장을 자동으로 얻을 수 없다.

관측은 세 경계로 나뉜다. local diagnostic은 상세 debugging, Elasticsearch는 allowlist된 운영 집계, Langfuse는 Agent tree와 LLM generation 분석을 담당한다. 관측 장애는 제품 결과를 바꾸지 않지만 그만큼 서비스 성공과 관측 공백이 동시에 생길 수 있어 관측 파이프라인 자체를 따로 감시해야 한다.

2026-07-28과 07-30 회의에서는 AI Server의 직접 RDB 접근을 제거하고 App Server API를 통해 조회·저장하는 전환, callback·polling 장애, server-to-server token 갱신, Elasticsearch보다 Agent 내부 판단을 보기 적합한 Langfuse 도입이 진행 상황으로 보고됐다. 08-02부터 08-06에는 AWS 예산에 따른 RDS·EC2·NAT 선택, AgentCore 후보, 외부 장소 API의 WebClient connection pool 병목과 User Memory 충돌 작업 재처리가 논의됐다. 비용과 성능 수치는 회의 중 추정 또는 관찰이므로 운영 결정 전에 측정 자료로 확인해야 한다.

## Key Points

- 결과 저장과 callback, User Memory result 저장 여부는 task 완료 운영 이벤트의 핵심 상태다.
- Elasticsearch에는 `event.dataset=laimory.api` 운영 이벤트만 보내고 사용자 본문과 secret을 금지한다.
- Langfuse `NONE`은 본문 없이 진단 정보만, `SANITIZED`는 제한된 개발용 본문을 기록한다.
- Filebeat 실패는 앱 배포를 막지 않으며 workflow에서 상태를 따로 확인해야 한다.
- AgentCore 전환은 traffic ownership, task drain, CloudWatch→Elasticsearch 전달, IAM/network와 arm64 smoke test가 필요하다.
- runtime version, image SHA, provider/model을 함께 관측해야 배포와 모델 변화의 영향을 분리할 수 있다.

## Open Questions

- AgentCore에서 202 이후 background task의 수명과 scale-in 동작은 어떻게 보장되는가?
- durable queue 또는 외부 task state가 필요한 시점은 언제인가?
- Filebeat를 대체할 CloudWatch subscription, Lambda, Firehose 또는 collector 중 무엇을 쓸 것인가?
- 관측 공백을 감지할 별도 health와 alert 기준은 무엇인가?
- EC2와 AgentCore의 traffic ownership과 rollback 기간을 어떻게 운영할 것인가?
- 외부 장소 API를 포함한 실제 production traffic에서 connection pool, batch 크기와 concurrency 목표는 얼마인가?

## Linked Sources

- [[2026-08-09-markdown-laimory-ai-system-architecture]]
- [[2026-08-09-markdown-laimory-ai-deployment-and-runtime]]
- [[2026-08-09-markdown-laimory-observability]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]
- [[2026-07-28-meeting-369-team-space]]
- [[2026-07-30-meeting-369-team-space]]
- [[2026-08-02-meeting-369-team-space]]
- [[2026-08-03-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]
- [[2026-08-06-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
