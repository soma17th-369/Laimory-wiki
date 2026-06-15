---
title: Notion AI 하루 타임라인 기능 MVP 개발
source_type: markdown
source_path: raw/markdown/notion/369-team/ai-daily-timeline-mvp.md
source_url: https://app.notion.com/p/27fcdc4d240a82519d78012ee0702a42
ingest_date: 2026-06-15
status: ingested
tags: [notion, laimory, mvp, ai-timeline, ux]
---

# Notion AI 하루 타임라인 기능 MVP 개발

## Summary

Laimory의 AI 하루 타임라인 MVP 기능에 대한 사용자 시나리오와 결정 사항.

## Key Claims

- 신규 사용자는 앱 설치 후 권한 허용을 거치고, 메인 화면에서 지난 기록과 오늘 수집된 정보 수준을 본 뒤 `하루 보기`로 진입한다.
- 사용자는 그날 찍은 사진 중 기록될 사진을 고르고, AI가 하루 타임라인 초안을 생성하면 자기 전에 수정 후 저장한다.
- 반복 사용 시나리오는 자기 전 푸시 알림을 통해 앱을 열고 하루 타임라인을 확인/수정/저장하는 흐름이다.
- 하루의 범위는 기상 시간이 시작과 끝으로 정해진다.
- 하루 기록은 그날 12시 이후부터 확인할 수 있다.
- 저장 전까지 하루 타임라인은 계속 추가되며, 기존 수정/작성 내용은 임시저장으로 유지된다.

## Caveats

- UX 시나리오 중심 문서이며 API/ERD/sequence diagram은 다음 작업으로 남아 있다.

## Related Pages

- [[laimory]]
- [[ai-life-logging]]
- [[android-life-logging-data-collection]]

