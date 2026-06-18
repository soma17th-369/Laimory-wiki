---
source_type: notes
title: Timeline Draft API Thought Process
captured_at: 2026-06-17
status: raw-design-thought-process
---

# Timeline Draft API Thought Process

## Context

Laimory의 하루 타임라인은 단순히 이벤트를 시간순으로 나열하는 기능이 아니다.

처음에는 사진, 일정, 위치, 이동 같은 이벤트를 `timeline_items`에 저장하고 시간순으로 보여주면 된다고 생각했다. 하지만 wireframe과 사용자 메모 흐름을 다시 보면서 중요한 점이 드러났다.

사용자는 개별 item이 아니라 **카드 단위**로 감정, 느낀 점, 생각, 메모를 남긴다. 예를 들어 12:30 카페 체류, 12:42 사진, 근처 위치 정보가 하나의 "성수동 카페" 카드로 묶이면, 사용자는 그 카드 전체에 대해 memo를 작성한다.

그래서 card는 단순 display grouping이 아니라 저장되어야 하는 도메인 단위가 되었다.

최종적으로 MVP의 기본 구조는 다음 3개 테이블로 잡았다.

```text
daily_records
timeline_cards
timeline_items
```

이 문서는 `timeline_items` 저장 방식, AI grouping 방식, 비동기 draft 생성 API, Redis task 상태, Jackson payload discriminator까지 이어진 사고 흐름을 기록한다.

## Thinking Flow

### 1. Flat timeline에서 card 단위 저장으로 이동

처음 고민은 "timeline item을 시간순으로 정렬하면 되는가"였다.

하지만 일부 카드는 단일 이벤트가 아니라 여러 이벤트를 묶은 결과다.

예시:

```text
13:00-16:00 캘린더 일정
그 시간 안의 사진
그 시간 안의 위치
그 시간 안의 이동
```

이런 것들은 하나의 card로 보여야 한다.

또 card에 사용자가 memo를 남길 수 있으므로, card는 클라이언트에서 즉석으로 묶는 임시 view가 아니라 DB에 저장되는 단위여야 한다.

### 2. timeline_card_items join table을 고민했지만 MVP에서는 제외

초기에는 `timeline_cards`, `timeline_items`, `timeline_card_items` 관계 테이블을 두는 방식을 고민했다.

장점은 item이 여러 card에 속할 수 있고, card와 item의 관계 이력이 유연해진다는 점이다.

하지만 MVP 규칙은 더 단순하다.

```text
item은 정확히 하나의 card에만 들어간다.
AI가 card에 포함하지 않은 source item은 timeline_item으로 저장하지 않는다.
```

그래서 관계 테이블은 과하다고 판단했다.

MVP에서는 `timeline_items.timeline_card_id`를 직접 FK로 둔다.

```text
daily_records
  -> timeline_cards
       -> timeline_items
```

이 구조는 단순하고, card 렌더링 쿼리도 쉽고, "persisted timeline item은 반드시 하나의 card에 속한다"는 도메인 규칙과 잘 맞는다.

### 3. timeline_items는 raw archive가 아니다

중요한 사고 전환은 `timeline_items`를 raw source archive로 보지 않는 것이다.

Android가 보내는 모든 사진, 일정, 위치, 이동 데이터를 무조건 `timeline_items`에 저장하는 것이 아니다.

MVP에서 `timeline_items`는 다음 의미다.

```text
AI가 card에 포함시킨 accepted source item이 DB에 저장된 것
```

즉 Android에서 받은 입력은 persistence 전까지 `source item`이고, AI grouping과 app server 검증을 통과한 뒤에야 `timeline_item`이 된다.

AI가 어떤 source item을 어떤 card에도 포함하지 않았다면, 그 item은 MVP에서는 저장하지 않는다.

### 4. itemId는 DB id가 아니라 request-scoped index

AI가 card proposal을 만들려면 source item을 참조할 ID가 필요하다.

처음에는 `timeline_items`를 먼저 저장하고 DB id를 AI에게 넘기는 방식도 떠올렸다.

하지만 이 방식은 `timeline_card_id`가 아직 없기 때문에 nullable FK가 필요해지고, AI 실패 시 orphan item cleanup도 필요해진다.

그래서 버렸다.

선택한 방식은 단순하다.

```text
Android request의 sourceItems 배열 index를 itemId로 사용한다.
```

