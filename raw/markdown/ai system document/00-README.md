---
title: Laimory AI·LLM 지식 위키
summary: Laimory의 Timeline 생성, 프롬프트, 결정론적 보정, User Memory, 모델 평가, 배포와 관측 구조를 설명하는 문서 모음의 시작 페이지
tags: [laimory, ai, llm, timeline, user-memory, deployment, observability]
status: current-and-roadmap
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# Laimory AI·LLM 지식 위키

## 이 문서 묶음의 목적

이 문서들은 Laimory AI 서버에서 지금까지 설계하고 구현한 AI 관련 작업을 한곳에서 이해하기 위한 지식 위키다. 단순한 디렉터리 설명이 아니라, 왜 이런 구조를 택했는지, LLM과 코드가 각각 무엇을 책임지는지, 장애가 어디에서 흡수되고 어디에서 작업 실패가 되는지, 배포와 관측이 어떻게 연결되는지를 설명한다.

문서는 저장소의 실행 코드, Pydantic 스키마, 테스트, Dockerfile, GitHub Actions workflow를 우선적인 근거로 작성했다. 코드보다 오래된 설명과 실행 코드가 충돌하는 경우에는 실행 코드를 따랐다.

## 기준과 상태 표기

- 코드 기준일: 2026-08-09
- 기준 commit: `c36799389ce449ad3b8500865476e1b7fb859a47`
- 기준 branch: `feat/#63`
- `현재`: 해당 기준 commit에서 실행 코드나 workflow로 확인되는 상태
- `계획`: 아직 현재 기본 경로는 아니지만 프로젝트가 앞으로 추진하려는 방향
- `평가 대상`: 비교 실험을 수행할 후보이며, 우승 모델이나 운영 모델로 확정됐다는 뜻은 아님

특히 배포와 모델에 관해서는 다음 세 가지를 혼동하지 않는다.

1. 현재 `dev` 자동 배포 대상은 EC2 단일 컨테이너다.
2. AgentCore 배포 workflow는 이미 존재하지만 현재는 수동 실행 경로다.
3. 향후에는 AgentCore를 기본 배포 경로로 사용하는 방향을 계획하고 있다.

모델도 마찬가지다. Docker image의 기본 provider, 실제 runtime 환경변수로 선택된 provider, 프롬프트와 품질 개선 작업의 기준 모델은 서로 다른 개념이다. 현재까지 프롬프트와 품질 작업은 GPT 기준으로 진행됐고, 향후 Amazon Nova 2 Lite, Gemini 2.5 Flash, GPT 5.4 mini를 동일 조건에서 비교할 예정이다.

## 문서 지도

| 문서 | 핵심 질문 |
|---|---|
| [01. AI 시스템 아키텍처](01-ai-system-architecture.md) | API 접수부터 결과 저장까지 전체 시스템은 어떻게 연결되는가? |
| [02. Timeline 그래프와 Agent](02-timeline-graph-and-agents.md) | Event, Timeline, Repair, Question Agent는 어떤 순서와 책임으로 동작하는가? |
| [03. 프롬프트 엔지니어링](03-prompt-engineering.md) | 프롬프트는 어떻게 버전 관리되고, context와 structured output은 어떻게 통제되는가? |
| [04. 결정론적 Repair와 도구](04-deterministic-repair-and-tools.md) | LLM 결과를 코드가 어떤 순서로 확정하고, Repair Agent는 어떤 도구로 개선하는가? |
| [05. User Memory](05-user-memory.md) | 사용자 프로필은 어떻게 소비되고, 어떻게 전체 rewrite로 갱신되는가? |
| [06. LLM provider와 모델 평가](06-llm-providers-and-model-evaluation.md) | 세 provider를 어떻게 추상화했고 세 후보 모델을 무엇으로 비교할 것인가? |
| [07. 배포와 runtime](07-deployment-and-runtime.md) | 현재 EC2 배포와 AgentCore 경로는 어떻게 다르며 전환 시 무엇을 지켜야 하는가? |
| [08. 관측성과 로그](08-observability.md) | Elasticsearch 운영 이벤트와 Langfuse trace는 각각 무엇을 관측하는가? |
| [09. 불변식·용어·한계](09-invariants-glossary-and-known-gaps.md) | 바꾸면 안 되는 핵심 계약과 현재 한계는 무엇인가? |

