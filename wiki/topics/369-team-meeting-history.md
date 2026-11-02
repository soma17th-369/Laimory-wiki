---
title: 369팀 회의 이력
kind: topic
status: active
updated: 2026-11-02
tags: [369-team, laimory, meetings, decision-history, project-history]
---

# 369팀 회의 이력

## Scope

369팀 회의 source 55건(음성 자동 전사 54건·채팅만 1건)에서 Laimory의 제품 정의, 기획심의 준비, 구현 통합, alpha·beta 준비와 기술 의사결정이 어떻게 변했는지를 시간순으로 연결한다. 각 항목은 `raw/meetings/`의 회의 요약본을 인제스트한 `wiki/sources/` page를 근거로 한다.

## Current Synthesis

회의 이력은 크게 세 단계로 나뉜다. 2026-05-16부터 05-23까지는 제품을 단순 AI 일기에서 모바일 life logging과 Personal AI Memory로 재정의하고, 기획심의를 위해 문제·MVP·permission·경쟁·수익화·검증 지표를 다듬은 시기다. 사진·위치·calendar를 우선 source로 삼는 축소안은 유력했지만 persona, permission을 감수할 즉시 가치와 AI 품질 검증은 미결이었다.

2026-07-28과 07-30에는 구현 통합과 alpha test가 중심으로 이동했다. source ID와 structured output, App Server 경유 저장, callback·FCM·polling, Langfuse 관측성, 사진·알림 수집과 UTC/KST 하루 경계 문제가 실제 장애와 개선 항목으로 나타났다.

2026-08-02부터 08-06까지는 모델 품질, User Memory, AWS와 AgentCore, privacy filter, DRAFT/SAVED UX, K6 부하 테스트, 위치·체류 데이터와 User Memory 동시 갱신으로 논의가 구체화됐다.

2026-08-09부터 08-19까지는 중간보고서·발표와 beta 준비가 개발과 병행됐다. 데이터 비식별화·외부 AI 동의·위치 제외, 사회초년생 기록자 persona와 목표 기능, draft/saved API, notification filtering, 약관·push 동의, GA4·crash log, 탈퇴·재가입, 실제 앱 시연이 논의됐다. 08-19 rehearsal은 구현·시장·비용 주장을 발표 문구로 정리했으므로 독립 검증된 운영 상태와 구분해야 한다.

2026-08-24부터 08-30까지는 초기 release의 마지막 통합 단계였다. GA4 funnel, AgentCore 연결, timeline 읽기·편집 UX, initializer와 onboarding, ALB callback, notification·위치 UX, 탈퇴 후 data lifecycle, Bedrock 모델 전환 장애와 단계별 model routing, 약관 WebView·static hosting, 무입력 empty state가 이어졌다. 이 시기의 구현 보고와 model명은 code·배포 기록으로 확인해야 하며, 회의 중 법률·비용·일정 추정은 확정 사실로 취급하지 않는다.

2026-09-01부터 09-03까지는 permission onboarding과 읽기·편집 mode를 고정하고 release build·login·logging을 마무리하는 hardening 단계였다. Onboarding은 photo·calendar·location·notification을 왜 읽고 어떻게 Timeline에 쓰는지 구체적으로 설명하는 방향으로 수정됐다. 완전 무입력 첫날에는 생성을 막을지 manual blank Timeline을 줄지 미결이었고, 같은 날 복수 생성은 server append와 client window·history state가 완전히 연결되지 않아 초기 beta에서는 하루 한 번 오후 9시 이후 생성하도록 안내하기로 했다. Release는 9월 4일 목표에서 주말 가능성으로 밀렸으며 실제 배포·beta 시작은 확인되지 않았다.

2026-09-05~29에는 지인 beta, 사진·메모·onboarding QA, GA4 debug 검증, production 신청과 심사 지연, 광고 계정 접근 장애를 다뤘다. 10-05~08은 출시 전 접수·광고 소구점과 생성 확인·공지·로딩을 검토한 시기다. 자동 요약의 설치·AI 재현율·V3 완료 단정은 원전과 맞지 않는 부분이 있어 각 source에 구분했다.

10-10 회의는 출시됨을 확인한 보고이며 최초 공개 시각은 불명이다. 10-11~20에는 V3 설정·로그 누락·AgentCore timeout, 첫 생성 데이터 부족·credit·초기 사용자 지표를 점검했다. 10-26~11-01에는 tutorial·gallery·사진 근거 장소 후보와 schema를 정리하고 연동 release, 알림 지연·추가 GA4, 개발 Agent 테스트의 API 비용 급증을 다뤘다. 실제 release·billing·cohort 검증 없이 회의 보고를 성과 확정값으로 승격하지 않는다.

