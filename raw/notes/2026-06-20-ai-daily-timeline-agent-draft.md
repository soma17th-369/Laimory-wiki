# AI Daily Timeline Agent Architecture

Date: 2026-06-20  
Last Updated: 2026-06-25  
Status: revised draft  
Feature: Laimory AI Daily Timeline

## 1. Overview

AI Daily Timeline Agent는 하루 동안 수집된 여러 종류의 데이터를 바탕으로, 사용자가 확인하고 수정할 수 있는 하루 타임라인 초안을 생성하는 시스템이다.

이 문서의 목적은 내부 구현 세부사항을 확정하는 것이 아니라, Agent가 어떤 입력을 받고 어떤 결과를 만들어야 하는지 정의하는 것이다. 각 Agent의 내부 상태, 세부 schema, patch 방식, 평가 metric은 구현 과정에서 별도 문서나 코드로 구체화한다.

핵심 목표는 다음과 같다.

- 여러 종류의 하루 데이터를 event 단위로 해석한다.
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
      "photoId": "photo-001",
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
      "appName": "카카오톡",
      "title": "친구",
      "content": "산책하자",
      "receivedAt": "2026-06-20T18:00:00"
    },
    {
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
## 3. Expected Output

최종 output은 사용자가 검토하고 수정할 수 있는 하루 timeline draft다.

Output은 내부 Agent의 중간 판단을 노출하기 위한 것이 아니라, 앱에서 바로 보여주거나 저장 흐름으로 넘길 수 있는 결과여야 한다.

### 3.1 Timeline Draft

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

### 3.2 Timeline Event

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
  "sourceRefs": [],
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
- source references
- uncertainty

### 3.3 Questions

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

### 3.4 Warnings

결과 생성은 완료됐지만 품질이나 근거에 주의가 필요한 경우 warning을 남긴다.

예시:

- 위치 데이터가 부족함
- 사진 metadata가 신뢰하기 어려움
- 캘린더 일정과 위치 기록이 충돌함
- 일부 데이터 Agent가 실패함

## 4. Agent Structure

이 시스템은 데이터별 Event Agent와 Timeline Agent로 구성한다.

### 4.1 Data-specific Event Agents

각 데이터별 Agent는 자기 데이터에서 오늘 하루에 있었을 가능성이 있는 event 후보를 만든다.

대상 Agent:

- Location Event Agent
- Calendar Event Agent
- Photo Event Agent
- Sleep Event Agent
- Activity Event Agent
- Notification Event Agent
- User Context Agent

각 Agent의 내부 처리 방식은 구현 과정에서 결정한다. 이 문서에서는 각 Agent가 최종 timeline 생성을 돕는 event 후보 또는 context를 만든다는 책임만 정의한다.

### 4.2 Timeline Agent

Timeline Agent는 데이터별 Agent가 만든 결과를 모아 하루 timeline draft를 만든다.

주요 책임:

- 같은 사건을 가리키는 결과를 합친다.
- 시간 순서대로 정리한다.
- 충돌하는 근거를 보수적으로 처리한다.
- confidence를 조정한다.
- 확정할 수 없는 내용은 question으로 남긴다.
- 최종 timeline draft를 생성한다.

## 5. Processing Direction

MVP에서는 단순하고 예측 가능한 흐름을 우선한다.

기본 흐름:

```text
Input Data
  -> available data type 확인
  -> 해당 Data-specific Event Agent 실행
  -> Agent 결과 수집
  -> Timeline Agent가 timeline draft 생성
  -> validation
  -> expected output 반환
```

초기 구현에서는 모든 세부 orchestration을 복잡하게 만들 필요가 없다. 데이터가 존재하면 해당 Agent를 실행하고, 결과를 Timeline Agent가 합치는 구조로 시작한다.

다만 다음 경우에는 추가 분석 또는 사용자 질문이 필요할 수 있다.

- 서로 다른 데이터가 같은 시간대에 충돌할 때
- 중요한 시간대의 근거가 부족할 때
- Agent 결과의 confidence가 낮을 때
- event를 확정하면 hallucination 위험이 있을 때

## 6. Design Principles

- Input data는 원본 근거로 취급한다.
- Agent는 근거 없는 event를 만들지 않는다.
- User Memory Data는 보조 context이며, 단독으로 실제 사건을 확정하지 않는다.
- Timeline은 사용자가 수정하기 쉬워야 한다.
- 불확실성은 숨기지 않고 `uncertainty`, `question`, `warning`으로 표현한다.
- 내부 schema와 세부 상태 관리는 구현하면서 정한다.

## 7. MVP Success Criteria

- 하루 timeline draft가 안정적으로 생성된다.
- 생성된 event가 source data에 근거한다.
- 사용자가 수정 가능한 event 단위로 결과가 나온다.
- 불확실한 내용은 질문으로 남긴다.
- 명백한 hallucinated event를 만들지 않는다.
- 데이터가 부족한 날에도 최소한의 timeline과 warning을 반환한다.


### 멘토님 질문
- 그래서 이런 구조를 선택했는데 괜찮은 거 같은가?
- 이제 세부 Agent 들은 따로 설계 문서를 작성 해야 될 거 같다.
- 원래 Agent 를 구현할 때 어떤 식으로 설계를 하는가?