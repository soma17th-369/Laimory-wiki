# Timeline Backend Change Plan

Date: 2026-06-20
Status: planned

## Context

This note is the planning document for the backend changes discussed in the current session.

The first change is the `itemType`/payload structure correction.

The current server implementation stores the timeline item type inside `payload.itemType`.
That made `payload` self-describing, but it also made the payload carry metadata that should belong to the timeline item row.

The mentor feedback changes the direction:

- `itemType` should be a normal column on `timeline_items`.
- API DTOs should carry `itemType` as a sibling of `payload`.
- `payload` must not contain `itemType`.
- Jackson can still map payload subtypes by using the external `itemType`.

The second change is the audit/base entity correction.

Mentor feedback:

> `created_at`, `updated_at`, `modified_by` are needed. Use a base entity and use JPA properly.

The naming decision for the modifier column is:

```text
modified_by_type
```

This is more precise than `modified_by` because the current requirement is not "which exact user id modified the row", but "whether the last modification came from a user flow or an operation/server flow".

The third change is durable pre-AI source item storage.

Redis remains for draft task status, polling, and callback token state, while MySQL stores pre-refinement source items so AI failure does not lose the original request data.

The fourth change is domain terminology cleanup.

The current code and glossary use `Timeline Card` for the unit that groups timeline items. This should be renamed to `Timeline Event` because the concept is a persisted domain event/scene in the user's day, not merely a UI card.

UI can still render a timeline event as a card, but backend domain names should use event terminology.

The fifth change is primary key naming cleanup.

Current tables use generic `id` primary keys. The plan is to rename primary key columns to explicit entity id names such as `daily_record_id`, so foreign keys use the same column name as the referenced primary key.

The sixth change is API response envelope cleanup.

The API should return a consistent JSON envelope with `header.code`, `header.message`, and `body`, while still preserving meaningful HTTP status codes.

The seventh change is `record_date` boundary clarification.

Laimory's record day does not start at midnight. It starts at local noon. For example, `2026-05-20 11:59` belongs to `record_date = 2026-05-19`, while `2026-05-20 12:00` belongs to `record_date = 2026-05-20`.

The recommended processing model is:

```text
client sends source occurrence instant + IANA time zone
server calculates record_date using the noon boundary
```

## ItemType And Payload Plan

### Target Shape

#### API request and callback shape

```json
{
  "itemId": 1,
  "itemType": "PHOTO",
  "startAt": "2026-06-20T09:00:00",
  "endAt": null,
  "summary": "photo near cafe",
  "payload": {
    "photoUri": "content://media/external/images/media/12345",
    "latitude": 37.5445,
    "longitude": 127.0557
  }
}
```

### Database shape

```text
timeline_items.item_type = PHOTO
timeline_items.payload   = {"photoUri":"content://media/external/images/media/12345","latitude":37.5445,"longitude":127.0557}
```

The `payload` JSON is pure subtype data. It does not include `itemType`.

### Corrected Design Point

This is possible as long as the application does not try to deserialize the `payload` column by itself.

The failing case is:

```text
payload JSON only -> TimelineItemPayload
```

That has no type discriminator after `payload.itemType` is removed.

The valid case is:

```text
timeline_items row -> item_type column + payload JSON -> TimelineItemPayload subtype
```

The `item_type` column becomes the discriminator for the row.

### Implementation Plan

1. Add `item_type` to `timeline_items`.

```sql
ALTER TABLE timeline_items
  ADD COLUMN item_type VARCHAR(32) NOT NULL AFTER timeline_card_id,
  ADD INDEX idx_timeline_items_type (item_type);
```

Because the project uses `spring.jpa.hibernate.ddl-auto=validate`, `src/main/resources/db/schema.sql` also needs the new column for fresh local databases.

2. Add `ItemType itemType` to `SourceItemDto`.

`SourceItemDto` should become:

```java
public record SourceItemDto(
        Integer itemId,
        ItemType itemType,
        LocalDateTime startAt,
        LocalDateTime endAt,
        String summary,
        TimelineItemPayload payload
) {
}
```

3. Remove payload-internal Jackson discriminator as the domain contract.

`TimelineItemPayload` should no longer require `@JsonTypeInfo(... property = "itemType")` as an internal payload property.

