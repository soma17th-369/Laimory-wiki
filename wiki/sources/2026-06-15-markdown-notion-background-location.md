---
title: Notion 백그운드 위치 가져오기
source_type: markdown
source_path: raw/markdown/notion/369-team/background-location.md
source_url: https://app.notion.com/p/6d5cdc4d240a8356bf0e81b86fb61b45
ingest_date: 2026-06-15
status: ingested
tags: [notion, android, background-location, laimory, technical-note]
---

# Notion 백그운드 위치 가져오기

## Summary

Laimory의 위치 기반 라이프 로그 수집 가능성을 Android 백그라운드 위치 제약, 배터리, 현실적 대안 관점에서 정리한 기술 메모.

## Key Claims

- Android 8 이후 백그라운드 위치 업데이트가 제한되고 Doze 모드에서 GPS 접근이 막힐 수 있다.
- Android 10 이후 `ACCESS_BACKGROUND_LOCATION` 권한이 별도로 필요하며, Google Play 정책상 일기 앱은 승인받기 어려울 수 있다.
- Android 12 이후 정확한 위치와 대략적 위치 권한이 나뉘며 사용자가 대략적 위치만 허용할 가능성이 있다.
- 일기 앱 목적에서는 GPS 상시 추적보다 Passive Location + Geofencing 조합이 현실적이다.
- WorkManager 기반 주기적 스냅샷이나 Geofencing, Google Timeline/Places 연동이 대안이다.
- 결론은 "GPS 상시 추적"이 아니라 "하루 중 방문한 장소 목록" 수준을 수집하는 방향이다.

## Caveats

- 기술 메모는 Android 정책과 API 상태에 따라 시간이 지나면 바뀔 수 있다.
- Google Maps Timeline API 접근 가능성은 별도 검증이 필요하다.

## Related Pages

- [[android-life-logging-data-collection]]
- [[laimory]]

