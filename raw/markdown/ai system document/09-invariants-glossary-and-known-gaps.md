---
title: AI 도메인 불변식·용어·알려진 한계
summary: Timeline과 User Memory에서 반드시 유지할 계약, 공통 용어, 현재 구현이 의도적으로 해결하지 않는 범위
tags: [invariants, glossary, constraints, known-gaps]
status: current
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# AI 도메인 불변식·용어·알려진 한계

## 입력과 source 불변식

- 한 Timeline task의 input response `taskId`는 접수 `taskId`와 같아야 한다.
- source는 한 건 이상이어야 하고 `rawId`는 batch 안에서 중복되지 않아야 한다.
- `rawId`는 source의 정식 식별자이며 현재 request에 있는 값만 Candidate, Fragment, event 근거가 될 수 있다.
- LLM이 잘못 붙인 `sourceType`은 `rawId`로 찾은 실제 입력 type으로 정정한다.
- 유효한 sourceRef가 하나도 없는 Candidate/event는 유지하지 않는다.
- 하나의 source가 여러 event의 근거로 사용되는 것은 허용한다.
- User Memory는 source가 아니며 `sourceRefs`에 넣지 않는다.

## 시간 불변식

- end는 start보다 빠를 수 없다.
- 접수 request의 window가 정본이다.
- window 완전 밖의 Candidate/event는 제외한다.
- window 경계에 걸친 구간은 clamp한다.
- 기상 경계를 알 때 수면 이전의 일반 event를 확정하지 않는다.
- 경계를 모르면 시간을 만들어내지 않는다.
- MEAL은 20~60분이다.
- 비캘린더 일반 event 3시간 초과는 warning으로 드러내되 코드가 임의 분할하지 않는다.
- Location-only event는 참조한 STAY/MOVEMENT 근거 시간을 벗어나지 않는다.

## 보존과 병합 불변식

- 유효한 Calendar item은 최종 Timeline에서 누락되지 않게 복원한다.
- Event Agent에 들어온 source가 Candidate 또는 Fragment로 보존됐는지 검사한다.
- Fragment만 근거로 남은 최종 event는 warning으로 드러낸다.
- 순수 STAY만 이동 없는 연속 체류 병합 대상이다.
- Calendar·Photo·Notification 의미를 긴 STAY에 무조건 흡수하지 않는다.
- Photo source는 최종 event 하나에만 귀속한다.
- 시간 겹침만으로 의미가 다른 사건을 임의로 자르거나 병합하지 않는다.

## 문장 불변식

- Timeline/Repair의 title과 description은 사용자가 읽는 일기다.
- 1인칭 해요체 과거형을 목표로 한다.
- title은 30자 이내 명사구다.
- description은 1~2문장, 100자 안팎을 목표로 한다.
- 120자 초과는 warning이다.
- 최종 문장에 `듯해요` 같은 추정 표현을 쓰지 않는다.
- 분 단위 시각과 걸음 수 같은 원본 수치를 최종 일기에 쓰지 않는다.
- 불확실성은 confidence, inferenceLevel, uncertainty로 표현한다.
- Event Agent의 사실 보고에는 최종 일기 문체 규칙을 적용하지 않는다.

## 질문 불변식

- `TimelineDraft.questions`는 내부 모호성 질문이다.
- `TimelineEventDraft.question`은 사용자 회고 유도 질문이다.
- 두 값은 목적과 저장 경계가 다르다.
- 회고 질문은 Repair 뒤 확정 event에 붙인다.
- 현재 실행 코드는 모든 event에 질문 하나를 시도한다.
- 1차에서 빠진 event만 한 번 재요청한다.
- event당 첫 유효 질문 하나만 적용한다.
- 질문은 물음표로 끝나고 255자 이하여야 한다.
- Question 실패와 누락은 Timeline 저장을 막지 않는다.

## User Memory 불변식

- User Memory는 사건 근거가 아니라 해석·표현 보조 context다.
- Timeline과 Question이 같은 projection을 사용한다.
- Event Agent와 Repair Agent에는 주입하지 않는다.
- 수집 원본과 충돌하면 원본이 우선한다.
- 갱신은 append가 아니라 전체 rewrite다.
- AI가 쓴 title/subtitle/question에서 사용자 성향을 뽑지 않는다.
- personality, values, preferences, emotionalPatterns, memoryStyle은 memo만 근거로 갱신한다.
- memo가 없는 batch에서 성향 필드를 유지하는 것은 정상 SUCCESS다.
- `schemaVersion`, `updatedAt`은 서버가 확정한다.
- 크기·민감정보 위반 문서를 코드가 잘라 저장하지 않는다.
- 실패하면 기존 User Memory를 유지한다.
- 모든 성공·실패 경로는 결과 저장 호출 정확히 한 번으로 수렴한다.
- User Memory FAILED는 DailyRecord 저장 실패가 아니다.

