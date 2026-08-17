---
title: Laimory
kind: entity
status: active
updated: 2026-08-17
tags: [product, ai-life-logging, personal-ai-memory, android]
---

# Laimory

## Scope

369팀이 기획 중인 Android 기반 Personal AI Memory / AI life-logging 서비스.

## Current Synthesis

Laimory는 모바일 기기 안에 흩어진 사진, 위치, 일정, 앱 사용, 통화/메시지 등 생활 데이터를 AI가 자동으로 수집·구조화·분석해 사용자의 하루와 장기적인 삶의 흐름을 기록/회고/질문 가능한 형태로 만드는 서비스로 정의된다.

제품의 핵심 문제의식은 두 가지다. 첫째, 사용자는 삶을 기록하고 회고하고 싶지만 데이터가 여러 서비스에 파편화되어 직접 회상·정리해야 하는 비용이 높다. 둘째, AI는 대화/파일 맥락을 다루는 방향으로 발전했지만 아직 사용자의 실제 일상과 장기적 삶의 컨텍스트를 충분히 이해하지 못한다.

2026-08-09 기준 AI 구현은 App Server가 source, 결과, User Memory와 task 상태를 소유하고 FastAPI AI server가 무상태 실행 계층을 맡는 구조로 구체화되었다. 다섯 Event Agent가 source domain을 병렬 해석하고 Timeline, Repair, Question 단계를 거친다. User Memory는 사건 근거가 아닌 압축 profile이며, 배포는 현재 EC2 자동 경로와 AgentCore 수동 경로를 병행한다.

2026-08-17 공식 중간보고서 기준 1차 MVP는 하루 Timeline 생성·기록이며 로그인, 권한 설정·생활 데이터 수집, 비동기 생성, 편집·확정과 월별 조회까지 구현·연동해 App Tester alpha test를 진행 중이라고 보고된다. 첫 가치 행동은 Timeline 확인·필요시 수정 뒤 첫 일간 회고 완료로 정했고, 8월 24~30일 약 20명 beta test를 계획한다. 출시·사용자 검증 완료가 아니라 문서 작성 시점의 자체 보고 상태다.

회의 기록은 이 구조의 시간적 변화를 보완한다. 2026-05에는 AI 일기에서 모바일 life logging과 Personal AI Memory로 제품 정의를 넓히고 MVP와 permission 가설을 다듬었으며, 07-28 이후에는 alpha test에서 source ID, structured output, callback, Langfuse, 시간대, Android 수집과 외부 API 병목을 발견해 수정했다. 회의 중 수치·경쟁사 정보·잠정 설계는 해당 시점의 주장으로 남기고 최신 구현 판단에는 2026-08-09 시스템 문서를 우선한다.

## Key Points

- 핵심 기능은 AI Timeline, 5가지 구조화 회고, 충분한 기록 누적 후 Personal AI Chat이다.
- 회고 기능은 기억 복원, 패턴 발견, 변화 인식, 회고 유도, 재방문/재평가로 나뉜다.
- MVP 시나리오는 사용자가 하루 보기에서 사진을 선택하고 AI 초안을 받은 뒤 자기 전에 수정/저장하는 흐름이다.
- 현재 AI 하루 타임라인 구현은 다섯 Event Agent의 병렬 실행, Timeline 의미 병합, 결정론 confirm과 제한된 도구를 가진 Repair, 확정 event 질문 생성 순서다.
- 과거 문서의 독립 Reflection Agent 구조는 현재 구현 계약이 아니며 선택적 상류 재실행은 Repair 도구로 흡수되었다.
- source 존재, 시간 범위, Calendar 보존, Photo 단일 귀속과 ID처럼 셀 수 있는 불변식은 prompt가 아니라 코드가 확정한다.
- User Memory는 최대 크기가 제한된 전체 rewrite profile이고, 성향 계열 필드는 사용자가 쓴 memo만 근거로 삼는다.
- OpenAI, Gemini, Bedrock provider를 공통 계약으로 감싸지만 Nova 2 Lite, Gemini 2.5 Flash, GPT 5.4 mini의 비교 결과는 아직 평가 전이다.
- 현재 `dev` 자동 배포는 EC2이며 AgentCore는 수동 경로다. 관측은 Elasticsearch 운영 이벤트와 Langfuse AI trace를 분리한다.
- 기록은 저장 전까지 계속 추가되며, 기존 수정/작성 내용은 임시저장으로 유지되는 방향이 제안되었다.
- 사업화 구상은 Free, Premium, Max 3단계 구독 모델이며, 고급 AI 회고/패턴/대화 기능을 유료화한다.
- 기술 전략은 Android 앱, Spring Boot backend, 자체 경량 AI 서버/상용 LLM API, On-device AI 1차 가공, 모니터링 도구를 포함한다.
- Laboratory Android lab에서 사진, 일정, 알림, Health Connect, Samsung Health-origin 데이터를 실험하고 있으며, 서버 전송 후보 구조는 typed timeline source item batch로 정리되었다.
- 공식 중간보고서는 위치·일정·사진·건강·알림 수집을 공통 source로 정규화하고, 권한이 거부·회수되면 해당 source만 제한하며 사용자가 선택한 데이터만 AI 생성에 활용한다고 설명한다.
- 콘텐츠 영역은 인증 userId와 분리한 무작위 Subject ID와 HMAC 조회 key를 사용하고, Timeline·AI staging·User Memory·FCM·Redis task·S3 namespace에 비식별 식별자를 적용했다고 보고한다. 실제 code와 배포 설정은 별도 검증이 필요하다.