For API DTO mapping, use external-property style mapping so Jackson reads the sibling `itemType` field to decide the payload subtype.

4. Change `TimelineItem`.

`TimelineItem` should store:

```java
@Enumerated(EnumType.STRING)
@Column(name = "item_type", nullable = false, length = 32)
private ItemType itemType;

@JdbcTypeCode(SqlTypes.JSON)
@Column(nullable = false)
private JsonNode payload;
```

The entity should not store `TimelineItemPayload` directly if Hibernate/Jackson only sees the JSON column in isolation. It should store raw JSON and expose typed payload through a mapper or service method that also has access to `itemType`.

5. Save items with explicit type.

`DailyTimelineService` should create items with:

```java
TimelineItem.of(
        savedCard.getId(),
        src.itemType(),
        src.startAt(),
        src.endAt(),
        src.payload()
)
```

The factory can validate that `src.itemType()` matches the runtime payload subtype. The column remains the persisted authority, but mismatch should be rejected before saving.

6. Restore typed payload using row-level data.

When building `TimelineItemResponse`, read both `item.getItemType()` and `item.getPayload()`:

```java
TimelineItemPayload typedPayload = switch (item.getItemType()) {
    case PHOTO -> objectMapper.convertValue(item.getPayload(), PhotoPayload.class);
    case CALENDAR -> objectMapper.convertValue(item.getPayload(), CalendarPayload.class);
    case LOCATION -> objectMapper.convertValue(item.getPayload(), LocationPayload.class);
    case MOVEMENT -> objectMapper.convertValue(item.getPayload(), MovementPayload.class);
};
```

The response remains:

```json
{
  "id": 10,
  "itemType": "PHOTO",
  "startAt": "2026-06-20T09:00:00",
  "endAt": null,
  "payload": {
    "photoUri": "content://media/external/images/media/12345",
    "latitude": 37.5445,
    "longitude": 127.0557
  }
}
```

7. Update validation.

Validation should reject:

- missing `itemType`
- missing `payload`
- `itemType` and payload runtime subtype mismatch
- legacy payloads that still include `payload.itemType`, unless a temporary migration path is intentionally accepted

8. Update tests.

Required test changes:

- API JSON request/callback accepts sibling `itemType` plus payload without `itemType`.
- API JSON response emits sibling `itemType` and payload without `itemType`.
- `timeline_items` persistence stores `item_type` and payload JSON separately.
- DB reload restores typed payload using `item_type`.
- payload-only deserialization is not treated as a supported path.

## Migration Note

If existing rows contain payload JSON with `itemType`, migration can be:

1. Backfill `timeline_items.item_type` from `payload.itemType`.
2. Remove `itemType` from payload JSON.
3. Make `item_type` `NOT NULL`.
4. Update application code and tests.

For a fresh MVP database with no production data, update `schema.sql` and recreate the local Docker volume or apply the ALTER statements manually.

## Decision

Use top-level/column `itemType` as the item type authority.

Do not keep `itemType` inside payload.

When reading from DB, do not deserialize `payload` alone. Always combine the row's `item_type` column with the payload JSON.

## Base Entity Auditing Plan

### Decision

Use a JPA mapped superclass for common audit columns:

- `created_at`
- `updated_at`
- `modified_by_type`

Use Spring Data JPA auditing annotations instead of manually setting timestamps in every service.

### Column Meaning

#### `created_at`

When the row was first persisted.

#### `updated_at`

When the row was last modified.

#### `modified_by_type`

The actor category responsible for the latest modification.

Planned values:

```java
public enum ModifiedByType {
    USER,
    OPERATION
}
```

Meaning:

- `USER`: app user initiated the change.
- `OPERATION`: server, AI callback, admin/ops flow, scheduled job, or internal repair flow initiated the change.

This intentionally does not store a user id. In the current MVP model, the owner user is already part of the domain row where needed, and the immediate requirement is only user-vs-operation provenance.

If exact actor identity becomes necessary later, add a separate column such as:

```text
modified_by_user_id
modified_by_operator_id
```

Do not overload `modified_by_type` with ids.

### Recommended Java Shape

```java
@Getter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class BaseEntity {

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @LastModifiedBy
    @Enumerated(EnumType.STRING)
    @Column(name = "modified_by_type", nullable = false, length = 32)
    private ModifiedByType modifiedByType;
}
```

