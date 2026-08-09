---
title: 결정론적 Timeline Repair와 도구
source_type: markdown
source_path: raw/markdown/ai system document/04-deterministic-repair-and-tools.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, timeline, repair, deterministic, guard, tools]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# 결정론적 Timeline Repair와 도구

## Summary

LLM이 만든 draft에 source 무결성, 시간 범위, Calendar 보존, 장소, 중복, 민감정보, 길이와 ID 규칙을 항상 다시 적용하는 `repair_draft` 확정 계층을 설명한다. 이 순서는 dependency graph이며 앞 단계의 정규화 결과를 뒤 guard가 전제로 사용한다.

Repair Agent는 확정된 draft를 분석해 등록된 조회·편집·재적용·상류 재실행 도구만 선택할 수 있다. 각 반복 끝에는 전체 confirm이 다시 실행되며, LLM 또는 도구 실패 시 마지막 confirm 성공본을 복원한다.

## Key Claims

- 존재하지 않는 `rawId` 제거와 실제 source type 정정이 다른 guard보다 먼저 실행된다.
- 누락 Calendar 복원, duration·location·meal·sleep·window·place 규칙 이후 병합과 중복 검사를 수행한다.
- Photo 단일 귀속과 Notification 안전성 검사는 병합·문장 수정 뒤 최종 draft에서 다시 확인한다.
- 정렬, request window, source 무결성, 최종 ID는 LLM 도구 선택과 무관하게 항상 실행한다.
- Repair tool catalog는 arbitrary code나 임의 HTTP 호출을 허용하지 않는다.
- 장시간 event처럼 의미 판단이 필요한 문제는 코드가 임의 분할하지 않고 warning으로 드러낸다.

## Caveats

- Photo의 의미상 귀속이나 사건 분할처럼 기계적으로 확정할 수 없는 문제는 Repair Agent 판단에 남는다.
- confirm 자체의 코드 오류는 해당 반복을 확정하지 못하므로 이전 `last_good` 결과로 돌아간다.

## Related Pages

- [[ai-daily-timeline-generation]]
- [[2026-08-09-markdown-laimory-timeline-graph-and-agents]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]