## Risks and Tensions

- 민감 데이터 권한 허용을 받을 만큼의 즉시 체감 가치가 필요하다.
- Android 백그라운드 수집과 배터리/권한 제약이 핵심 기술 리스크다.
- FastAPI BackgroundTasks가 durable하지 않아 프로세스 종료·scale-in 시 실행 중 task를 복구하지 못한다.
- process-local inflight와 single worker에 의존하므로 AgentCore 전환 시 drain과 multi-replica health를 재설계해야 한다.
- User Memory와 Timeline에는 민감한 생활 맥락이 들어가므로 source provenance, memo 근거 경계와 관측 content policy가 제품 신뢰의 핵심이다.
- 사진·위치·일정만으로 충분히 의미 있는 결과물을 만들 수 있는지 검증해야 한다.
- 기존 Apple Journal, Day One 등과 비교해 사용자가 별도 앱에 장기 데이터를 맡겨야 하는 이유와 신뢰 형성 방식이 더 명확해야 한다.
- 일기/회고 앱은 장기 리텐션 확보가 어렵기 때문에 반복 방문과 유료 전환 포인트를 정량적으로 검증해야 한다.
- 제품 activation은 설치·가입·permission 동의나 AI 생성 완료 자체보다, 사용자가 첫 Timeline을 열람하고 필요한 수정·memo를 거쳐 완성·저장해 자기 기록으로 받아들인 행동에 둔다. 이후 retention도 단순 재실행이 아니라 Timeline의 반복 열람·완성으로 측정한다.
- 공식 기획심의 의견은 자동 생성된 기억을 사용자가 쉽게 수정·삭제·비공개 처리할 수 있어야 하며, On-device 처리 범위와 외부 model 전송 기준을 명확히 하도록 요구한다.
- 중간보고서는 첫 가치 행동을 첫 일간 회고 완료로 정의하지만 retention 표는 첫 Timeline 생성 후 재생성을 기준으로 두므로 실제 analytics event와 cohort 기준을 통일해야 한다.

## Open Questions

- 무료 장기기억 기능에서 즉시 제공할 첫 가치는 무엇인가?
- On-device SLM이 한국어 일상 이벤트 요약과 감정 추출을 충분히 수행할 수 있는가?
- Google Timeline/Places 연동, Geofencing, Passive Location 중 MVP에 맞는 위치 수집 전략은 무엇인가?
- 20~30대 직장인과 50대 이상 액티브 시니어 중 어떤 persona가 더 강한 문제/지불 의사를 보이는가?
- 모바일 추출 데이터 중 metadata-only로 충분한 항목과 원본/썸네일 업로드가 필요한 항목을 어떻게 나눌 것인가?

## Linked Sources

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-07-notes-laimory-marketing-kpi-mentoring]]
- [[2026-06-15-markdown-notion-laimory]]
- [[2026-06-15-markdown-notion-mobile-ai-lifelogging-app-1]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-08-09-pdf-laimory-planning-review-report]]
- [[2026-06-15-markdown-notion-laimory-presentation-script-260529]]
- [[2026-06-05-notes-laimory-planning-review-evaluation]]
- [[2026-06-15-markdown-notion-background-location]]
- [[2026-06-20-notes-ai-daily-timeline-agent-draft]]
- [[2026-06-27-github-laboratory-mobile-data-extraction]]
- [[2026-08-09-markdown-laimory-ai-llm-wiki-readme]]
- [[2026-08-09-markdown-laimory-ai-system-architecture]]
- [[2026-08-09-markdown-laimory-timeline-graph-and-agents]]
- [[2026-08-09-markdown-laimory-user-memory]]
- [[2026-08-09-markdown-laimory-llm-provider-model-evaluation]]
- [[2026-08-09-markdown-laimory-ai-deployment-and-runtime]]
- [[2026-08-09-markdown-laimory-observability]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]
- [[2026-05-16-meeting-369-team-space]]
- [[2026-05-17-meeting-369-team-space]]
- [[2026-05-18-meeting-369-team-planning-review-preparation]]
- [[2026-05-19-meeting-369-team-planning-review-preparation]]
- [[2026-05-21-meeting-369-team-planning-review-preparation]]
- [[2026-05-23-meeting-369-team-space]]
- [[2026-07-28-meeting-369-team-space]]
- [[2026-07-30-meeting-369-team-space]]
- [[2026-08-02-meeting-369-team-space]]
- [[2026-08-03-meeting-369-team-space]]
- [[2026-08-04-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]
- [[2026-08-06-meeting-369-team-space]]

## Related Pages

- [[369-team-meeting-history]]
- [[369-team]]
- [[ai-life-logging]]
- [[ai-daily-timeline-generation]]
- [[laimory-planning-and-validation]]
- [[android-life-logging-data-collection]]
- [[mobile-data-extraction-payload-structure]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
