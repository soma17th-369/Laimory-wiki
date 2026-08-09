---
title: 프롬프트 엔지니어링과 Structured Output
source_type: markdown
source_path: raw/markdown/ai system document/03-prompt-engineering.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, prompt, structured-output, context-engineering, pydantic]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# 프롬프트 엔지니어링과 Structured Output

## Summary

Laimory는 source 해석, Timeline 병합, Repair 계획, 질문 생성과 User Memory rewrite를 역할별 prompt로 분리한다. 모든 Agent가 전역 `PROMPT_VERSION`을 공유하고, 현재 `v1`과 `v2`를 허용한다. Location과 Sleep/Activity는 v1에서 infer와 review의 2회 호출, v2에서 단일 structured call이라는 실행 구조 차이까지 가진다.

Context engineering은 지시 추가뿐 아니라 불필요한 정보를 입력에서 제거하는 방식으로 구현된다. 특히 User Memory는 Timeline과 Question에만 공통 projection으로 주고 Event Agent와 Repair에는 제공하지 않는다.

## Key Claims

- prompt 파일 누락 시 다른 version으로 fallback하지 않고 version 세트 전체의 완결성을 요구한다.
- `complete_json`은 항목별 tolerant parsing, `complete_structured`는 Pydantic 전체 계약이 필요한 응답에 사용한다.
- provider native schema를 사용해도 최종 Pydantic 검증과 교정 retry를 생략하지 않는다.
- Timeline과 Question은 일부 item이 잘못돼도 유효한 item을 살리지만 Repair plan은 전체 검증을 통과해야 한다.
- 최종 Timeline은 1인칭 해요체 과거형, 간결한 title/description을 목표로 하고 불확실성은 문장 속 추정 표현보다 metadata로 표현한다.
- 사용자 memo, notification, Calendar, User Memory의 지시문처럼 보이는 문자열은 비신뢰 데이터로 취급한다.

## Caveats

- 자연어의 일기 문체와 자연스러움은 코드만으로 완전히 검증할 수 없어 live LLM 평가가 필요하다.
- v1/v2 비교 시 prompt 내용뿐 아니라 graph 호출 횟수 차이도 함께 고려해야 한다.

## Related Pages

- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]