## 결과·상태·오류 불변식

- 저장 전 event는 title, 유효 start, 유효 시간 범위, 현재 task의 source를 하나 이상 가져야 한다.
- event가 0개여도 확정 결과로 result API에 보낼 수 있다.
- Timeline 결과 저장 성공 뒤에만 SUCCESS callback을 보낸다.
- 저장 성공 뒤 callback 실패가 결과를 FAILED로 바꾸지 않는다.
- User Memory task에는 callback이 없다.
- 같은 실패는 API, callback/result, operational event에서 같은 정수 error code를 쓴다.
- 외부 오류 문장은 catalog의 안전 메시지만 사용한다.
- App Server 401/404/409는 retry와 callback 없이 abort한다.

## 보안·관측 불변식

- `taskToken` 값은 모든 log와 Langfuse에서 금지한다.
- credential, presigned URL, notification 원문, User Memory 본문을 operational event에 넣지 않는다.
- 일반 diagnostic log는 자동으로 Elasticsearch에 수집되지 않는다.
- Elasticsearch 운영 이벤트는 action별 allowlist field만 사용한다.
- 관측 실패는 Timeline/User Memory 결과를 바꾸지 않는다.
- User Memory와 daily timeline은 본문 대신 개수·크기 summary로 관측한다.
- 단일 worker를 유지해 process-local inflight와 `/ping` 의미를 보존한다.

## 용어 사전

| 용어 | 이 프로젝트에서의 의미 |
|---|---|
| Timeline task | `taskId`로 연결되는 비동기 하루 Timeline 생성 작업. 상태는 App Server 소유 |
| Timeline trigger | `taskId`, 최초 `taskToken`, `dailyRecordId`, 정본 window를 전달하는 202 요청 |
| Timeline window | 생성 대상 시간 범위. 접수 request 값이 정본 |
| Collected snapshot | App Server input response를 내부 형태로 옮긴 하루 source 묶음 |
| Source item | STAY, MOVEMENT, CALENDAR, HEALTH, NOTIFICATION, PHOTO 원본 한 건 |
| `rawId` | source의 정식 UUID 식별자이자 근거 연결 key |
| Normalized request | source를 domain별 list로 분리한 `TimelineDraftRequest` |
| Event Agent | 한 source domain을 사실 중심으로 Candidate/Fragment로 해석하는 Agent |
| Candidate | event가 될 근거가 충분한 중간 산출물 |
| Fragment | 단독 event에는 약하지만 다른 source와 결합할 수 있는 보조 단서 |
| SourceRef | 어떤 `rawId`를 왜 근거로 사용했는지 나타내는 참조 |
| Timeline Agent | Candidate/Fragment를 실제 사건 단위로 의미 병합하는 Agent |
| Timeline draft | event, 내부 질문, warning, 판단 metadata를 가진 편집 가능한 내부 결과 |
| Timeline event | 사용자가 읽는 하루의 사건 단위 |
| `clientEventId` | draft 내부의 `event-NNN` ID. 병합·삭제 후 코드가 다시 부여하며 저장 결과에는 보내지 않음 |
| Repair Agent | 코드 확정과 제한된 LLM tool 개선을 결합하는 Agent |
| Confirm pass | `repair_draft`와 Fragment 검사를 실행해 불변식을 재적용하는 단계 |
| Guard | 특정 불변식을 검사·보정하거나 warning으로 드러내는 결정론 service |
| 내부 모호성 질문 | `TimelineDraft.questions`, 시간·장소 불확실성을 나타내는 내부 값 |
| 회고 유도 질문 | event의 `question`, 사용자가 경험·감정·이유를 기록하게 하는 질문 |
| Warning | 복구 가능한 누락·충돌·품질 문제. task 실패와 다름 |
| Confidence | Candidate/event의 확신도 0~1 |
| Inference level | DIRECT, EVIDENCE_BASED, INFERRED, UNCERTAIN 근거 수준 |
| User Memory | 사용자 압축 profile v1.0. 사건이 아닌 보조 context |
| Daily timeline | User Memory 갱신에 쓰는 하루치 확정 Timeline |
| `memo` | 사용자가 직접 쓴 event 글이며 성향 필드의 유일한 근거 |
| Rewrite | 기존 User Memory를 통째로 대체하는 새 전체 문서 |
| App Server | source, Timeline 결과, User Memory, task 상태의 외부 소유자 |
| TaskToken | 한 task의 서버간 인증 token holder. 값은 header로만 전송 |
| Callback | Timeline의 SUCCESS/FAILED terminal 상태 통보. 결과 body 저장과 다름 |
| 운영 이벤트 | Elasticsearch 집계를 위해 allowlist된 stdout JSON event |
| Langfuse trace | Agent tree, LLM generation, token·latency와 정책에 따른 본문 관측 |