예시:

```json
{
  "sourceItems": [
    { "itemType": "MOVEMENT" },
    { "itemType": "CALENDAR" },
    { "itemType": "PHOTO" }
  ]
}
```

이때 request-scoped itemId는 다음과 같다.

```text
MOVEMENT = 0
CALENDAR = 1
PHOTO = 2
```

AI는 `cards[].itemIds`로 이 index를 돌려준다.

DB에 저장된 뒤의 `timeline_items.id`와 request itemId는 완전히 다른 개념이다.

> 갱신(2026-06-17): 최종적으로는 itemId를 배열 위치에 암묵적으로 의존하지 않고 **명시 필드**로 둔다. 클라이언트가 각 sourceItem에 request-scoped로 유일한 itemId를 부여하고(0-based 권장), 이 값이 client -> AI -> callback까지 그대로 유지된다. app server는 callback 내부에서 `sourceItems.itemId`와 `cards.itemIds`의 정합만 검증한다(무보관이라 클라 원본과의 대조는 불가).

### 5. JSON payload는 쓰되 Map<String, Object>는 피한다

`timeline_items`는 사진, 일정, 위치, 이동뿐 아니라 나중에 결제, 전화, 메시지, 앱 사용, 건강, 음악 같은 다양한 타입을 받을 수 있다.

모든 타입마다 별도 테이블을 만들면 정규화는 강하지만 MVP에는 무겁다.

그래서 payload는 MySQL JSON 컬럼으로 저장한다.

하지만 Java 코드에서는 raw map을 쓰지 않는다.

금지:

```java
Map<String, Object> payload;
```

이 방식은 key typo, 타입 캐스팅 오류, 필수 필드 누락을 컴파일러가 잡아주지 못한다.

선택한 방식:

```java
sealed interface TimelineItemPayload
record PhotoPayload(...) implements TimelineItemPayload
record CalendarPayload(...) implements TimelineItemPayload
record LocationPayload(...) implements TimelineItemPayload
record MovementPayload(...) implements TimelineItemPayload
```

DB는 유연하게 JSON을 쓰고, Java application model은 typed payload를 사용한다.

`TimelineItem.of(...)`는 payload만 받는다. Java에서 타입이 필요하면 `payload.itemType()`로 얻는다.

```java
item.payload = payload;   // 타입은 payload 안 discriminator가 단일 권위
```

> 갱신(2026-06-17): 처음에는 `timeline_items.item_type` 컬럼을 두고 `payload.itemType()`에서 파생시켜 `item_type=PHOTO / payload=CalendarPayload` 같은 불일치를 막으려 했다. 이후 더 정리해서 **v1에는 `item_type` 컬럼을 아예 두지 않기로** 했다(타입은 payload JSON 안에만). 어차피 v1의 어떤 흐름도 타입으로 DB 검색을 하지 않기 때문이다. 타입 검색이 필요해지는 시점에 MySQL generated column으로 추가한다(아래 14번). 그러면 컬럼은 payload에서 DB가 파생하는 projection이라 애초에 불일치가 불가능하다.

### 6. AI grouping은 필요하지만 동기 API로 기다리면 위험하다

처음 API 계획은 Android가 sourceItems를 보내면 app server가 AI에게 보내고, AI 결과를 받아 DB 저장 후 응답하는 동기 구조였다.

하지만 LLM 응답을 기다리는 동안 app server request thread가 계속 잡힌다.

사용자가 많아지면 Tomcat thread pool이 고갈될 수 있다.

그래서 동기 API는 버리고 비동기 task 구조로 바꿨다.

```text
Android -> App Server: draft task 생성 요청
App Server -> Android: 202 Accepted + taskId 즉시 반환
AI Server -> App Server: callback으로 결과 전달
Android -> App Server: polling으로 상태 확인
```

이렇게 하면 app server는 LLM을 기다리지 않는다.

### 7. sourceItems 보관 방식을 고민했다

비동기 구조가 되면 문제가 생긴다.

AI callback 시점에 app server가 원본 sourceItems를 알아야 DB에 저장할 수 있다.

처음에는 app server가 Redis나 MySQL staging table에 sourceItems를 보관하는 방식을 고민했다.

하지만 MVP에서는 다음 판단을 했다.

