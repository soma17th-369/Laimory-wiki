---
title: Laimory Data Privacy And Consent
kind: topic
status: active-with-open-legal-questions
updated: 2026-11-02
tags: [laimory, privacy, consent, data-minimization, retention, policy]
---

# Laimory Data Privacy And Consent

## Scope

Laimory가 사진·위치·일정·건강·알림과 User Memory를 수집·전송·보관할 때 필요한 데이터 최소화, 비식별 식별자, 사용자 선택, 약관·동의 이력, 삭제와 외부 AI 제공 경계를 정리한다.

## Current Synthesis

공식 중간보고서는 인증 userId와 콘텐츠 영역의 Subject ID를 분리하고 HMAC 기반 조회 key로 연결하며, Timeline·AI staging·User Memory·FCM·Redis task·S3 namespace에 비식별 식별자를 적용한다고 설명한다. AI Server는 task 처리에 필요한 source만 받아 비영속적으로 처리하고, 사용자가 생성 전에 선택한 데이터만 전송한다는 것이 현재 privacy 서사의 핵심이다. 실제 algorithm, secret rotation, 접근 제어와 배포 설정은 code·security review로 별도 검증해야 한다.

2026-08-10과 08-12 회의에서는 정규식으로 탐지할 수 있는 직접 식별자와 이름·상세 주소·병원·종교·정치처럼 맥락 의존적인 민감정보를 구분했다. 회원가입 동의와 Timeline 생성 시 외부 LLM 제3자 제공·국외 이전 고지를 구분하고 동의 시점·version을 server에 저장하는 방향이 제시됐다. 사용자가 제외한 장소와 관련 movement는 mobile에서 제거해 server로 보내지 않는 방향도 정해졌지만, 반복 동의가 매 생성마다 필요한지와 비정형 민감정보 처리 기준은 미결이다.

08-15부터 08-30까지의 회의는 정책을 account deletion, notification consent와 배포 가능한 약관 flow로 확장했다. 탈퇴 후 재가입·보존 정책은 한동안 미결이었고, 08-27에는 탈퇴 7일 뒤 user data와 orphan item을 삭제하는 scheduler가 구현 중이라고 보고됐다. Retention push의 광고성·야간 수신 동의는 법률 자문이 아닌 내부 조사 수준에 머물렀다. 약관은 database에 보수적으로 반영하고 initializer API가 최신 URL을 내려 WebView로 표시하며, 향후 static hosting으로 옮기는 방향이 정해졌다. 중요한 변경의 재동의 기준과 실제 처리자·국가·보존기간의 일치 여부는 여전히 검증해야 한다.

09-01~03 회의에서는 약관 web posting 전환 완료가 보고됐고, onboarding에서 photo·calendar·location·notification의 처리 목적을 구체적으로 설명하는 방향이 고정됐다. Kakao login에서 나이를 받지 못해 login 또는 onboarding에서 `14세 이상` self-attestation을 받는 안이 제시됐지만 법률적 충분성과 위치는 검토되지 않았다. 일부 beta participant의 User Memory를 사전 입력해 결과 차이를 보는 아이디어도 나왔으나, 이는 실행 전 명시적 동의·수정·삭제와 비교군 기준이 필요한 별도 experiment다.

따라서 현재의 durable 원칙은 `필요한 source만 선택`, `제외 데이터는 가능하면 client에서 제거`, `인증 식별자와 콘텐츠 식별자 분리`, `동의 version 기록`, `수정·삭제·탈퇴 경로 제공`, `법률 해석과 구현 상태를 분리`하는 것이다. On-device AI는 당시 MVP flow에 필수적이지 않다고 판단됐으며, privacy를 보장하는 만능 수단으로 설명해서는 안 된다.

## 2026-09~11 회의 반영

09-05 베타 profile 사전 수집·수동 입력안, 09-08 logging 고지·onboarding reset 시험 API, 09-09 초기 release 수면 제외, 09-17 카카오톡 수집 재허용은 서로 다른 경계를 바꾼다. 특히 카카오톡을 풀어 놓았다는 보고와 개인정보처리방침에 부합하는지 모른다는 발언을 함께 보존한다. 접근 제어·OS/스토어 정책·건강 데이터 적합성은 회의 요약으로 승인하지 않는다. [[2026-09-05-meeting-369-team-space]], [[2026-09-08-meeting-369-team-space]], [[2026-09-09-meeting-369-team-space]], [[2026-09-17-meeting-369-team-space]].

