---
title: Laimory
kind: entity
status: active
updated: 2026-11-02
tags: [product, ai-life-logging, personal-ai-memory, android]
---

# Laimory

## Scope

369팀이 기획·개발하고 출시·운영 상태를 점검하는 Android 기반 Personal AI Memory / AI life-logging 서비스.

## Current Synthesis

Laimory는 모바일 기기 안에 흩어진 사진, 위치, 일정, 앱 사용, 통화/메시지 등 생활 데이터를 AI가 자동으로 수집·구조화·분석해 사용자의 하루와 장기적인 삶의 흐름을 기록/회고/질문 가능한 형태로 만드는 서비스로 정의된다.

제품의 핵심 문제의식은 두 가지다. 첫째, 사용자는 삶을 기록하고 회고하고 싶지만 데이터가 여러 서비스에 파편화되어 직접 회상·정리해야 하는 비용이 높다. 둘째, AI는 대화/파일 맥락을 다루는 방향으로 발전했지만 아직 사용자의 실제 일상과 장기적 삶의 컨텍스트를 충분히 이해하지 못한다.

2026-08-09 기준 AI 구현은 App Server가 source, 결과, User Memory와 task 상태를 소유하고 FastAPI AI server가 무상태 실행 계층을 맡는 구조로 구체화되었다. 다섯 Event Agent가 source domain을 병렬 해석하고 Timeline, Repair, Question 단계를 거친다. User Memory는 사건 근거가 아닌 압축 profile이며, 배포는 현재 EC2 자동 경로와 AgentCore 수동 경로를 병행한다.

2026-08-17 공식 중간보고서 기준 1차 MVP는 하루 Timeline 생성·기록이며 로그인, 권한 설정·생활 데이터 수집, 비동기 생성, 편집·확정과 월별 조회까지 구현·연동해 App Tester alpha test를 진행 중이라고 보고된다. 첫 가치 행동은 Timeline 확인·필요시 수정 뒤 첫 일간 회고 완료로 정했고, 8월 24~30일 약 20명 beta test를 계획한다. 출시·사용자 검증 완료가 아니라 문서 작성 시점의 자체 보고 상태다.

8월 12~20일의 승인된 product·presentation artifact는 현재 표현 원칙과 검증 준비를 보완한다. AI는 감정과 의미를 대신 쓰는 대필자보다 기억 단서·구체적 질문·표현을 돕는 편집자로 정의하고, 회고가 MVP에서 빠졌다면 activation을 첫 Timeline 확정·저장으로 맞추도록 권고한다. beta 실행계획은 약 20명 모집, end-to-end MVP, privacy-safe analytics, reminder와 운영 model 고정을 준비 항목으로 두지만 아직 결과를 보고하지 않는다. 63쪽 최종 발표 PDF는 이 시점의 공식 presentation snapshot이다.

회의 기록은 이 구조의 시간적 변화를 보완한다. 2026-05에는 AI 일기에서 모바일 life logging과 Personal AI Memory로 제품 정의를 넓히고 MVP와 permission 가설을 다듬었으며, 07-28 이후에는 alpha test에서 source ID, structured output, callback, Langfuse, 시간대, Android 수집과 외부 API 병목을 발견해 수정했다. 회의 중 수치·경쟁사 정보·잠정 설계는 해당 시점의 주장으로 남기고 최신 구현 판단에는 2026-08-09 시스템 문서를 우선한다.

2026-08-09~30 회의는 중간발표와 초기 release 준비를 연결한다. 사회초년생 기록자 persona, Timeline 확정·저장 중심 activation과 GA4 funnel, client-side source 제외, 약관·동의 version, notification filtering, 읽기·편집 UX와 onboarding이 구체화됐다. Runtime은 AgentCore 배포 뒤 application callback을 ALB로 보내는 방향으로 진행됐고, model 선택은 Nova 계열 후보의 품질·structured output 문제를 겪은 뒤 stage별 cost·quality routing을 시도하는 방향으로 바뀌었다. 이는 회의 보고이며 beta 결과, production 배포와 정확한 model명은 아직 검증되지 않았다.

2026-09-01~03 회의에서는 photo·calendar·location·notification의 활용 이유를 설명하는 permission onboarding을 고정하고, 읽기·편집 mode, event 추가, notification·theme 설정을 구현했다고 보고했다. Release build·login·logging이 남아 release 목표는 9월 4일에서 주말 가능성으로 이동했다. 완전 무입력 첫날과 same-day multi-generation은 아직 완성된 product flow가 아니며, 초기 beta에는 하루 한 번 오후 9시 이후 생성하도록 안내하는 임시 규칙을 쓰기로 했다. 따라서 이 시점도 beta 결과가 아니라 release 직전 hardening 상태다.