Add JPA auditing configuration:

```java
@Configuration
@EnableJpaAuditing
public class JpaAuditingConfig {

    @Bean
    public AuditorAware<ModifiedByType> auditorAware() {
        return new ModifiedByTypeAuditorAware();
    }
}
```

### Auditor Strategy

`AuditorAware<ModifiedByType>` should return:

- `USER` for public/authenticated app API flows initiated by the mobile client.
- `OPERATION` for server-to-server endpoints such as AI callbacks, internal maintenance, scheduled jobs, retries, and admin/ops flows.

Current endpoint prefixes can help decide the default:

- `/api/{applicationVersion}/...` -> usually `USER`
- `/a/api/{applicationVersion}/...` -> usually `USER` after authentication is added
- `/s/api/{applicationVersion}/...` -> `OPERATION`

For non-web execution, default to `OPERATION`.

### Scope

Apply `BaseEntity` to JPA entities that represent persisted domain or operational state:

- `DailyRecord`
- `TimelineCard`
- `TimelineItem`
- `AppConfig`
- future draft task/raw input/result/evaluation entities

Do not apply it to Redis-only records such as the current `TimelineDraftTask` record unless that model becomes a JPA entity.

### DDL Plan

Because the server uses `spring.jpa.hibernate.ddl-auto=validate`, schema changes must be applied before the application starts.

Fresh local DB:

- update `src/main/resources/db/schema.sql`

Existing local DB should add these columns to JPA entity tables:

```sql
ALTER TABLE daily_records
  ADD COLUMN created_at DATETIME(6) NOT NULL,
  ADD COLUMN updated_at DATETIME(6) NOT NULL,
  ADD COLUMN modified_by_type VARCHAR(32) NOT NULL;

ALTER TABLE timeline_cards
  ADD COLUMN created_at DATETIME(6) NOT NULL,
  ADD COLUMN updated_at DATETIME(6) NOT NULL,
  ADD COLUMN modified_by_type VARCHAR(32) NOT NULL;

ALTER TABLE timeline_items
  ADD COLUMN created_at DATETIME(6) NOT NULL,
  ADD COLUMN updated_at DATETIME(6) NOT NULL,
  ADD COLUMN modified_by_type VARCHAR(32) NOT NULL;

ALTER TABLE app_config
  ADD COLUMN created_at DATETIME(6) NOT NULL,
  ADD COLUMN updated_at DATETIME(6) NOT NULL,
  ADD COLUMN modified_by_type VARCHAR(32) NOT NULL;
```

For existing rows, the actual migration should backfill values before adding `NOT NULL`, or add nullable columns first, backfill, then alter to `NOT NULL`.

Example backfill:

```sql
UPDATE daily_records
SET created_at = CURRENT_TIMESTAMP(6),
    updated_at = CURRENT_TIMESTAMP(6),
    modified_by_type = 'OPERATION'
WHERE created_at IS NULL;
```

### AI Server Caveat

Spring Data JPA auditing only runs in the application process that uses this JPA configuration.

If the AI server writes directly to MySQL, it must also follow the same audit contract. Options:

1. AI server uses its own equivalent auditing/base model.
2. AI server explicitly sets `created_at`, `updated_at`, and `modified_by_type`.
3. Shared operational tables use DB defaults for timestamps, while `modified_by_type` is still explicitly set.

Do not assume app-server JPA annotations will populate rows written by the AI server.

### Tests

Add or update tests to verify:

- new entities receive non-null `createdAt`, `updatedAt`, and `modifiedByType` on save
- updating an entity changes `updatedAt`
- `createdAt` is not updated after the first persist
- app/user request flow records `USER`
- server callback or internal flow records `OPERATION`

### Decision Summary

Use:

```text
created_at
updated_at
modified_by_type
```

Use:

```text
@MappedSuperclass BaseEntity
Spring Data JPA auditing annotations
AuditorAware<ModifiedByType>
```

Do not store exact user id in this first pass. Add a separate id column later only if there is a concrete product or operational need.

## Primary Key And Foreign Key Naming Plan

### Decision

Do not use generic `id` column names in database tables.

Use explicit primary key names:

