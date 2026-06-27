---
title: Mobile Data Extraction Payload Structure
kind: answer
status: draft
updated: 2026-06-27
tags: [laimory, android, mobile-data, payload, timeline, api-contract]
---

# Mobile Data Extraction Payload Structure

## Scope

This page proposes a first server-send structure for mobile data extracted by the `Laboratory` Android project. It is based on the current lab models for photos, calendar events, notifications, Health Connect records, Samsung Health sleep, and Samsung Health steps.

The shape is intentionally aligned with Laimory's timeline draft direction: the app sends a daily batch of source items, each source item has a request-local `itemId`, an `itemType`, local `startAt`/`endAt`, a short `summary`, and a typed `payload`.

The first documented upload candidates are photos, sleep, calendar events, and filtered notifications. Location is included as an expected design, not as current `Laboratory` implementation.

## Batch Envelope

```json
{
  "recordAnchorAt": "2026-06-27T23:30:00+09:00",
  "recordTimeZone": "Asia/Seoul",
  "clientBatchId": "android-20260627-233000-01",
  "sourceItems": []
}
```

Priority scale:

| Priority | Meaning |
|---|---|
| Required | Needed for server storage, AI grouping, or time ordering |
| Important | Directly affects timeline quality or diary context |
| Supporting | Useful for display, debugging, or later product work, but not necessary for MVP behavior |
| Caution/exclude | Sensitive, duplicate, or low-value enough to omit by default or require opt-in |

## Type Summary

| itemType | Status | Meaning | Core time | Priority |
|---|---|---|---|---|
| `PHOTO` | Implemented | Photo metadata from Android MediaStore | taken time | Important |
| `SLEEP_SESSION` | Implemented | Health Connect sleep session | sleep start/end | Important |
| `CALENDAR_EVENT` | Implemented | User event, holiday, or solar term | event start/end | Required |
| `NOTIFICATION` | Implemented | Filtered app notification | post time | Important/caution |
| `LOCATION_STAY` | Expected | Staying in one area for tens of minutes | stay start/end | Important |
| `LOCATION_MOVE` | Expected | Moving between areas for several minutes | move start/end | Important |

## PHOTO

```json
{
  "itemId": 0,
  "itemType": "PHOTO",
  "startAt": "2026-06-27T09:12:33",
  "endAt": null,
  "summary": "Camera photo IMG_20260627_091233.jpg",
  "payload": {
    "mediaStoreId": 1000012345,
    "name": "IMG_20260627_091233.jpg",
    "dateTaken": 1782522753000,
    "mimeType": "image/jpeg",
    "bucketName": "Camera",
    "width": 4032,
    "height": 3024,
    "gps": {
      "latitude": 37.5665,
      "longitude": 126.978
    }
  }
}
```

| Field | Priority | Meaning |
|---|---|---|
| `itemId`, `itemType`, `startAt`, `summary` | Required | Common source item fields |
| `mediaStoreId` or local client ID | Required | Client-local dedupe/provenance |
| `name`, `dateTaken` | Required | Photo identification and ordering |
| `bucketName`, `mimeType`, `gps` | Important | Context and place inference |
| `width`, `height` | Important | Helps judge image quality or screenshot-like cases |
| `uri`, `size`, `orientation`, `isFavorite`, `relativePath` | Supporting | Display/debugging. `content://` is not backend-readable media |
| Original image or thumbnail bytes | Caution/exclude | Needs separate consent, storage, and security policy |

## SLEEP_SESSION

```json
{
  "itemId": 1,
  "itemType": "SLEEP_SESSION",
  "startAt": "2026-06-26T23:50:00",
  "endAt": "2026-06-27T07:30:00",
  "summary": "460 minutes sleep from Samsung Health",
  "payload": {
    "totalMinutes": 460,
    "originPackage": "com.sec.android.app.shealth",
    "fromSamsungHealth": true,
    "stages": [
      { "label": "깊은 수면", "minutes": 90 },
      { "label": "렘(REM)", "minutes": 80 },
      { "label": "얕은 수면", "minutes": 260 },
      { "label": "깨어있음", "minutes": 30 }
    ]
  }
}
```