## 2026-09~11 회의 반영

2026-11-02 추가 회의 ingest는 9월 beta·출시 준비에서 11월 초 운영까지를 연결한다. 10-10에는 Play Store 출시됨을 확인했다고 보고했으나 정확한 최초 공개 시각은 모른다. 10-11 V3 전환 보고는 환경변수·배포 오류와 함께 읽어야 한다. 10-20 이후 location·calendar code 전처리, 새 event 종류·사진 근거 장소 후보·단일 장소 편집을 설계했고 11-01에는 연동 rollout이 남았다. 8월 구현 문서는 기준 snapshot이며 최신 production 계약은 후속 commit·artifact로 재검증해야 한다. [[2026-10-10-meeting-369-team-space]], [[2026-10-11-meeting-369-team-space]], [[2026-10-20-meeting-369-team-space]], [[2026-10-26-meeting-369-team-space]], [[2026-10-27-meeting-369-team-space]], [[2026-11-01-meeting-369-team-space]].

첫 사용의 핵심은 권한 허용만으로 유효 source가 보장되지 않는 점과 credit을 쓰기 전에 품질·데이터를 설명하는 점으로 구체화됐다. 6시간 gate·0개 차단·tutorial·사진 선택은 미결·변화 중인 설계로 분리한다. 초기 169~170명·42%는 정의를 점검하던 앱 재실행 지표이며 승인된 생성·저장 retention이 아니다. 상품 화면안·API 비용·영상 약세는 [[laimory-planning-and-validation]] 및 관련 source에서 계획·관측·검증 상태를 확인한다. [[2026-10-15-meeting-369-team-space]], [[2026-10-18-meeting-369-team-space]].

## Key Points

- 핵심 기능은 AI Timeline, 5가지 구조화 회고, 충분한 기록 누적 후 Personal AI Chat이다.
- 회고 기능은 기억 복원, 패턴 발견, 변화 인식, 회고 유도, 재방문/재평가로 나뉜다.
- MVP 시나리오는 사용자가 하루 보기에서 사진을 선택하고 AI 초안을 받은 뒤 자기 전에 수정/저장하는 흐름이다.
- 현재 AI 하루 타임라인 구현은 다섯 Event Agent의 병렬 실행, Timeline 의미 병합, 결정론 confirm과 제한된 도구를 가진 Repair, 확정 event 질문 생성 순서다.
- 과거 문서의 독립 Reflection Agent 구조는 현재 구현 계약이 아니며 선택적 상류 재실행은 Repair 도구로 흡수되었다.
- source 존재, 시간 범위, Calendar 보존, Photo 단일 귀속과 ID처럼 셀 수 있는 불변식은 prompt가 아니라 코드가 확정한다.
- User Memory는 최대 크기가 제한된 전체 rewrite profile이고, 성향 계열 필드는 사용자가 쓴 memo만 근거로 삼는다.
- OpenAI, Gemini, Bedrock provider는 공통 계약을 공유한다. 8월 말 회의에서는 Nova 계열 후보를 주력에서 제외하고 저비용 event 단계와 핵심 Timeline 단계의 model을 나누는 routing이 제안됐지만 재현 가능한 비교표와 정확한 release 설정은 없다.
- 2026-08-09 문서 기준 `dev` 자동 배포는 EC2이고 AgentCore는 수동 경로였다. 8월 말 회의에서는 AgentCore 배포·연결 시험과 ALB callback이 진행됐으므로 현재 traffic ownership과 운영 상태는 배포 기록으로 재확인해야 한다.
- 기록은 저장 전까지 계속 추가되며, 기존 수정/작성 내용은 임시저장으로 유지되는 방향이 제안되었다.
- 읽기 mode는 AI 질문을 숨기고 편집 button으로 기존 event 수정 UI에 들어가는 별도 depth를 유지하며, edit mode의 빈 memo에는 AI 질문을 보여주는 방향으로 구현 보고됐다.
- 초기 문서의 Free/Premium/Max 구독 구상 이후, 10월 회의에서는 생성 크레딧과 소량 구매 가격안을 논의했다. 상품 등록·실결제·매출은 별도 확인 대상이다. [[2026-10-15-meeting-369-team-space]], [[2026-10-20-meeting-369-team-space]].
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
- 제품 표현 원칙은 `기억은 찾아주고, 이야기는 사용자가 완성한다`이며 AI가 사용자 감정·의미를 단정하거나 장문 기록을 강제하지 않는다.
- First Value Action은 실제 MVP에 회고가 포함되는지에 따라 보고서 정의와 review 정의가 충돌한다. 현재 실행 계약을 정할 때 첫 Timeline 확정·저장을 중심으로 하나로 고정해야 한다.
- 8월 말 회의에서는 약관 URL·동의 version·탈퇴 후 삭제 scheduler가 구체화됐지만 법률 요구, backup 삭제와 재가입 semantics는 아직 검증되지 않았다.
- 수집 data가 전혀 없는 첫날과 같은 날 여러 번 생성하는 경우에는 낮은 first-value 품질, AI 비용, source dedupe, client window·history state가 충돌하며 정식 flow가 아직 없다.