```text
클라이언트가 1차 정제한 source item payload는 크기가 감당 가능하다.
사진/영상 바이너리와 raw GPS 대량 데이터는 보내지 않는다.
따라서 sourceItems 전체를 app -> AI -> app callback으로 왕복시켜도 된다.
```

그래서 staging table은 만들지 않는다.

Redis도 sourceItems 저장소가 아니라 task status 저장소로만 사용한다.

### 8. callback payload는 cards + sourceItems로 나눈다

한때 callback에서 card 안에 item 전체를 중첩하는 형태도 생각했다.

하지만 그렇게 하면 AI가 item payload를 card 안에 복사하면서 누락, 변형, 중복을 만들 수 있다.

그래서 callback은 다음 형태로 결정했다.

```json
{
  "sourceItems": [
    {
      "itemId": 0,
      "startAt": "2026-05-08T12:42:00",
      "endAt": null,
      "payload": {
        "itemType": "PHOTO",
        "photoUri": "content://media/external/images/media/12345",
        "latitude": 37.5445,
        "longitude": 127.0557
      }
    }
  ],
  "cards": [
    {
      "title": "성수동 카페",
      "subtitle": "사진 1장",
      "startAt": "2026-05-08T12:30:00",
      "endAt": "2026-05-08T13:20:00",
      "itemIds": [0]
    }
  ]
}
```

즉 payload는 sourceItems에만 있고, cards는 itemIds만 참조한다.

app server는 `cards[].itemIds`를 `sourceItems[].itemId`와 대조하여 최종 저장한다.

검증 규칙:

```text
sourceItems.itemId는 유일해야 한다.
cards.itemIds는 sourceItems에 존재해야 한다.
하나의 itemId는 하나의 card에만 들어갈 수 있다.
빈 itemIds card는 실패 처리한다.
title은 필수다.
card에 포함되지 않은 sourceItem은 저장하지 않는다.
```

> 갱신(2026-06-17): 초기에는 sourceItem 바깥에 `itemType`을 두고 `payload.itemType()`과 같은지 검증하려 했다(위 callback 예시에도 바깥 itemType이 있었다). 하지만 같은 정보를 두 곳에 두고 등가 검증을 하는 건 구조적 냄새라, **바깥 itemType을 아예 제거**하고 payload 안 discriminator를 단일 권위로 삼았다. 그래서 sourceItems에서 바깥 itemType이 빠졌고, 등가 검증 규칙도 사라졌다. (이유는 아래 10번·14번.)

### 9. Redis는 task status만 담당한다

Redis는 sourceItems 저장소가 아니다.

MVP에서 Redis는 polling을 위한 task status 저장소다.

키:

```text
timeline:draft-task:{taskId}
```

값:

```json
{
  "status": "PROCESSING",
  "recordDate": "2026-05-08",
  "dailyRecordId": null,
  "error": null
}
```

상태:

```text
PROCESSING
SUCCESS
FAILED
```

TTL:

```text
PROCESSING = 1h
SUCCESS = 24h
FAILED = 24h
```

Redis가 없어지면 task polling 상태는 유실된다. 이는 staging table을 만들지 않기로 한 MVP 선택의 tradeoff다.

### 10. Jackson discriminator는 As.PROPERTY를 사용한다

Typed payload JSON에서 가장 헷갈렸던 부분은 Jackson discriminator다.

처음에는 `EXISTING_PROPERTY` 또는 `EXTERNAL_PROPERTY`를 생각할 수 있었다.

하지만 DB에는 `TimelineItemPayload` 객체 하나가 `timeline_items.payload` 컬럼에 단독으로 저장된다.

Hibernate가 payload 컬럼을 읽을 때 Jackson에게 넘기는 것은 row 전체가 아니라 payload JSON 하나다.

따라서 JSON 안에 type discriminator가 self-contained하게 들어 있어야 한다.

선택:

```java
@JsonTypeInfo(
    use = JsonTypeInfo.Id.NAME,
    property = "itemType"
)
@JsonSubTypes({
    @JsonSubTypes.Type(value = PhotoPayload.class, name = "PHOTO"),
    @JsonSubTypes.Type(value = CalendarPayload.class, name = "CALENDAR"),
    @JsonSubTypes.Type(value = LocationPayload.class, name = "LOCATION"),
    @JsonSubTypes.Type(value = MovementPayload.class, name = "MOVEMENT")
})
public sealed interface TimelineItemPayload
        permits PhotoPayload, CalendarPayload, LocationPayload, MovementPayload {

    ItemType itemType();
}
```

