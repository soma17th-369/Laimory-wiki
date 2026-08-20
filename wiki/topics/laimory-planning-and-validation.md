---
title: Laimory Planning And Validation
kind: topic
status: active
updated: 2026-08-20
tags: [laimory, product-validation, planning-review, business-model]
---

# Laimory Planning And Validation

## Scope

Laimory의 기획 검증, 심의 피드백, 사업화/metric 설계, 리스크를 모으는 topic.

## Current Synthesis

Laimory의 기획은 "자동 모바일 라이프 로그 -> 회고 -> 장기 기억 기반 AI 대화"로 확장되는 구조다. 내부 기획 자료는 이 방향을 Android 기반 시장 선점, 기록 피로 감소, 개인 AI 컨텍스트 구축의 기회로 본다. 2026-06-05 공식 심의 평가의견은 이 문제 정의와 자동 Timeline 아이디어를 긍정적으로 평가하면서도 민감 permission 이전의 즉시 가치, background data 유실과 battery, 기존 기록 서비스 대비 신뢰와 차별성, 실제 수집 가능한 source의 양과 품질, AI가 만드는 구체적 부가가치, 장기 retention과 유료 전환을 8월 중간점검의 핵심 개선 과제로 제시한다. 2026-08-07 마케팅 자문은 이를 측정 가능한 funnel로 좁혀 설치·가입이 아니라 사용자가 첫 Timeline을 수정·완성해 자기 기록으로 받아들이는 순간을 activation으로 보고, 그 cohort의 반복 행동을 retention으로 추적하는 방향을 제안했다.

2026-08-17 공식 중간보고서는 1차 MVP를 하루 Timeline 생성·기록으로 좁히고, 기록·회고에 익숙한 20대 후반~30대 사회초년생·저연차 직장인을 초기 target으로 정했다. 첫 가치 행동은 생성된 Timeline을 확인·필요시 수정한 뒤 첫 일간 회고를 완료하는 것으로 정의하며, 약 20명의 beta cohort를 8월 24~30일 운영해 행동 지표와 설문·인터뷰를 함께 확인할 계획이다. 이는 실행 결과가 아니라 보고서 시점의 검증 계획이다.

8월 12~17일의 승인된 review artifact는 이 정의를 더 엄격하게 다듬는다. 기록 기능의 즉시 가치는 AI 대필보다 `기억은 찾아주고 이야기는 사용자가 완성한다`는 자기효능감에 두고, 회고가 MVP에서 제외됐다면 First Value Action을 `첫 Timeline 확정·저장`으로 바꾸도록 권고한다. TTFV는 가입부터 첫 확정까지의 median·p75와 단계별 이탈로 보고, beta는 모집·MVP end-to-end·analytics·알림·운영 model 고정을 준비하는 실행계획으로 분해한다. 이 문서들은 승인된 knowledge input이지만 beta 완료나 기능 구현 결과를 뜻하지 않는다.

따라서 검증의 중심은 기능 구현 여부보다 "사용자가 데이터 권한을 줄 만큼 즉시 가치를 느끼는가", "자동 타임라인이 반복 방문을 만들 만큼 의미 있는가", "기록 누적 후 회고/AI 대화가 유료 전환 가치로 이어지는가"에 있다.

2026-05-16부터 05-23까지의 회의들은 이 가설이 한 번에 확정된 것이 아니라 문제 정의, MVP 데이터 범위, permission onboarding, 경쟁 비교, 수익화와 성공 지표를 반복해서 다듬은 결과임을 보여준다. 사진·위치·calendar 중심의 축소 MVP와 단계적 permission 요청은 유력한 안이었지만, 우선 persona와 일간 회고의 실제 문제 강도는 미결이었다. 2026-08-05에는 제품 상태를 alpha test 단계로 설명하고 marketing 시작 방식과 예산 집행을 mentor에게 묻는 준비가 보고됐다.

## Key Points