## Open Questions

- 무료 장기기억 기능에서 즉시 제공할 첫 가치는 무엇인가?
- On-device SLM이 한국어 일상 이벤트 요약과 감정 추출을 충분히 수행할 수 있는가?
- Google Timeline/Places 연동, Geofencing, Passive Location 중 MVP에 맞는 위치 수집 전략은 무엇인가?
- 20~30대 직장인과 50대 이상 액티브 시니어 중 어떤 persona가 더 강한 문제/지불 의사를 보이는가?
- 모바일 추출 데이터 중 metadata-only로 충분한 항목과 원본/썸네일 업로드가 필요한 항목을 어떻게 나눌 것인가?
- 10월 출시 확인 이후 activation·생성·저장 retention·수정·삭제 지표는 어떤 검증된 cohort와 집계 창으로 나왔는가?
- 입력 source와 User Memory가 모두 없는 날의 첫 경험을 AI 호출 없이 어떻게 유용하게 만들 것인가?
- 같은 날 복수 생성에서 server append, client request window와 previous record state를 어떤 계약으로 연결할 것인가?

## Linked Sources

- [[2026-09-05-meeting-369-team-space]]
- [[2026-09-08-meeting-369-team-space]]
- [[2026-09-09-meeting-369-team-space]]
- [[2026-09-10-meeting-369-team-space]]
- [[2026-09-14-meeting-369-team-space]]
- [[2026-09-15-meeting-369-team-space]]
- [[2026-09-17-meeting-369-team-space]]
- [[2026-09-21-meeting-369-team-space]]
- [[2026-09-24-meeting-369-team-space]]
- [[2026-09-25-meeting-369-team-september-25]]
- [[2026-09-28-meeting-369-team-space]]
- [[2026-09-29-meeting-369-team-space]]
- [[2026-10-05-meeting-369-team-space]]
- [[2026-10-07-meeting-369-team-space]]
- [[2026-10-08-meeting-369-team-space]]
- [[2026-10-10-meeting-369-team-space]]
- [[2026-10-11-meeting-369-team-space]]
- [[2026-10-12-meeting-369-team-space]]
- [[2026-10-13-meeting-369-team-space]]
- [[2026-10-15-meeting-369-team-space]]
- [[2026-10-17-meeting-369-team-space]]
- [[2026-10-18-meeting-369-team-space]]
- [[2026-10-20-meeting-369-team-space]]
- [[2026-10-26-meeting-369-team-space]]
- [[2026-10-27-meeting-369-team-space]]
- [[2026-11-01-meeting-369-team-space]]

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-12-notes-laimory-new-value-proposition]]
- [[2026-08-16-notes-laimory-midterm-report-feedback-resolution]]
- [[2026-08-17-notes-laimory-beta-test-execution-plan]]
- [[2026-08-20-pdf-laimory-midterm-presentation]]
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
- [[2026-08-09-meeting-369-team-space]]
- [[2026-08-10-meeting-369-team-space]]
- [[2026-08-12-meeting-369-team-space]]
- [[2026-08-13-meeting-369-team-space]]
- [[2026-08-15-meeting-369-team-space]]
- [[2026-08-16-meeting-369-team-space]]
- [[2026-08-18-meeting-369-team-space]]
- [[2026-08-19-meeting-369-team-space]]
- [[2026-08-24-meeting-369-team-space]]
- [[2026-08-25-meeting-369-team-space]]
- [[2026-08-26-meeting-369-team-space]]
- [[2026-08-27-meeting-369-team-space]]
- [[2026-08-30-meeting-369-team-space]]
- [[2026-09-01-meeting-369-team-space]]
- [[2026-09-02-meeting-369-team-space]]
- [[2026-09-03-meeting-369-team-space]]

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
- [[laimory-data-privacy-and-consent]]