이 설정은 기본 `As.PROPERTY` 방식이다.

DB에 저장되는 payload JSON:

```json
{
  "itemType": "PHOTO",
  "photoUri": "content://...",
  "latitude": 37.5,
  "longitude": 127.0
}
```

왜 `EXISTING_PROPERTY`를 쓰지 않는가:

```text
itemType()은 record 컴포넌트가 아니라 파생 메서드다.
Jackson record 직렬화는 주로 record 컴포넌트를 JSON property로 내보낸다.
따라서 itemType이 기존 property로 자동 직렬화된다고 기대하면 깨질 수 있다.
```

왜 `EXTERNAL_PROPERTY`를 쓰지 않는가:

```text
EXTERNAL_PROPERTY는 payload의 형제 itemType을 부모 객체에서 찾는다.
DTO 전체에서는 itemType과 payload가 형제일 수 있다.
하지만 DB payload 컬럼에는 payload JSON만 단독 저장된다.
Jackson은 SQL row의 item_type 컬럼을 같이 보지 못한다.
따라서 payload JSON 내부에 itemType이 있어야 안전하다.
```

결론(갱신 2026-06-17):

```text
itemType은 payload 안 discriminator(As.PROPERTY)에만 둔다 = 단일 권위.
sourceItem 바깥 itemType 필드는 제거했다 -> 중복도, 등가 검증도 없다.
EXTERNAL_PROPERTY는 DB payload 단독 역직렬화에서 형제 슬롯이 없어 깨지므로 안 쓴다.
타입 검색이 필요하면 item_type을 MySQL generated column으로 파생한다(아래 14번).
```

### 11. 기존 기록 보호 — 재생성은 full replace가 아니라 freeze + append

비동기 draft가 하루에 여러 번 돌 수 있게 되면서 "같은 날짜를 다시 생성하면 기존 카드를 어떻게 하나"가 문제가 됐다.

처음 떠올린 방식은 그날 카드를 전부 지우고 새로 만드는 full replace였다.

하지만 곧 막혔다. 사용자가 카드에 memo를 남겼는데 full replace를 하면 그 memo가 사라진다. card가 영속 도메인 단위인 이유(= 사용자 기록이 붙는다)와 정면으로 충돌한다.

대안들을 따져봤다.

```text
- memo를 시간/소스 앵커로 떼어내 재생성 후 재부착
- memo 있는 카드만 잠그고 나머지만 재생성
- memo가 생기면 그날 자동 재생성 자체를 막기
```

MVP 결론은 가장 단순하고 안전한 쪽이다.

```text
기존 카드는 건드리지 않는다(freeze).
새 이벤트는 새 카드로만 추가한다(append).
daily_record가 SAVED면 새 draft task 자체를 409로 거절한다.
DRAFT면 기존 card/item/title/subtitle/memo는 그대로 두고 append만 한다.
```

이렇게 하면 memo 손실이 구조적으로 불가능하다. 트레이드오프는 에피소드 중간에 늦게 도착한 이벤트가 기존 카드에 합쳐지지 못하고 별도 카드로 쪼개질 수 있다는 점인데, MVP에서는 수용한다.

### 12. 팀 아키텍처 규칙이 영속 구조를 결정했다

서버 repo의 `CLAUDE.md`에는 강한 규칙이 있다.

```text
하나의 Service는 정확히 하나의 Repository에만 접근한다.
여러 도메인에 걸친 로직은 Repository를 여러 개 주입하지 말고 Service를 합성해서 푼다.
```

이 규칙이 JPA 연관관계 선택을 결정했다.

만약 `TimelineCard`에 `@OneToMany(cascade=ALL)`로 items를 매핑하면, card 하나를 저장할 때 items까지 transitive하게 INSERT된다. 그러면 `TimelineCardService`가 자기 테이블 외에 items까지 저장하게 되어 "Service=Repository 1개" 규칙이 깨진다.

그래서 연관관계를 JPA로 매핑하지 않기로 했다.

```text
dailyRecordId, timelineCardId를 plain Long FK 컬럼으로 둔다.
@OneToMany / @ManyToOne / cascade / orphanRemoval을 쓰지 않는다.
card -> items의 cascade 삭제는 DB의 ON DELETE CASCADE로 처리한다.
저장은 record -> cards -> items 순서로 leaf service 3개를 합성해서 수행한다.
```

