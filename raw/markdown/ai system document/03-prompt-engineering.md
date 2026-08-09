---
title: 프롬프트 엔지니어링과 Structured Output
summary: 전역 prompt version, Agent별 prompt 역할, context projection, provider 공통 structured output와 tolerant parsing 전략
tags: [prompt, prompt-version, structured-output, pydantic, context-engineering]
status: current
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# 프롬프트 엔지니어링과 Structured Output

## 프롬프트를 하나로 보지 않는 이유

Laimory는 하나의 거대한 prompt로 모든 source를 해석하지 않는다. 역할별 prompt를 나눠 서로 다른 책임과 신뢰 경계를 명확히 한다.

| Prompt | 의미 판단 |
|---|---|
| Location | 체류·이동·여정·공백 해석 |
| Calendar | 일정 의미와 참석 불확실성 |
| Photo describer | 실제 이미지 또는 metadata의 사실 설명 |
| Photo Event | 사진 grouping과 사건 후보화 |
| Sleep/Activity | 수면·기상·활동 사실 해석 |
| Notification | 알림 category와 안전한 사건 단서 추출 |
| Timeline | 여러 source를 실제 사건 단위로 병합하고 일기 문장 작성 |
| Repair | 확정 draft와 근거 원본을 대조해 도구 계획 생성 |
| Question | 확정 event마다 회고 유도 질문 작성 |
| User Memory | 기존 profile과 확정 기록을 최신 profile 전체로 rewrite |

이 분리는 prompt가 길어지는 것을 막는 것보다 더 중요한 의미가 있다. Event Agent는 source 사실을 정확히 보고해야 하고 Timeline은 사용자가 읽을 문장을 써야 한다. 두 계층의 문체 규칙을 섞으면 Event Agent가 정확한 수치를 숨기거나, Timeline이 센서 보고서처럼 딱딱한 문장을 쓰게 된다.

## 전역 `PROMPT_VERSION`

모든 Agent는 설정의 `PROMPT_VERSION`을 공유한다. 현재 허용 값은 `v1`, `v2`다. prompt loader는 Agent module 옆의 `prompts/{version}/{정확한 파일명}`만 UTF-8로 읽는다.

중요한 규칙은 다음과 같다.

- 일부 Agent만 다른 version을 쓰지 않는다.
- 파일이 없다고 v1이나 다른 version으로 fallback하지 않는다.
- version과 filename에 nested path를 허용하지 않는다.
- version 세트는 기동 시 실제 사용하는 모든 prompt 파일을 갖춰야 한다.
- 큰 의미 변경 전에는 같은 디렉터리에 suffix가 붙은 동결본을 둘 수 있다.
- loader는 정확한 활성 filename만 읽으므로 동결본은 실행에 영향을 주지 않는다.

### v1과 v2의 실행 구조 차이

Prompt version은 문장 파일만 바꾸지 않고 일부 Agent의 graph도 바꾼다.

| Agent | v1 | v2 |
|---|---|---|
| Location | 자유 텍스트 infer → structured review, LLM 2회 | 단일 structured infer, LLM 1회 |
| Sleep/Activity | 자유 텍스트 infer → structured review, LLM 2회 | 단일 structured infer, LLM 1회 |
| 나머지 Agent | version별 system prompt | 기본 실행 형태는 동일 |

v2에서 review를 제거한 이유는 Location의 상위 여정 복원과 공백 추론처럼 더 적극적인 의미 판단을 하려는 방향과 “과한 추론 억제” review의 목적이 충돌했기 때문이다. 대신 structured output과 source/window guard, Repair가 후단 방어를 맡는다.

`PROMPT_VERSION=v1`로 롤백하면 prompt 내용뿐 아니라 2단계 호출 구조까지 돌아가야 한다. 테스트가 LLM 호출 횟수와 review prompt 사용을 고정한다.

## System prompt와 user prompt 분리

