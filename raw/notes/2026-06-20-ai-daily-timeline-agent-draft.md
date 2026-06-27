# AI Daily Timeline Agent Architecture

Date: 2026-06-20  
Last Updated: 2026-06-26  
Status: revised draft  
Feature: Laimory AI Daily Timeline

## 1. Overview

AI Daily Timeline Agent는 하루 동안 수집된 여러 종류의 데이터를 바탕으로, 사용자가 확인하고 수정할 수 있는 하루 타임라인 초안을 생성하는 시스템이다.

이 문서의 목적은 내부 구현 세부사항을 확정하는 것이 아니라, Agent가 어떤 입력을 받고 어떤 결과를 만들어야 하는지 정의하는 것이다. 각 Agent의 내부 상태, 세부 schema, patch 방식, 평가 metric은 구현 과정에서 별도 문서나 코드로 구체화한다.

핵심 목표는 다음과 같다.

- 여러 종류의 하루 데이터를 event 단위로 해석한다.
- 데이터별 raw input을 공통 `Event` 후보로 정규화한다.
- 데이터별 해석 결과를 하나의 하루 timeline으로 합친다.
- 근거가 부족한 내용은 단정하지 않는다.
- 사용자가 수정하기 쉬운 timeline draft를 만든다.
- 불확실한 부분은 질문으로 남긴다.

## 2. Input

### 2.1. Location Data

사용자의 기기에서 수집된 원본 위치 로그 데이터.

```json
{
  "rawLocationLogs": [
    {
      "sourceId": "raw-location-001",
      "timestamp": "2026-06-20T10:10:00",
      "latitude": 35.8881,
      "longitude": 128.6105,
      "accuracyMeters": 15,
      "speedMetersPerSecond": 1.2
    }
  ]
}
```

Raw Location Data를 기반으로 추출한 사용자의 체류 정보.

```json
{
  "stayLogs": [
    {
      "sourceId": "stay-log-001",
      "derivedFromSourceIds": ["raw-location-001"],
      "placeName": "경북대학교",
      "address": "대구광역시 북구",
      "latitude": 35.8881,
      "longitude": 128.6105,
      "startTime": "2026-06-20T11:00:00",
      "endTime": "2026-06-20T18:00:00"
    }
  ]
}
```

Raw Location Data를 기반으로 추출한 사용자의 이동 정보.

```json
{
  "movementLogs": [
    {
      "sourceId": "movement-log-001",
      "derivedFromSourceIds": ["raw-location-001"],
      "fromPlace": "집",
      "toPlace": "경북대학교",
      "startTime": "2026-06-20T10:10:00",
      "endTime": "2026-06-20T11:00:00",
      "transportation": "BUS"
    }
  ]
}
```

---

### 2.2. Calendar Data

사용자가 등록한 일정 데이터.

```json
{
  "events": [
    {
      "sourceId": "calendar-event-001",
      "title": "김종찬 멘토링",
      "description": "SW 마에스트로 멘토링",
      "location": "포스트타워",
      "startTime": "2026-06-20T12:30:00",
      "endTime": "2026-06-20T13:30:00"
    }
  ]
}
```

---

### 2.3. Photo Data

사용자가 촬영하거나 저장한 사진 데이터.

AI는 촬영 시각, 위치 정보, 이미지 내용을 기반으로 특정 사건이나 활동을 추론할 수 있다.

```json
{
  "photos": [
    {
      "sourceId": "photo-001",
      "capturedAt": "2026-06-20T17:15:00",
      "latitude": 37.123,
      "longitude": 127.123,
      "localPath": "/photos/001.jpg",
      "description": "팀원들과 저녁으로 닭갈비를 먹은 사진"
    }
  ]
}
```

---

### 2.4. Sleep Data

사용자의 수면 및 기상 데이터

```json
{
  "sleep": {
    "sourceId": "sleep-session-001",
    "sleepStartTime": "2026-06-19T01:10:00",
    "wakeUpTime": "2026-06-20T09:20:00",
    "durationMinutes": 490
  }
}
```

---

### 2.5. Activity Data

걸음 수, 이동 거리 등 사용자의 활동량 데이터.

```json
{
  "activity": {
    "sourceId": "activity-summary-001",
    "steps": 8299,
    "distanceKm": 6.57,
    "calories": 312
  }
}
```

---

### 2.6. Notification Data

사용자 기기에 수신된 알림 기록 데이터.

```json
{
  "notifications": [
    {
      "sourceId": "notification-001",
      "appName": "카카오톡",
      "title": "친구",
      "content": "산책하자",
      "receivedAt": "2026-06-20T18:00:00"
    },
    {
      "sourceId": "notification-002",
      "appName": "네이버 예약",
      "title": "예약 알림",
      "content": "예약 방문 예정",
      "receivedAt": "2026-06-20T10:50:00"
    }
  ]
}
```

---

### 2.7. User Memory Data

AI가 장기간 축적한 사용자 정보.

필수 필드는 `userId`만 존재하며, 나머지 속성은 AI가 필요에 따라 자유롭게 생성·수정·확장할 수 있다.

```json
{
  "userId": "user-1234",

  "importantPeople": [
    {
      "name": "김종찬",
      "relationship": "멘토"
    }
  ],

  "frequentPlaces": [
    {
      "name": "SW 마에스트로 연수센터",
      "visitCount": 23
    }
  ],

  "preferences": {
    "wakeUpLate": true
  },

  "favoriteFoods": [
    "텐동",
    "족발"
  ]
}
```