| Field | Priority | Meaning |
|---|---|---|
| `itemId`, `itemType`, `startAt`, `endAt`, `summary` | Required | Sleep is a duration item |
| `totalMinutes` | Required | Core value for reflection and condition inference |
| `originPackage`, `fromSamsungHealth` | Important | Samsung Health origin verification |
| `stages[]` | Important | Qualitative sleep context |
| `title` | Supporting | Display-only when Health Connect provides it |
| Missing stage detail | Caution/exclude | MVP can start with total sleep time only |

## CALENDAR_EVENT

```json
{
  "itemId": 2,
  "itemType": "CALENDAR_EVENT",
  "startAt": "2026-06-27T14:00:00",
  "endAt": "2026-06-27T15:00:00",
  "summary": "팀 미팅 at 회의실 A",
  "payload": {
    "eventId": 42,
    "title": "팀 미팅",
    "location": "회의실 A",
    "allDay": false,
    "timezone": "Asia/Seoul",
    "eventType": "USER"
  }
}
```

| Field | Priority | Meaning |
|---|---|---|
| `itemId`, `itemType`, `startAt`, `endAt`, `summary` | Required | Calendar events are strong timeline anchors |
| `eventId`, `title` | Required | Event identity and reflection context |
| `location`, `allDay`, `timezone`, `eventType` | Important | Place, all-day handling, holiday/solar-term classification |
| `calendarId`, `calendarName`, `rrule`, `status` | Supporting | Source, recurrence, and state checks |
| Long `description` | Caution/exclude | May need summary, masking, or opt-in |

## NOTIFICATION

```json
{
  "itemId": 3,
  "itemType": "NOTIFICATION",
  "startAt": "2026-06-27T16:20:10",
  "endAt": null,
  "summary": "카카오톡 notification from 홍길동",
  "payload": {
    "packageName": "com.kakao.talk",
    "appName": "카카오톡",
    "title": "홍길동",
    "text": "안녕하세요",
    "postTime": 1782544810000,
    "matchedFilter": {
      "type": "PACKAGE",
      "value": "com.kakao.talk"
    }
  }
}
```

| Field | Priority | Meaning |
|---|---|---|
| `itemId`, `itemType`, `startAt`, `summary` | Required | Notification occurrence and short context |
| `packageName`, `appName`, `postTime`, `matchedFilter` | Required | App source and collection rule |
| `title`, `text` | Important/caution | High context value, high sensitivity |
| `key`, `subText`, `isClearable`, `isOngoing`, `collectedAt` | Supporting | Dedupe, debugging, and display |
| Full unfiltered notification text | Caution/exclude | Default no-send candidate; require allow-list/keyword match |

## LOCATION_STAY Expected

Not implemented yet. This expected item means the device appears to stay in roughly the same area for tens of minutes. The initial threshold below is only a documentation placeholder.

```json
{
  "itemId": 4,
  "itemType": "LOCATION_STAY",
  "startAt": "2026-06-27T10:20:00",
  "endAt": "2026-06-27T11:35:00",
  "summary": "Stayed near 강남역 for 75 minutes",
  "payload": {
    "placeLabel": "강남역 근처",
    "latitude": 37.4979,
    "longitude": 127.0276,
    "accuracyMeters": 80,
    "durationMinutes": 75,
    "stayThresholdMinutes": 30,
    "detectionStatus": "EXPECTED_NOT_IMPLEMENTED"
  }
}
```

