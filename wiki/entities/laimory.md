---
title: Laimory
kind: entity
status: active
updated: 2026-06-27
tags: [product, ai-life-logging, personal-ai-memory, android]
---

# Laimory

## Scope

369팀이 기획 중인 Android 기반 Personal AI Memory / AI life-logging 서비스.

## Current Synthesis

Laimory는 모바일 기기 안에 흩어진 사진, 위치, 일정, 앱 사용, 통화/메시지 등 생활 데이터를 AI가 자동으로 수집·구조화·분석해 사용자의 하루와 장기적인 삶의 흐름을 기록/회고/질문 가능한 형태로 만드는 서비스로 정의된다.

제품의 핵심 문제의식은 두 가지다. 첫째, 사용자는 삶을 기록하고 회고하고 싶지만 데이터가 여러 서비스에 파편화되어 직접 회상·정리해야 하는 비용이 높다. 둘째, AI는 대화/파일 맥락을 다루는 방향으로 발전했지만 아직 사용자의 실제 일상과 장기적 삶의 컨텍스트를 충분히 이해하지 못한다.

## Key Points

- 핵심 기능은 AI Timeline, 5가지 구조화 회고, 충분한 기록 누적 후 Personal AI Chat이다.
- 회고 기능은 기억 복원, 패턴 발견, 변화 인식, 회고 유도, 재방문/재평가로 나뉜다.
- MVP 시나리오는 사용자가 하루 보기에서 사진을 선택하고 AI 초안을 받은 뒤 자기 전에 수정/저장하는 흐름이다.
- AI 하루 타임라인 생성 설계는 데이터별 Event Agent가 source별 `Event` 후보를 만들고, Timeline Agent가 이를 병합한 뒤 Reflection Agent와 Repair Agent가 bounded loop로 품질을 개선하는 구조로 구체화되었다.
- 기록은 저장 전까지 계속 추가되며, 기존 수정/작성 내용은 임시저장으로 유지되는 방향이 제안되었다.
- 사업화 구상은 Free, Premium, Max 3단계 구독 모델이며, 고급 AI 회고/패턴/대화 기능을 유료화한다.
- 기술 전략은 Android 앱, Spring Boot backend, 자체 경량 AI 서버/상용 LLM API, On-device AI 1차 가공, 모니터링 도구를 포함한다.

## Risks and Tensions

- 민감 데이터 권한 허용을 받을 만큼의 즉시 체감 가치가 필요하다.
- Android 백그라운드 수집과 배터리/권한 제약이 핵심 기술 리스크다.
- 사진·위치·일정만으로 충분히 의미 있는 결과물을 만들 수 있는지 검증해야 한다.
- 기존 Apple Journal, Day One 등과 비교해 사용자가 별도 앱에 장기 데이터를 맡겨야 하는 이유와 신뢰 형성 방식이 더 명확해야 한다.
- 일기/회고 앱은 장기 리텐션 확보가 어렵기 때문에 반복 방문과 유료 전환 포인트를 정량적으로 검증해야 한다.

## Open Questions

- 무료 장기기억 기능에서 즉시 제공할 첫 가치는 무엇인가?
- On-device SLM이 한국어 일상 이벤트 요약과 감정 추출을 충분히 수행할 수 있는가?
- Google Timeline/Places 연동, Geofencing, Passive Location 중 MVP에 맞는 위치 수집 전략은 무엇인가?
- 20~30대 직장인과 50대 이상 액티브 시니어 중 어떤 persona가 더 강한 문제/지불 의사를 보이는가?

## Linked Sources

- [[2026-06-15-markdown-notion-laimory]]
- [[2026-06-15-markdown-notion-mobile-ai-lifelogging-app-1]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-15-markdown-notion-laimory-planning-review-report]]
- [[2026-06-15-markdown-notion-laimory-presentation-script-260529]]
- [[2026-06-15-markdown-notion-laimory-planning-review-evaluation]]
- [[2026-06-15-markdown-notion-background-location]]
- [[2026-06-20-notes-ai-daily-timeline-agent-draft]]

## Related Pages

- [[369-team]]
- [[ai-life-logging]]
- [[ai-daily-timeline-generation]]
- [[laimory-planning-and-validation]]
- [[android-life-logging-data-collection]]
