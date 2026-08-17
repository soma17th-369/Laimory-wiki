---
title: Laimory 8월 7일 마케팅 KPI 멘토링과 초기 사용자 획득 실행안
source_type: user-supplied-notes
mentoring_date: 2026-08-07
created_at: 2026-08-12
status: approved-for-ingest
approval_basis: 사용자가 raw 문서 작성 후 내용이 타당하면 wiki ingest와 기존 문서 병합을 명시적으로 요청함
tags: [laimory, marketing, kpi, activation, retention, beta-test, meta-ads]
---

# Laimory 8월 7일 마케팅 KPI 멘토링과 초기 사용자 획득 실행안

## 문서 성격

사용자가 전달한 2026년 8월 7일 윤지환 멘토의 마케팅 자문과 같은 날의 다른 멘토링 요지, 팀의 무비용·유료 마케팅 실행안을 보존하고 하나의 측정 가능한 검증 계획으로 정리한 문서다. 멘토링 원문 녹취가 아니라 사용자가 회고해 전달한 내용이므로, 발언의 정확한 문구와 세부 맥락은 원자료가 확보되면 다시 확인한다.

## 사용자 제공 멘토링 요지

- 설치 수나 회원가입 수를 최종 KPI로 삼지 않는다.
- 사용자가 Laimory의 가치를 처음 체감하는 행동을 핵심 KPI로 정한다.
- 첫 가치 행동의 후보로 다음이 언급됐다.
  - 회원가입 후 필요한 권한에 동의하는 비율
  - 타임라인 생성
  - 생성된 타임라인을 사용자가 수정하거나 완성하는 행동
- 이 가운데 타임라인을 수정·완성하는 순간을 Laimory의 `첫 가치 행동`으로 볼 수 있다는 의견이 강조됐다.
- 첫 가치 행동을 경험한 사용자가 이후에도 반복하는지를 기준으로 retention을 계속 추적한다.
- 당시 참고 기준으로 D1 40%, D7 20%, D30 10%가 제시됐다.
- 다른 8월 7일 멘토링에서도 다운로드 수만 발표하지 말고 GA4, 앱 내부 event, install referrer를 연결해 `광고 유입 → 가입 → 첫 가치 행동 → 재방문`을 측정하라는 방향이 정리됐다.

## 팀이 제시한 마케팅 실행안

### 1안: 비용 없이 베타 사용자 모집

- 커뮤니티에 참여해 잠재 사용자를 찾고 베타 사용자로 전환한다.
- Instagram 브랜드 계정을 만들고 Reels와 게시물을 주기적으로 올린다.
- 마케팅 소구점 A~C를 기획해 콘텐츠로 제작하고 반응을 비교한다.
- Instagram 팔로워와 콘텐츠를 장기 채널 자산으로 축적한다.
- 실제 사용자 20~30명을 확보해 앱 전환율, 이탈률, D1~D7 retention을 관찰하고 제품을 최적화한 뒤 광고를 집행한다.

### 2안: 비용을 사용한 Landing·Meta 실험

- alpha 단계에서 landing page를 구성하고 Meta A/B test로 베타 사용자를 사전에 모집한다.
- 주목적은 마케팅 소구점과 concept 탐색이며, CTA는 `베타 참여하기`로 두고 이메일 주소 또는 전화번호를 받아 후속 안내한다.
- 1주 동안 다음 두 소구점을 우선 비교한다.
  - A: `기억하고 있는가`
  - B: `일기 기록이 힘들지 않은가`
- 소구점별 Reels를 제작하고 일 예산 2만~3만 원 수준, 총 30만 원 안팎의 concept test가 제안됐다.
- landing에서 신청까지 이탈이 발생할 수 있다는 점을 위험으로 본다.

## 통합 분석

### 1안과 2안의 관계

두 안은 서로 배타적인 선택지가 아니라 순차 실험으로 연결하는 편이 적절하다.

1. 커뮤니티와 자체 콘텐츠로 초기 사용자 20~30명을 모집한다.
2. 앱의 첫 가치 행동까지 발생하는지 관찰하고 주요 이탈 구간을 고친다.
3. Meta 광고로 소구점별 유입 품질과 획득 비용을 비교한다.
4. 첫 가치 행동과 반복 사용이 확인된 campaign만 확대한다.

초기 20~30명은 사용성 문제와 이탈 이유를 발견하기에는 유용하지만 retention 목표를 확정하기에는 작다. 결과를 보고할 때는 백분율과 함께 `5/25명`처럼 분자와 분모를 표시한다.

### KPI 계층

| 단계 | 행동 | 해석 | KPI 역할 |
|---|---|---|---|
| 유입 | 광고·콘텐츠 클릭, landing 방문 | 메시지에 관심을 보임 | acquisition 진단 |
| 신청 | 베타 신청 | 사용 의향을 표현함 | 모집 지표 |
| 진입 | 설치, 회원가입 | 제품에 들어옴 | 상단 funnel 지표 |
| 준비 | 필수 permission 동의 | 제품 사용 조건을 수용함 | onboarding 지표 |
| 기능 도달 | 타임라인 생성 성공·열람 | 결과물을 받음 | 제품·기술 도달 지표 |
| 첫 가치 | 타임라인을 검토하고 수정·memo 후 완성·저장 | 결과를 자기 기록으로 수용함 | activation 핵심 KPI |
| 반복 가치 | 이후 다시 타임라인을 확인·완성 | 가치를 반복 경험함 | retention 핵심 KPI |

