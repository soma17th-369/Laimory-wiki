---
title: AI 배포와 Runtime 구조
source_type: markdown
source_path: raw/markdown/ai system document/07-deployment-and-runtime.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, deployment, ec2, agentcore, ecr, docker]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# AI 배포와 Runtime 구조

## Summary

현재 `dev` 자동 배포 대상은 EC2의 amd64 단일 컨테이너이고 AgentCore arm64 경로는 수동 `workflow_dispatch` 기반이라는 상태를 기록한다. 두 경로는 하나의 Dockerfile과 `/ping`, `/invocations` 계약을 공유하지만 AgentCore를 기본 경로로 전환하는 일은 아직 계획 단계다.

EC2 배포는 GitHub OIDC, immutable ECR tag, SSM Run Command, 기존 컨테이너 idle 대기, 새 컨테이너 health 검증과 직전 image rollback을 결합한다. AgentCore update는 전체 설정 교체이므로 기존 role, network, protocol과 environment를 보존한 채 container URI를 바꾼다.

## Key Claims

- busy container 강제 교체는 FastAPI background task를 잃을 수 있어 `/ping`의 `HealthyBusy` 동안 대기한다.
- 배포 성공 후에만 현재와 직전 image를 제외한 오래된 ECR image를 정리한다.
- Filebeat 실패는 앱 배포를 막지 않으므로 서비스 성공과 관측 공백이 동시에 생길 수 있다.
- AgentCore 기본 전환 전 traffic ownership, task 수명·drain, 관측 전달, IAM/network와 arm64 dependency를 검증해야 한다.
- `/invocations`는 별도 pipeline을 만들지 않고 기존 Timeline 처리 계약에 위임한다.
- process-local inflight 때문에 single worker 불변식은 배포 drain 전략과 직접 연결된다.

## Caveats

- AgentCore는 현재 자동 기본 배포 경로가 아니다.
- AgentCore scale-in이나 runtime replacement 이후 202 background task의 수명 보장은 아직 검증 대상이다.

## Related Pages

- [[laimory-ai-runtime-and-observability]]
- [[laimory]]
- [[2026-08-09-markdown-laimory-observability]]

