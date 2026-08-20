---
title: Laimory 베타테스트 준비 실행계획
source_type: notes
source_path: raw/notes/2026-08-17-laimory-beta-test-execution-draft.md
derived_from: raw/pdf/3-3. 369. 중간보고서.pdf
source_date: 2026-08-17
approved_date: 2026-08-20
ingest_date: 2026-08-20
status: ingested
tags: [laimory, beta-test, user-recruitment, mvp, kpi]
---

# Laimory 베타테스트 준비 실행계획

## Summary

2026년 8월 24~30일 Android beta를 약 20명 대상으로 운영하기 위해 모집, MVP, analytics, 알림, AI·모바일·서버 준비를 우선순위와 checklist로 나눈 실행 문서다. 공식 중간보고서 13~24쪽을 기준으로 정정됐으며 완료 보고가 아니라 계속 갱신하는 작업 목록이다.

## Key Claims

- 모집 lead time이 가장 길어 지인, SW Maestro 17기, 개발자 community 순서로 먼저 시작한다.
- 소개 page, 신청 form, 보상 기준, 설치 안내, 문의 창구와 종료 설문·interview를 beta 시작 전에 준비한다.
- beta 최소 기능은 로그인부터 권한·수집, Timeline 생성·확인·수정·삭제·memo·확정과 월별 조회까지의 실제 기기 end-to-end 흐름이다.
- 권한 동의, Timeline 완료, 수정·삭제, memo, 평균 memo 수와 D1·D7·D30을 계산할 event를 수집하되 생활 데이터 원문은 analytics에 넣지 않는다.
- 기능 알림, reminder와 beta 공지를 분리하고 발송 수단·시각·빈도·click logging을 결정해야 한다.
- AI model은 beta 도중 바꾸지 않고 공통 fixture에서 품질·structured failure·Repair·latency·token·비용을 비교해 beforehand 확정한다.

## Caveats

- 일정, 보상, channel과 각 part의 책임 중 일부는 미결이며 체크박스가 완료를 의미하지 않는다.
- Mobile과 Server 세부 할 일은 비어 있다.
- 8월 20일 ingest 시점에도 beta 결과는 포함하지 않는다.

## Related Pages

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-14-notes-laimory-midterm-marketing-kpi-draft]]
- [[laimory-planning-and-validation]]
- [[369-team]]
