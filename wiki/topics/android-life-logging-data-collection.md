---
title: Android Life Logging Data Collection
kind: topic
status: active
updated: 2026-09-04
tags: [android, location, background-data, laimory, technical-risk]
---

# Android Life Logging Data Collection

## Scope

Laimory 같은 Android 기반 life logging 앱이 위치/일상 데이터를 수집할 때 맞닥뜨리는 권한, 배터리, OS 정책, UX 리스크.

## Current Synthesis

Android 기반 life logging에서 위치는 중요한 일기 소재를 만들 수 있지만, 상시 GPS 추적은 배터리와 권한 심사 양쪽에서 부담이 크다. raw 기술 메모는 Laimory 관점에서 "GPS 상시 추적"이 아니라 "하루 중 방문한 장소 목록" 정도를 목표로 삼는 것이 현실적이라고 본다.

MVP에서는 Passive Location, Geofencing, WorkManager 기반 주기적 스냅샷, Google Timeline/Places 연동 같은 낮은 마찰의 대안부터 검토하는 편이 제품 리스크를 줄일 수 있다. 다만 Google Timeline/Places API 접근성과 정책은 별도 확인이 필요하다.

Laboratory Android lab work expands the collection scope beyond location into photos, calendars, filtered notifications, Health Connect, and Samsung Health-origin verification. For server upload, this should be normalized as request-local timeline source items with `itemType`, local time bounds, a short summary, and typed payload JSON rather than uploading UI display strings directly. Location upload is still an expected design, tentatively split into `LOCATION_STAY` for tens-of-minutes stays and `LOCATION_MOVE` for several-minutes movement segments.

2026-08-06 회의에서는 위치·체류 수집 개선 build가 app console에 배포되었고, 실제 이동 데이터 검증이 다음 단계로 보고되었다. Android 내부 reverse geocoding으로 위도·경도 위에 주소를 표시하는 기능도 추가되었지만 도로명과 지번 주소가 일관되지 않는 문제가 있다. 이는 회의 보고에 근거한 상태이며 구현 코드 검증은 아직 하지 않았다.

2026-08-17 공식 중간보고서는 MediaStore, Calendar Provider와 Health Connect 기반 source 수집, Room 저장, source별 permission fallback, 사용자가 선택한 데이터만 AI에 보내는 흐름을 구현했다고 보고한다. 위치는 Foreground Service로 수집 상태를 표시하고 체류·이동 구간으로 줄이며 재시작 뒤 진행 상태를 복원한다. Kakao API 위치 보강은 server가 담당하고, 고유 좌표 실패율 20% 이하의 부분 실패는 허용하되 20% 초과 또는 시간순 3개 연속 실패에서는 생성을 중단하는 정책을 제시한다. Android 버전·제조사별 누락과 battery 영향은 beta에서 검증할 계획이므로 아직 결과로 보지 않는다.

초기 2026-05 회의에서는 사진·위치·calendar를 MVP 우선 source로 좁히고 permission을 필요한 순간에 단계적으로 요청하는 안이 논의됐다. 07-30부터 08-06 alpha test에서는 알림 과다 수집, 로컬 DB 정리, photo 선택·삭제, GPS noise, 하루 경계와 주소 표시 문제가 실제 개선 항목으로 나타났다. 08-04의 on-device SLM privacy filter는 법률 mentoring을 참석자들이 재해석해 제안한 절충안이므로 법률 요구사항이나 검증된 보호 수단으로 단정할 수 없다.

2026-08-12~30 회의에서는 release UX와 source control이 구체화됐다. 사용자가 제외한 장소와 관련 movement는 mobile에서 제거해 server로 보내지 않고, movement는 20분 미만이면 저장하지 않는 rule이 보고됐다. Notification은 category·keyword·package와 반복 갱신 field를 조합한 자동 filter를 우선 구현하고 실제 debug data로 검수하기로 했다. Permission은 onboarding에서 단계적으로 요청하고 calendar·health는 앱 진입과 생성 날짜 선택 시 갱신하며, 위치는 Google Maps marker와 toggle로 확인·제외하는 흐름이 구현 보고됐다. 이 상태와 20분 기준의 정확도, 지도·약관 요구, background 실패 복구는 code와 beta 결과로 확인해야 한다.

같은 기간 Timeline UI는 생성 직후 edit와 저장 후 read mode를 분리하고, initializer API가 onboarding·약관 등 초기 상태를 제공하는 방향으로 이동했다. Notification filter와 onboarding·약관 연결이 초기 release의 큰 mobile 병목으로 남았으며, 완전 무입력 날과 사진 없는 loading 화면도 명시적 empty-state 설계가 필요해졌다.

2026-09-01~03 회의에서는 onboarding을 실제 기기에서 검수해 photo 의미 분석, 일정이 채워진 calendar, 여러 location marker, 결제·예약·배송 notification과 reminder가 Timeline에 어떻게 쓰이는지 직접 설명하도록 수정했다. System 설정까지 이동하는 permission depth는 beta 검증 대상으로 남았고, onboarding은 현재 상태로 고정됐다. 읽기·편집 mode, event 추가, notification 수신 설정과 light·dark·system theme는 구현 보고됐지만 release build·login·logging은 남아 있었다. 같은 날 복수 생성은 client window·history state가 완성되지 않아 초기 beta에 하루 한 번 오후 9시 이후 생성하도록 안내하기로 했다.

## Key Points

