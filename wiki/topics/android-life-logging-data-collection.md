---
title: Android Life Logging Data Collection
kind: topic
status: active
updated: 2026-06-15
tags: [android, location, background-data, laimory, technical-risk]
---

# Android Life Logging Data Collection

## Scope

Laimory 같은 Android 기반 life logging 앱이 위치/일상 데이터를 수집할 때 맞닥뜨리는 권한, 배터리, OS 정책, UX 리스크.

## Current Synthesis

Android 기반 life logging에서 위치는 중요한 일기 소재를 만들 수 있지만, 상시 GPS 추적은 배터리와 권한 심사 양쪽에서 부담이 크다. raw 기술 메모는 Laimory 관점에서 "GPS 상시 추적"이 아니라 "하루 중 방문한 장소 목록" 정도를 목표로 삼는 것이 현실적이라고 본다.

MVP에서는 Passive Location, Geofencing, WorkManager 기반 주기적 스냅샷, Google Timeline/Places 연동 같은 낮은 마찰의 대안부터 검토하는 편이 제품 리스크를 줄일 수 있다. 다만 Google Timeline/Places API 접근성과 정책은 별도 확인이 필요하다.

## Key Points

- Android 8 이후 백그라운드 위치 업데이트가 제한되고 Doze 모드에서 GPS 접근이 막힐 수 있다.
- Android 10 이후 `ACCESS_BACKGROUND_LOCATION` 권한이 별도로 필요하며, 일기 앱은 Google Play 정책상 승인 난도가 높을 수 있다.
- Android 12 이후 정확한 위치/대략적 위치 권한 선택으로 데이터 정밀도가 낮아질 수 있다.
- 위치 수집 목적은 자세한 궤적이 아니라 "방문 장소와 머문 시간"을 통해 하루 소재를 만드는 것이다.
- 기능 가치와 데이터 신뢰를 설명하는 온보딩/권한 UX가 기술 구현만큼 중요하다.

## Open Questions

- Google Timeline API나 Places API를 실제로 사용할 수 있는가?
- Geofencing만으로 충분히 풍부한 하루 타임라인을 만들 수 있는가?
- 위치 권한을 앱 설치 첫날 요청할지, 첫 회고 가치 체감 이후 요청할지 결정해야 한다.

## Linked Sources

- [[2026-06-15-markdown-notion-background-location]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-15-markdown-notion-laimory-planning-review-evaluation]]
- [[2026-06-15-markdown-notion-epic-system-initial-setup]]

## Related Pages

- [[laimory]]
- [[ai-life-logging]]