```text
<singular_entity_name>_id
```

The foreign key column should use the same name as the referenced primary key.

Example:

```text
daily_records.daily_record_id      -- PK
timeline_events.daily_record_id    -- FK to daily_records.daily_record_id
```

Reason:

- SQL joins are easier to read.
- `SELECT *` or debug query output is less ambiguous.
- FK names naturally match the referenced PK names.
- It avoids tables full of unrelated `id` columns in multi-table queries.

### Planned Column Names

Current and planned names:

```text
app_config.id                         -> app_config.app_config_id
daily_records.id                      -> daily_records.daily_record_id
timeline_cards.id                     -> timeline_events.timeline_event_id
timeline_cards.daily_record_id        -> timeline_events.daily_record_id
timeline_items.id                     -> timeline_items.timeline_item_id
timeline_items.timeline_card_id       -> timeline_items.timeline_event_id
timeline_draft_source_items.id        -> timeline_draft_source_items.timeline_draft_source_item_id
```

After the card-to-event rename, the main relationship should read:

```text
daily_records.daily_record_id
  -> timeline_events.daily_record_id

timeline_events.timeline_event_id
  -> timeline_items.timeline_event_id
```

### JPA Mapping

Prefer matching the entity field name to the DB column for clarity:

```java
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "daily_record_id")
private Long dailyRecordId;
```

Similarly:

```java
@Column(name = "daily_record_id", nullable = false)
private Long dailyRecordId;
```

This makes the entity's PK field and other entities' FK field use the same domain name.

If API responses still need a generic `id` field for client compatibility, response DTOs can map:

```text
dailyRecordId -> id
```

But the database and domain model should use explicit names.

### DDL Migration Shape

For an MVP database with no production data, update `schema.sql` directly.

For existing data, use column rename migrations:

```sql
ALTER TABLE daily_records
  RENAME COLUMN id TO daily_record_id;

ALTER TABLE timeline_events
  RENAME COLUMN id TO timeline_event_id;

ALTER TABLE timeline_items
  RENAME COLUMN id TO timeline_item_id;

ALTER TABLE timeline_draft_source_items
  RENAME COLUMN id TO timeline_draft_source_item_id;
```

Foreign key constraints and index names should also be renamed so they match the explicit columns.

## API Response Envelope Plan

### Decision

Use a generic API response envelope for app-facing APIs:

```json
{
  "header": {
    "code": "COMMON_0000",
    "message": "success"
  },
  "body": {
    "taskId": "..."
  }
}
```

Java shape:

```java
public record ApiResponse<T>(
        ApiHeader header,
        T body
) {
}

public record ApiHeader(
        String code,
        String message
) {
}
```

Use static factories to avoid repeating header construction:

```java
public static <T> ApiResponse<T> success(T body) {
    return new ApiResponse<>(new ApiHeader("COMMON_0000", "success"), body);
}

public static ApiResponse<Void> error(String code, String message) {
    return new ApiResponse<>(new ApiHeader(code, message), null);
}
```

### HTTP Status Rule

Do not return HTTP 200 for every response.

Use both:

```text
HTTP status code  -> transport/protocol-level result
header.code       -> app/domain-specific result code
```

Examples:

```text
200 OK       + COMMON_0000
202 Accepted + COMMON_0000
400 Bad Request + COMMON_4000
401 Unauthorized + AUTH_4010
404 Not Found + TIMELINE_4040
409 Conflict + TIMELINE_4090
500 Internal Server Error + COMMON_5000
```

Reason:

- HTTP clients, proxies, monitoring, and logs understand HTTP status codes.
- Mobile clients can still branch on stable app-specific `header.code`.
- `message` stays human-readable and should not be parsed for logic.

### Success Response

Controller methods should return:

```java
ResponseEntity<ApiResponse<CreateDraftTaskResponse>>
```

Example:

```java
return ResponseEntity
        .accepted()
        .body(ApiResponse.success(new CreateDraftTaskResponse(taskId)));
```

For empty successful responses:

```java
ResponseEntity<ApiResponse<Void>>
```

with `body = null`.

### Error Response

Use `@RestControllerAdvice` to convert exceptions into:

```java
ResponseEntity<ApiResponse<Void>>
```

Example JSON:

```json
{
  "header": {
    "code": "TIMELINE_4090",
    "message": "daily record already saved"
  },
  "body": null
}
```

Validation errors may later need structured details. If so, either:

1. add a `details` field to `header`, or
2. use `ApiResponse<ValidationErrorBody>` for validation failures.

For the current plan, keep `header.code`, `header.message`, and nullable `body`.

### Code Catalog

Create a stable app code catalog.

Suggested format:

```text
COMMON_0000 success
COMMON_4000 bad request
COMMON_5000 internal server error
AUTH_4010 invalid callback token
TIMELINE_4040 draft task not found
TIMELINE_4090 daily record already saved
TIMELINE_4220 invalid AI event suggestion
```

Rules:

- Codes are stable and machine-readable.
- Messages can change and should not be parsed by clients.
- Do not expose internal exception messages directly for 5xx errors.

### Scope

Apply the envelope to app-facing JSON APIs.

Possible exclusions:

- health/status endpoints used by infrastructure
- actuator-style endpoints
- file/download endpoints
- server-to-server callback endpoints if the caller only needs HTTP status

If the AI callback endpoint benefits from consistency, it can return `ApiResponse<Void>`, but HTTP status is still the important signal for retry.

### Best-Practice Note

This envelope is a product/team API convention, not a universal HTTP standard.

For public HTTP error APIs, RFC 9457 Problem Details is the standard format. Spring also supports `ProblemDetail`/`ErrorResponse` for RFC-style error responses.

For this mobile-app API, a consistent `ApiResponse<T>` envelope is acceptable if:

- HTTP status codes remain meaningful
- app-specific `header.code` is stable
- errors are centralized in exception handling
- the wrapper does not hide transport failures behind HTTP 200

## Record Date Boundary Plan

### Decision

`record_date` is not a UTC date and not a normal midnight-based local date.

It is the label for a Laimory record day, where a record day starts at local noon and ends just before the next local noon.

Definition:

```text
record_date = local date of the noon-start record day
record day interval = [record_date 12:00, next day 12:00)
```

Example with `Asia/Seoul`:

```text
2026-05-19 12:00 <= time < 2026-05-20 12:00
=> record_date = 2026-05-19

2026-05-20 11:59
=> record_date = 2026-05-19

2026-05-20 12:00
=> record_date = 2026-05-20
```

### Time Zone Rule

Use the user's IANA time zone, not a fixed offset.

Store or receive:

```text
record_timezone = Asia/Seoul
```

Do not use only:

```text
UTC+9
```

Reason:

- global users may have daylight saving time
- offsets can change by date
- `Asia/Seoul`, `America/New_York`, `Europe/London` preserve the local calendar rules needed to compute a user's record day

### Calculation

Given an event/source timestamp and a user time zone:

```java
ZonedDateTime local = instant.atZone(userZoneId);
LocalDate recordDate = local.toLocalDate();
if (local.toLocalTime().isBefore(LocalTime.NOON)) {
    recordDate = recordDate.minusDays(1);
}
```

Equivalent mental model:

```text
local wall-clock time before 12:00 belongs to the previous record_date
local wall-clock time at or after 12:00 belongs to the same local date
```

Use local wall-clock noon as the boundary, not server time and not UTC midnight.

### Request Contract

The client should send the source item's occurrence time and the user's IANA time zone.

The server should calculate `record_date`.

Recommended request shape:

```json
{
  "recordTimeZone": "Asia/Seoul",
  "sourceItems": [
    {
      "itemId": 0,
      "itemType": "PHOTO",
      "occurredAt": "2026-05-20T02:59:00Z",
      "startAt": "2026-05-20T02:59:00Z",
      "endAt": null,
      "payload": {}
    }
  ]
}
```

For duration-based items, `startAt` is the main record-date calculation input.
For point-in-time items, `occurredAt` and `startAt` may be the same value.

If the API keeps a top-level `recordDate` for compatibility, the server should treat it as a client hint and validate it against the server-calculated value.

Preferred long-term request fields:

```json
{
  "recordTimeZone": "Asia/Seoul",
  "sourceItems": []
}
```

MVP default:

```text
recordTimeZone omitted -> Asia/Seoul
```

Long-term:

```text
recordTimeZone is required
source item occurrence/start times include an instant or offset
```

