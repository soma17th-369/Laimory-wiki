# GBrain은 Karpathy의 LLM Wiki와 같은 구조인가?

## 결론

GBrain은 Karpathy의 LLM Wiki와 같은 문제의식에서 출발한 도구다. 둘 다 "LLM이 개인 지식 저장소를 읽고, 정리하고, 누적해서 더 똑똑한 기억으로 만든다"는 방향을 공유한다.

하지만 구조는 완전히 같지 않다. Karpathy의 LLM Wiki는 마크다운 파일, 원문 소스, 운영 지침을 중심으로 한 추상적인 패턴이다. 반면 GBrain은 그 패턴을 실제 제품 수준으로 확장한 구현체에 가깝다. 마크다운 파일을 그대로 쓰되, Postgres/PGLite 데이터베이스, 벡터 검색, 키워드 검색, 지식 그래프, MCP 서버, 에이전트 스킬, 백그라운드 동기화까지 포함한다.

짧게 말하면 다음과 같다.

- Karpathy LLM Wiki: LLM이 관리하는 파일 기반 위키 패턴
- GBrain: 파일 기반 위키를 DB와 검색 엔진, 지식 그래프, 에이전트 런타임으로 확장한 개인/팀용 brain layer

## Karpathy LLM Wiki와 닮은 점

GBrain은 Karpathy의 LLM Wiki와 다음 점에서 닮았다.

1. 지식은 일회성 답변이 아니라 누적되는 산출물이어야 한다.

   질문할 때마다 원문을 다시 뒤지는 대신, 이미 정리된 지식 저장소를 계속 갱신한다는 생각을 공유한다.

2. LLM은 단순 검색기가 아니라 지식 관리자다.

   LLM은 문서를 읽고, 요약하고, 관련 페이지를 연결하고, 오래된 내용과 모순을 점검한다.

3. 마크다운과 링크를 중요하게 본다.

   Karpathy의 LLM Wiki는 Obsidian 스타일의 마크다운 위키를 기본 이미지로 삼는다. GBrain도 마크다운 파일과 wikilink를 중요한 입력과 저장 형식으로 다룬다.

4. 사용자는 모든 문서를 직접 정리하지 않는다.

   사용자는 자료를 넣고 질문하고 방향을 잡는다. 반복적인 정리, 연결, 유지 관리 작업은 에이전트가 맡는다.

## 다른 점

가장 큰 차이는 Karpathy의 글이 "운영 패턴"이고, GBrain은 "실행 가능한 시스템"이라는 점이다.

| 구분 | Karpathy LLM Wiki | GBrain |
| --- | --- | --- |
| 성격 | 아이디어와 운영 패턴 | 오픈소스 도구와 런타임 |
| 저장 방식 | 주로 마크다운 파일 디렉터리 | 마크다운 brain repo + PGLite/Postgres DB |
| 검색 | `index.md`, 파일 검색, 선택적 검색 도구 | 벡터 검색 + 키워드 검색 + RRF + 그래프 탐색 + reranker |
| 링크 | LLM이 교차 참조 유지 | 페이지 쓰기 시 자동 링크/typed edge 추출 |
| 질의 응답 | LLM이 위키를 읽고 합성 | `gbrain search`, `gbrain think`, MCP 도구로 검색과 합성 제공 |
| 운영 | 사람이 LLM에게 작업 지시 | CLI, MCP 서버, 스킬팩, cron/autopilot |
| 규모 | 개인 위키 패턴에 가까움 | 개인 brain, 팀 brain, 회사 brain까지 지향 |

## GBrain의 핵심 개념

### 1. Brain repo

GBrain에서 지식의 원본은 일반 git 저장소 안의 마크다운 파일이다. README는 이를 "brain repo"라고 설명한다. 즉, 사용자의 지식은 특정 앱 안에만 갇히는 것이 아니라 파일로 남는다.

GBrain은 이 파일들을 데이터베이스에 동기화해서 검색, 임베딩, 링크 분석, 그래프 탐색에 사용한다. 파일은 사람이 읽고 편집할 수 있는 원본이고, DB는 에이전트가 빠르게 찾고 계산하기 위한 색인/실행 계층이다.