System prompt에는 역할, 입력 의미, 품질 기준, 금지 규칙, 출력 계약을 둔다. User prompt에는 task마다 달라지는 실제 입력과 metadata를 둔다.

예를 들어 Timeline user prompt는 다음 블록으로 조립된다.

```text
[draft metadata]
date, timezone, windowStart, windowEnd

[user memory]
빈 필드와 metadata를 제거한 profile projection

[AI Event candidates]
source별 Event Agent의 candidate 목록

[Source fragments]
보조 단서 목록

병합·충돌·정렬에 관한 요청 문장
```

Repair user prompt는 확정 draft, 축약된 source index, 사용 가능한 tool catalog, 지금까지의 tool log, 남은 반복 횟수를 담는다. 자세한 원본은 모두 prompt에 넣지 않고 필요할 때 `lookup_source(rawId)`로 조회하게 한다.

Question user prompt는 확정 event의 최소 projection만 담는다. User Memory는 무엇을 물을지 결정하는 사건 근거가 아니라 질문의 결을 조정하는 자료다.

User Memory update prompt는 existing profile, daily timeline digest, 직전 출력의 위반 목록을 담는다. 위반 목록은 값 자체를 인용하지 않고 어느 필드가 어떤 규칙을 어겼는지만 설명한다.

## Context engineering: 주는 정보와 일부러 빼는 정보

좋은 prompt는 지시를 많이 쓰는 것만이 아니라 모델이 볼 필요가 없는 정보를 제거한다.

### Event Agent

- 자기 담당 source만 본다.
- User Memory를 받지 않는다.
- 정확한 시각과 수치를 사실 보고에 사용할 수 있다.

다섯 병렬 Event Agent가 같은 User Memory를 읽으면 하나의 profile 문장이 서로 독립된 다섯 근거처럼 반복될 수 있다. Timeline이 이를 합치면서 “여러 source가 동의했다”고 잘못 판단할 위험이 있어 주입하지 않는다.

### Timeline Agent

- Candidate와 Fragment 전체를 본다.
- request window와 date/timezone을 본다.
- User Memory의 공용 projection을 본다.
- User Memory만으로 사건을 확정하지 않는다는 명시적 경계를 가진다.

### Repair Agent

- User Memory를 받지 않는다.
- 이미 User Memory를 참고해 작성된 draft와 실제 source를 대조한다.
- source index는 축약본으로 보고 상세 원본은 도구로 조회한다.

Repair 반복마다 profile까지 다시 주면 오늘 source가 아니라 profile을 이용해 draft를 고치는 방향으로 drift할 수 있다.

### Question Agent

- `clientEventId`, event type, title, 시 단위 시간대, 선택적 description/place만 본다.
- confidence, inference level, uncertainty, sourceRefs는 보지 않는다.
- 분 단위 시각을 보지 않는다.
- Timeline과 같은 User Memory projection을 본다.

내부 정확도나 source 정보가 질문 문장에 새지 않게 “쓰지 말라”고만 하지 않고 입력에서 없앤다.

### User Memory Agent

- AI가 쓴 `title`, `subtitle`, `question`과 사용자가 쓴 `memo`의 출처 차이를 명시적으로 본다.
- 성향 계열 필드는 `memo`만 근거로 사용한다.
- `schemaVersion`, `updatedAt`은 출력하지 않는다.

## 최종 Timeline 문체 계약

Timeline과 Repair prompt는 사용자에게 보이는 title/description을 다음 방향으로 만든다.

- 1인칭 해요체 과거형 일기
- title은 30자 이내 명사구
- description은 1~2문장, 100자 안팎 목표
- 120자 초과는 코드 warning
- `듯해요`, `가능성이 있어요` 같은 hedge를 문장에 쓰지 않음
- 분 단위 시각, 걸음 수 같은 원본 수치를 최종 문장에 쓰지 않음
- 모르는 것은 문장에서 빼고 confidence/inferenceLevel/uncertainty로 표현
- 서로 다른 사건을 하루 전체 체류 하나로 과도하게 합치지 않음

