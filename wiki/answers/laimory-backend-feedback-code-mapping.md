---
title: Laimory Backend Feedback Code Mapping
kind: answer
status: active
updated: 2026-06-21
tags: [laimory, backend, timeline, implementation, feedback]
---

# Laimory Backend Feedback Code Mapping

이 문서는 멘토 피드백과 이후 설계 리뷰에서 나온 항목들이 Laimory 서버 코드에 어떤 형태로 반영되는지 정리한다.

기준 문서:

- `../server/docs/backend-change-spec.md`
- `../server/plan.md`

주의: 이 문서는 구현 완료 보고서가 아니라, 확정된 구현 계획 기준의 코드 반영 설명이다. 실제 PR 적용 후 파일명이나 메서드명은 테스트와 리팩터링 과정에서 조금 달라질 수 있다.

## 전체 방향

이번 변경의 핵심은 timeline draft 생성 흐름을 더 복구 가능하고 추적 가능한 구조로 바꾸는 것이다.

기존 구조는 AI 콜백이 성공해야만 정제된 timeline 데이터가 남고, 실패하거나 AI 서버가 죽으면 요청 당시의 원본 source item을 복구하기 어려웠다. 변경 후에는 source item을 먼저 MySQL에 저장하고, AI 서버는 `taskId`를 통해 DB에서 source item을 읽는다. Redis는 task 상태 관리에 집중하고, MySQL은 원본 보존에 집중한다.

또한 payload JSON 내부에 있던 `itemType`을 DB 컬럼으로 승격하고, JPA auditing과 명시적 PK/FK 네이밍을 적용해 데이터 모델의 추적성과 가독성을 높인다.

## 피드백별 코드 반영