즉 팀 컨벤션이 "JPA 관계 매핑" 대신 "명시적 FK + DB 제약 + 서비스 합성"이라는 구조를 강제했고, 이게 오히려 저장 책임을 테이블별로 명확히 나눠줬다.

### 13. 트랜잭션 경계 — AI는 트랜잭션 밖, 영속만 단일 트랜잭션

저장은 daily_record, timeline_cards, timeline_items가 한 번에 성공하거나 한 번에 실패해야 한다. 그래서 영속은 단일 `@Transactional`로 묶는다.

반면 AI 호출은 트랜잭션 안에 있으면 안 된다(오래 걸린다). 비동기 구조에서는 AI가 아예 별도 서버라 자연스럽게 트랜잭션 밖이다.

한 가지 함정은 Spring `@Transactional`의 self-invocation이다. 같은 빈 안에서 자기 메서드를 호출하면 프록시가 안 걸려 트랜잭션이 시작되지 않는다. 그래서 callback 오케스트레이션 서비스가 **별도 빈**인 `@Transactional` 영속 서비스를 호출하도록 빈 경계를 나눴다. 영속 서비스는 leaf service 3개를 합성한다(각자 repo 1개).

### 14. 타입 검색은 payload 안에서가 아니라 파생 컬럼으로 — 그리고 필요할 때 추가한다

itemType을 payload 안에만 두기로 한 뒤, "그러면 나중에 타입으로 검색할 때 어렵지 않나"가 마지막 고민이었다.

여기서 두 가지를 구분하게 됐다.

```text
- payload 안 itemType: Java 역직렬화용 discriminator(단일 권위). 빼면 Hibernate 왕복이 깨진다.
- 검색용 item_type: SQL 인덱스용. JSON 내부를 WHERE로 뒤지면 풀스캔이라 별도 컬럼이 정석.
```

베스트프랙티스는 "JSON을 권위 원본으로 두고, 검색이 필요한 값은 인덱스 가능한 별도 컬럼으로 파생"하는 것이다(MySQL/Hibernate/JPA 공통). 이 파생 컬럼은 두 값을 따로 저장하는 나쁜 중복이 아니라, 하나의 원본(payload)에서 기계적으로 계산되는 projection이라 절대 어긋나지 않는다.

그리고 v1에서는 어떤 흐름도 타입으로 DB 검색을 하지 않으므로, 컬럼을 **아직 만들지 않는다**.

```sql
-- 타입 검색이 필요해지는 시점에만 추가 (무손실 마이그레이션)
ALTER TABLE timeline_items
  ADD COLUMN item_type VARCHAR(32) GENERATED ALWAYS AS (payload->>'$.itemType') STORED,
  ADD INDEX idx_timeline_items_type (item_type);
```

기존 행은 자동 백필되고, 앱 코드는 바뀌지 않으며, payload에서 DB가 파생하므로 항상 일치한다. 이는 처음 노트의 promotion rule("JSON으로 시작, 쿼리 조건이 되면 컬럼으로 승격")과 정확히 같다.

## Current MVP Shape

### API

```text
POST /api/v1/timeline/daily-records/draft-tasks
GET  /api/v1/timeline/daily-records/draft-tasks/{taskId}
POST /internal/api/v1/timeline/daily-records/draft-tasks/{taskId}/callback
```

### POST draft task

```text
1. Android가 recordDate와 sourceItems를 보낸다.
2. app server는 userId = 0L로 처리한다.
3. existing daily_record가 SAVED면 409 Conflict.
4. taskId를 만든다.
5. Redis에 PROCESSING을 저장한다.
6. AI server에 taskId + sourceItems + callbackUrl을 전달한다.
7. Android에는 202 Accepted + taskId를 즉시 반환한다.
```

### AI callback

```text
1. AI server가 sourceItems 전체와 cards[itemIds]를 callback으로 보낸다.
2. app server가 내부 secret header를 검증한다.
3. Redis task를 확인한다.
4. 이미 SUCCESS면 중복 저장하지 않고 성공 응답한다.
5. sourceItems와 cards.itemIds를 검증한다.
6. daily_records 상태가 SAVED인지 재확인한다.
7. 하나의 DB transaction으로 daily_record, timeline_cards, timeline_items를 저장한다.
8. Redis를 SUCCESS 또는 FAILED로 변경한다.
```