Do not calculate `record_date` from server receive time except as a last-resort fallback for records that genuinely have no occurrence time.

Server receive time can be stored separately as operational metadata, but it should not define the user's record day.

### Client Responsibility

The client does not need to calculate `record_date`.

The client should provide the calculation inputs:

- source item occurrence/start instant
- source item end instant, if any
- user's IANA time zone id

On Android:

```kotlin
val zoneId = ZoneId.systemDefault().id
val occurredAt = Instant.now().toString()
```

For imported data sources, prefer the source's real event time:

- photo captured time
- calendar event start/end time
- location visit start/end time
- movement segment start/end time

If the true event time is unavailable, use the best available collection time and mark that convention in the source item construction layer.

### Storage

`daily_records` should store:

```text
record_date DATE NOT NULL
record_timezone VARCHAR(64) NOT NULL
```

If the noon boundary may become configurable later, also consider:

```text
record_day_start_time TIME NOT NULL DEFAULT '12:00:00'
```

For now, noon can be a product constant.

`created_at` and `updated_at` remain UTC-like instants through JPA auditing. They are unrelated to the record day boundary.

`timeline_draft_source_items` and `timeline_items` should store event/source times as instants or offset-aware timestamps, not ambiguous server-local `LocalDateTime` values, if the API is updated in this change set.

### Naming Note

`record_date` remains acceptable if documented clearly as the Laimory record-day label.

If the team wants less ambiguity, `record_day` is a possible future rename, but it is not necessary if the glossary defines the noon boundary.

## AI Draft Source Persistence Plan

### Context

Mentor feedback:

> If the app server and AI server exchange data directly, data cannot be recovered when the AI server dies.

> Store data before refinement in MySQL, then delete it after AI results are created. Redis is also possible.

> Separate data storage is needed for evaluation.

> The current implementation stores only highly refined data and does not handle request failure.

Project decision for this session:

```text
Keep Redis for lightweight task status and callback token state.
Use MySQL for durable pre-AI source item storage.
```

The issue is not that Redis is too slow or unusable for status.
The issue is that source item payloads are too important to keep only in transit or in volatile task state.

Redis remains responsible for:

- draft task status used by app polling
- callback token hash
- short-lived error/status display

MySQL becomes responsible for:

- pre-refinement source items
- recovery when the AI server dies before producing a result
- source data needed for validation, retry, and evaluation export

### Decision

Create a separate MySQL table for draft source items.

Do not let the AI server write directly into final domain tables such as:

- `daily_records`
- `timeline_cards`
- `timeline_items`

Instead:

1. App server stores the pre-AI source data in MySQL before AI work starts.
2. AI server reads draft source data from MySQL or receives the same data from the app server.
3. AI server returns the generated cards through the app-server callback.
4. App server validates the AI result.
5. App server writes final accepted data into `daily_records`, `timeline_cards`, and `timeline_items`.
6. App server exports evaluation data to an external evaluation storage path.
7. App server deletes or short-retains the pre-AI source rows after success.

### Proposed Table

#### `timeline_draft_source_items`

One row per source item from the app request.

Purpose:

- preserve pre-refinement data before AI processing
- let AI server read stable source data from MySQL
- allow retry if AI processing fails

Suggested columns:

```text
id BIGINT PRIMARY KEY AUTO_INCREMENT
task_id CHAR(36) NOT NULL
user_id BIGINT NOT NULL
record_date DATE NOT NULL
request_item_id INT NOT NULL
item_type VARCHAR(32) NOT NULL
start_at DATETIME(6) NULL
end_at DATETIME(6) NULL
summary TEXT NULL
payload JSON NOT NULL
created_at DATETIME(6) NOT NULL
updated_at DATETIME(6) NOT NULL
modified_by_type VARCHAR(32) NOT NULL
UNIQUE KEY uq_draft_source_item (task_id, request_item_id)
```

`user_id` and `record_date` are duplicated here on purpose so the raw source rows remain understandable even though Redis owns task status.

This table follows the same payload decision as final `timeline_items`:

- `item_type` is a column
- `payload` does not contain `itemType`

### No Separate AI Results Table For MVP

Do not create a separate `timeline_draft_ai_results` table in the MVP plan.

Reason:

- The mentor feedback is mainly about preserving the pre-refinement input when AI work fails.
- The current API shape already has the AI server return results through the callback.
- If the callback succeeds, the app server can validate and persist final domain data in the same flow.
- If the callback fails validation, Redis task state can store `FAILED` and the validation error.
- A separate AI-result-attempt table is useful for advanced retry/evaluation analysis, but it is not necessary for the current recovery requirement.

Callback crash handling should rely on:

- AI server retries callback on non-2xx response
- app server returns 2xx only after validation/final persistence transaction succeeds
- app server callback handling is idempotent for an already completed `taskId`
- app server can reload source items from MySQL during callback handling

If the app server dies while processing the callback, the DB transaction should roll back and the AI server should retry.
If the DB commit succeeds but the app server dies before sending the HTTP response, the AI server may retry; the app server should detect the already completed task and return success without duplicating cards/items.

Add a durable callback inbox table only if one of these becomes true:

- AI server cannot reliably retry callback
- app server wants to acknowledge callback before finalization
- AI results must be preserved even when validation/finalization fails
- repeated AI attempts need to be compared

Possible later table name:

```text
timeline_draft_callbacks
```

That would be a callback receipt/inbox table, not an MVP evaluation table.

### Evaluation Storage

Do not create `timeline_evaluation_samples` in the app MySQL database for this plan.

Evaluation data should be exported to an external storage path.

The app server should create the evaluation payload after validation/finalization, then send or write it outside the main transactional database.

The evaluation payload should include enough metadata to compare model quality:

```text
task_id
record_date
model_name
model_version
prompt_version
input snapshot or redacted input reference
AI output snapshot
validation status
validation error
final_daily_record_id, if created
```

The exact external storage is a separate decision. It may be object storage, analytics storage, a data warehouse, or files managed by the AI/evaluation pipeline.

### Flow

#### 1. App request

`POST /api/{applicationVersion}/timeline/drafts`

App server:

1. validates request shape
2. creates Redis task state with `PROCESSING` and callback token hash
3. stores each source item in `timeline_draft_source_items`
4. dispatches to AI or lets AI read by `task_id`
5. returns `task_id`

Redis state is still used for polling and callback token validation.

#### 2. AI dispatch or worker read

There are two acceptable MVP paths:

1. App server dispatches the source data to AI after saving it in MySQL.
2. AI server reads the source data from MySQL using `task_id`.

In both paths, MySQL has the pre-AI source rows before AI work starts.

If the AI server dies, source data remains recoverable because `timeline_draft_source_items` still exists.
Redis can mark the task failed or keep it processing until timeout policy handles it.

#### 3. AI callback

AI server calls the app-server callback with either:

- `SUCCESS` and card suggestions
- `FAILED` and an error message

App server updates Redis task state:

- `FAILED` with `failure_stage = AI_PROCESSING` if AI reports failure
- `SUCCESS` if validation and final persistence succeed
- `VALIDATION_FAILED` if AI output cannot be accepted

#### 4. App server finalization

Finalization happens inside the app-server callback path or an internal app-server worker after callback receipt.

App server:

1. loads the task
2. loads source items
3. validates callback cards against source items
4. validates item ids, time ranges, required titles, payload/type consistency
5. writes final `daily_records`, `timeline_cards`, and `timeline_items`
6. exports evaluation payload to external storage
7. marks request `SUCCESS`
8. deletes or short-retains `timeline_draft_source_items`

If validation fails:

```text
status = VALIDATION_FAILED
failure_stage = VALIDATION
error_message = validation reason
```

#### 5. Cleanup

After successful finalization and evaluation export:

- delete or short-retain `timeline_draft_source_items`
- keep Redis terminal task state until its normal TTL expires
- keep external evaluation data according to the evaluation/privacy policy

Suggested MVP retention:

```text
SUCCESS raw source rows: delete after evaluation export or retain for 1-7 days
FAILED/VALIDATION_FAILED raw source rows: retain longer for debugging, then delete
evaluation data: store outside app MySQL according to evaluation/privacy policy
```

### Why Separate Tables

Separate draft source table is preferred because:

- final timeline tables should contain accepted product data only
- AI failures should not create partial timeline cards/items
- raw source data is operationally useful but may have a shorter retention policy
- evaluation data has a different purpose and should live outside the main app MySQL database