| 피드백 | 코드 반영 방식 | 주요 파일/객체 |
|---|---|---|
| `created_at`, `updated_at`, `modified_by_type`이 필요하다 | 공통 `BaseEntity`를 만들고 JPA Auditing으로 생성/수정 시각과 수정 주체 종류를 자동 기록한다. | `common/BaseEntity`, `common/ModifiedByType`, `config/JpaAuditingConfig` |
| Base entity와 JPA를 잘 활용하라 | `@MappedSuperclass`, `@CreatedDate`, `@LastModifiedDate`, `@LastModifiedBy`, `AuditorAware`를 사용한다. 도메인 엔티티는 `BaseEntity`를 상속한다. | `DailyRecord`, `TimelineEvent`, `TimelineItem`, `TimelineDraftSourceItem` |
| 수정 주체가 사용자인지 운영인지 구분해야 한다 | 사용자 ID가 아니라 actor 종류를 저장하는 `modified_by_type`을 둔다. 현재 MVP는 인증이 없으므로 `AuditorAware`가 항상 `OPERATION`을 반환한다. | `ModifiedByType.USER`, `ModifiedByType.OPERATION` |
| AI 서버가 죽으면 데이터를 살릴 수 없다 | AI 요청 전 source item을 MySQL에 저장한다. AI 서버에는 source item 전체를 보내지 않고 `taskId`만 전달한다. | `timeline_draft_source_items`, `TimelineDraftSourceItem` |
| 정제 전 데이터를 저장해야 한다 | POST `/timeline/drafts` 시점에 `timeline_draft_source_items`에 source item을 저장하고 커밋한다. AI 결과 callback이 성공하면 최종 timeline을 저장하고 draft source row를 삭제한다. | `TimelineDraftTaskService`, `TimelineDraftSourceItemService`, `TimelineCallbackService` |
| Redis도 괜찮지만 MySQL을 쓰고 싶다 | Redis는 task 상태만 저장한다. source 원본은 MySQL에 저장한다. | Redis `TimelineDraftTask`, MySQL `timeline_draft_source_items` |
| evaluation용 데이터도 따로 필요하다 | R1에서는 app MySQL에 evaluation table을 만들지 않는다. evaluation sample은 외부 저장소로 분리하는 방향으로 둔다. | R1 out of scope |
| 지금은 너무 정제된 데이터만 담는다 | 최종 timeline 데이터와 별도로, AI 정제 전 source item JSON을 `timeline_draft_source_items.payload`에 보관한다. | `payload JSON`, `item_type`, `summary`, `record_timezone` |
| 요청 실패를 다루지 않는다 | task 상태를 `PROCESSING`, `SUCCESS`, `FAILED`로 관리하고, callback 실패/검증 실패/dispatch 실패를 `FAILED`로 남긴다. 실패 draft는 cleanup 전까지 보존한다. | `TimelineTaskService`, `TimelineTaskStore`, `TimelineDraftCleanupScheduler` |
| payload 안의 `itemType`을 컬럼으로 빼라 | `timeline_items.item_type` 컬럼을 추가하고, payload JSON에는 discriminator를 저장하지 않는다. 입력 DTO에서만 sibling `itemType`을 사용해 payload subtype을 역직렬화한다. | `TimelineItem.itemType`, `TimelineItem.payload`, `SourceItemDto` |
| Jackson으로 mapping 가능하다 | `SourceItemDto.payload` 필드에 external property 기반 `@JsonTypeInfo`를 둔다. `TimelineItemPayload` 자체는 순수 sealed interface로 유지한다. | `TimelineItemPayload`, `PhotoPayload`, `CalendarPayload`, `LocationPayload`, `MovementPayload` |
| payload의 `itemType`이 단일 권위이면 안 된다 | 영속 권위는 `timeline_items.item_type` 컬럼이다. 저장 시에는 payload 런타임 타입에서 `ItemTypes.typeOf(payload)`로 `ItemType`을 도출하고, sibling `itemType`과 일치하는지 검증한다. | `ItemTypes.typeOf`, `TimelineItem` |
| Card라는 묶음 단어가 애매하다 | domain 용어를 `Timeline Card`에서 `Timeline Event`로 바꾼다. UI 표현이 아니라 저장되는 사건 단위라는 의미를 분명히 한다. | `TimelineCard -> TimelineEvent`, `CardSuggestionDto -> TimelineEventSuggestionDto` |
| PK가 전부 `id`면 FK에서 보기 어렵다 | 테이블 PK와 엔티티 필드를 명시적 이름으로 바꾼다. FK 컬럼명은 참조하는 PK명과 맞춘다. | `daily_record_id`, `timeline_event_id`, `timeline_item_id`, `app_config_id` |
| DTO에서는 어떻게 할지 정해야 한다 | 응답 DTO도 명시적 ID를 쓴다. 단, app-AI 와이어 DTO의 `itemId`/`itemIds`는 요청 범위 인덱스라 유지하고 주석으로 DB id가 아님을 명시한다. | `TimelineItemResponse.timelineItemId`, `TimelineEventResponse.timelineEventId`, `SourceItemDto.itemId` |
| API response를 header/body 구조로 통일하고 싶다 | app-facing 성공 응답은 `ApiResponse<T>`로 감싼다. `header.code`, `header.message`, `body` 구조를 사용한다. | `ApiResponse`, `ApiHeader` |
| 에러는 code로 알려줄 예정이다 | R1에서는 성공 응답만 envelope을 적용한다. 에러 envelope과 에러 코드 카탈로그는 다음 마일스톤으로 분리한다. | 기존 `ErrorResponse`, `TimelineExceptionHandler` 유지 |
| `record_date` 기준이 애매하다 | 클라이언트가 `recordAnchorAt`과 IANA `recordTimeZone`을 보내고, 서버가 local noon boundary로 `record_date`를 계산한다. | `RecordDates.resolveRecordDate` |
| 하루 기준이 자정이 아니라 정오다 | 현지 시간 기준 12:00 전이면 전날 record date, 12:00 이후면 당일 record date로 계산한다. | `11:59 -> 전날`, `12:00 -> 당일` 테스트 |
| 글로벌 사용자를 고려해야 한다 | 서버의 물리적 timezone을 기준으로 하지 않는다. 클라이언트가 보낸 `recordTimeZone`을 기준으로 계산하고, `daily_records.record_timezone`에 저장한다. | `record_timezone` |
| AI 서버도 DB 접속 가능하다 | app 서버는 source item을 DB에 저장하고, AI 서버는 `taskId`로 DB에서 source item을 읽는다. callback body에는 source item을 다시 싣지 않는다. | `DraftTaskCallbackRequest(status, error, events)` |

## 주요 코드 구조

### 1. Auditing

`BaseEntity`는 공통 audit 컬럼을 제공한다.

```java
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {
    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    @LastModifiedBy
    private ModifiedByType modifiedByType;
}
```

적용 대상:

- `DailyRecord`
- `TimelineEvent`
- `TimelineItem`
- `TimelineDraftSourceItem`

