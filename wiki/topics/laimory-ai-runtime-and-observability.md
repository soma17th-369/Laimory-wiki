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

## Linked Sources

- [[2026-08-09-markdown-laimory-ai-system-architecture]]
- [[2026-08-09-markdown-laimory-ai-deployment-and-runtime]]
- [[2026-08-09-markdown-laimory-observability]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]

## Related Pages

- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