09-21 회원 PK analytics 사용 논의와 10-11 masking 뒤 운영 식별 필요는 기존 Subject ID 분리 원칙 및 실제 analytics 식별 정책과 대조할 미결 사항이다. 09-28 문의 회신 이메일·첨부 수집도 별도 고지·보존 확인이 필요하다. 11-01 로컬 테스트 key 호출의 자체 원인 분석은 외부 유출을 독립적으로 배제하는 감사가 아니다. 계정 접근값·연락처·개인 일정은 원전에 남기고 요약에는 복제하지 않았다. [[2026-09-21-meeting-369-team-space]], [[2026-09-28-meeting-369-team-space]], [[2026-10-11-meeting-369-team-space]], [[2026-11-01-meeting-369-team-space]].

## Key Points

- 외부 model 전송 전에 사용자가 source를 확인·제외할 수 있어야 하며, 제외한 장소와 연관 이동은 server 전송 전에 제거하는 방향이다.
- 정규식 masking은 직접 식별자 일부에는 유효하지만 이름·상세 주소·건강·종교·정치·관계 맥락을 완전히 다루지 못한다.
- Subject ID와 HMAC 조회 key 분리는 식별 위험을 낮추지만 access control, key rotation, log redaction과 deletion까지 함께 검증해야 한다.
- 약관·개인정보 처리방침은 URL과 version을 server가 관리하고 mobile은 WebView로 표시하는 방향이다.
- OS notification permission, 일반 알림 설정, 광고성 정보 동의와 야간 수신 동의는 서로 다른 층으로 취급해야 한다.
- 탈퇴 7일 후 삭제와 orphan cleanup은 회의상 구현 보고이며 production 배포·복구·재가입 semantics는 확인되지 않았다.
- 회의의 국외 이전·광고성 push·보존기간 발언은 법률 자문이나 platform policy 확인 결과가 아니다.
- `14세 이상` self-attestation과 beta User Memory 사전 입력은 product idea일 뿐 법률 적합성·동의 flow가 확정되지 않았다.

## Open Questions

- Timeline 생성마다 외부 제공 고지가 필요한지, onboarding 동의와 중요한 약관 변경 시 재동의의 경계를 어디에 둘 것인가?
- 이름·상세 주소·민감한 notification처럼 비정형 민감정보를 어떤 rule과 human control로 차단할 것인가?
- 동의 철회, 탈퇴 7일 유예, 재가입, backup과 파생 데이터 삭제를 하나의 lifecycle로 어떻게 정의할 것인가?
- 약관에 적힌 처리자·국가·data category·보존기간이 실제 model routing과 infrastructure에 일치하는지 어떻게 자동 검증할 것인가?
- 사용자가 User Memory와 생성 결과를 열람·수정·삭제하고 provenance를 확인할 수 있는 UI는 무엇인가?
- Retention push를 정보성·광고성으로 구분하는 공식 기준과 quiet-hours 설정은 무엇인가?
- Kakao가 나이를 제공하지 않을 때 14세 이상 self-attestation을 어디서 어떤 evidence와 함께 받아야 하는가?
- beta에서 사전 입력한 User Memory의 동의, provenance, 수정·삭제와 experiment 종료 후 cleanup을 어떻게 보장할 것인가?

## Linked Sources

- [[2026-09-05-meeting-369-team-space]]
- [[2026-09-08-meeting-369-team-space]]
- [[2026-09-09-meeting-369-team-space]]
- [[2026-09-17-meeting-369-team-space]]
- [[2026-09-21-meeting-369-team-space]]
- [[2026-09-28-meeting-369-team-space]]
- [[2026-10-11-meeting-369-team-space]]

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-09-pdf-laimory-planning-review-report]]
- [[2026-08-04-meeting-369-team-space]]
- [[2026-08-10-meeting-369-team-space]]
- [[2026-08-12-meeting-369-team-space]]
- [[2026-08-15-meeting-369-team-space]]
- [[2026-08-16-meeting-369-team-space]]
- [[2026-08-18-meeting-369-team-space]]
- [[2026-08-26-meeting-369-team-space]]
- [[2026-08-27-meeting-369-team-space]]
- [[2026-08-30-meeting-369-team-space]]
- [[2026-09-01-meeting-369-team-space]]
- [[2026-09-02-meeting-369-team-space]]
- [[2026-09-03-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[android-life-logging-data-collection]]
- [[laimory-user-memory]]
- [[laimory-planning-and-validation]]
- [[laimory-ai-runtime-and-observability]]
