---
title: Laimory AI 시스템 아키텍처
source_type: markdown
source_path: raw/markdown/ai system document/01-ai-system-architecture.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, architecture, fastapi, app-server, timeline, user-memory]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# Laimory AI 시스템 아키텍처

## Summary

Laimory AI 서버를 App Server가 제공한 하루치 source로 Timeline을 만들고, 확정된 여러 날의 Timeline으로 User Memory를 갱신하는 무상태 실행 서버로 설명한다. 제품 데이터와 task 상태의 영속 소유권은 App Server에 있고 AI 서버에는 요청 단위 중간 상태, provider cache, inflight counter와 관측 context만 남는다.

Timeline task는 202를 먼저 반환한 뒤 source 조회, 정규화, Agent graph, 최종 검증, 결과 저장, SUCCESS callback 순으로 진행한다. User Memory task는 별도 endpoint와 runner를 사용하며 성공과 실패 모두 결과 저장 요청 정확히 한 번으로 수렴하고 callback은 사용하지 않는다.

## Key Claims

- Timeline trigger의 request window가 정본이며 source 조회 응답의 window보다 우선한다.
- Timeline 결과 저장 성공을 확인한 뒤에만 SUCCESS callback을 보낸다.
- User Memory FAILED는 DailyRecord 저장 실패가 아니라 이번 profile 갱신 미반영을 뜻한다.
- 동기 provider SDK 호출은 `asyncio.to_thread`로 넘겨 event loop와 `/ping`을 막지 않는다.
- process-local inflight 의미를 유지하기 위해 현재 Uvicorn은 single worker로 실행한다.
- FastAPI `BackgroundTasks`는 durable queue가 아니어서 프로세스 종료 후 task 복구와 multi-replica busy 집계가 되지 않는다.

## Caveats

- App Server의 result/callback idempotency와 DB transaction은 이 문서의 저장소 범위에서 검증되지 않았다.
- 설명은 source commit 시점의 실행 구조이며 배포 환경의 실제 설정은 별도 확인이 필요하다.

## Related Pages

- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-runtime-and-observability]]

