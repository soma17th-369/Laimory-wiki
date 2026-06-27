---
title: Laboratory Mobile Data Extraction
source_type: github
source_path: /Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory
ingest_date: 2026-06-27
status: ingested
tags: [laimory, android, mobile-data, health-connect, media-store, calendar, notifications]
---

# Laboratory Mobile Data Extraction

## Summary

`Laboratory` is an Android/Kotlin lab project for checking which device/platform data can be read for Laimory-style life logging. The app is organized as simple tabs plus repository classes: photos, calendar, notifications, Health Connect, and Samsung Health verification through Health Connect data origins.

Primary files checked:

- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/docs/data-features.md`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/java/com/soma369/laboratory/photo/PhotoRepository.kt`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/java/com/soma369/laboratory/photo/PhotoItem.kt`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/java/com/soma369/laboratory/calendar/CalendarRepository.kt`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/java/com/soma369/laboratory/calendar/EventItem.kt`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/java/com/soma369/laboratory/notification/LabNotificationListenerService.kt`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/java/com/soma369/laboratory/notification/NotificationDb.kt`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/java/com/soma369/laboratory/notification/NotificationItem.kt`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/java/com/soma369/laboratory/health/HealthRepository.kt`
- `/Users/hyeongseon/Workspaces/Programs/ASM/Laimory-project/Laboratory/app/src/main/AndroidManifest.xml`

## Key Claims

- Photos are read from `MediaStore.Images` and represented as `PhotoItem` with media ID, content URI, filename, taken/added time, size, dimensions, MIME type, bucket/path, orientation, favorite flag, and optional EXIF GPS.
- Calendar events are read from `CalendarContract.Events` and represented as `EventItem` with calendar metadata, title/description/location, start/end time, all-day flag, recurrence rule, timezone, status, and a derived event type: `USER`, `HOLIDAY`, or `SOLAR_TERM`.
- Notifications are captured through `NotificationListenerService` as `NotificationItem`. A separate SQLite helper stores package/keyword filters and collected notifications that match those filters.
- Health data is read from Health Connect. General `HealthTypeResult` rows are display-oriented (`time`, `summary`), while Samsung Health verification has more structured sleep and steps models.
- Samsung Health is not integrated directly; the app checks Health Connect `dataOrigin.packageName == "com.sec.android.app.shealth"`.
- The lab already documents that some Samsung Health app data may not be available through Health Connect depending on Samsung Health sync scope and device settings.

## Caveats

- Health `HealthTypeResult` rows are useful for UI display but not ideal as server payloads because many metrics are flattened into localized summary strings.
- Notification data is highly sensitive. Server-send candidates should be filtered and minimized before upload, using explicit package/keyword allow rules.
- Photo `uri` is a local Android `content://` URI and is not itself fetchable by the backend. It is useful as client-local provenance, not as a server-download URL.
- The current lab code verifies data access shape, not final Laimory production consent, retention, encryption, or upload policy.

## Related Pages

- [[laimory]]
- [[android-life-logging-data-collection]]
- [[mobile-data-extraction-payload-structure]]