- 초기 persona는 20~30대 디지털 네이티브/직장인 중심이지만, 심의에서는 50대 이상 액티브 시니어와 자서전 방향 피봇 가능성도 제안되었다.
- 공식 기술분류는 `소프트웨어 - 기반 SW`다.
- permission UX, 쉬운 수정·삭제·비공개, On-device 처리 범위와 외부 model 전송 기준은 하나의 제품 신뢰 문제로 함께 검증해야 한다.
- 사진·위치·일정만으로 만드는 Timeline은 MVP의 단순한 입력 범위가 아니라 결과물의 유용성과 AI 부가가치를 증명해야 하는 핵심 검증 과제다.
- Kafka, Edge SLM과 On-device AI는 기획 시점 architecture로 평가받은 계획이며 현재 구현 상태와 동일하다고 간주하지 않는다.
- MVP metric 후보는 권한 허용 성공률, 타임라인 조회 빈도, 타임라인 수정률, 회고 완독률, 회고 재방문율, AI 대화 메시지 수, 대화 만족도, 대화 재방문율이다.
- metric은 `유입·신청 → 설치·가입 → permission → Timeline 생성·열람 → 수정·memo·완성 → 반복 완성`의 단계별 funnel로 구분한다. Permission은 onboarding, 생성은 기능 도달, 첫 Timeline 완성·저장은 activation으로 해석한다.
- 첫 가치 행동은 첫 Timeline을 열람하고 필요한 수정 또는 memo를 거쳐 완성·저장한 행동으로 운영 정의한다. 수정량·memo·삭제는 activation의 단독 판정 조건보다 참여도와 AI correction burden을 함께 보는 보조 지표로 둔다.
- retention은 단순 앱 실행보다 activation 이후 Timeline을 다시 열람·완성한 행동으로 계산한다. 8월 7일 자문에서 언급된 D1 40%, D7 20%, D30 10%는 외부 검증된 업계 benchmark가 아닌 당시 참고 기준이다.
- 초기 마케팅은 community·Instagram으로 20~30명의 관찰 가능한 beta cohort를 먼저 만들고 제품 funnel을 고친 뒤, Landing·Meta A/B test로 소구점별 activation과 cost per activated user를 비교하는 순서가 적절하다.
- 중간보고서의 구체적 beta 계획은 약 20명, 2026-08-24~08-30, 5개 이상 일기 작성자 보상이며, 정식 출시 뒤 두 소구점에 Meta 광고 약 30만 원을 균등 배분하는 것이다.
- 광고·콘텐츠 평가는 CTR이나 beta 신청에서 끝내지 않고 GA4, app event와 install referrer를 연결해 campaign별 첫 가치 행동과 D1·D7·D30 행동 retention까지 추적한다.
- 유료화 가설은 기본 기록/타임라인은 무료, 고급 AI 회고/패턴 분석/AI 대화는 Premium/Max로 차등 제공하는 것이다.
- 운영 비용 추정과 손익분기점은 내부 가정이므로 별도 검증 전에는 사업 계획 가설로 취급한다.
- 기획심의 피드백은 Apple Journal 등 기존 서비스 대비 별도 앱을 신뢰하고 장기 데이터를 맡겨야 하는 이유를 더 명확히 요구한다.
- 기획심의 보고서의 경쟁 구도는 웨어러블 기반 자동 로깅, 직접 입력형 AI 저널, 플랫폼 종속 저널의 세 유형이다. Laimory는 자동 기록과 장기 생활 맥락 기반 회고를 동시에 제공한다는 가설로 차별화한다.
- 문서에 제시된 Agent·Reflection·Memory Graph 구조와 개발환경은 기획 시점 설계이며, 현재 구현 상태를 판단할 때는 2026-08-09 AI 시스템 문서를 우선한다.
- 중간보고서의 첫 가치 행동은 `첫 일간 회고 완료`이지만 D1·D7·D30 표는 `첫 Timeline 생성 후 재생성`을 기준으로 삼는다. activation cohort와 retention event의 기준 시점을 하나의 분석 계약으로 맞춰야 한다.
- 중간보고서의 멘토 의견은 범위 확대보다 MVP 핵심 가치, 지표별 정량 목표와 실제 결과, callback 유실·중복 요청·재시작 정합성, 더 넓은 시장 발굴을 남은 기간의 검증 과제로 강조한다.
- 최신 review 기준 activation은 회고가 실제 MVP에 없을 경우 첫 Timeline 확인·필요한 수정·삭제·확정·저장으로 통일하고, 수정량과 memo는 참여도·correction burden 보조 지표로 둔다.
- TTFV는 도달 사용자 평균 하나가 아니라 median·p75, 도달률, 생성 실패와 단계별 이탈을 함께 기록한다.
- privacy 서사는 사용자 선택, task 단위 최소 source, AI Server 비영속, 외부 model 제공 고지·동의·마스킹을 기준으로 하며 `요약·인덱스만 전송`처럼 실제 처리와 다른 표현을 쓰지 않는다.
- 목표 추적은 Timeline 품질과 반복 사용 검증 뒤 축적 기록에서 사용자가 정한 목표 관련 행동 근거를 확인하는 선택적 확장으로 둔다.

