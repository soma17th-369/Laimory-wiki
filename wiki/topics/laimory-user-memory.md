---
title: Laimory User Memory
kind: topic
status: active
updated: 2026-08-09
tags: [laimory, user-memory, profile, privacy, context-engineering]
---

# Laimory User Memory

## Scope

확정된 여러 날의 Timeline에서 지속적인 사용자 맥락을 압축하고, 그 profile을 다음 Timeline과 회고 질문에 안전하게 사용하는 설계.

## Current Synthesis

User Memory는 장기 사건 로그나 사실 source가 아니라 고정 크기의 압축 프로필이다. `basicProfile`, `lifeContext`, `relationships`, `personality`, `values`, `preferences`, `routines`, `currentFocus`, `emotionalPatterns`, `memoryStyle`과 제한된 `customAttributes`로 현재 사용자 맥락을 표현한다.

갱신은 append가 아니라 전체 rewrite다. 기존 profile과 최대 5일의 확정 daily timeline digest를 결합해 중복과 오래된 단기 정보를 제거한 새 전체 profile을 만든다. Timeline Agent와 Question Agent는 같은 projection을 사용하지만 Event Agent와 Repair Agent에는 profile을 주지 않는다. 하나의 보조 context가 여러 독립 근거처럼 반복되거나 오늘 source보다 profile에 맞춰 사건을 바꾸는 것을 막기 위해서다.

가장 중요한 안전장치는 문장 출처의 구분이다. AI가 작성한 title, subtitle, question에서 성향을 다시 추출하면 모델의 추측이 다음 세대의 사실처럼 증폭된다. 그래서 `personality`, `values`, `preferences`, `emotionalPatterns`, `memoryStyle`은 사용자가 직접 쓴 memo만 근거로 갱신한다. memo가 없는 batch에서 이 필드들을 그대로 유지하는 것은 정상 성공이다.

## Key Points

- User Memory는 `rawId`나 `sourceRefs`를 갖지 않는다.
- 깨진 기존 profile은 보조 context 실패로 흡수하고 새 갱신을 계속할 수 있다.
- digest는 날짜별 최대 20개 event를 남기고 memo가 있는 최근 event를 우선한다.
- provider 독립적인 저장 상한으로 직렬화 문자 수 1,200자를 사용한다.
- 크기나 민감정보 위반은 잘라 저장하지 않고 전체 rewrite를 최대 두 번 재요청한다.
- `schemaVersion`과 `updatedAt`은 LLM이 아니라 서버가 확정한다.
- User Memory task는 callback 없이 SUCCESS 또는 FAILED result 저장 정확히 한 번으로 종료한다.

## Open Questions

- App Server가 실제 Timeline input response에 User Memory를 언제부터 안정적으로 포함하는가?
- 1,200자 상한이 실제 한국어 profile 품질과 provider context 비용에 적절한가?
- memo 출처 규칙을 prompt뿐 아니라 더 강한 provenance 구조로 검증할 수 있는가?
- profile retention, 사용자 열람·수정·삭제와 consent 정책은 어떻게 연결되는가?

## Linked Sources

- [[2026-08-09-markdown-laimory-ai-system-architecture]]
- [[2026-08-09-markdown-laimory-prompt-engineering]]
- [[2026-08-09-markdown-laimory-user-memory]]
- [[2026-08-09-markdown-laimory-observability]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]

## Related Pages

- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]

