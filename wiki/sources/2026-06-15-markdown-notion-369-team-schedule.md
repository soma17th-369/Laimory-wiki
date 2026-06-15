---
title: Notion 369팀 일정 DB
source_type: markdown
source_path: raw/markdown/notion/369-team/369-team-schedule.md
source_url: https://app.notion.com/p/708cdc4d240a8325a7ce8166d079e4d1
ingest_date: 2026-06-15
status: ingested
tags: [notion, 369-team, schedule, database-schema]
---

# Notion 369팀 일정 DB

## Summary

369팀 일정 데이터베이스의 schema 캡처. 날짜, 사람, 선택, 태그, 이름 속성 및 회의/멘토링/특강/공식 일정 태그를 가진다.

## Key Claims

- 일정 DB는 `회의`, `멘토링`, `특강`, `공식 일정`을 태그로 구분한다.
- 선택 속성은 대면, 비대면, 기타를 구분한다.
- 템플릿은 비대면 회의, 대면 회의, 공식일정으로 구성되어 있다.

## Caveats

- MCP의 data source query 기능이 동작하지 않아 전체 row dump는 확보하지 못했다.
- 멘토링/특강 페이지는 이번 ingest 범위에서 제외했다.

## Related Pages

- [[369-team]]
- [[2026-06-15-markdown-notion-meeting-records]]