## 현재 알려진 한계

### Task 실행과 복구

- FastAPI BackgroundTasks는 durable queue가 아니다.
- process 종료 후 실행 중 task를 다른 worker가 이어받지 않는다.
- AI 서버에는 task 상태 조회나 재처리 persistence가 없다.
- App Server의 idempotency와 DB transaction은 이 저장소에서 확인할 수 없다.

### Concurrency와 health

- inflight가 process-local이라 multi-worker/multi-replica busy를 합산하지 못한다.
- 20분 이상 작업은 EC2 idle wait를 넘겨 배포를 실패시킬 수 있다.
- drain이나 task migration이 없다.

### Timeline 품질

- 1인칭·해요체·문장 자연스러움은 코드가 의미적으로 완전 판정하지 못한다.
- 실제 provider 품질은 live LLM 평가 없이는 보장할 수 없다.
- `TimelineDraft.userId`는 내부 placeholder이며 result 계약에 보내지 않는다.
- 접수 window 역전이 endpoint에서 거절되지 않는 known gap이 있다.

### User Memory

- 소비 경로는 준비돼 있지만 App Server가 실제 input response에 profile을 채워 보내는지는 이 저장소만으로 확인할 수 없다.
- 1,000 token 요구를 1,200 serialized character로 구현한 것은 provider 독립성을 위한 프로젝트 규칙이며 표준이 아니다.
- 소비 측에는 별도 전체 token 상한이 없고 field별 길이와 customAttributes 개수만 schema가 강제한다.
- AI가 쓴 문장과 memo의 의미 구분은 prompt가 지키며 코드가 자연어 출처를 의미적으로 판정하지 않는다.

### 모델과 provider

- model availability, quota, 가격은 저장소 밖의 시점 의존 정보다.
- 실제 provider 간 품질·비용 비교 결과는 아직 평가 전이다.
- prompt가 GPT 기준으로 개선됐으므로 다른 모델에서 동일 품질을 가정할 수 없다.

### 배포

- 현재 EC2 workflow에는 unit/integration test gate가 없다.
- 별도 수동 승인 environment gate가 없다.
- AgentCore가 언제 기본 경로가 되는지 자동 cutover 기준은 아직 없다.
- AgentCore scale-in과 FastAPI background task 수명 보장은 별도 검증이 필요하다.

### 관측

- Elasticsearch index template, dashboard, retention은 저장소 밖에서 관리한다.
- Filebeat 실패가 앱 배포를 막지 않아 관측 공백이 생길 수 있다.
- Langfuse는 optional이고 sampling이 1 미만이면 모든 task trace가 존재하지 않는다.
- local stdout 보존과 접근 통제는 host 운영 설정에 의존한다.
- AgentCore 전환 후 Filebeat와 동등한 Elasticsearch 전달 경로가 아직 확정되지 않았다.

## 변경 검토 체크리스트

AI 관련 변경 전후에 다음을 확인한다.

- LLM이 선택하지 않아도 반드시 실행돼야 하는 규칙을 tool로만 옮기지 않았는가?
- User Memory를 새 Agent에 주입해 사건 근거로 오인하게 만들지 않는가?
- 질문이 Repair보다 앞서 생성되지 않는가?
- merge 뒤에 실행해야 할 Photo/Notification/길이 검사를 앞으로 옮기지 않았는가?
- 결과 저장과 callback 순서를 바꾸지 않았는가?
- User Memory 실패 경로에서 결과 저장 호출이 빠지지 않는가?
- 새 operational field에 사용자 본문이나 secret이 들어가지 않는가?
- 새 execution stage에 Langfuse generation name을 추가했는가?
- worker 수나 replica 변화가 `/ping` busy 의미를 깨뜨리지 않는가?
- 모델 비교에서 prompt version과 fixture를 동일하게 유지했는가?