| Field | Priority | Meaning |
|---|---|---|
| `itemId`, `itemType`, `startAt`, `endAt`, `summary` | Required | Stay is a duration item |
| `latitude`, `longitude`, `durationMinutes` | Required | Core stay evidence |
| `placeLabel`, `accuracyMeters` | Important | Human-readable place and confidence |
| `stayThresholdMinutes`, `detectionStatus` | Supporting | Experiment/debugging metadata |
| Full precise GPS trail | Caution/exclude | High battery, privacy, and policy risk |

## LOCATION_MOVE Expected

Not implemented yet. This expected item means the device appears to move meaningfully between areas for several minutes. Transport mode can start as `unknown`.

```json
{
  "itemId": 5,
  "itemType": "LOCATION_MOVE",
  "startAt": "2026-06-27T13:30:00",
  "endAt": "2026-06-27T13:52:00",
  "summary": "Moved from 강남역 근처 to 선릉역 근처 for 22 minutes",
  "payload": {
    "from": {
      "label": "강남역 근처",
      "latitude": 37.4979,
      "longitude": 127.0276
    },
    "to": {
      "label": "선릉역 근처",
      "latitude": 37.5045,
      "longitude": 127.0490
    },
    "durationMinutes": 22,
    "distanceMeters": 2300,
    "moveThresholdMinutes": 5,
    "transportMode": "unknown",
    "detectionStatus": "EXPECTED_NOT_IMPLEMENTED"
  }
}
```

| Field | Priority | Meaning |
|---|---|---|
| `itemId`, `itemType`, `startAt`, `endAt`, `summary` | Required | Move is a duration item |
| `from`, `to`, `durationMinutes` | Required | Movement endpoints and duration |
| `distanceMeters`, `transportMode` | Important | Movement scale and context |
| `moveThresholdMinutes`, `detectionStatus` | Supporting | Experiment/debugging metadata |
| Second-by-second GPS trail | Caution/exclude | Do not include in default payload |

## Human-Readable Example

| itemId | itemType | Time | Summary | Key payload |
|---:|---|---|---|---|
| 0 | `PHOTO` | 2026-06-27 09:12 | Camera photo `IMG_20260627_091233.jpg` | Camera album, GPS present |
| 1 | `SLEEP_SESSION` | 2026-06-26 23:50-2026-06-27 07:30 | 460 minutes sleep | Samsung Health, stage breakdown |
| 2 | `CALENDAR_EVENT` | 2026-06-27 14:00-15:00 | Team meeting at Meeting Room A | User calendar event |
| 3 | `NOTIFICATION` | 2026-06-27 16:20 | KakaoTalk notification from 홍길동 | Package filter matched |
| 4 | `LOCATION_STAY` | 2026-06-27 10:20-11:35 | Stayed near 강남역 for 75 minutes | Expected design |
| 5 | `LOCATION_MOVE` | 2026-06-27 13:30-13:52 | 강남역 근처 to 선릉역 근처 | Expected design |

## Implementation Notes

- The backend timeline draft DTO already points toward `itemType + payload` as sibling fields. Keep `itemType` outside `payload` and let the server validate that the payload subtype matches it.
- For sleep, prefer the structured `SleepSessionDetail` shape over generic localized `HealthRecordRow(time, summary)` strings.
- For notifications, the lab's SQLite filter model is a good MVP safety gate: collect/send only if a package or keyword rule matches.
- For photos, decide separately whether the backend receives metadata only, thumbnail bytes, or full media upload. The metadata payload above assumes metadata-only.
- For location, `LOCATION_STAY` and `LOCATION_MOVE` are expected designs only. They should stay marked as not implemented until Android collection and threshold logic exist.
- For AI prompt construction, `summary` should be concise and privacy-aware; the raw `payload` remains available for deterministic server logic and future evaluation.

## Linked Sources

- [[2026-06-27-github-laboratory-mobile-data-extraction]]
- [[2026-06-16-notes-timeline-card-grouping-design]]
- [[2026-06-19-notes-timeline-implementation-reconciliation]]

## Related Pages

- [[laimory]]
- [[android-life-logging-data-collection]]
