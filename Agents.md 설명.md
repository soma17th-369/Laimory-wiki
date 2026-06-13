# `AGENTS.md` 설명

## 이 파일은 무엇인가

`AGENTS.md`는 이 vault를 LLM Wiki 방식으로 운영하기 위한 schema 파일이다. Codex나 다른 LLM 에이전트가 이 저장소에서 어떤 폴더를 어떻게 다루고, 새 자료를 어떻게 ingest하고, 질문에 어떻게 답하고, 위키를 어떻게 유지해야 하는지 정의한다.

쉽게 말하면 `AGENTS.md`는 이 저장소의 운영 헌법이다.

## 핵심 역할

이 파일은 LLM에게 다음을 알려준다.

- 어떤 자료가 원본이고 어떤 자료가 LLM이 유지하는 위키인지
- 새 자료가 들어왔을 때 어떤 순서로 처리해야 하는지
- 언제 source page, topic page, entity page, answer page, domain page를 만들어야 하는지
- 질문에 답할 때 어떤 파일을 먼저 읽어야 하는지
- 불확실성, 모순, 소셜 출처, 검증 문제를 어떻게 다뤄야 하는지
- `index.md`와 `log.md`를 어떻게 유지해야 하는지

## 전체 구조

`AGENTS.md`는 이 vault를 세 층으로 나눈다.

### 1. Source layer

사람이 제공하거나 캡처한 원본 자료 계층이다.

대표 폴더는 다음과 같다.

- `Clippings/`
- `raw/pdf/`
- `raw/social/`
- `raw/web/`
- `raw/github/`
- `raw/markdown/`
- `raw/notes/`

이 계층의 핵심 규칙은 "원본은 원본으로 보존한다"이다. LLM은 이 파일들을 마음대로 고치지 않고, 읽어서 위키 계층에 정리한다.

### 2. Wiki layer

LLM이 유지하는 지식 계층이다.

주요 폴더는 다음과 같다.

- `wiki/sources/`: ingest한 원문마다 만드는 소스 페이지
- `wiki/topics/`: 여러 소스를 관통하는 주제 페이지
- `wiki/entities/`: 사람, 회사, 제품, 저장소, 라이브러리 등 엔티티 페이지
- `wiki/answers/`: 재사용할 가치가 있는 질문 답변
- `wiki/domains/`: 큰 관심 영역이나 장기 테마

여기서 중요한 규칙은 새 자료를 넣을 때 항상 `wiki/sources/` 페이지를 먼저 만든다는 것이다. 그 다음 topic, entity, answer, domain 페이지를 갱신한다.

### 3. Reference layer

운영 방식이나 개념적 배경을 담는 계층이다.

대표 폴더는 `references/`다. 여기는 외부 자료를 지식으로 흡수하는 곳이라기보다, 이 vault를 어떻게 운영할지 설명하는 문서를 두는 곳이다.

예를 들어 Karpathy LLM Wiki 설명, schema 설명, 운영 규칙, 소셜 캡처 상태 파일 등이 여기에 들어갈 수 있다.

## Ingest Workflow

`AGENTS.md`의 가장 중요한 부분 중 하나는 ingest 절차다.

새 자료가 들어오면 LLM은 다음 순서로 작업해야 한다.

1. 자료 유형과 원본 경로를 확인한다.
2. `Clippings/` 또는 `raw/`에서 원본을 직접 읽는다.
3. `wiki/sources/`에 소스 페이지를 만들거나 갱신한다.
4. 핵심 주장, 엔티티, 주제, 날짜, 링크를 추출한다.
5. 관련 `wiki/topics/`와 `wiki/entities/` 페이지를 갱신한다.
6. 큰 주제 클러스터에 기여한다면 `wiki/domains/`도 갱신한다.
7. `index.md`를 갱신한다.
8. `log.md`에 작업 기록을 남긴다.

이 순서 덕분에 위키가 원문에 근거를 둔 상태로 커진다.

## 소셜 출처 검증 규칙

`AGENTS.md`는 소셜 게시물을 특히 조심스럽게 다룬다.