### Polling

```text
PROCESSING -> status만 반환
SUCCESS -> MySQL에서 dailyRecordId로 grouped timeline 조회 후 반환
FAILED -> error 반환
task 없음 또는 TTL 만료 -> 404
```

### DB

```text
daily_records
- id
- user_id
- record_date
- emotion_type
- status
- UNIQUE(user_id, record_date)

timeline_cards
- id
- daily_record_id
- start_at
- end_at
- title
- subtitle
- memo

timeline_items
- id
- timeline_card_id
- start_at
- end_at
- payload JSON   (타입은 payload 안 itemType discriminator. item_type 컬럼은 v1에 없음 - 검색 필요 시 generated column으로 추가)
```

권장 제약:

```text
daily_records.status NOT NULL
timeline_cards.title NOT NULL
timeline_items.timeline_card_id NOT NULL
timeline_cards -> timeline_items ON DELETE CASCADE
```

## Major Decisions

```text
MVP는 daily_records, timeline_cards, timeline_items 3테이블로 간다.
timeline_card_items join table은 만들지 않는다.
timeline_items는 raw source archive가 아니라 accepted source item 저장 결과다.
source item의 request itemId는 클라가 부여하는 request-scoped 명시 필드다(0-based 권장, DB id 아님).
AI grouping은 사용하지만 app server request thread는 LLM을 기다리지 않는다.
비동기 task + polling + AI callback 구조를 사용한다.
sourceItems는 app -> AI -> app callback으로 왕복한다.
Redis는 task status만 저장한다.
MySQL staging table은 만들지 않는다.
AI server는 MySQL에 직접 저장하지 않는다.
최종 저장은 app server callback에서 검증 후 수행한다.
payload는 DB JSON이지만 Java에서는 sealed interface + record를 사용한다.
Jackson payload discriminator는 As.PROPERTY 방식으로 payload 내부 itemType을 저장한다.
item_type은 v1에 별도 컬럼으로 두지 않고 payload 안에만 둔다. 타입 검색이 필요해지면 MySQL generated column으로 파생한다.
기존 기록 보호를 위해 재생성은 full replace가 아니라 freeze + append를 쓴다.
팀 규칙(Service=Repository 1개) 때문에 JPA 연관/cascade 대신 plain FK 컬럼 + DB ON DELETE CASCADE + 서비스 합성을 쓴다.
```

## Rejected Or Deferred Options

### timeline_card_items join table

MVP에서는 item이 정확히 하나의 card에만 들어가므로 제외했다.

나중에 item이 여러 card에 속하거나, card versioning, regeneration history가 필요하면 재검토한다.

### timeline_items를 raw archive로 사용

AI가 포함하지 않은 source item까지 모두 저장하면 raw archive와 accepted timeline item의 의미가 섞인다.

MVP에서는 저장하지 않는다.

### nullable timeline_card_id로 먼저 item 저장

AI 전에 item을 저장하면 `timeline_card_id`가 비게 된다.

이는 "persisted timeline item은 정확히 하나의 card에 속한다"는 규칙을 약하게 만든다.

### sourceItems MySQL staging table

서버 장애 복구와 callback 검증에는 좋지만 MVP 구현 복잡도가 커진다.

현재는 sourceItems를 callback으로 왕복시키기로 했다.

### Redis에 sourceItems 원본 저장

Redis는 영속 source of truth가 아니고, 큰 payload 저장소로 쓰는 것도 MVP에서 굳이 필요하지 않다고 봤다.

### Map<String, Object> payload

너무 느슨하다.

컴파일러가 key typo, 타입 불일치, 필수 필드 누락을 잡지 못한다.

### DB inheritance / subtype detail tables

DB 정합성은 강해지지만 테이블과 join이 많아진다.

item type이 자주 늘어날 수 있는 MVP에는 무겁다.

### Jackson EXTERNAL_PROPERTY

DTO wire format에는 가능하지만 DB payload 컬럼에서는 payload JSON만 단독으로 역직렬화되므로 깨질 수 있다.

### full replace 재생성

재생성 시 그날 카드를 전부 지우고 새로 만드는 방식. 사용자 memo가 사라지므로 제외했다. freeze + append로 대체(section 11).

### sourceItem 바깥 itemType + 등가 검증