권한 동의는 신뢰와 onboarding의 중요한 지표이고, 생성 성공은 제품이 약속한 기능에 도달했는지를 보여준다. 그러나 둘만으로 사용자가 결과에서 가치를 느꼈다고 단정할 수 없다. 핵심 activation은 첫 타임라인을 사용자가 자기 기록으로 채택한 행동에 두는 것이 적절하다.

### 첫 가치 행동의 운영 정의

권장 운영 정의는 다음과 같다.

> 첫 가치 행동은 사용자가 생성된 첫 타임라인을 열람하고, 필요한 수정 또는 memo를 거쳐 최종 완성·저장한 사건이다.

최종 구현에서는 `수정`을 필수 조건으로 고정하기보다 `완성·저장`을 핵심 event로 두고 수정 필드 수, memo 추가, event 삭제를 속성 또는 보조 event로 수집하는 편이 안전하다. AI 결과가 이미 만족스러워 수정할 필요가 없는 사용자까지 실패로 분류하지 않고, 과도한 수정이 AI 품질 문제인지도 별도로 볼 수 있기 때문이다.

### 측정 funnel

```text
광고·커뮤니티 노출
→ landing 방문
→ 베타 신청
→ 설치
→ 회원가입
→ 필수 permission 동의
→ 첫 타임라인 생성 성공
→ 첫 타임라인 열람
→ 수정·memo
→ 첫 타임라인 완성·저장
→ D1·D7·D30 반복 가치 행동
```

우선 계산할 지표는 다음과 같다.

- 회원가입 대비 필수 permission 동의율
- permission 동의 대비 타임라인 생성 성공률
- 생성 성공 대비 타임라인 열람률과 완성률
- 회원가입 대비 첫 가치 행동 전환율
- 가입부터 첫 가치 행동까지 걸린 시간
- 첫 가치 행동 cohort의 D1·D7·D30 행동 retention
- campaign·소구점별 첫 가치 행동 전환율
- `광고비 / 첫 가치 행동 사용자 수`로 계산한 cost per activated user

### Retention 정의

단순 앱 실행을 retention으로 보지 않고, 첫 가치 행동 이후 다시 타임라인을 열람·완성하는 의미 있는 행동을 기준으로 본다. exact-day, rolling, unbounded retention 가운데 어떤 방식을 사용할지 분석 전에 고정해야 하며, 같은 보고서 안에서는 정의를 바꾸지 않는다.

멘토링에서 제시된 D1 40%, D7 20%, D30 10%는 당시의 참고 기준이다. 독립적으로 확인된 업계 benchmark나 절대 합격선으로 일반화하지 않는다.

### 소구점 A/B test 해석

Landing·Meta 실험은 우선 어떤 약속이 클릭과 베타 신청을 만드는지 검증한다. 실제 제품 가치까지 검증하려면 campaign 식별자를 앱 행동에 연결해야 한다.

- 상단 funnel: impression, CTR, landing 전환율, qualified beta 신청 비용
- 제품 funnel: permission 동의율, activation rate, cost per activated user
- 반복 가치: campaign cohort별 D1·D7·D30 행동 retention

CTR이 높더라도 activation과 retention이 낮으면 좋은 소구점으로 확정하지 않는다. A/B test에서는 audience, 기간, 예산, landing 구조를 가능한 한 동일하게 하고 한 번에 핵심 메시지 하나를 비교한다. 총 30만 원 규모라면 A와 B 두 소구점부터 비교해 표본의 과도한 분산을 피한다.

## 권장 Event 초안

| Event | 핵심 속성 예시 |
|---|---|
| `landing_view` | campaign, ad_set, creative, appeal |
| `beta_signup` | campaign, appeal, qualified 여부 |
| `signup_completed` | acquisition source, campaign |
| `permission_result` | permission type, accepted, request step |
| `timeline_generation_requested` | record date, source availability |
| `timeline_generation_completed` | success, latency, failure reason |
| `timeline_viewed` | first timeline 여부 |
| `timeline_edited` | edited field count, deleted event count, memo added |
| `timeline_completed` | first value 여부, elapsed time from signup |
| `timeline_returned` | days since activation, meaningful action type |

Event 명칭과 속성은 실제 Android·backend·GA4 schema에 맞춰 확정한다. 민감한 타임라인 본문이나 원본 생활 데이터는 analytics payload에 넣지 않는다.

## 실행 제안

1. 광고 전에 app event와 install referrer 연결을 준비한다.
2. target 조건을 정한 20~30명의 베타 사용자를 모집한다.
3. 각 funnel 단계의 전환과 이탈 이유를 행동 자료와 짧은 인터뷰로 함께 기록한다.
4. permission, 생성 실패·지연, 결과 품질, 수정 부담, 저장 UX를 먼저 개선한다.
5. Meta에서 A/B 두 소구점을 같은 조건으로 비교한다.
6. landing 지표와 activation·retention을 함께 보고 확대 여부를 결정한다.

## Caveats

- 이 문서는 멘토링 원문 녹취가 아니라 사용자가 전달한 요약을 바탕으로 작성됐다.
- 윤지환 멘토에게 귀속된 세부 문구와 다른 8월 7일 멘토링의 발언자는 원자료 확보 전까지 사용자 제공 정보로 취급한다.
- D1 40%, D7 20%, D30 10%는 당시 제시된 참고 수치이며 외부 benchmark로 검증되지 않았다.
- 20~30명 표본에서는 사용자 한 명이 비율에 미치는 영향이 크므로 정성 관찰과 분자·분모를 함께 제시한다.
- 실제 event schema, attribution 구현 가능 범위와 개인정보 처리 기준은 개발팀이 확인해야 한다.