## Chronology

| 날짜 | 회의 성격 | 주요 변화와 쟁점 |
|---|---|---|
| 2026-05-16 | 제품 방향 | AI 일기에서 모바일 life logging으로 문제 범위를 확대하고 회고를 선택적 interface로 재배치 |
| 2026-05-17 | 문제 정의 | 파편화된 디지털 흔적을 하루 기록으로 복원하고 장기 second brain으로 확장하는 비전 구체화 |
| 2026-05-18 | 기획심의 준비 | 자동 하루 기록 중심 MVP, on-device·server hybrid, privacy와 AI 비용 검토 |
| 2026-05-19 | 기획심의 준비 | 경쟁 제품 조사, Android-first 차별화, permission·privacy와 beta·AI QA 쟁점 정리 |
| 2026-05-21 | 기획심의 준비 | 사진·위치·calendar 중심 축소 MVP, 단계적 permission, 유료 기능 가설 검토 |
| 2026-05-23 | 기획심의 점검 | 설명 문구, 위험 대응, 부하 테스트, 사용자 검증 지표와 community 확장안 검토 |
| 2026-07-28 | 통합 테스트 | row ID 정합성, structured output, App Server 경유 DB, FCM·callback·Redis 문제 점검 |
| 2026-07-30 | alpha test | Langfuse 도입, server token, 알림·사진 수집, 하루 경계와 UTC/KST 오류 확인 |
| 2026-08-02 | 품질·인프라 | 모델 비교, User Memory, AWS 비용, Android local cleanup와 수집 제한 논의 |
| 2026-08-03 | UX·runtime | prompt version, AgentCore, timeline window와 오전 6시 하루 경계 구체화 |
| 2026-08-04 | privacy·UX | 외부 LLM 제3자 제공 우려, on-device SLM filter, DRAFT/SAVED와 저장 trigger 검토 |
| 2026-08-05 | 평가·성능 | User Memory table, Langfuse evaluation, K6 외부 API 병목, 위치 noise와 marketing 준비 |
| 2026-08-06 | 동시성·위치 | User Memory 충돌 작업 재처리, AI 품질 도구, 외부 API 성능과 주소 표시 검증 |
| 2026-08-09 | 운영 일정 | 대면·비대면 mentoring 배치와 중간발표 전 marketing·mentor 조언 일정 조정 |
| 2026-08-10 | privacy·제품 방향 | AI 비용, 비식별화·외부 제공 동의, 회고 대체 목표 기능과 보고서 구조 검토 |
| 2026-08-12 | persona·data control | 사회초년생 기록자 persona, 제외 위치의 client-side 제거, 월 목표 기반 retention 방향 |
| 2026-08-13 | API·mobile 상태 | draft/saved 동시 반환과 nullable emotion, 20분 미만 movement 제외, scheduler·Redis 정리 |
| 2026-08-15 | beta 준비 | 보고·발표와 beta 준비 병렬화, GA4·crash log 우선, 탈퇴·재가입 정책 미결 |
| 2026-08-16 | notification·약관 | 자동 notification filtering 우선, 약관 server abstraction, 장기 사용자 가치 미결 |
| 2026-08-18 | 발표·push | Push 광고성·야간 동의 불확실성, 실제 앱 demo, saved event 수정 검증 |
| 2026-08-19 | 중간발표 rehearsal | 18분 17초 rehearsal, section 전환·pace 수정, MVP·AI·beta 발표 주장 점검 |
| 2026-08-24 | release·analytics | GA4 funnel, Play Store 준비, AgentCore·model 전환, Android 자동 수집·map·filter |
| 2026-08-25 | timeline UX | 읽기·편집 mode 분리, initializer API, onboarding과 notification filter 검수 |
| 2026-08-26 | runtime 통합 | AgentCore callback을 ALB로 보내기로 결정, initializer·monitoring·약관·onboarding 점검 |
| 2026-08-27 | 품질·data lifecycle | Model 전환 장애, notification 과잉 event, 탈퇴 7일 삭제와 초기 release 병목 점검 |
| 2026-08-30 | model routing·policy | Nova 계열 후보 제외, 단계별 model routing, Codex CLI judge, 약관 URL과 empty state |
| 2026-09-01 | onboarding review | data 활용을 직접 설명하는 permission onboarding, photo 의미 분석·calendar·location visual과 release 범위 조정 |
| 2026-09-02 | edit UX·first value | onboarding 고정, 별도 depth의 읽기·편집 mode, 14세 확인과 완전 무입력 first experience 논의 |
| 2026-09-03 | release hardening | 읽기·편집·event 추가·notification·theme 구현 보고, AI metric·비용 추정, 복수 생성 gap과 beta 하루 1회 규칙 |
| [2026-09-05](../sources/2026-09-05-meeting-369-team-space.md) | 회의 | AI 정량 평가와 release·QA 빌드를 점검하고 Play Store 제출 및 지인 베타 운영을 준비했다 |
| [2026-09-08](../sources/2026-09-08-meeting-369-team-space.md) | 회의 | Prompt V3 개선과 mobile onboarding·수집·logging 문제를 함께 점검했다 |
| [2026-09-09](../sources/2026-09-09-meeting-369-team-space.md) | 회의 | 홈 화면 redesign과 데이터·기록 접근성을 검토하고 beta 전 마무리 항목을 조율했다 |
| [2026-09-10](../sources/2026-09-10-meeting-369-team-space.md) | 회의 | Prompt V3와 홈 UI·onboarding 마무리를 공유했다 |
| [2026-09-14](../sources/2026-09-14-meeting-369-team-space.md) | 회의 | 초기 사용자 반응과 첫 사용 UX를 검토했다 |
| [2026-09-15](../sources/2026-09-15-meeting-369-team-space.md) | 회의 | Beta 중 수집·편집 오류와 버그 추적을 점검하고 미사용자 후속 확인 및 V3 배포 목표를 논의했다 |
| [2026-09-17](../sources/2026-09-17-meeting-369-team-space.md) | 회의 | 부하 테스트에서 동기 logging 병목을 발견한 뒤 비동기 전환을 보고했다 |
| [2026-09-21](../sources/2026-09-21-meeting-369-team-space.md) | 회의 | 프로덕션 접근 신청과 GA4 debug 테스트를 보고하고 메모 계측을 단순화했다 |
| [2026-09-24](../sources/2026-09-24-meeting-369-team-space.md) | 회의 | GA4·광고 귀속과 스토어 자료를 준비하고 사진 크기·업로드 지연을 검토했다 |
| [2026-09-25](../sources/2026-09-25-meeting-369-team-september-25.md) | 회의 | 충전한 Meta 광고 계정이 콘솔에서 보이지 않는 문제를 조사하고 지원·결제 증빙 경로를 찾았다 |
| [2026-09-28](../sources/2026-09-28-meeting-369-team-space.md) | 회의 | KPI 쿼리·스토어와 랜딩 시각 자료·문의 기능을 준비했다 |
| [2026-09-29](../sources/2026-09-29-meeting-369-team-space.md) | 회의 | V3·계측 준비와 출시 지연에 따른 마케팅 시작 시점을 조율했다 |
| [2026-10-05](../sources/2026-10-05-meeting-369-team-space.md) | 회의 | 출시 전 광고의 관심·전화번호 접수와 랜딩 마찰을 검토했다 |
| [2026-10-07](../sources/2026-10-07-meeting-369-team-space.md) | 회의 | 출시 전 광고 지표·크레딧 확인 UI·공지·로딩을 검토했다 |
| [2026-10-08](../sources/2026-10-08-meeting-369-team-space.md) | 회의 | 의미 없는 체류 사건을 줄이고 장소 기반 추론을 시험했다 |
| [2026-10-10](../sources/2026-10-10-meeting-369-team-space.md) | 회의 | 회의 중 Play Store 출시 상태를 확인했다고 보고하고 V3 production 전환과 후속 UX 업데이트를 조율했다 |
| [2026-10-11](../sources/2026-10-11-meeting-369-team-space.md) | 회의 | V3 production 전환을 보고했으나 회의 중 실제 사용자 생성 실패와 환경변수·배포 상태 불일치를 점검했다 |
| [2026-10-12](../sources/2026-10-12-meeting-369-team-space.md) | 회의 | Play Store 후속 업데이트 심사를 기다리며 홈페이지 다운로드 연결·UTM·AI 고지를 점검했다 |
| [2026-10-13](../sources/2026-10-13-meeting-369-team-space.md) | 회의 | 운영 로그 누락과 정리 batch를 보완하고 심사 지연 중 남은 UX·마케팅 준비를 공유했다 |
| [2026-10-15](../sources/2026-10-15-meeting-369-team-space.md) | 회의 | 스토어 이미지·크레딧 가격 화면을 다듬고 첫날 데이터 부족과 생성 제한·튜토리얼 대안을 길게 논의했다 |
| [2026-10-17](../sources/2026-10-17-meeting-369-team-space.md) | 채팅만 보존 | 음성 전사 없이 남은 채팅에서 최소 데이터 가이드의 dev/prod 상태, calendar·UTC 수정 계획, 초기 지표의 집계 불확실성을 확인했다 |
| [2026-10-18](../sources/2026-10-18-meeting-369-team-space.md) | 회의 | 출시 후 debug 수정과 AgentCore timeout을 점검하고 첫 사용·유지 지표를 확인했다 |
| [2026-10-20](../sources/2026-10-20-meeting-369-team-space.md) | 회의 | Calendar 수집 정합성과 위치 후보 확인·지도 UX를 검토했다 |
| [2026-10-26](../sources/2026-10-26-meeting-369-team-space.md) | 회의 | Event 종류 확장과 장소 후보 저장·표시 계약을 맞췄다 |
| [2026-10-27](../sources/2026-10-27-meeting-369-team-space.md) | 회의 | 튜토리얼과 gallery prototype을 검토하고 장소 선택을 event당 하나로 단순화하는 방향을 맞췄다 |
| [2026-11-01](../sources/2026-11-01-meeting-369-team-space.md) | 회의 | API 비용 급증을 조사하다 로컬 개발 Agent 테스트의 실제 API 호출을 원인으로 보고했다 |