타입을 sourceItem 바깥과 payload 양쪽에 두고 같은지 검증하는 방식. 같은 정보를 두 번 두는 구조적 냄새라 제외하고, payload 안 단일 권위로 정리했다(section 10·14).

### timeline_items.item_type 컬럼을 처음부터 두기

타입 검색이 없는 v1에서는 불필요. payload 안에 두고, 검색이 필요해지면 generated column으로 파생(section 14).

## Known Tradeoffs

### sourceItems echo 신뢰

app server는 최초 Android request의 sourceItems를 보관하지 않는다.

따라서 callback의 sourceItems가 최초 원본과 완전히 같은지 대조할 수 없다.

MVP에서는 AI server를 1st-party trusted service로 보고 수용한다.

### Redis task 유실

Redis TTL 만료 또는 Redis 장애 시 task status가 사라질 수 있다.

MVP에서는 클라이언트 재요청으로 처리한다.

### MySQL commit 후 Redis SUCCESS 전환 전 장애

DB 저장은 성공했는데 Redis 상태가 PROCESSING에 남을 수 있다.

MVP에서는 수용한다.

후속 개선:

```text
outbox
generation_task_id 컬럼
polling 시 MySQL fallback
Redis CAS/lock
```

### 같은 날짜 동시 task

동시에 같은 user/date로 task가 여러 개 생성되면 append가 중복될 수 있다.

MVP에서는 강하게 막지 않는다.

후속 개선:

```text
timeline:draft-active:{userId}:{recordDate}
distributed lock
source item dedup key
```

### 이 task가 만든 카드만 조회 불가

현재 최종 DB에는 taskId가 저장되지 않는다.

SUCCESS polling은 dailyRecordId 기준으로 그날 전체 timeline을 반환한다.

특정 task가 만든 card만 조회하려면 `generation_task_id` 같은 컬럼이 필요하다.

## Open Questions

### emotionType 저장 시점 (확정됨)

draft task 생성 흐름에서는 `emotionType`을 받지 않는다.

`emotionType`은 사용자가 타임라인을 본 뒤 '저장' 버튼을 누르는 시점, 즉 `status: DRAFT -> SAVED` 전환에서 생긴다. 그래서 draft 생성 시 `daily_records.emotion_type`은 NULL이고, emotion은 별도 save 완료 endpoint(후속)에서 `status=SAVED`와 함께 저장한다.

남은 작업: 그 save 완료 API와 `EmotionType` enum 값 정의. (이건 draft API 범위 밖이라 후속으로 분리.)

### 실제 AI dispatcher

MVP v1에서는 AI dispatcher를 no-op stub으로 둘 수 있다.

이 경우 task는 자동 완료되지 않고 callback을 수동 호출해야 완료된다.

실제 AI server 연동 시에는 short timeout, retry, callback URL, secret header 정책이 필요하다.

### 예외 처리

현재 server repo에는 전역 `@RestControllerAdvice`가 없다.

검증 실패가 500으로 보이지 않게 하려면 timeline 전용 또는 전역 exception handler가 필요하다.

권장 매핑:

```text
IllegalArgumentException -> 400
SAVED conflict -> 409
callback secret failure -> 401 or 403
task not found -> 404
```

### payload 필드 promotion

JSON payload 내부 필드가 자주 검색, 정렬, join 조건이 되면 normal column 또는 detail table로 승격한다.

예시:

```text
location.place_id
payment.amount
call.contact_id
```

MVP에서는 아직 승격하지 않는다.

## Final Current Recommendation

현재 MVP 기준으로 가장 적합한 구조는 다음이다.

```text
비동기 draft task API
Redis task status
sourceItems full round-trip
AI callback with sourceItems + cards[itemIds]
app server validation and persistence
MySQL 3 domain tables
typed payload JSON with Jackson As.PROPERTY discriminator
```

이 구조는 완벽한 운영 안정성보다는 MVP 구현 단순성과 도메인 모델 명확성을 우선한다.

후속 개선 포인트는 이미 보이는 상태다.

```text
sourceItems staging table
generation_task_id
outbox
Redis lock/CAS
real AI dispatcher
save-complete endpoint
exception handler
```

하지만 지금 단계에서는 위 개선들을 미리 넣기보다, 현재 구조로 기능을 끝까지 통과시키는 것이 더 중요하다.