## 가장 중요한 설계 원칙

### LLM은 의미를 판단하고 코드는 셀 수 있는 것을 확정한다

Laimory의 핵심 설계는 모든 일을 LLM에 맡기지 않는 것이다. 어떤 source들이 같은 실제 사건인지, 어떤 문장이 사용자가 읽기 좋은 일기인지, 어떤 질문이 회고를 유도하는지는 의미 판단이라 LLM이 맡는다. 반면 source가 실제 입력에 존재하는지, 시간이 window 안인지, event가 시간순인지, ID가 유일한지, 문자열이 상한을 넘는지는 코드가 확정한다.

이 경계는 Repair에서도 유지된다. Repair Agent가 도구를 선택할 수 있지만 정렬, window 적용, 최종 ID 부여처럼 반드시 실행돼야 하는 규칙은 도구 선택에 맡기지 않고 매 반복의 확정 pass에서 항상 실행한다.

### 보조 context는 사건 근거가 아니다

User Memory는 사용자를 이해하고 표현을 조정하는 보조 context다. 오늘 사건이 실제로 일어났다는 근거는 source item과 `rawId`다. User Memory만으로 일정 참석, 장소, 이동 목적, 인물 관계를 확정할 수 없으며, 원본과 충돌하면 원본이 우선한다.

### AI 서버는 제품 상태를 소유하지 않는다

task 상태, source, Timeline 결과, User Memory의 영속 저장은 App Server가 소유한다. AI 서버는 비동기 작업을 실행하고 결과를 App Server API로 전달하지만 자체 DB나 task 조회 API를 두지 않는다. 프로세스에 남는 inflight counter나 provider cache는 운영 보조 상태일 뿐 제품의 정본이 아니다.

### 실패를 전부 같은 무게로 다루지 않는다

- Event Agent 실패: 빈 결과와 warning으로 흡수
- Timeline Agent 실패: 빈 draft와 HIGH warning으로 흡수
- Repair의 LLM 개선 실패: 마지막으로 확정된 draft 유지
- Question Agent 실패: 질문 없는 Timeline으로 저장 계속
- User Memory 갱신 실패: 기존 User Memory를 유지하고 FAILED 결과를 App Server에 통보
- 결과 저장 실패: App Server가 결과를 받지 못했으므로 task 실패

이 구분은 AI 부가 기능 하나의 실패가 사용자의 하루 기록 전체를 버리지 않게 하면서도, 실제 결과 전달 실패를 성공으로 오인하지 않게 한다.

## 위키 ingest 권장 방식

- Markdown 파일 하나를 page 하나로 ingest한다.
- YAML frontmatter의 `title`, `summary`, `tags`, `status`를 문서 metadata로 사용한다.
- 코드 블록과 Mermaid는 가능한 한 원문을 보존한다.
- chunk를 나눌 때는 H2 절을 기본 경계로 사용한다.
- `source_commit`과 `last_verified_at`을 함께 색인해 오래된 설명을 식별한다.
- 운영 계획과 현재 구현을 하나의 사실로 합치지 않는다. `현재`, `계획`, `평가 대상` 표기를 유지한다.

## 문서 갱신 기준

다음 변경이 생기면 관련 페이지를 다시 검증해야 한다.

- LangGraph 노드나 순서 변경
- Event Agent 추가·삭제 또는 source 담당 변경
- prompt version 추가 또는 활성 프롬프트의 의미 변화
- `repair_draft` 순서나 Repair 도구 카탈로그 변경
- User Memory 스키마, 근거 규칙, 크기 제한, 결과 통보 방식 변경
- provider 추가, 모델 설정 방식 또는 structured output 계약 변경
- EC2/AgentCore 기본 배포 대상, port, worker, health, rollback 방식 변경
- 운영 event action, allowlist, Filebeat 경로, Langfuse content policy 변경