### 2.8 Source Identity

Repair orchestration에서 특정 시간대나 특정 근거만 다시 분석하려면 raw data와 derived data를 source 단위로 식별할 수 있어야 한다.

따라서 각 input item은 가능한 한 `sourceId`를 가진다.

- raw data item은 자체 `sourceId`를 가진다.
- raw data에서 파생된 stay, movement 같은 derived item은 자체 `sourceId`와 `derivedFromSourceIds`를 가진다.
- Event의 `sourceRefs`는 이 `sourceId`를 참조한다.
- ReflectionIssue의 follow-up 대상도 전체 input이 아니라 관련 `sourceId` 목록으로 좁힌다.

이 규칙이 없으면 Repair Agent가 Sub-Agent를 다시 호출할 때 전체 location/photo/calendar 데이터를 다시 넘겨야 한다. source id가 있으면 `timeRange`와 `targetSourceRefs`만 넘겨 targeted re-analysis를 수행할 수 있다.

## 3. Event

`Event`는 서로 다른 raw data를 AI와 서버가 공통으로 다룰 수 있게 정규화한 단위다.

Location, Calendar, Photo, Sleep, Activity, Notification처럼 입력 데이터의 성격은 서로 다르지만, Timeline Agent가 하루를 만들 때는 모두 "특정 시간대에 있었을 가능성이 있는 일"로 다뤄야 한다. 따라서 각 Data-specific Event Agent는 자기 데이터에서 직접 설명할 수 있는 `Event` 후보를 만든다.

이 문서에서 말하는 `Event`는 최종 DB row를 의미하지 않는다. AI 생성 과정에서 사용하는 표준 후보 단위이며, 최종 Timeline Agent가 여러 `Event` 후보를 병합하거나 보정해 사용자가 보는 timeline event draft를 만든다.

기본 흐름은 다음과 같다.

```text
하루 raw data
  -> Data-specific Event Agent
  -> Event 후보
  -> Timeline Agent
  -> Timeline Event Draft 생성
  -> Backend Timeline Model
```

### 3.1 Event의 역할

`Event`는 다음 역할을 한다.

- 데이터별 Agent의 출력 형식을 통일한다.
- 서로 다른 source가 같은 일을 가리키는지 비교할 수 있게 한다.
- Timeline Agent가 병합, 충돌 판단, confidence 조정을 할 수 있게 한다.
- 최종 backend timeline model에 저장될 수 있는 구조로 이어진다.
- 근거와 불확실성을 event 단위로 보존한다.

### 3.2 Event Schema

초기 설계에서 기대하는 공통 형태는 다음과 같다.

```json
{
  "eventId": "event-location-001",
  "eventType": "MOVEMENT",
  "title": "집에서 학교로 이동",
  "description": "위치 로그를 바탕으로 집에서 경북대학교까지 이동한 것으로 추정됩니다.",
  "startTime": "2026-06-20T10:10:00+09:00",
  "endTime": "2026-06-20T11:00:00+09:00",
  "sourceRefs": [
    {
      "sourceType": "LOCATION",
      "sourceId": "movement-log-001"
    }
  ],
  "confidence": 0.86,
  "inferenceLevel": "EVIDENCE_BASED",
  "uncertainty": [
    "이동 수단은 GPS 속도와 이동 경로를 바탕으로 추정되었습니다."
  ]
}
```

필수적으로 기대하는 정보:

- event id
- event type
- title
- description
- start time
- end time
- source references
- confidence
- inference level
- uncertainty

### 3.3 Event Type

| Event Type | 의미 | 사용 기준 |
|---|---|---|
| `WAKE_UP` | 사용자가 잠에서 깬 event | sleep data, activity 시작, 기기 사용 시작 등으로 기상 시각을 판단할 수 있을 때 사용한다. |
| `SLEEP` | 수면 또는 취침 event | sleep session, 취침 시각, 장시간 비활동 데이터 등으로 수면 구간을 표현할 때 사용한다. |
| `STAY` | 특정 장소에 머문 event | 위치 데이터에서 일정 시간 이상 한 장소에 체류한 것이 확인되지만 활동 의미를 확정하기 어려울 때 사용한다. |
| `MOVEMENT` | 장소 간 이동 event | 위치 변화, 이동 경로, 속도, 교통수단 추정 등으로 이동 구간을 표현할 때 사용한다. |
| `CALENDAR_EVENT` | 캘린더에 등록된 일정 event | 일정이 존재한다는 사실을 표현한다. 실제 참석 여부는 location, photo 등 다른 근거와 결합해 판단한다. |
| `MEAL` | 식사 event | 음식 사진, 식당 체류, 결제, 일정/메모 등 식사 근거가 충분할 때 사용한다. 위치만으로는 보수적으로 판단한다. |
| `PHOTO_MOMENT` | 사진 중심의 순간 기록 event | 사진 자체가 의미 있는 기록이지만 식사, 모임, 수업 등 더 구체적 type으로 확정하기 어려울 때 사용한다. |
| `MEETING` | 회의, 멘토링, 미팅 event | 캘린더, 위치, 참가자 context, 관련 사진/알림 등을 통해 회의성 활동으로 볼 수 있을 때 사용한다. |
| `CLASS` | 수업, 강의, 시험 등 학업 일정 event | 캘린더나 학교 위치, 시간표 context를 통해 학업 관련 일정으로 볼 수 있을 때 사용한다. |
| `WORK` | 작업, 공부, 프로젝트 수행 event | 캘린더, 장시간 체류, 사용 앱/메모 등으로 작업성 활동을 추정할 수 있을 때 사용한다. 근거가 약하면 질문으로 남긴다. |
| `EXERCISE` | 운동 event | workout record, health data, 높은 활동량, 이동 패턴 등으로 운동이라고 볼 수 있을 때 사용한다. |
| `SOCIAL` | 사람을 만나거나 대화한 social event | 일정, 알림, 사진, 위치, 사용자 메모 등으로 만남이나 교류가 확인될 때 사용한다. 대화 내용은 근거 없이 단정하지 않는다. |
| `REST` | 휴식 event | 집 체류, 낮은 활동량, 수면/비활동, 사용자 메모 등으로 휴식으로 볼 수 있을 때 사용한다. 데이터만으로 감정이나 컨디션은 확정하지 않는다. |
| `UNKNOWN` | 의미를 확정할 수 없는 event | 시간/장소 등 최소 근거는 있지만 활동 type을 정하기 어려울 때 사용한다. 가능한 경우 question이나 warning과 함께 둔다. |