문체 의미 자체는 코드가 완전히 판정할 수 없다. 코드는 길이와 형식 같은 일부 속성만 검사하고 1인칭·해요체·자연스러움은 prompt와 live 평가에 의존한다.

## Provider 공통 Structured Output

LLM facade는 두 가지 JSON 경로를 제공한다.

### `complete_json`

provider가 JSON 형태를 생성하도록 요청하지만 최종 item 검증은 호출자가 맡는다. Timeline과 Question처럼 한 항목이 깨져도 나머지를 살려야 하는 tolerant parse에 적합하다.

### `complete_structured`

공통 `run_structured` 경로에서 Pydantic model을 검증한다. 기본적으로 한 번의 교정 retry가 있다.

1. provider native schema/tool/response schema 기능을 가능한 범위에서 사용한다.
2. 응답의 첫 `{`부터 마지막 `}`까지 JSON object를 추출한다.
3. Pydantic으로 필드와 교차 규칙을 검증한다.
4. 실패 내용을 원래 prompt에 붙여 교정 요청한다.
5. 모두 실패하면 `StructuredOutputError(1202)`를 발생시킨다.

provider native schema가 있어도 Pydantic 검증을 생략하지 않는다. 자유형 object 때문에 strict JSON schema로 변환할 수 없으면 일반 JSON mode와 schema hint로 내려가지만 최종 계약은 동일하다.

## Tolerant parsing이 필요한 곳

Timeline LLM 응답에서 event 하나가 잘못됐다고 하루 전체를 버리면 불필요한 손실이 크다. 따라서 최상위 JSON object 자체를 읽을 수 없는 경우만 전체 fallback으로 보내고, 개별 event/question/warning 오류는 항목 단위로 제외한다.

Question도 동일하다. 질문 한 건의 schema 오류는 다른 질문을 살린다. 이후 코드가 ID, 중복, 물음표 종료, 길이를 다시 검사한다.

Repair plan은 다르게 취급한다. 도구 호출 계획을 반쯤 읽어 반쯤 적용하면 draft가 예측 불가능하게 바뀌므로 plan 전체가 `RepairPlan`을 통과해야 한다. 실패하면 이번 개선을 포기하고 마지막 확정 draft를 유지한다.

## Prompt injection과 비신뢰 문자열

사용자 memo, notification text, Calendar title, User Memory 문장에는 지시문처럼 보이는 문자열이 있을 수 있다. Prompt는 이를 데이터로만 해석하고 지시로 따르지 않도록 명시한다.

결정론 코드는 자연어의 의미에 의존해 권한을 확장하지 않는다. 예를 들어 User Memory custom key가 무엇이든 새로운 source나 tool 권한이 생기지 않고, Repair가 호출할 수 있는 도구는 코드에 등록된 고정 catalog뿐이다.

## Prompt 품질 검증

기본 테스트는 다음을 검증한다.

- version별 필수 파일 존재
- loader가 정확한 version과 filename만 읽는지
- v1/v2 graph 호출 횟수
- system prompt의 핵심 금지·출력 계약 문구
- FakeLLM 응답의 Pydantic parsing과 fallback
- provider별 structured output adapter

실제 자연어 품질은 live LLM test와 Langfuse trace 검토가 필요하다. prompt 비교 시에는 provider, model, prompt version, 입력 fixture, temperature를 함께 고정해야 한다.

## 주요 코드와 prompt 위치

- `app/agents/prompt_loader.py`
- `app/core/structured.py`
- `app/core/llm.py`
- `app/agents/**/prompts/v1/**`
- `app/agents/**/prompts/v2/**`
- `tests/agents/test_prompt_sets.py`
- `tests/agents/test_prompt_version_graph.py`
- `tests/core/test_structured.py`

