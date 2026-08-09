---
title: LLM Provider 구조와 모델 비교 계획
summary: OpenAI·Gemini·Bedrock 공통 facade, structured output와 vision 계약, Nova 2 Lite·Gemini 2.5 Flash·GPT 5.4 mini 평가 설계
tags: [llm, openai, gemini, bedrock, nova, benchmark, evaluation]
status: current-and-evaluation-plan
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# LLM Provider 구조와 모델 비교 계획

## 현재 상태와 평가 계획을 구분한다

현재까지 Timeline 품질, 문체, Repair, Question, User Memory prompt는 GPT를 기준으로 반복 개선됐다. 이것은 “모든 운영 환경에서 현재 GPT가 선택되어 있다”거나 “GPT가 최종 우승 모델이다”라는 뜻은 아니다.

런타임 모델은 환경변수로 선택한다.

- `LLM_PROVIDER=openai` + `OPENAI_MODEL`
- `LLM_PROVIDER=gemini` + `GEMINI_MODEL`
- `LLM_PROVIDER=bedrock` + `BEDROCK_MODEL`

Docker image 기본 provider는 `bedrock`이지만 EC2 `runtime.env`나 AgentCore environment variables가 덮어쓸 수 있다. 실제 운영 모델은 배포 환경 설정을 확인해야 한다.

향후 비교할 평가 대상은 프로젝트에서 다음처럼 정했다.

1. Amazon Nova 2 Lite
2. Gemini 2.5 Flash
3. GPT 5.4 mini

이 페이지는 모델별 최신 가격, context window, 공개 benchmark 수치를 단정하지 않는다. 그런 값은 시점과 region, API 상품에 따라 바뀌므로 실제 평가 시점의 공식 문서와 청구 데이터를 별도로 기록해야 한다.

## Provider 추상화

`LLMProvider`는 세 SDK의 차이를 공통 interface로 감싼다.

| 기능 | 공통 method | 용도 |
|---|---|---|
| text completion | `complete` | v1 자유 텍스트 infer 등 |
| vision | `complete_with_images` | Photo describer |
| JSON text | `complete_json` | tolerant item parsing |
| Pydantic output | `complete_structured` | Event Agent v2, RepairPlan, User Memory |

`LLMClient`는 provider facade다. 기본 모델을 쓰면 provider instance를 cache하고 특정 모델을 명시하면 별도 provider instance를 만든다.

### OpenAI

- API key 기반 client
- text와 image message 구성
- 가능한 경우 response format/JSON schema 사용
- usage metadata를 prompt/completion 및 세부 token bucket으로 변환

### Gemini

- API key 기반 client
- text와 inline image parts 구성
- response MIME type과 schema 기능 사용
- Gemini usage metadata를 공통 token 관측 구조로 변환

### Bedrock

- API key 필드가 없음
- boto3 credential chain 사용
- local에서는 선택적 AWS profile
- EC2에서는 instance role
- AgentCore에서는 execution role
- Converse API의 text/image content와 tool-based structured output 사용
- model ID 또는 cross-region inference profile ID를 설정 가능

Nova 2 Lite의 실제 호출은 서울 region credential과 global inference profile을 사용할 수 있도록 설계돼 있다. 모델 목록 조회 권한과 모델 호출 권한은 별개이므로 목록 API가 실패해도 지정 ID 호출이 반드시 불가능하다는 뜻은 아니다.

## 공통 계약을 유지해야 하는 이유

provider를 바꿔도 Agent 코드는 같은 입력과 Pydantic schema를 사용해야 한다. 특정 provider에서만 작동하는 prompt branch가 늘어나면 품질 차이와 adapter 차이를 구분하기 어려워진다.

공통 불변식:

- provider native schema가 있어도 Pydantic 최종 검증 수행
- text와 vision 모두 같은 execution context와 Langfuse generation 관측 사용
- SDK가 제공하지 않은 token 종류를 추측해 채우지 않음
- credential과 provider 원문 오류를 외부 response에 노출하지 않음
- provider/model/version/duration/token을 동일한 필드 의미로 관측
- 모델 교체로 User Memory 저장 상한이 달라지지 않게 문자 수 기준 유지

## 비교의 핵심 질문

단순히 한 번의 Timeline이 그럴듯해 보이는지로 모델을 고르면 안 된다. 이 시스템은 여러 Agent call과 Repair loop가 결합되어 있어 다음을 함께 봐야 한다.