### 2. Brain과 source

GBrain은 지식을 두 축으로 나눈다.

- `brain`: 하나의 데이터베이스다. 개인 brain, 팀 brain, 회사 brain처럼 소유자나 접근 권한이 달라지는 경계다.
- `source`: 하나의 brain 안에 들어 있는 콘텐츠 저장소다. 예를 들어 `wiki`, `essays`, `project-notes`, `research` 같은 repo 단위가 source가 될 수 있다.

즉 한 개인 brain 안에 여러 source를 넣을 수 있고, 여러 팀 brain을 mount해서 필요할 때 명시적으로 조회할 수도 있다.

### 3. Page, chunk, embedding

마크다운 파일은 페이지로 들어가고, 긴 페이지는 검색을 위해 chunk로 나뉜다. 각 chunk에는 embedding이 붙을 수 있다. 이 구조 덕분에 GBrain은 의미적으로 비슷한 문서를 찾는 벡터 검색을 수행한다.

### 4. 키워드 검색과 벡터 검색의 결합

GBrain은 벡터 검색만 쓰지 않는다. 벡터 검색은 의미 유사도에는 강하지만 이름, 날짜, 고유명사, 코드 식별자처럼 정확한 문자열이 중요한 질의에서는 흔들릴 수 있다.

그래서 GBrain은 다음을 함께 사용한다.

- pgvector HNSW 기반 벡터 검색
- Postgres `tsvector`/BM25 계열 키워드 검색
- Reciprocal Rank Fusion(RRF)을 통한 결과 결합
- source별 ranking boost
- 선택적 query expansion
- reranker

이 구조는 "관련 문서 목록"을 더 잘 찾기 위한 검색 계층이다.

### 5. Self-wiring knowledge graph

GBrain의 중요한 차별점은 자동으로 지식 그래프를 만든다는 것이다. 페이지가 저장될 때 마크다운 링크, Obsidian wikilink, typed link를 읽고 엔티티 간 edge를 만든다.

예를 들어 다음 같은 관계를 만들 수 있다.

- `attended`
- `works_at`
- `invested_in`
- `founded`
- `advises`
- `mentions`

이 그래프 덕분에 단순히 "비슷한 문서"를 찾는 것을 넘어, "A가 투자한 회사", "B가 일하는 조직", "이번 분기에 만난 사람"처럼 관계를 따라가는 질문에 답할 수 있다.

### 6. Synthesis layer

GBrain은 검색 결과만 보여주는 것을 목표로 하지 않는다. README에서 강조하는 차이는 "search gives you raw pages, GBrain gives you the answer"이다.

즉 `gbrain search`는 관련 페이지를 찾아주고, `gbrain think`는 검색 결과를 읽어 출처가 달린 종합 답변을 만든다. 여기에 "무엇을 아직 모르는지", "어떤 정보가 오래되었는지", "어디에 공백이 있는지" 같은 gap analysis를 포함하는 것이 특징이다.

### 7. Skills와 MCP

GBrain은 AI 에이전트가 직접 사용할 수 있도록 MCP 서버를 제공한다. Claude Code, Codex, Cursor 같은 도구에서 GBrain을 메모리 계층처럼 붙일 수 있다.

또한 설치 시 여러 agent skill을 제공한다. GeekNews 요약 기준으로 ingest, query, maintain, enrich, briefing, migrate, install 같은 작업 흐름이 포함된다. README 기준으로는 더 넓게 signal capture, ingestion, enrichment, querying, citation fixing, cron scheduling, migration 같은 스킬을 제공한다.

## GBrain의 동작 루프

GBrain README는 전체 흐름을 다음처럼 설명한다.

```text
signal -> search -> respond -> write -> auto-link -> sync
```

이를 풀어 쓰면 다음과 같다.

1. Signal

   에이전트가 사용자의 메시지, 회의, 메모, 링크, 이름, 할 일 같은 신호를 포착한다.

