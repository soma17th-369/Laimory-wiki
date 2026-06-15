---
source_type: notion
source_url: https://app.notion.com/p/6d5cdc4d240a8356bf0e81b86fb61b45
title: 백그운드 위치 가져오기
captured_at: 2026-06-15
capture_method: Notion MCP fetch
status: raw-text-snapshot
---

# 백그운드 위치 가져오기

## 안드로이드 백그라운드 위치: 현실적인 정리

### OS 제약

Android 8.0 (Oreo) 이후:

- 백그라운드 앱의 위치 업데이트를 시간당 몇 번으로 제한.
- Doze 모드 진입 시 GPS 접근 차단.

Android 10 이후:

- `ACCESS_BACKGROUND_LOCATION` 권한 별도 요청 필수.
- 구글 플레이 정책상 "반드시 필요한 앱"만 승인.
- 일기 앱은 승인받기 매우 어려움.

Android 12 이후:

- 정확한 위치(`PRECISE`)와 대략적 위치(`APPROXIMATE`) 구분.
- 사용자가 대략적 위치만 허용할 가능성이 높음.

## 배터리 문제

| 방식 | 정확도 | 배터리 소모 |
|---|---|---|
| GPS 상시 | 높음 | 매우 높음 |
| Fused Location (`PRIORITY_BALANCED`) | 중간 | 중간 |
| Passive Location | 낮음 | 거의 없음 |
| Geofencing | 지점 단위 | 낮음 |

일기 앱 목적이라면 **Passive Location + Geofencing 조합**이 현실적입니다.

## 현실적인 대안 접근법

### 1. Foreground Service

```kotlin
// 상태바에 알림이 뜨는 조건으로 백그라운드 허용
// 사용자 경험상 거슬릴 수 있음
startForegroundService(Intent(this, LocationService::class.java))
```

배터리 문제는 줄어들지만 알림이 항상 노출되는 단점이 있다.

### 2. WorkManager + 주기적 스냅샷

상시 추적 대신 하루 3~5회 위치를 찍는 방식. 배터리 영향을 최소화하면서 하루 동선을 대략 파악할 수 있다.

### 3. Geofencing

자주 가는 장소(집, 회사, 카페)를 등록해두고 진입/이탈 이벤트만 기록한다. 배터리 영향이 거의 없고 "오늘 카페에 2시간 있었음" 정도는 충분히 잡힌다.

### 4. Google Places API / Semantic Location

구글 타임라인이 이미 이 문제를 잘 다루고 있으므로, 사용자가 구글 위치 기록을 켜둔 경우 Google Maps Timeline API로 가져오는 것이 더 정확하고 배터리 소모도 없다.

## 라이프 로깅 초안 서비스 관점에서 결론

> "GPS 상시 추적"이 아니라 "하루 중 방문한 장소 목록 (Geofencing 또는 구글 타임라인 연동)"

이 정도면 "오늘 스타벅스에서 친구 만남", "퇴근 후 헬스장 들름" 같은 일기 소재는 충분히 뽑을 수 있고, 배터리·권한 문제도 피할 수 있다.
