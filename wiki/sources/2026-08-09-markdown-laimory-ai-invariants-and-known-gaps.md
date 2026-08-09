---
title: AI 도메인 불변식·용어·알려진 한계
source_type: markdown
source_path: raw/markdown/ai system document/09-invariants-glossary-and-known-gaps.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, invariants, glossary, constraints, known-gaps]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# AI 도메인 불변식·용어·알려진 한계

## Summary

Timeline과 User Memory 구현에서 깨뜨리면 안 되는 source, 시간, 병합, 문장, 질문, 결과, 보안·관측 계약을 한곳에 모으고 공통 용어와 known gap을 정리한다. 변경 검토 시 LLM 선택과 무관하게 항상 실행될 규칙, context 경계, 결과 저장 순서와 privacy를 확인하는 체크리스트 역할도 한다.

## Key Claims

- 현재 request에 있는 `rawId`만 사건 근거가 될 수 있고 User Memory는 source가 아니다.
- request window, 기상·식사·location 시간, Calendar 보존과 Photo 단일 귀속 규칙을 유지한다.
- 회고 질문은 Repair 뒤 확정 event에 붙이고 질문 누락은 Timeline 저장을 막지 않는다.
- User Memory는 memo 근거 경계와 전체 rewrite, 결과 저장 1회 계약을 지킨다.
- Timeline 결과 저장 성공 뒤에만 SUCCESS callback을 보내며 User Memory task에는 callback이 없다.
- secret과 사용자 본문은 운영 이벤트에서 금지하고 관측 실패를 제품 실패로 승격하지 않는다.

## Known Gaps

- BackgroundTasks는 durable하지 않고 process 종료 후 task를 이어받지 못한다.
- multi-worker/multi-replica busy 집계와 drain이 없다.
- 자연어 문체와 실제 provider 품질은 코드만으로 보장되지 않는다.
- request window 역전이 endpoint에서 거절되지 않는 gap이 있다.
- provider 평가 결과와 AgentCore 기본 전환·관측 전달 경로는 아직 확정되지 않았다.

## Related Pages

- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]