2. Search

   답하기 전에 먼저 brain을 조회한다. 외부 웹이나 일반 LLM 기억보다 사용자의 개인 지식 저장소를 우선한다.

3. Respond

   검색 결과와 그래프 관계를 바탕으로 답변을 만든다. 단순 문서 목록이 아니라 출처가 달린 종합 답변을 지향한다.

4. Write

   새로 알게 된 내용이나 저장할 가치가 있는 답변을 페이지로 쓴다. 캡처한 생각, 회의 메모, 문서 요약 등이 brain repo에 들어간다.

5. Auto-link

   새 페이지 안의 링크와 엔티티 참조를 분석해 backlink와 typed edge를 만든다.

6. Sync

   git repo와 DB를 동기화하고, 필요하면 백그라운드 작업으로 citation 보정, 중복 정리, 모순 탐지, enrichment를 수행한다.

## 어떻게 사용하나

### 1. 설치

GBrain은 agent가 설치해주는 흐름을 권장한다. README 기준으로 OpenClaw, Hermes, Claude Code, Codex 같은 에이전트에게 설치 문서를 읽고 실행하라고 지시하는 방식이다.

CLI로 직접 설치하는 기본 흐름은 다음과 같다.

```bash
bun install -g github:garrytan/gbrain
gbrain init --pglite
gbrain doctor
```

`--pglite`는 로컬에서 바로 쓸 수 있는 PGLite 기반 brain을 만든다. 더 큰 팀/회사 규모에서는 Postgres나 Supabase 구성을 사용할 수 있다.

### 2. 기존 마크다운 가져오기

이미 Obsidian vault나 일반 마크다운 폴더가 있다면 import할 수 있다.

```bash
gbrain import ~/notes/
```

이렇게 하면 마크다운 파일이 brain repo/source로 들어가고, GBrain이 페이지, chunk, embedding, 링크 정보를 구성한다.

### 3. 새 지식 캡처하기

짧은 생각이나 파일을 바로 넣을 수 있다.

```bash
gbrain capture "나중에 기억하고 싶은 생각"
gbrain capture --file ./notes/today.md
```

stdin이나 webhook, 모바일 inbox 폴더를 통한 capture도 지원한다. 이 점은 단순 노트 앱보다 "에이전트가 계속 먹이를 받는 기억 계층"에 가깝다.

### 4. 검색하기

관련 페이지 목록이 필요할 때는 `search`를 쓴다.

```bash
gbrain search "내 노트에서 반복해서 등장하는 주제는?"
```

이 명령은 벡터 검색, 키워드 검색, RRF, 그래프 신호 등을 사용해 관련 페이지를 찾아준다. LLM 합성이 필요 없는 빠른 조회에 적합하다.

### 5. 종합 답변 받기

페이지 목록이 아니라 답변이 필요하면 `think`를 쓴다.

```bash
gbrain think "다음 미팅 전에 Alice에 대해 알아야 할 것은?"
```

`think`는 검색 결과를 바탕으로 출처가 달린 답변을 만들고, 오래된 정보나 비어 있는 정보도 함께 알려주는 것을 목표로 한다.

### 6. Codex나 Claude Code에 연결하기

로컬 brain을 MCP로 연결하면 코딩 에이전트가 GBrain을 기억 계층처럼 사용할 수 있다.

```bash
gbrain init --pglite
codex mcp add gbrain -- gbrain serve
```

Claude Code라면 다음 형태다.

```bash
claude mcp add gbrain -- gbrain serve
```

원격 brain 서버가 있다면 `gbrain connect`로 연결한다.

```bash
gbrain connect https://your-host/mcp --token gbrain_xxx --agent codex --install
```

### 7. 스키마 조정하기

GBrain은 고정된 폴더 구조 하나만 강요하지 않는다. schema pack을 통해 brain의 모양을 정한다.