이 type은 UI 표현을 고정하기 위한 것이 아니라, Timeline Agent가 event를 병합하고 backend가 저장/필터링/분석하기 쉽게 만드는 내부 분류다.

예를 들어 위치 데이터만으로 식당 체류를 발견했다면 `STAY` 또는 낮은 confidence의 `MEAL` 후보가 될 수 있다. 음식 사진과 결제 정보가 같은 시간대에 함께 있으면 Timeline Agent가 이를 `MEAL` timeline event로 확정할 수 있다.

### 3.4 Inference Level

`confidence`는 0~1 사이의 점수이고, `inferenceLevel`은 그 event가 어떤 방식으로 만들어졌는지를 나타낸다.

초기 후보:

- `DIRECT`: source data가 직접 말해주는 event. 예: 캘린더 일정, 수면 시작/종료, 사진 촬영.
- `EVIDENCE_BASED`: 여러 근거를 조합해 만든 event. 예: 위치 체류 + 음식 사진 기반 저녁 식사.
- `INFERRED`: 근거는 있지만 해석이 필요한 event. 예: 위치 패턴 기반 이동 수단 추정.
- `UNCERTAIN`: 근거가 약하거나 충돌이 있어 질문이 필요한 event.

여기서 `inferenceLevel`은 AI가 하루 timeline을 추론하는 과정에서 사용하는 정보다. 사용자가 저장 전 직접 수정하거나 추가한 내용은 별도의 user edit/source 정보로 다룰 수 있지만, 초기 AI timeline 추론 단계의 `inferenceLevel`에는 포함하지 않는다.

이 정보는 반드시 UI에 그대로 노출할 필요는 없다. 다만 AI 내부 처리, server validation, 디버깅, 평가, 추후 사용자 질문 생성에는 필요하다.

### 3.5 Event와 Backend Timeline Model의 관계

AI의 `Event`는 backend 저장 모델과 다음 방식으로 연결된다.

```text
AI Event 후보들
  -> Timeline Agent가 병합/정렬/검증
  -> Timeline Event Draft
  -> App Server validation
  -> daily_records
  -> timeline_events
  -> timeline_items
```

역할 구분:

- `Event`: AI 생성 과정에서 사용하는 후보 단위.
- `Timeline Event Draft`: 사용자가 확인하고 수정할 수 있는 최종 초안 단위.
- `timeline_events`: backend에 저장되는 사용자-visible timeline 단위.
- `timeline_items`: timeline event를 뒷받침하는 source item 또는 typed payload 단위.

따라서 Data-specific Event Agent가 만든 `Event`를 그대로 DB에 저장하지 않는다. App Server는 Timeline Agent가 만든 최종 draft를 검증한 뒤, 저장 가능한 timeline model로 변환한다.

## 4. Expected Output

최종 output은 사용자가 검토하고 수정할 수 있는 하루 timeline draft다.

Output은 내부 Agent의 중간 판단을 노출하기 위한 것이 아니라, 앱에서 바로 보여주거나 저장 흐름으로 넘길 수 있는 결과여야 한다.

### 4.1 Timeline Draft

```json
{
  "userId": "user-1234",
  "date": "2026-06-20",
  "timezone": "Asia/Seoul",
  "events": [],
  "questions": [],
  "warnings": []
}
```

### 4.2 Timeline Event

각 event는 사용자가 하루를 이해하고 수정할 수 있을 정도의 정보를 포함한다.

```json
{
  "clientEventId": "event-001",
  "eventType": "MEAL",
  "title": "저녁 식사",
  "description": "식당 체류 기록과 음식 사진을 바탕으로 생성된 이벤트입니다.",
  "startTime": "2026-06-20T18:10:00+09:00",
  "endTime": "2026-06-20T18:52:00+09:00",
  "confidence": 0.88,
  "inferenceLevel": "EVIDENCE_BASED",
  "sourceRefs": [
    {
      "sourceType": "LOCATION",
      "sourceId": "stay-log-017"
    },
    {
      "sourceType": "PHOTO",
      "sourceId": "photo-001"
    }
  ],
  "uncertainty": []
}
```