소셜 포스트가 GitHub 저장소, 제품, 라이브러리, 회사, API, 벤치마크, 성능 수치 같은 구체적 주장을 담고 있으면, 그 포스트를 확정적 사실로 바로 취급하지 않는다.

원칙은 다음과 같다.

- 소셜 포스트는 claim source로 본다.
- 가능하면 공식 저장소, README, 문서, 논문, 벤더 페이지 같은 primary source를 확인한다.
- 확인된 내용과 확인되지 않은 내용을 분리한다.
- 검증 전에는 topic/entity 페이지에 넓은 결론으로 일반화하지 않는다.

이 규칙은 LLM Wiki가 소문이나 홍보성 주장을 사실처럼 누적하지 않도록 막아준다.

## Query Workflow

질문에 답할 때도 순서가 정해져 있다.

1. `index.md`를 먼저 읽는다.
2. 관련 `wiki/` 페이지를 읽는다.
3. 운영 맥락이 필요하면 `references/`를 참고한다.
4. 유지된 위키를 바탕으로 답을 합성한다.
5. 세부 검증이 필요하면 원본 자료로 돌아간다.
6. 답변이 재사용 가치가 있으면 `wiki/answers/`에 저장한다.
7. 새 durable artifact가 생기면 `index.md`와 `log.md`를 갱신한다.

즉 답변은 "기억에 의존한 즉흥 답변"이 아니라 "유지된 위키를 먼저 읽고 합성한 답변"이어야 한다.

## Page Creation Heuristics

`AGENTS.md`는 어떤 페이지를 언제 만들지 기준을 제공한다.

- 새 원문이 들어오면 source page
- 여러 소스가 같은 주제를 반복하면 topic page
- 사람, 회사, 제품, 저장소가 반복해서 등장하면 entity page
- 재사용 가치가 있는 질문 결과는 answer page
- 여러 topic/entity가 큰 관심 영역으로 묶이면 domain page

애매할 때는 얇은 새 페이지를 많이 만들기보다, source page를 충실히 만들고 기존 topic/entity를 갱신하라고 지시한다.

## Naming Convention

파일명은 안정적이고 설명적인 lowercase kebab-case를 사용한다.

예시는 다음과 같다.

```text
wiki/sources/YYYY-MM-DD-<source_type>-<slug>.md
wiki/topics/<topic-slug>.md
wiki/entities/<entity-slug>.md
wiki/answers/<answer-slug>.md
wiki/domains/<domain-slug>.md
```

이 규칙은 나중에 중복 페이지가 생기거나 링크가 깨지는 문제를 줄인다.

## Maintenance와 Lint

이 파일은 위키 유지보수 방식도 정의한다.

주기적으로 확인할 항목은 다음과 같다.

- 고아 페이지
- `index.md`에 빠진 페이지
- 약한 교차 링크
- 오래된 요약
- 중복 topic page
- 반복 등장하지만 아직 entity page가 없는 엔티티
- domain으로 승격하거나 나눠야 할 큰 주제

의미 있는 유지보수 작업은 `log.md`에 기록해야 한다.

## 이 파일이 중요한 이유

Karpathy의 LLM Wiki 패턴에서는 schema가 매우 중요하다. 같은 LLM이라도 명확한 schema가 없으면 일반 챗봇처럼 답변만 하고 끝날 수 있다. 반대로 `AGENTS.md` 같은 schema가 있으면 LLM은 이 저장소를 지식 베이스로 유지하는 관리자로 행동할 수 있다.

이 파일은 특히 다음 점에서 중요하다.

- 원본과 위키를 섞지 않게 한다.
- 새 자료 처리 순서를 고정한다.
- 근거 없는 합성을 줄인다.
- 소셜 출처의 불확실성을 보존한다.
- `index.md`와 `log.md`를 통해 위키가 커져도 탐색 가능하게 만든다.
- 사람이 직접 모든 정리를 하지 않아도 위키가 누적되게 한다.

## 한 줄 요약

`AGENTS.md`는 이 vault를 Karpathy식 LLM Wiki로 운영하기 위한 실제 작업 규칙이며, LLM에게 "어떻게 읽고, 쓰고, 검증하고, 유지보수할지" 알려주는 핵심 schema 파일이다.