기본 schema pack에는 `person`, `company`, `media`, `tweet`, `analysis`, `concept`, `source`, `deal`, `email`, `slack`, `writing`, `project`, `note` 같은 타입이 포함된다. 필요하면 사용자의 실제 파일 구조를 감지하고, LLM의 도움을 받아 새 schema를 제안받을 수도 있다.

```bash
gbrain schema active
gbrain schema list
gbrain schema detect
gbrain schema suggest
gbrain schema review-candidates
gbrain schema use my-pack
```

## Karpathy LLM Wiki 관점에서 본 GBrain

Karpathy LLM Wiki를 세 층으로 보면 다음과 같다.

```text
Raw sources -> Wiki -> Schema
```

GBrain으로 바꾸면 대략 이렇게 확장된다.

```text
Brain repo / sources
  -> GBrain DB(PGLite/Postgres)
  -> Hybrid retrieval + knowledge graph
  -> MCP tools / CLI / agent skills
  -> synthesized answers + maintained pages
```

즉 GBrain은 Karpathy의 `index.md`와 `log.md` 중심 수동 운영을 더 자동화한다. 대신 단순함은 줄어든다. 로컬 파일 몇 개와 LLM만으로 시작하는 LLM Wiki보다, GBrain은 설치, DB, 임베딩, MCP, 스키마, 동기화라는 운영 요소가 더 많다.

## 언제 GBrain이 더 잘 맞나

다음 경우에는 GBrain이 Karpathy식 단순 LLM Wiki보다 잘 맞는다.

- 이미 마크다운 노트가 많고 검색 품질이 중요하다.
- 사람, 회사, 프로젝트, 미팅, 투자, 할 일처럼 관계형 질문이 많다.
- Claude Code나 Codex 같은 에이전트가 항상 개인 기억을 조회하게 만들고 싶다.
- 개인 지식뿐 아니라 팀/회사 지식 저장소로 확장하고 싶다.
- 단순 문서 검색이 아니라 출처 달린 종합 답변과 gap analysis가 필요하다.
- 백그라운드 enrichment, citation 보정, 모순 탐지 같은 유지 관리 자동화를 원한다.

## 언제 단순 LLM Wiki가 더 낫나

다음 경우에는 Karpathy의 원래 LLM Wiki 방식이 더 가볍고 적합하다.

- 아직 자료가 적다.
- Obsidian과 마크다운 파일만으로 시작하고 싶다.
- DB, 임베딩, MCP 서버를 운영하고 싶지 않다.
- 위키 구조를 직접 보면서 LLM과 천천히 발전시키고 싶다.
- 지식 저장소가 개인 실험 단계라 검색 인프라보다 단순함이 중요하다.

## 요약

GBrain은 Karpathy의 LLM Wiki와 "LLM이 지속적인 지식 저장소를 관리한다"는 철학을 공유한다. 그러나 구현 구조는 훨씬 더 공학적이다. 파일 기반 위키에 데이터베이스, 하이브리드 검색, 지식 그래프, MCP, 스킬팩, 백그라운드 작업을 붙여서 에이전트가 실제로 사용할 수 있는 brain layer를 만든다.

따라서 둘은 같은 계열이지만 같은 구조는 아니다. Karpathy LLM Wiki가 설계 철학과 최소 패턴이라면, GBrain은 그 철학을 개인/팀용 운영 시스템으로 확장한 도구라고 보는 것이 가장 정확하다.

## 참고 자료

- [GBrain GitHub repository](https://github.com/garrytan/gbrain)
- [GBrain README](https://raw.githubusercontent.com/garrytan/gbrain/master/README.md)
- [GBrain architecture: Brains and Sources](https://raw.githubusercontent.com/garrytan/gbrain/master/docs/architecture/brains-and-sources.md)
- [GBrain architecture: Retrieval](https://raw.githubusercontent.com/garrytan/gbrain/master/docs/architecture/RETRIEVAL.md)
- [GBrain install guide](https://raw.githubusercontent.com/garrytan/gbrain/master/docs/INSTALL.md)
- [GeekNews: GBrain — 오픈소스 개인 지식 베이스](https://news.hada.io/topic?id=28323)