## Open Questions

- 가장 먼저 검증할 "아하 모먼트"는 자동 타임라인, 회고 카드, AI 대화 중 무엇인가?
- 권한 요청은 어떤 순서와 문구로 해야 이탈을 최소화할 수 있는가?
- 무료 장기기억과 유료 AI 기능의 경계는 어느 시점에 그어야 하는가?
- 사용자 인터뷰/커뮤니티 반응에서 실제 문제 강도와 지불 의사는 어떻게 측정할 것인가?
- 사용자가 장기 데이터를 별도 앱과 외부 model에 맡기기 전에 어떤 수정·삭제·비공개·전송 통제를 제공해야 하는가?
- 사진·위치·일정만으로 만든 Timeline이 기억 복원에 도움이 됐는지를 어떤 정성·정량 기준으로 판단할 것인가?
- Timeline `완성·저장` event의 정확한 UI 조건과 D1·D7·D30 retention의 exact-day·rolling 계산 방식을 어떻게 고정할 것인가?
- `기억 복원`과 `기록 부담 감소` 중 어떤 소구점이 신청뿐 아니라 activation과 반복 사용이 높은 cohort를 만드는가?
- 첫 일간 회고 완료를 activation으로 쓸 때 D1·D7·D30의 cohort anchor와 return event를 정확히 무엇으로 정의할 것인가?
- 2026-08-24~30 beta가 실제로 시작됐는지, 모집 규모·완주·activation·retention 결과는 무엇인지?

## Linked Sources

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-10-notes-laimory-midterm-report-section-guide]]
- [[2026-08-12-notes-laimory-new-value-proposition]]
- [[2026-08-14-notes-laimory-midterm-marketing-kpi-draft]]
- [[2026-08-16-notes-laimory-midterm-report-feedback-resolution]]
- [[2026-08-17-notes-laimory-beta-test-execution-plan]]
- [[2026-08-07-notes-laimory-marketing-kpi-mentoring]]
- [[2026-08-09-pdf-laimory-planning-review-report]]
- [[2026-06-15-markdown-notion-laimory-presentation-script-260529]]
- [[2026-06-05-notes-laimory-planning-review-evaluation]]
- [[2026-06-15-markdown-notion-ai-diary-draft-service]]
- [[2026-06-15-markdown-notion-ai-diary-renewal]]
- [[2026-06-15-markdown-notion-meeting-records]]
- [[2026-05-16-meeting-369-team-space]]
- [[2026-05-17-meeting-369-team-space]]
- [[2026-05-18-meeting-369-team-planning-review-preparation]]
- [[2026-05-19-meeting-369-team-planning-review-preparation]]
- [[2026-05-21-meeting-369-team-planning-review-preparation]]
- [[2026-05-23-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[android-life-logging-data-collection]]