### Redis Decision

Keep Redis for the MVP task state.

Redis is still appropriate because:

- task status is short-lived
- app polling needs a simple status lookup
- callback token hash is short-lived
- terminal success/failure state can expire naturally

Do not store source item payloads only in Redis.
Source rows belong in MySQL so AI failure or process loss does not destroy the input data.

### Tests

Add tests for:

- creating a draft task stores source items before AI starts
- polling still reads task status from Redis
- AI failure marks Redis task failed while MySQL source rows remain available for debugging/retry
- callback result is validated before final timeline rows are written
- callback retry after successful commit is idempotent
- callback retry after transaction rollback can succeed using source rows from MySQL
- validation failure does not write final `timeline_cards` or `timeline_items`
- successful finalization exports evaluation data before raw cleanup

## Timeline Card To Timeline Event Rename Plan

### Decision

Rename the domain term:

```text
Timeline Card -> Timeline Event
```

Reason:

- `Card` is a UI presentation word.
- The backend concept is persisted and has domain behavior: time range, title, subtitle, memo, and grouped source/timeline items.
- The unit represents a meaningful event, scene, or activity in the user's day.
- UI can still display a timeline event as a card without making `Card` the domain name.

Preferred domain hierarchy:

```text
Daily Record
  -> Timeline Event
      -> Timeline Item
```

Meaning:

- `Daily Record`: one user's record for one date.
- `Timeline Event`: a meaningful day segment generated from one or more source items and shown to the user.
- `Timeline Item`: an accepted source item inside one timeline event.

### Naming Changes

Suggested code/table/API rename map:

```text
TimelineCard                  -> TimelineEvent
TimelineCardService           -> TimelineEventService
TimelineCardRepository        -> TimelineEventRepository
TimelineCardResponse          -> TimelineEventResponse
CardSuggestionDto             -> TimelineEventSuggestionDto
CardSuggestionValidator       -> TimelineEventSuggestionValidator
CardSuggestionDispatcher      -> TimelineEventSuggestionDispatcher
timeline_cards                -> timeline_events
timeline_items.timeline_card_id -> timeline_items.timeline_event_id
cards                         -> events
cardIds/card itemIds context  -> event itemIds context
```

The source item and timeline item names should not change.

```text
Source Item
Timeline Item
Item Type
Payload
```

These still describe the raw/pre-AI input and accepted item-level data correctly.

### Glossary Update

The glossary should define:

```text
Timeline Event
```

as:

```text
AI가 source items를 묶어 만든, 사용자에게 하루 타임라인에서 보이는 의미 단위.
UI에서는 카드 형태로 렌더링될 수 있지만, backend domain name은 Event다.
```

Avoid bare `Event` in code where ambiguity is possible.

Use `TimelineEvent` rather than `Event` because `event` can also mean:

- calendar event
- analytics event
- application event
- domain event

### API Contract

Current response/request fields named `cards` should become `events` if the API is still allowed to change.

Example callback shape:

```json
{
  "status": "SUCCESS",
  "sourceItems": [],
  "events": [
    {
      "title": "성수동 카페",
      "subtitle": "사진과 위치 기록",
      "startAt": "2026-06-20T12:30:00",
      "endAt": "2026-06-20T13:10:00",
      "itemIds": [0, 1, 2]
    }
  ]
}
```

If client compatibility matters, keep `cards` temporarily as a legacy wire field and map it internally to `TimelineEvent`.

### Migration Note

Because the project currently has `timeline_cards` and `timeline_card_id`, the rename affects:

- DDL/schema.sql
- primary key and foreign key column names
- JPA entity names
- repository method names
- service names
- DTO names and JSON field names
- tests
- glossary and design docs

For an MVP database with no production data, prefer a clean rename in `schema.sql`.

For existing data, use table/column rename migrations:

```sql
RENAME TABLE timeline_cards TO timeline_events;

ALTER TABLE timeline_items
  RENAME COLUMN timeline_card_id TO timeline_event_id;
```

Foreign key and index names should also be renamed for readability.

### Decision Summary

Use `Timeline Event` as the backend domain term.

Use `card` only for UI rendering language, not backend entities, tables, services, DTOs, or AI contracts.
