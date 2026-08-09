---
title: 관측성 - Filebeat·Elasticsearch·Langfuse
source_type: markdown
source_path: raw/markdown/ai system document/08-observability.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, observability, logging, elasticsearch, langfuse, redaction]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# 관측성 - Filebeat·Elasticsearch·Langfuse

## Summary

Laimory 관측을 local 진단 로그, Elasticsearch 운영 이벤트, Langfuse AI trace의 세 경계로 분리한다. Elasticsearch에는 `event.dataset=laimory.api`가 붙은 allowlist 기반 운영 이벤트만 보내고, Langfuse는 Agent tree와 generation의 provider, model, prompt version, latency, token과 정책에 따른 본문을 기록한다.

Content capture는 production 방향의 `NONE`과 local/dev용 `SANITIZED`로 나뉜다. User Memory와 daily timeline은 값 모양이 아닌 key 이름을 기준으로 본문을 접어 개수·크기·hash summary만 남긴다.

## Key Claims

- 일반 diagnostic log를 추가해도 자동으로 Elasticsearch 수집 대상이 되지 않는다.
- HTTP request와 background task 완료 이벤트는 cardinality 자체가 계약이며 사용자 본문을 포함하지 않는다.
- 같은 실패는 API, callback/result, 운영 이벤트와 가능한 trace에서 같은 정수 ErrorCode를 사용한다.
- `taskToken`, credential, presigned URL, notification 원문과 User Memory 본문은 운영 이벤트에서 금지한다.
- 관측 client, span, flush, operational handler 또는 Filebeat 실패는 제품 task 결과를 바꾸지 않는다.
- AgentCore 전환 후에는 EC2 Filebeat sidecar와 동등한 Elasticsearch 전달 경로를 별도 설계해야 한다.

## Caveats

- 관측 실패 격리 때문에 서비스는 성공했지만 trace나 운영 이벤트가 없는 상태가 가능하다.
- Elasticsearch template, dashboard, retention과 local stdout 접근 통제는 저장소 밖 운영 설정이다.

## Related Pages

- [[laimory-ai-runtime-and-observability]]
- [[laimory-ai-model-evaluation]]
- [[2026-08-09-markdown-laimory-ai-deployment-and-runtime]]