필수적으로 기대하는 정보:

- event id
- event type
- title
- description
- start time
- end time
- confidence
- inference level
- source references
- uncertainty

### 4.3 Questions

Agent가 확정할 수 없는 내용은 임의로 채우지 않고 사용자에게 질문으로 남긴다.

```json
{
  "questionId": "question-001",
  "timeRange": {
    "startTime": "2026-06-20T15:20:00+09:00",
    "endTime": "2026-06-20T15:40:00+09:00"
  },
  "question": "이 시간대에 실제로 학교에 있었나요, 아니면 저장된 사진만 있었나요?",
  "reason": "위치 기록과 사진 metadata가 서로 충돌합니다.",
  "relatedEventIds": ["event-012"]
}
```

좋은 질문은 다음을 포함한다.

- 확인이 필요한 시간대
- 현재 시스템이 추정한 내용
- 왜 확정할 수 없는지
- 사용자의 답변이 어떤 event를 수정하는지

### 4.4 Warnings

결과 생성은 완료됐지만 품질이나 근거에 주의가 필요한 경우 warning을 남긴다.

예시:

- 위치 데이터가 부족함
- 사진 metadata가 신뢰하기 어려움
- 캘린더 일정과 위치 기록이 충돌함
- 일부 데이터 Agent가 실패함

## 5. Agent Structure

이 시스템은 데이터별 Event Agent, Timeline Agent, Reflection Agent, Repair Agent로 구성한다.

초기 생성의 주 흐름은 데이터별 Event Agent와 Timeline Agent, Reflection Agent 순서로 진행된다. Repair Agent는 이 초기 생성 경로에 먼저 등장하지 않고, Reflection 이후 해결 가능한 issue가 있을 때만 활성화된다.

입력이 존재하는 데이터별 Event Agent를 deterministic workflow로 병렬 실행하고, Timeline Agent가 그 결과를 합쳐 첫 timeline draft를 만든다. 이후 Reflection Agent가 첫 draft를 평가한다. Reflection 결과에서 충돌, 누락, 낮은 confidence, 과한 추론이 발견되면 Repair Agent가 어떤 Sub-Agent를 어떤 시간 범위와 질문으로 다시 호출할지 결정한다. 재호출 결과를 반영해 Timeline Agent가 영향을 받은 구간을 다시 구성하고, 수정된 timeline은 다시 Reflection Agent의 평가를 받는다.

즉 이 구조의 핵심은 다음과 같다.

```text
초기 생성:
  사용 가능한 모든 Event Agent 병렬 실행
  -> Timeline Agent가 초기 draft 생성
  -> Reflection Agent가 draft 평가

수정 루프:
  해결 가능한 issue가 있고 loop 한도에 도달하지 않은 동안 반복:
    Reflection 결과
      -> Repair Agent가 후속 호출 계획 생성
      -> Repair Agent가 선택된 Sub-Agent 제어
      -> Timeline Agent가 영향받은 timeline 구간 재구성
      -> Reflection Agent가 수정된 timeline 재평가
  종료 조건:
    중요한 issue가 남아 있지 않음
    또는 사용자 질문이나 warning으로 넘길 issue만 남음
    또는 loop 한도 도달
```

### 5.1 Data-specific Event Agents

각 데이터별 Agent는 자기 데이터에서 오늘 하루에 있었을 가능성이 있는 `Event` 후보를 만든다.

대상 Agent:

- Location Event Agent
- Calendar Event Agent
- Photo Event Agent
- Sleep Event Agent
- Activity Event Agent
- Notification Event Agent
- User Context Agent

각 Agent의 내부 처리 방식은 구현 과정에서 결정한다. 이 문서에서는 각 Agent가 최종 timeline 생성을 돕는 `Event` 후보 또는 context를 만든다는 책임만 정의한다.

각 Data-specific Event Agent의 공통 책임:

- 자기 데이터에 필요한 전처리와 해석을 수행한다.
- 자기 데이터에서 설명 가능한 `Event` 후보를 만든다.
- source reference와 evidence를 보존한다.
- 자기 데이터만으로 확정할 수 없는 내용은 `uncertainty`로 남긴다.
- 다른 데이터와의 최종 병합과 event 확정은 Timeline Agent에게 넘긴다.

예를 들어 Location Event Agent는 체류와 이동 후보를 만들 수 있지만, 식당 위치에 있었다는 이유만으로 실제 식사를 확정하지 않는다. Photo Event Agent는 음식 사진을 바탕으로 식사 후보를 강화할 수 있지만, 동행자나 감정은 임의로 확정하지 않는다.

### 5.2 Timeline Agent

Timeline Agent는 데이터별 Agent가 만든 `Event` 후보를 모아 하루 timeline draft를 만든다.

주요 책임:

- 같은 사건을 가리키는 결과를 합친다.
- 시간 순서대로 정리한다.
- 충돌하는 근거를 보수적으로 처리한다.
- confidence를 조정한다.
- inference level과 uncertainty를 조정한다.
- 확정할 수 없는 내용은 question으로 남긴다.
- 최종 timeline draft를 생성한다.
- follow-up 결과가 들어오면 영향받은 timeline 구간을 다시 구성한다.
- 재구성된 결과가 다시 Reflection 평가를 받을 수 있도록 넘긴다.

### 5.3 Reflection Agent