1. source 사실을 얼마나 정확히 Candidate/Fragment로 보존하는가?
2. 여러 source를 같은 실제 사건으로 올바르게 병합하는가?
3. 존재하지 않는 rawId, 사람, 장소, 활동을 만들어내지 않는가?
4. 한국어 일기 문체와 길이 계약을 얼마나 지키는가?
5. structured output을 안정적으로 지키는가?
6. Repair가 필요한 문제를 정확히 찾고 최소 도구로 고치는가?
7. 모든 event에 중복되지 않는 회고 질문을 만드는가?
8. User Memory가 AI 문장에서 성향을 만드는 feedback loop를 피하는가?
9. latency와 token/cost가 background task 예산에 맞는가?
10. Photo vision과 metadata fallback 품질이 일관적인가?

## 공정한 실험 조건

### 반드시 고정할 것

- 같은 git commit
- 같은 `PROMPT_VERSION`
- 같은 input fixture와 request window
- 같은 User Memory 입력
- 같은 temperature와 structured repair 횟수
- 같은 Repair 반복 상한
- 같은 이미지 bytes
- 같은 region 및 네트워크 조건을 가능한 범위에서 유지
- 같은 평가 rubric과 evaluator

### 모델별로 달라지는 것

- provider/model environment variables
- provider SDK의 native schema 방식
- 실제 token accounting
- response latency와 retry/error
- 모델별 청구 비용

prompt를 모델마다 먼저 튜닝하면 “기본 호환성 비교”가 아니라 “모델별 최적화 결과 비교”가 된다. 1차는 동일 prompt zero/adaptation 비교, 2차는 각 모델에 허용된 최소 튜닝 비교로 나누는 것이 좋다.

## 평가 데이터셋 구성

평균적인 하루만 사용하면 guard와 실패 격리를 평가할 수 없다. 최소 다음 scenario를 포함한다.

### Location

- 연속 STAY와 MOVEMENT가 정상적으로 이어지는 날
- 같은 장소로 돌아오는 왕복
- source 공백이 긴 날
- 평균 속도가 비정상인 이동
- 같은 장소 label의 표기 차이
- 수면 이전 위치 source

### Calendar

- Calendar만 있고 참석 근거가 없는 일정
- STAY 장소와 Calendar 장소가 일치하는 일정
- Timeline Agent가 일정을 누락하도록 유도되는 복잡한 날
- 다른 사건과 시간이 겹치는 일정

### Photo

- 실제 image download 성공
- 다중 사진 grouping
- 간판·메뉴·영수증에서 장소 text를 읽는 사진
- 다운로드 실패 후 metadata fallback
- 같은 사진이 여러 event에 귀속될 위험

### Notification

- 메시지·결제·예약·교통 알림
- 미래 예약 알림
- token, 전화번호, 계좌·카드 형태가 섞인 원문
- 알림과 실제 행동을 혼동하기 쉬운 입력

### Sleep/Activity

- 명확한 수면·기상 구간
- 수면과 일반 event 겹침
- steps만 있는 날
- 기상 경계를 알 수 없는 날

### User Memory

- 기존 profile 없음
- memo가 하나도 없는 batch
- memo가 있는 여러 날
- AI title이 강한 성향을 암시하지만 memo는 없는 경우
- 크기 상한 초과 후보
- 민감정보가 섞인 memo
- 깨진 기존 profile

## 정량 지표

### 구조와 신뢰성

| 지표 | 계산 |
|---|---|
| structured first-pass success | 최초 응답이 Pydantic 검증을 통과한 비율 |
| structured repair rate | 공통 교정 retry가 필요했던 비율 |
| total structured failure | retry 후에도 실패한 비율 |
| hallucinated rawId rate | 입력에 없는 rawId reference 수 / 전체 reference 수 |
| invalid item skip rate | tolerant parse에서 제외된 item 수 / 전체 item 수 |
| empty fallback rate | Timeline이 빈 fallback으로 끝난 task 비율 |
| question coverage | 유효 질문이 붙은 event 수 / 최종 event 수 |
| repair tool success | 성공 tool call 수 / 전체 tool call 수 |
| redundant tool rate | 결과를 바꾸지 않은 불필요 tool call 비율 |
| max-iteration hit rate | Repair가 상한까지 도달한 task 비율 |

### 성능과 비용

- 전체 task latency p50/p95/p99
- Agent별 generation latency
- input/output token 합계와 Agent별 분포
- task당 LLM call 수
- provider retry/error rate
- task당 실제 청구 비용
- Photo vision 포함/제외 비용
- Timeline timeout과 User Memory timeout 비율

