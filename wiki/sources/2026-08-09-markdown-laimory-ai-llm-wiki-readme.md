---
title: Laimory AI·LLM 지식 위키 안내
source_type: markdown
source_path: raw/markdown/ai system document/00-README.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, ai, llm, architecture, documentation]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# Laimory AI·LLM 지식 위키 안내

## Summary

Laimory AI 서버의 Timeline 생성, 프롬프트, 결정론적 보정, User Memory, 모델 평가, 배포와 관측 문서 묶음의 시작 페이지다. 문서들은 2026-08-09의 `feat/#63` commit을 기준으로 현재 구현, 계획, 평가 대상을 구분한다.

핵심 설계 원칙은 의미 판단은 LLM에 맡기되 source 존재, 시간 범위, ID, 길이처럼 기계적으로 확정할 수 있는 계약은 코드가 보장하는 것이다. User Memory는 사건 근거가 아닌 보조 context이며, 제품 상태의 영속 소유자는 App Server다. 단계별 실패는 영향에 맞는 fallback으로 격리한다.

## Key Claims

- 현재 구현과 향후 계획, 아직 평가하지 않은 모델 후보를 같은 사실로 취급하지 않는다.
- AI 서버는 source, Timeline 결과, User Memory와 task 상태를 영속 소유하지 않는다.
- Event Agent, Timeline Agent, Repair Agent, Question Agent와 User Memory Agent는 서로 다른 책임과 context 경계를 가진다.
- Markdown 파일 하나를 source page 하나로 ingest하고 `source_commit`과 검증일을 함께 보존하는 방식을 권장한다.
- LangGraph, prompt, repair 순서, User Memory schema, provider, 배포 또는 관측 계약이 바뀌면 관련 문서를 다시 검증해야 한다.

## Caveats

- 문서가 설명하는 구현 상태는 명시된 commit 기준이며 이후 코드 변경을 자동 반영하지 않는다.
- 통합본은 00–09 문서의 편의용 합본으로, 독립된 새로운 주장으로 보지 않는다.

## Related Pages

- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]