Reflection Agent는 Timeline Agent가 만든 timeline draft를 평가한다.

Reflection Agent의 목적은 더 그럴듯한 문장을 만드는 것이 아니라, timeline이 근거와 일관성을 지키는지 확인하는 것이다.

주요 책임:

- 같은 사건이 중복 생성되었는지 확인한다.
- 서로 양립할 수 없는 위치나 시간이 동시에 확정되었는지 확인한다.
- 캘린더 일정이 실제 참석으로 과도하게 표현되었는지 확인한다.
- 사진이나 알림에서 근거 없는 맥락이 추가되었는지 확인한다.
- 긴 공백 구간이 임의로 채워졌는지 확인한다.
- confidence와 inference level이 근거 수준에 비해 과한지 확인한다.
- 자동 재분석으로 해결 가능한 문제와 사용자 질문으로 넘겨야 할 문제를 구분한다.
- 재구성된 timeline을 다시 평가해 문제가 해결되었는지 확인한다.
- 같은 문제가 반복되면 추가 재호출 대신 warning 또는 user question으로 넘긴다.

Reflection Agent는 직접 Sub-Agent를 호출하지 않는다. 대신 Repair Agent가 사용할 수 있는 `ReflectionIssue[]`를 만든다.

### 5.3.1 ReflectionIssue Schema

`ReflectionIssue`는 Reflection Agent가 timeline draft를 평가한 결과다.

이 schema의 목적은 "timeline이 마음에 들지 않는다"는 모호한 평가를 Repair Agent가 실행 가능한 재오케스트레이션 입력으로 바꾸는 것이다. Repair Agent는 `recommendedAction`, `targetAgents`, `timeRange`, `targetEventIds`, `targetSourceRefs`를 보고 어떤 Sub-Agent를 어떤 source 범위로 다시 호출할지 결정한다.

```json
{
  "issues": [
    {
      "issueId": "issue-001",
      "severity": "HIGH",
      "issueType": "SOURCE_CONFLICT",
      "targetEventIds": ["event-012"],
      "timeRange": {
        "startTime": "2026-06-20T15:20:00+09:00",
        "endTime": "2026-06-20T15:40:00+09:00"
      },
      "targetSourceRefs": [
        {
          "sourceType": "LOCATION",
          "sourceId": "stay-log-017"
        },
        {
          "sourceType": "PHOTO",
          "sourceId": "photo-041"
        }
      ],
      "reason": "사진 metadata는 학교를 가리키지만 같은 시간대 위치 기록은 집 근처 체류로 해석되었습니다.",
      "recommendedAction": "RECALL_SUB_AGENT",
      "targetAgents": ["LocationEventAgent", "PhotoEventAgent"],
      "questionForAgents": "해당 시간대의 위치와 사진 metadata 신뢰도를 다시 평가해 주세요."
    }
  ]
}
```

필수적으로 기대하는 정보:

- `issueId`: Reflection loop 안에서 issue를 추적하기 위한 id
- `severity`: issue의 심각도
- `issueType`: 충돌, 누락, 과한 추론, 중복 등 문제 유형
- `targetEventIds`: 문제가 연결된 timeline event id
- `timeRange`: 재분석이 필요한 시간 범위
- `targetSourceRefs`: 재분석에 필요한 source id 목록
- `reason`: 왜 문제가 있다고 판단했는지
- `recommendedAction`: Repair Agent가 취해야 할 다음 행동
- `targetAgents`: 재호출 후보 Sub-Agent

초기 `recommendedAction` 후보:

- `RECALL_SUB_AGENT`: 특정 Sub-Agent를 다시 호출해 재분석한다.
- `RE_SYNTHESIZE_TIMELINE`: Sub-Agent 재호출 없이 Timeline Agent가 다시 합성한다.
- `ASK_USER`: 자동으로 확정할 수 없어 사용자 질문으로 넘긴다.
- `WARN_ONLY`: 저장은 가능하지만 warning으로 남긴다.
- `IGNORE`: 낮은 중요도의 issue로 무시한다.

초기 `issueType` 후보:

- `SOURCE_CONFLICT`
- `MISSING_EVIDENCE`
- `OVERCONFIDENT_INFERENCE`
- `DUPLICATED_EVENT`
- `BAD_MERGE`
- `TIME_RANGE_ERROR`
- `UNSUPPORTED_CONTEXT`
- `LOW_CONFIDENCE`

Repair Agent는 이 schema를 직접 실행 계획으로 해석한다. 예를 들어 `recommendedAction`이 `RECALL_SUB_AGENT`이고 `targetAgents`가 존재하면, Repair Agent는 해당 `timeRange`, `targetSourceRefs`, `questionForAgents`를 포함해 필요한 Sub-Agent만 다시 호출한다.

Repair 단계에서는 전체 raw data를 다시 넘기지 않는다. `targetSourceRefs`에 포함된 source와, 해당 source를 해석하는 데 필요한 최소 주변 context만 전달한다.

반대로 `ASK_USER`, `WARN_ONLY`, `IGNORE`는 추가 Sub-Agent 호출 없이 final output의 `questions` 또는 `warnings`로 전환될 수 있다.

### 5.4 Repair Agent

Repair Agent는 Reflection 이후의 repair loop를 조정한다.

초기 pass에서는 Repair Agent가 모든 Sub-Agent 호출을 동적으로 계획하지 않는다. 입력 존재 여부와 고정된 실행 정책으로 baseline Agent들을 병렬 실행하면 충분하다.