- Android 8 이후 백그라운드 위치 업데이트가 제한되고 Doze 모드에서 GPS 접근이 막힐 수 있다.
- Android 10 이후 `ACCESS_BACKGROUND_LOCATION` 권한이 별도로 필요하며, 일기 앱은 Google Play 정책상 승인 난도가 높을 수 있다.
- Android 12 이후 정확한 위치/대략적 위치 권한 선택으로 데이터 정밀도가 낮아질 수 있다.
- 위치 수집 목적은 자세한 궤적이 아니라 "방문 장소와 머문 시간"을 통해 하루 소재를 만드는 것이다.
- 기능 가치와 데이터 신뢰를 설명하는 온보딩/권한 UX가 기술 구현만큼 중요하다.
- 사진/일정/알림/헬스 데이터는 서로 구조가 다르므로, 서버 전송 단계에서는 source-specific fields를 typed payload로 보존하는 편이 안전하다.
- Health Connect rows are currently display-oriented in the lab; production upload should preserve structured metric values and units.
- 2026-06-27 laboratory 자료에서는 위치 데이터가 구현 전이었으며, 기본 payload에는 정밀 GPS trail 전체가 아니라 체류/이동 구간 요약을 보내는 방향이 더 안전하다고 정리했다.
- 회의 보고 기준으로 위치·체류 수집과 기본 주소 표시는 구현 검증 단계에 들어갔지만, 장소명 조회와 외부 지도 API 호출 위치는 미결이다.
- 중간보고서 기준 장소·주소 보강의 현재 설계 위치는 API Server이며 Kakao API를 병렬 호출한다. 다만 실제 code와 운영 실패율은 이 ingest에서 검증하지 않았다.
- 제외한 위치와 관련 movement를 client에서 제거해 전송 자체를 막는 방향이며, 20분 미만 movement 제외는 구현 보고됐지만 정밀도 검증 결과는 없다.
- Notification은 사용자의 app별 수동 설정에만 맡기지 않고 category·keyword·package 기반 자동 filter와 실제 수집 data 검수를 우선한다.
- Onboarding initializer, 단계별 permission, 약관·notification 설정과 read/edit UI는 하나의 release flow로 연결된다.
- Permission onboarding은 source 이름만 보여주지 않고 photo 의미 분석, calendar 일정, location route와 유용한 notification이 결과에 주는 가치를 구체적으로 설명해야 한다.
- 같은 날 복수 생성은 Android의 request window와 previous record state가 server의 draft append와 일치해야 하며, beta의 하루 1회 규칙은 임시 우회다.

## Open Questions

- Google Timeline API나 Places API를 실제로 사용할 수 있는가?
- Geofencing만으로 충분히 풍부한 하루 타임라인을 만들 수 있는가?
- 위치 권한을 앱 설치 첫날 요청할지, 첫 회고 가치 체감 이후 요청할지 결정해야 한다.
- 알림과 사진 원본/썸네일을 어느 수준까지 서버로 보낼지, metadata-only로 시작할지 결정해야 한다.
- client의 기본 주소 표시와 server의 Kakao 장소 보강 사이에서 정본, cache와 불일치 처리 책임을 어떻게 나눌 것인가?
- 회의에서 언급된 이동 관련 20분 기준이 정확히 어떤 판정 규칙인지 코드로 확인해야 한다.
- Android 버전·제조사별 데이터 누락과 배터리 소모를 어떤 기기 matrix와 수치 threshold로 통과 판정할 것인가?
- 20분 미만 movement 제외가 의미 있는 짧은 방문을 버리지 않는지 어떤 ground truth로 검증할 것인가?
- Notification filter가 민감한 대화를 과잉 event로 만들지 않으면서 결제·예약·배송을 보존하는지 어떻게 회귀 test할 것인가?
- Calendar·Health 자동 갱신 실패, permission 철회와 background 전환을 어떤 UI·retry로 설명할 것인가?
- 지도 SDK 이용조건과 location 제외 toggle이 server-side 장소 보강·photo·calendar 맥락에 일관되게 반영되는가?
- System 설정까지 이동하는 location·notification permission flow의 단계별 허용률과 이탈은 어떻게 측정할 것인가?
- client가 same-day draft의 마지막 window와 server state를 어떤 API·cache policy로 동기화할 것인가?

## Linked Sources

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-06-15-markdown-notion-background-location]]
- [[2026-06-15-markdown-notion-ai-daily-timeline-mvp]]
- [[2026-06-05-notes-laimory-planning-review-evaluation]]
- [[2026-06-15-markdown-notion-epic-system-initial-setup]]
- [[2026-06-27-github-laboratory-mobile-data-extraction]]
- [[2026-05-18-meeting-369-team-planning-review-preparation]]
- [[2026-05-19-meeting-369-team-planning-review-preparation]]
- [[2026-05-21-meeting-369-team-planning-review-preparation]]
- [[2026-05-23-meeting-369-team-space]]
- [[2026-07-30-meeting-369-team-space]]
- [[2026-08-02-meeting-369-team-space]]
- [[2026-08-03-meeting-369-team-space]]
- [[2026-08-04-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]
- [[2026-08-06-meeting-369-team-space]]
- [[2026-08-12-meeting-369-team-space]]
- [[2026-08-13-meeting-369-team-space]]
- [[2026-08-16-meeting-369-team-space]]
- [[2026-08-18-meeting-369-team-space]]
- [[2026-08-24-meeting-369-team-space]]
- [[2026-08-25-meeting-369-team-space]]
- [[2026-08-26-meeting-369-team-space]]
- [[2026-08-27-meeting-369-team-space]]
- [[2026-08-30-meeting-369-team-space]]
- [[2026-09-01-meeting-369-team-space]]
- [[2026-09-02-meeting-369-team-space]]
- [[2026-09-03-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[mobile-data-extraction-payload-structure]]
- [[laimory-data-privacy-and-consent]]
