---
title: Laimory User Memory
kind: topic
status: active
updated: 2026-08-17
tags: [laimory, user-memory, profile, privacy, context-engineering]
---

# Laimory User Memory

## Scope

확정된 여러 날의 Timeline에서 지속적인 사용자 맥락을 압축하고, 그 profile을 다음 Timeline과 회고 질문에 안전하게 사용하는 설계.

## Current Synthesis

User Memory는 장기 사건 로그나 사실 source가 아니라 고정 크기의 압축 프로필이다. `basicProfile`, `lifeContext`, `relationships`, `personality`, `values`, `preferences`, `routines`, `currentFocus`, `emotionalPatterns`, `memoryStyle`과 제한된 `customAttributes`로 현재 사용자 맥락을 표현한다.

갱신은 append가 아니라 전체 rewrite다. 기존 profile과 최대 5일의 확정 daily timeline digest를 결합해 중복과 오래된 단기 정보를 제거한 새 전체 profile을 만든다. Timeline Agent와 Question Agent는 같은 projection을 사용하지만 Event Agent와 Repair Agent에는 profile을 주지 않는다. 하나의 보조 context가 여러 독립 근거처럼 반복되거나 오늘 source보다 profile에 맞춰 사건을 바꾸는 것을 막기 위해서다.

가장 중요한 안전장치는 문장 출처의 구분이다. AI가 작성한 title, subtitle, question에서 성향을 다시 추출하면 모델의 추측이 다음 세대의 사실처럼 증폭된다. 그래서 `personality`, `values`, `preferences`, `emotionalPatterns`, `memoryStyle`은 사용자가 직접 쓴 memo만 근거로 갱신한다. memo가 없는 batch에서 이 필드들을 그대로 유지하는 것은 정상 성공이다.

2026-08-02부터 08-06까지의 회의에서는 User Memory가 제품의 장기 맥락 계층으로 구체화되는 과정이 기록됐다. 별도 table 저장, Timeline이 `SAVED`가 되는 시점의 갱신 trigger, 동일 사용자의 동시 Timeline 저장 충돌이 차례로 논의됐다. Redis 보류와 일일 batch 재처리 방안은 회의상 설계 또는 구현 중으로 언급됐지만 최종 구현 여부와 순서·멱등성·부분 실패 정책은 확인이 필요하다.

2026-08-17 공식 중간보고서도 User Memory를 append log가 아닌 고정 JSON profile의 전체 rewrite로 설명하고, Timeline·Question에만 제공하며 source와 충돌하면 원본을 우선한다고 재확인한다. 성격·가치관·선호는 사용자 memo에서만 추출한다는 provenance 경계도 명시한다. 다만 보고서는 사용자 열람·수정·삭제, 동시 갱신과 retention 정책의 검증 결과를 제시하지 않는다.

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
- 동일 사용자의 여러 Timeline이 동시에 완료될 때 User Memory 갱신 순서와 멱등성을 어떻게 보장하는가?
- 2026-08-06 회의에서 언급된 Redis 보류 및 일일 batch 방안이 실제 구현인지 잠정 설계인지 확인해야 한다.

## Linked Sources

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-09-markdown-laimory-ai-system-architecture]]
- [[2026-08-09-markdown-laimory-prompt-engineering]]
- [[2026-08-09-markdown-laimory-user-memory]]
- [[2026-08-09-markdown-laimory-observability]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]
- [[2026-08-02-meeting-369-team-space]]
- [[2026-08-04-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]
- [[2026-08-06-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