Repair Agent가 중요해지는 지점은 Reflection 이후다. Reflection Agent가 `ReflectionIssue[]`를 반환하면, Repair Agent는 그 문제를 해결하기 위한 follow-up orchestration을 수행한다.

주요 책임:

- Reflection 결과를 읽고 해결 가능한 issue를 구분한다.
- 어떤 Sub-Agent를 다시 호출할지 결정한다.
- 재호출할 time range, source id, 질문을 지정한다.
- 불필요한 재호출을 막고 loop 횟수를 제한한다.
- follow-up 결과를 Timeline Agent에게 넘겨 재구성을 요청한다.
- 재구성된 timeline을 다시 Reflection 단계로 넘길지 종료할지 결정한다.
- 자동으로 해결할 수 없는 문제는 사용자 질문으로 남긴다.

## 6. Processing Direction

MVP에서는 단순하고 예측 가능한 흐름을 우선한다.

기본 흐름:

```text
입력 데이터
  -> 사용 가능한 데이터 타입 확인
  -> 사용 가능한 모든 Data-specific Event Agent 병렬 실행
  -> Event 후보 수집
  -> Timeline Agent가 초기 timeline draft 생성
  -> Reflection 루프
      해결 가능한 issue가 있고 loop 한도에 도달하지 않은 동안 반복:
        Repair Agent가 선택된 Sub-Agent에 targetSourceRefs 중심으로 재호출
        Timeline Agent가 영향받은 timeline 구간 재구성
        Reflection Agent가 수정된 timeline 재평가
      loop 종료 조건 확인
  -> 최종 output 반환
```

초기 구현에서는 모든 세부 orchestration을 복잡하게 만들 필요가 없다. 데이터가 존재하면 해당 Agent를 실행하고, 결과를 Timeline Agent가 합치는 구조로 시작한다.

### 6.1 Structure 고민

초기 아이디어에서는 모든 raw data를 시간순으로 보면서 상위 Orchestrator가 매 순간 필요한 Sub-Agent를 선택하는 방식도 생각할 수 있다.

```text
하루 전체 데이터
  -> 시간순 정렬
  -> 상위 Orchestrator가 구간별로 필요한 Agent 선택
  -> Event를 하나씩 구성
  -> 최종 timeline 생성
```

하지만 이 방식은 MVP 기본 구조로는 복잡하다.

- 시간 window를 어떻게 나눌지 자체가 어렵다.
- 앞 구간의 잘못된 판단이 뒤 구간에 영향을 줄 수 있다.
- Agent 호출 횟수와 latency가 늘어날 수 있다.
- 병렬화가 어렵다.
- 하루 전체 맥락을 늦게 보게 되어 global conflict를 놓칠 수 있다.

반대로 데이터별 Agent를 모두 한 번씩 병렬 실행하고 결과를 한 번에 합치는 방식은 단순하고 예측 가능하다.

```text
기본 병렬 처리

Location Data ----> Location Event Agent ----┐
Photo Data -------> Photo Event Agent -------|
Calendar Data ----> Calendar Event Agent ----|--> Event 후보 Pool
Sleep Data -------> Sleep Event Agent -------|        |
Activity Data ----> Activity Event Agent ----|        v
Notification Data -> Notification Agent -----┘   Timeline Agent
                                                      |
                                                      v
                                            초기 Timeline Draft
                                                      |
                                                      v
                                             +------------------+
                          +----------------->| Reflection Agent |
                          |                  +------------------+
                          |                       |          |
                          |                       |          +-- 중요한 issue 없음
                          |                       |          |   또는 loop 종료
                          |                       |          v
                          |                       |   최종 Draft /
                          |                       |   User Question
                          |                       |
                          |                       +-- 해결 가능한 issue
                          |                               |
                          |                               v
                          |                        +---------------------+
                          |                        | Repair Agent |
                          |                        +---------------------+
                          |                               |
                          |                               v
                          |                  후속 Sub-Agent 호출
                          |                  Location / Photo / Calendar / ...
                          |                               |
                          |                               v
                          |                  갱신된 Event 후보
                          |                               |
                          |                               v
                          +------ 수정된 timeline -- Timeline Agent
                                                   영향받은 구간 재구성
```

단순 병렬 합성만으로 끝내면 candidate 간 충돌을 발견했을 때 특정 source를 다시 해석하도록 요청하는 경로가 약하다. 그래서 위 구조처럼 Reflection 이후 Repair Agent가 필요한 Sub-Agent와 source만 다시 호출하고, 재구성된 timeline을 다시 Reflection으로 돌려보내는 repair loop를 붙인다.

따라서 MVP 기본 구조는 다음으로 둔다.

```text
초기 생성 = 고정 병렬 workflow
수정과 개선 = 선택적 Agent 재오케스트레이션
```

즉 초기 생성은 입력이 존재하는 데이터별 Agent를 고정 규칙으로 병렬 실행하고, Timeline Agent가 한 번에 합친다. 이후 Reflection Agent가 초기 timeline을 평가한다. 평가 결과에서 충돌, 누락, 낮은 confidence가 발견되면 Repair Agent가 필요한 Agent만 특정 시간 범위와 source id 범위로 다시 호출하고, Timeline Agent가 해당 구간을 다시 구성한다. 재구성된 timeline은 다시 Reflection Agent가 평가하며, 문제가 해결되었거나 loop 한도에 도달하면 최종 결과를 반환한다.