비용은 공개 가격표를 단순 token에 곱하는 것보다 실제 청구 또는 provider usage와 pricing snapshot을 함께 보존하는 편이 정확하다. cached/reasoning/image token처럼 모델별 과금 항목이 다를 수 있다.

## 정성 rubric

각 최종 Timeline을 1~5점으로 평가한다.

| 항목 | 1점 | 5점 |
|---|---|---|
| source 충실도 | 없는 사실·근거를 생성 | 모든 주장이 source와 연결 |
| 사건 분할 | 하루를 과도 병합/조각냄 | 사람이 기억하는 장면 단위 |
| 시간 정확성 | source/window와 모순 | source span과 자연스럽게 일치 |
| 장소 정확성 | 근거 없는 상호·주소 | source/vision 근거만 사용 |
| 일기 문체 | 센서 보고서·추정 표현 | 자연스러운 1인칭 해요체 과거형 |
| 정보 밀도 | 중복·장황·수치 나열 | 핵심 경험만 간결하게 전달 |
| 불확실성 처리 | 문장에 억지 hedge | 모르는 사실은 빼고 metadata 사용 |
| 회고 질문 | generic·사실 확인·유도 | event 고유 경험을 꺼내는 질문 |
| User Memory 안전성 | AI 문장으로 성향 단정 | memo와 반복 구조만 신중히 반영 |

가능하면 evaluator가 모델 이름을 모르는 blind review를 하고, source 원본과 최종 결과를 함께 본다. 모델이 만든 문장만 보고 평가하면 hallucination을 발견하기 어렵다.

## 실험 실행 단위

한 fixture를 모델당 한 번만 실행하면 stochastic variance를 알 수 없다. temperature가 낮아도 provider와 backend 변화가 있다. 중요한 fixture는 모델당 최소 여러 회 반복하고 다음 두 층을 분리한다.

1. Agent 단위: Event, Timeline, Repair plan, Question, User Memory
2. end-to-end task 단위: 최종 result, 전체 latency/token/cost

Agent 단위는 원인을 찾는 데 좋고 end-to-end는 실제 사용자 품질과 비용을 보여준다.

## 결과 기록 표

| 항목 | Nova 2 Lite | Gemini 2.5 Flash | GPT 5.4 mini |
|---|---:|---:|---:|
| 코드 commit |  |  |  |
| prompt version |  |  |  |
| test case 수 × 반복 |  |  |  |
| structured first-pass success |  |  |  |
| hallucinated rawId rate |  |  |  |
| question coverage |  |  |  |
| Timeline 품질 평균 |  |  |  |
| User Memory 품질 평균 |  |  |  |
| task latency p50/p95 |  |  |  |
| 평균 input/output token |  |  |  |
| 평균 task 비용 |  |  |  |
| timeout/error rate |  |  |  |
| 주요 실패 pattern |  |  |  |

## 선택 기준 제안

최저 비용이나 최고 평균 점수 하나만으로 결정하지 않는다. 먼저 hard gate를 통과시킨 뒤 가중치를 적용한다.

### Hard gate 예시

- source hallucination이 허용 기준 이하
- structured failure가 허용 기준 이하
- task timeout이 운영 예산 이하
- Notification/User Memory 민감정보 검사 회귀 없음
- Photo vision 또는 fallback이 제품 요구를 충족

### 가중 평가 예시

- source·사실 충실도 30%
- Timeline 자연스러움과 사건 분할 25%
- structured/운영 안정성 15%
- Question/User Memory 품질 15%
- latency 10%
- 비용 5%

실제 가중치는 제품 우선순위에 맞춰 확정한다. 기억 서비스에서는 작은 비용 절감보다 사용자의 하루를 잘못 쓰지 않는 것이 더 중요할 수 있다.

## Langfuse를 이용한 비교

Langfuse generation에는 provider, model, prompt version, duration, token이 기록된다. 동일 fixture 실행에 dataset/run label 또는 별도 metadata를 추가하면 Agent 단계별 비교가 가능하다.

주의할 점:

- content capture가 `NONE`이면 본문은 보이지 않지만 latency/token/error 비교는 가능
- 품질 평가에는 안전한 test fixture와 `SANITIZED` 환경을 사용
- production 사용자 원문을 모델 benchmark dataset으로 무단 재사용하지 않음
- 동일 taskId를 모델 간 재사용하면 session이 합쳐질 수 있어 run 식별자를 분리

## 주요 코드

- `app/core/config.py`
- `app/core/llm.py`
- `app/core/structured.py`
- `app/core/langfuse_tracing.py`
- `tests/core/test_structured_providers.py`
- `tests/core/test_bedrock_provider.py`
- `tests/integration/**`

