---
title: User Memory 설계와 갱신
source_type: markdown
source_path: raw/markdown/ai system document/05-user-memory.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, user-memory, profile, rewrite, memo, privacy]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# User Memory 설계와 갱신

## Summary

User Memory를 사건 로그가 아니라 Timeline과 질문 표현을 돕는 고정 크기 압축 프로필로 정의한다. v1.0은 고정 필드와 제한된 `customAttributes`를 사용하고, 새 기록을 뒤에 붙이는 대신 기존 profile과 최근 근거를 합쳐 전체 rewrite한다.

성향을 AI가 쓴 문장에서 다시 추출하는 feedback loop를 막기 위해 근거 출처를 엄격히 나눈다. `personality`, `values`, `preferences`, `emotionalPatterns`, `memoryStyle`은 사용자가 쓴 `memo`만으로 갱신하며, 생활 구조 계열만 event의 반복 패턴을 보조 근거로 사용할 수 있다.

## Key Claims

- User Memory는 `rawId`와 `sourceRefs`를 갖지 않는 보조 context다.
- Timeline과 Question은 같은 profile projection을 사용하고 Event Agent와 Repair는 profile을 보지 않는다.
- 깨진 기존 profile은 error code 1106으로 기록한 뒤 없는 것으로 취급해 Timeline과 갱신을 계속한다.
- 입력 digest는 하루 최대 20개 event, 최대 5일을 사용하며 memo가 있는 최근 event를 우선 보존한다.
- 저장 가능 여부는 provider tokenizer가 아닌 직렬화 문자 수 1,200자라는 프로젝트 규칙으로 판단한다.
- 크기·민감정보 위반 시 코드를 잘라 저장하지 않고 최대 두 번 전체 rewrite를 재요청한다.
- 성공과 실패 모두 App Server 결과 저장 호출 정확히 한 번으로 수렴한다.

## Caveats

- 1,200자 상한은 “1,000 token” 요구를 provider 독립적으로 구현한 프로젝트 규칙이지 일반 표준이 아니다.
- App Server가 실제 Timeline input에 profile을 채워 보내는지는 이 AI 저장소만으로 확인되지 않는다.

## Related Pages

- [[laimory-user-memory]]
- [[ai-daily-timeline-generation]]
- [[laimory-ai-runtime-and-observability]]