이 구조를 `Batch Synthesis + Selective Re-orchestration`으로 정의한다.

```text
하루 입력 데이터
  -> 데이터 타입별 정규화와 분리
  -> 사용 가능한 Data-specific Event Agent 실행
  -> Event[] 수집
  -> Timeline Agent가 초기 timeline draft 생성
  -> Reflection Agent가 초기 timeline 평가
      -> 중요한 issue 없음
          -> 최종 timeline draft
      -> 해결 가능한 issue 존재
          -> 제한된 repair loop 진입
              해결 가능한 issue가 있고 loop 한도에 도달하지 않은 동안 반복:
                -> Repair Agent가 후속 호출 계획 생성
                -> Repair Agent가 targetSourceRefs 기준으로 필요한 Event Agent만 재호출
                -> 영향받은 Event 후보 갱신
                -> Timeline Agent가 영향받은 timeline 구간 재구성
                -> Reflection Agent가 수정된 timeline 평가
          -> 최종 timeline draft 또는 user question
```

초기 pass에서는 별도 동적 orchestrator 판단에 의존하지 않는다. 입력 존재 여부와 고정된 실행 정책만으로 baseline Agent를 병렬 실행한다. Repair Agent의 동적 orchestration은 Reflection 이후 실제로 의미가 생기는 conflict resolution과 follow-up 단계에 집중한다.

다만 다음 경우에는 추가 분석 또는 사용자 질문이 필요할 수 있다.

- 서로 다른 데이터가 같은 시간대에 충돌할 때
- 중요한 시간대의 근거가 부족할 때
- Agent 결과의 confidence가 낮을 때
- event를 확정하면 hallucination 위험이 있을 때

## 7. Design Principles

- Input data는 원본 근거로 취급한다.
- Agent는 근거 없는 event를 만들지 않는다.
- User Memory Data는 보조 context이며, 단독으로 실제 사건을 확정하지 않는다.
- Timeline은 사용자가 수정하기 쉬워야 한다.
- 불확실성은 숨기지 않고 `uncertainty`, `question`, `warning`으로 표현한다.
- Reflection은 생성 결과를 비판적으로 평가하고, Repair Agent는 그 평가를 바탕으로 필요한 Sub-Agent만 다시 호출한다.
- 재오케스트레이션으로 수정된 timeline은 다시 Reflection 평가를 거친 뒤에만 최종 후보가 된다.
- 모든 event는 가능한 한 source reference를 가져야 한다.
- confidence와 inference level은 UI 노출 여부와 별개로 내부 검증과 평가를 위해 유지한다.
- 내부 schema와 세부 상태 관리는 구현하면서 정한다.

## 8. MVP Success Criteria

- 하루 timeline draft가 안정적으로 생성된다.
- 생성된 event가 source data에 근거한다.
- 사용자가 수정 가능한 timeline, event 단위로 결과가 나온다.
- Data-specific Event Agent가 공통 `Event` 형식의 후보를 반환한다.
- Timeline Agent가 여러 `Event` 후보를 병합해 backend timeline model로 변환 가능한 draft를 만든다.
- Reflection Agent가 timeline draft의 충돌, 누락, 과한 추론을 정확하게 평가한다.
- Repair Agent가 Reflection 결과를 바탕으로 필요한 Sub-Agent만 선택적으로 재호출한다.
- 재호출 후 Timeline Agent가 영향을 받은 timeline 구간을 다시 구성한다.
- 재구성된 timeline을 Reflection Agent가 다시 평가하고, 설정된 loop 한도 안에서 종료한다.
- 데이터가 부족한 날에도 최소한의 timeline과 warning을 반환한다.

## 9. Evaluation and Observability

Agent 구조는 생성 결과만 보는 방식으로는 개선하기 어렵다. 개발 단계에서는 테스트 입력, 각 Agent의 중간 Event, Timeline Agent의 합성 결과, ReflectionIssue, 재오케스트레이션 결과를 모두 수집하고 평가할 수 있어야 한다.

이 섹션은 두 가지를 다룬다.

- Evaluation: 우리가 만든 test suite에 대해 결과 품질을 판단하고 기록하는 체계
- Observability: 개발과 디버깅 과정에서 각 Agent와 workflow에서 벌어지는 일을 관제하는 체계

### 9.1 Test Suite

초기에는 실제 Laimory 하루 데이터 예시를 기반으로 test case를 직접 작성한다.

각 test case는 다음을 포함한다.

- input fixture
  - location data
  - calendar data
  - photo data
  - sleep data
  - activity data
  - notification data
  - user memory data
- expected behavior
  - 반드시 생성되어야 하는 event
  - 생성되면 안 되는 hallucinated event
  - 질문으로 남겨야 하는 불확실한 구간
  - warning으로 남겨야 하는 데이터 품질 문제
  - Reflection이 발견해야 하는 issue
  - 재호출되어야 하는 Sub-Agent

Test case category:

- 데이터가 풍부한 날
- 데이터가 거의 없는 날
- 이동이 많은 날
- 사진과 위치가 충돌하는 날
- 캘린더 일정과 실제 위치가 충돌하는 날
- 긴 공백 시간이 있는 날
- 같은 사건이 여러 Agent에서 중복 생성되는 날
- Reflection 후 재오케스트레이션이 필요한 날
- 사용자 질문 없이는 확정할 수 없는 날