## Durable Threads

- 제품 정의는 자동 기록 자체보다 파편화된 생활 데이터를 회고 가능한 기억으로 바꾸는 데 수렴했다.
- permission과 privacy는 onboarding UX, on-device 처리, 외부 LLM 전송, 신뢰 형성을 함께 다뤄야 하는 제품 문제다.
- Timeline 품질은 prompt만이 아니라 source ID, structured output, 시간대, callback과 수집량 제한 같은 시스템 정합성에 의존한다.
- User Memory는 장기 맥락 가치의 핵심이지만 저장 trigger, provenance, 동시 갱신 순서와 실패 복구가 남아 있다.
- Langfuse와 품질 평가 도구는 결과가 그럴듯한지를 넘어 source 충실도와 Agent 내부 동작을 검증하는 방향으로 발전했다.
- Beta 준비는 GA4 funnel, crash log, onboarding, notification filtering, 읽기·편집 UX와 약관·탈퇴 lifecycle을 하나의 release gate로 묶었다.
- AgentCore 전환은 단순 runtime 교체가 아니라 callback 경로, ALB, IAM/network와 server-to-server authentication을 함께 해결해야 하는 통합 문제로 드러났다.
- Model 선택은 단일 provider 승자 결정에서 stage별 cost·quality routing으로 이동했지만, 정확한 model명과 재현 가능한 비교 결과는 아직 부족하다.
- Permission onboarding은 권한 종류를 나열하는 화면에서 각 source의 수집·처리·사용자 이익을 설명하는 설득 flow로 구체화됐다.
- 완전 무입력과 같은 날 복수 생성은 UI 문제만이 아니라 source 수집량, AI 비용, server append, client window·history state가 함께 얽힌 first-value 문제로 드러났다.
- 외부 API와 cloud 비용 문제는 실제 traffic 목표와 측정 자료가 없으면 회의 중 관찰 또는 rough estimate로만 취급해야 한다.

## Open Questions

- 회의에서 나온 잠정 설계 중 현재 코드와 운영 환경에 실제 반영된 것은 무엇인가?
- 결정·액션 아이템의 담당자와 완료 상태를 어떤 issue tracker와 연결할 것인가?
- 법률 mentoring을 참석자가 재해석한 내용과 실제 법률 자문 원문을 어떻게 분리해 보존할 것인가?
- 회의별 성능 수치와 모델 품질 관찰을 재현 가능한 benchmark·trace·issue로 어떻게 승격할 것인가?
- 10월 출시 확인 이후 beta·유료 유입·업데이트별 GA4 cohort와 실제 생성·저장 결과를 어떻게 검증할 것인가?
- 초기 beta의 하루 1회·오후 9시 이후 안내가 실제 사용 pattern과 first-value 평가를 얼마나 왜곡하는가?
- 약관·동의·삭제 scheduler와 notification policy가 실제 data lifecycle 및 platform 요구와 일치하는가?

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

- [[369-team]]
- [[laimory]]
- [[ai-life-logging]]
- [[laimory-planning-and-validation]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
- [[android-life-logging-data-collection]]
- [[laimory-data-privacy-and-consent]]
