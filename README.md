# Laimory LLM Wiki

이 저장소는 Laimory 프로젝트와 관련 자료를 쌓아 가는 LLM Wiki vault입니다.

목표는 매번 원본 자료를 다시 뒤지는 것이 아니라, 원본은 보존하고 LLM이 유지하는 위키 레이어를 계속 갱신해서 지식이 누적되게 만드는 것입니다.

## 핵심 구조

이 vault는 세 층으로 나뉩니다.

| 위치                   | 역할                                                                            |
| -------------------- | ----------------------------------------------------------------------------- |
| `raw/`, `Clippings/` | 사람이 넣은 원본 자료. 가능한 한 수정하지 않고 추가합니다.                                            |
| `wiki/`              | LLM이 관리하는 지식 레이어. source page, topic, entity, answer 등을 둡니다. 이는 인간이 손대지 않습니다. |
| `references/`        | vault 운영 방식, 개념 설명, 스키마 해석 같은 참고 문서입니다.                                       |

중요한 control file은 다음과 같습니다.

| 파일          | 역할                                      |
| ----------- | --------------------------------------- |
| `AGENTS.md` | LLM이 이 vault를 어떻게 다뤄야 하는지 정의한 운영 규칙입니다. |
| `index.md`  | 현재 위키의 메인 카탈로그입니다. 먼저 여기서 찾습니다.         |
| `log.md`    | ingest, 유지보수, 주요 문서 수정 이력을 남기는 로그입니다.   |

## 기본 사용법

### 1. 질문할 때

질문은 그냥 자연어로 하면 됩니다.

예시:

```text
AI 하루 타임라인 생성 구조 설명해줘
```

LLM은 먼저 `index.md`를 보고, 관련 `wiki/` 페이지를 읽은 뒤 답합니다. 위키에 정보가 부족하거나 원문 확인이 필요하면 `raw/` 자료를 다시 확인합니다.

답이 나중에도 재사용될 만큼 중요하면 `wiki/answers/`에 durable answer로 저장할 수 있습니다.

### 2. 새 자료를 넣을 때

오직 아래 경로에만 새 자료를 넣습니다. 

| 자료 유형 | 넣는 위치 |
|---|---|
| 개인 메모, 설계 초안 | `raw/notes/` |
| Notion/Markdown export | `raw/markdown/` |
| GitHub repo 조사 자료 | `raw/github/` |
| 웹 페이지 캡처 | `raw/web/` 또는 `Clippings/` |
| 소셜 글/thread | `raw/social/` |
| PDF | `raw/pdf/` |

그 다음 LLM에게 이렇게 요청합니다.

```text
이 raw 자료 ingest 해줘
```

LLM은 보통 다음 순서로 작업합니다.

1. 원본 자료를 읽습니다.
2. `wiki/sources/`에 source page를 만들거나 갱신합니다.
3. 필요한 경우 `wiki/topics/`, `wiki/entities/`, `wiki/answers/`를 갱신합니다.
4. `index.md`를 업데이트합니다.
5. `log.md`에 짧은 이력을 남깁니다.

원칙은 간단합니다. source page를 먼저 만들고, 그 다음 synthesis page를 갱신합니다.

### 3. 위키를 유지보수할 때

이런 요청을 할 수 있습니다.

```text
vault lint 해줘
```

또는:

```text
빠진 링크나 index 누락 있는지 봐줘
```

LLM은 보통 다음을 확인합니다.

- `raw/`나 `Clippings/`에 있는데 아직 `wiki/sources/`가 없는 자료
- `wiki/`에는 있는데 `index.md`에 없는 페이지
- topic, entity, source 사이의 약한 링크
- 너무 얇은 페이지, 중복된 topic, 오래된 요약
- `log.md`에 남겨야 할 의미 있는 변경

## Wiki 페이지 종류

| 위치 | 언제 쓰나 |
|---|---|
| `wiki/sources/` | 원본 하나당 하나의 ingest page가 필요할 때 |
| `wiki/topics/` | 여러 source가 같은 주제나 패턴으로 모일 때 |
| `wiki/entities/` | 사람, 팀, 제품, 저장소, 라이브러리, 회사 등이 반복해서 등장할 때 |
| `wiki/answers/` | 다시 물어볼 가능성이 높은 답변을 저장할 때 |
| `wiki/domains/` | 여러 topic과 entity가 큰 관심 영역으로 묶일 만큼 커졌을 때 |

페이지는 얇게 많이 만들기보다, 먼저 source page를 튼튼하게 만들고 기존 topic/entity에 연결하는 편을 우선합니다.

## 작업할 때의 기본 마음가짐

이 vault는 채팅 기록을 쌓는 곳이 아니라, 점점 좋아지는 지식 구조를 만드는 곳입니다.

새 정보는 원본으로 보존하고, 위키에는 요약과 연결과 판단을 남깁니다. 질문에 답할 때는 위키를 먼저 보고, 부족하면 원본으로 돌아갑니다. 답변이 재사용될 가치가 있으면 다시 위키에 저장합니다.