### 9.2 LLM Judge Evaluation

Reflection은 runtime에서 timeline draft를 개선하기 위한 내부 평가다.

개발 test suite에서는 별도의 LLM judge를 사용해 최종 결과와 중간 결과를 평가할 수 있다. 이 judge는 production Reflection Agent와 같은 역할을 할 수도 있지만, 목적은 다르다.

- Reflection Agent: 현재 생성 중인 timeline을 개선하기 위한 loop 내부 evaluator
- Test Judge: test suite 결과를 채점하고 실험 결과를 기록하기 위한 evaluator

LLM judge는 test case별 판단 기준을 입력으로 받아 다음 항목을 평가한다.

- groundedness: 생성된 event가 source data에 근거하는가
- hallucination: source에 없는 사건을 만들었는가
- event coverage: 중요한 source event를 누락하지 않았는가
- merge quality: 같은 사건을 적절히 병합했는가
- time accuracy: 시간 범위가 source data와 맞는가
- uncertainty handling: 모르는 내용을 질문이나 warning으로 남겼는가
- reflection quality: ReflectionIssue가 실제 문제를 잘 잡았는가
- re-orchestration quality: 재호출한 Sub-Agent와 time range가 적절했는가
- final usefulness: 사용자가 수정 가능한 timeline draft로 보기 쉬운가

평가 결과는 구조화해서 저장한다.

```json
{
  "testCaseId": "case-rich-soma-day-001",
  "runId": "run-2026-06-27-001",
  "scores": {
    "groundedness": 0.92,
    "hallucination": 0.0,
    "eventCoverage": 0.84,
    "mergeQuality": 0.81,
    "timeAccuracy": 0.88,
    "uncertaintyHandling": 0.76,
    "reflectionQuality": 0.8,
    "reOrchestrationQuality": 0.75,
    "finalUsefulness": 0.83
  },
  "judgeComments": [
    "저녁 식사 event는 사진과 위치 근거가 모두 있어 적절합니다.",
    "18:30~20:30 구간은 대화 내용까지 확정하지 않고 question으로 남기는 편이 안전합니다."
  ],
  "failedExpectations": [
    "calendar-location conflict should have produced a ReflectionIssue"
  ]
}
```

이 평가는 자동 점수만으로 끝내지 않는다. 개발 초기에는 사람이 일부 결과를 직접 검토해 LLM judge의 판단도 함께 보정한다.

### 9.3 Runtime Trace and Logs

개발과 디버깅 과정에서는 각 Agent와 workflow에서 벌어지는 일을 최대한 남긴다. 초기에는 많이 기록하고, 민감 정보와 비용 문제가 보이면 필요한 항목만 남기는 방향으로 줄인다.

각 run은 하나의 `runId`를 가진다.

기록 대상:

- input summary
- baseline execution plan
- 각 Data-specific Event Agent input summary
- 각 Data-specific Event Agent output Event[]
- Timeline Agent initial draft
- ReflectionIssue[]
- Repair Agent follow-up plan
- follow-up targetSourceRefs
- follow-up Sub-Agent input summary
- follow-up Sub-Agent output Event[]
- affected window rebuild result
- Reflection loop round별 결과
- final timeline draft
- questions
- warnings
- error
- latency
- token usage
- model name
- tool call
- retry/timeout

민감한 원문 payload는 그대로 저장하지 않는다. 알림 본문, 사진 설명, 위치 좌표처럼 민감할 수 있는 값은 masking, hashing, summary 저장 중 하나를 선택한다.

### 9.4 Trace Event Schema

관제를 위해 각 단계는 공통 trace event 형태로 남긴다.

```json
{
  "runId": "run-2026-06-27-001",
  "traceId": "trace-001",
  "nodeName": "PhotoEventAgent",
  "phase": "BASELINE",
  "round": 0,
  "startedAt": "2026-06-27T22:10:00+09:00",
  "endedAt": "2026-06-27T22:10:04+09:00",
  "status": "SUCCESS",
  "inputSummary": {
    "photoCount": 12,
    "timeRange": "2026-06-27T00:00:00+09:00/2026-06-28T03:00:00+09:00"
  },
  "outputSummary": {
    "eventCount": 4,
    "warningCount": 1
  },
  "model": "text-or-vision-model-name",
  "tokenUsage": {
    "inputTokens": 1200,
    "outputTokens": 420
  },
  "latencyMs": 4100,
  "error": null
}
```

`phase` 후보:

- `BASELINE`
- `INITIAL_SYNTHESIS`
- `REFLECTION`
- `FOLLOW_UP_PLAN`
- `FOLLOW_UP_AGENT`
- `RE_SYNTHESIS`
- `FINALIZATION`

### 9.5 Observability Tools

LangSmith, Langfuse 같은 LLM observability 도구를 사용할 수 있다.

도구 선택과 무관하게 반드시 필요한 것은 다음이다.

- run 단위 trace
- node 단위 input/output summary
- model call 기록
- Reflection loop round 기록
- test case별 evaluation score
- 실패 case 검색
- 같은 input에 대한 run 비교

도구는 저장과 시각화를 돕는 수단이다. 핵심은 각 Agent의 입출력과 Reflection loop의 판단 과정을 재현 가능하게 남기는 것이다.