제외 대상:

- `AppConfig`: JPA write 경로가 없는 정적 config에 가까워 audit 의미가 작다.
- `TimelineDraftTask`: Redis에 저장되는 상태 모델이며 JPA entity가 아니다.

### 2. Source Item 보존

새 테이블 `timeline_draft_source_items`가 추가된다.

역할:

- AI 정제 전 source item 저장
- callback 검증의 기준 데이터 제공
- AI 서버가 `taskId`로 source item을 읽을 수 있게 함
- callback 성공 후 최종 timeline 저장이 끝나면 삭제
- 실패/타임아웃/orphan은 cleanup 전까지 보존

주요 컬럼:

- `timeline_draft_source_item_id`
- `task_id`
- `user_id`
- `record_date`
- `record_timezone`
- `request_item_id`
- `item_type`
- `start_at`
- `end_at`
- `summary`
- `payload`
- audit columns

### 3. Redis Task 상태

Redis에는 source 원본을 두지 않고 task 상태만 둔다.

상태:

- `PROCESSING`
- `SUCCESS`
- `FAILED`

저장 정보:

- `recordDate`
- `callbackTokenHash`
- `error`

TTL:

- `PROCESSING_TTL`: 기본 1시간, AI 최대 처리/재시도 시간을 덮어야 함
- terminal TTL: 기본 24시간

한계:

- Redis가 진짜 유실되면 MySQL source row가 남아 있어도 callback task를 찾지 못해 finalize할 수 없다.
- R1에서는 관리형/persistent Redis 전제로 수용한다.
- 완전 복구가 필요해지면 R2에서 `timeline_draft_tasks` MySQL 테이블로 승격한다.

### 4. Callback Finalize

callback 성공 처리의 핵심 불변식은 다음이다.

1. token 검증을 terminal shortcut보다 먼저 한다.
2. DB finalize는 단일 트랜잭션으로 처리한다.
3. `daily_records`, `timeline_events`, `timeline_items` 저장과 draft row 삭제는 all-or-nothing이어야 한다.
4. Redis `SUCCESS`는 DB commit 이후에만 보인다.
5. rollback 시 Redis는 `PROCESSING`, draft row는 남아 AI 재시도가 가능해야 한다.

중요 구현 주의:

- 현재 `DailyRecordService.findOrCreateDraft`의 `REQUIRES_NEW`는 finalize all-or-nothing과 충돌한다.
- finalize 경로에서는 record 생성이 같은 트랜잭션에 합류해야 한다.
- `@Transactional` self-call은 Spring proxy를 거치지 않으므로 피한다.
- finalize는 별도 public bean 메서드 또는 `TransactionTemplate`으로 감싼다.

### 5. Payload와 itemType

입력 DTO:

```java
public record SourceItemDto(
        Integer itemId,
        ItemType itemType,
        LocalDateTime startAt,
        LocalDateTime endAt,
        String summary,
        TimelineItemPayload payload
) {}
```

저장 entity:

```java
public class TimelineItem extends BaseEntity {
    private Long timelineItemId;
    private Long timelineEventId;
    private ItemType itemType;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private JsonNode payload;
}
```

원칙:

- API 입력에서는 `itemType + payload`를 sibling으로 받는다.
- payload JSON 내부에는 `itemType`을 저장하지 않는다.
- DB에서는 `item_type` 컬럼이 권위다.
- response는 top-level `itemType`과 discriminator 없는 `payload`를 반환한다.

### 6. Record Date

`record_date`는 단순한 날짜가 아니라 Laimory의 기록일 label이다.

규칙:

- 클라이언트는 `recordAnchorAt`을 `Instant`로 보낸다.
- 클라이언트는 사용자의 IANA timezone을 `recordTimeZone`으로 보낸다.
- 서버는 해당 timezone으로 변환한 local time을 기준으로 계산한다.
- local time이 12:00 전이면 전날, 12:00 이상이면 당일이다.

예시:

| local time | record_date |
|---|---|
| 2026-05-20 11:59 | 2026-05-19 |
| 2026-05-20 12:00 | 2026-05-20 |

`timeline_events.start_at`, `timeline_items.start_at`, `timeline_draft_source_items.start_at`은 `record_timezone` 기준 local wall-clock time으로 해석한다.

## Stage별 반영 위치

| Stage | 핵심 변경 | 성격 |
|---|---|---|
| Stage 0 | `TimelineCard -> TimelineEvent`, PK/FK 명시적 네이밍 | 기계적 리네임, API shape 변경 |
| Stage 1 | `itemType` 컬럼 승격, payload `JsonNode`, sealed payload 정리 | app/AI wire contract 변경 |
| Stage 2 | `BaseEntity` + JPA auditing | DB audit 인프라 |
| Stage 3 | draft source MySQL 저장, callback finalize 재작성, record_date 서버 계산 | 핵심 동작 변경 |
| Stage 4 | draft cleanup scheduler | 실패/orphan 정리 |
| Stage 5 | 성공 응답 envelope | API 응답 규격 |
| Stage 6 | 용어집/문서 동기화 | Ubiquitous Language 정리 |

모든 stage는 독립적으로 컴파일/테스트가 가능해야 하지만, 독립 배포 가능한 것은 아니다. Stage 0부터 response JSON shape가 바뀌므로 실제 배포는 Android와 lockstep으로 진행한다.

## 검증 체크리스트

### JSON / Payload

- `SourceItemDto`가 sibling `itemType`으로 payload subtype을 역직렬화한다.
- `payload` 내부에는 `itemType`이 저장되지 않는다.
- `ItemTypes.typeOf(payload)` 결과와 sibling `itemType`이 다르면 400으로 거절한다.
- response는 `timelineItemId`, `itemType`, `payload`를 top-level 구조로 반환한다.

### DB / Auditing

- `ddl-auto=validate`에서 schema와 entity가 일치한다.
- audit 컬럼이 insert 시 채워진다.
- update 시 `updatedAt`이 변경된다.
- `createdAt`은 update 이후에도 유지된다.
- `modifiedByType`은 현재 `OPERATION`으로 채워진다.

### Callback / Failure

- token 검증이 terminal shortcut보다 먼저 실행된다.
- DB commit 전 Redis `SUCCESS`가 보이지 않는다.
- finalize rollback 시 final timeline은 생성되지 않고 draft row는 남는다.
- callback 재시도 시 같은 draft row로 다시 finalize할 수 있다.
- commit 후 재callback은 idempotent 200으로 끝난다.
- dispatch 실패는 `FAILED`로 기록되고 draft row는 cleanup 전까지 보존된다.

### Record Date

- `11:59 -> 전날`
- `12:00 -> 당일`
- 다른 timezone에서도 서버 timezone이 아니라 `recordTimeZone` 기준으로 계산된다.
- 잘못된 timezone은 400으로 처리된다.

### Cleanup

- 성공한 draft row는 finalize transaction에서 즉시 삭제된다.
- 실패/타임아웃/orphan draft row는 보관 기간 후 삭제된다.
- cleanup 보관 기간은 `PROCESSING_TTL`보다 길다.

## 의식적으로 남긴 한계

1. Redis 유실은 R1에서 완전히 복구하지 않는다.
   - MySQL에 source item은 남지만 Redis task가 사라지면 callback은 task를 찾지 못한다.
   - 완전 복구가 필요해지면 `timeline_draft_tasks`를 MySQL로 승격한다.

2. 에러 envelope은 다음 마일스톤이다.
   - R1에서는 성공 응답만 `ApiResponse<T>`로 감싼다.
   - 에러는 기존 `ResponseStatusException`, `IllegalArgumentException`, `ErrorResponse` 흐름을 유지한다.

3. evaluation sample 저장소는 app MySQL 밖으로 둔다.
   - R1의 app DB는 운영 흐름에 필요한 source 보존과 final timeline 저장에 집중한다.
   - evaluation dataset은 별도 파일/외부 저장소/분석 파이프라인으로 분리한다.

## 요약

이번 변경은 단순한 필드 추가가 아니라 timeline 생성 파이프라인의 책임 분리다.

- MySQL: source 원본과 최종 timeline의 권위
- Redis: task 상태와 polling/callback 진행 상태
- DTO: app/AI wire contract
- JPA auditing: 데이터 생성/수정 추적
- `item_type` 컬럼: payload 타입 권위
- `record_date`: 서버가 timezone과 정오 경계로 계산하는 기록일

이 구조로 바꾸면 AI 실패, callback 재시도, payload 타입 검증, DB 추적성, API 응답 일관성을 각각 독립적으로 다룰 수 있다.
