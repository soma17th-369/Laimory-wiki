---
title: Laimory 중간보고서 마케팅 및 KPI 설정안
source_type: notes
source_path: raw/notes/2026-08-14-laimory-midterm-report-marketing-kpi-draft.md
source_date: 2026-08-14
approved_date: 2026-08-20
ingest_date: 2026-08-20
status: ingested
tags: [laimory, marketing, kpi, activation, retention]
---

# Laimory 중간보고서 마케팅 및 KPI 설정안

## Summary

20대 후반~30대의 기록 관심 Android 사용자를 초기 target으로 두고, 광고 메시지부터 앱 안의 핵심 행동까지 연결해 검증하는 초안이다. 설치 수나 CTR보다 첫 가치 행동과 D1·D7·D30 행동 retention을 campaign 단위로 비교하는 방향을 제안한다.

## Key Claims

- 소구점은 `직접 쓰지 않아도 기록`, `파편화된 데이터를 하나의 Timeline으로 통합`, `일상을 기억하는 Personal AI`의 세 가설로 분리한다.
- Instagram, 기록·회고 community, Meta 소규모 광고를 연결하되 광고 조건은 가능한 한 통제한다.
- install referrer와 GA4로 노출·클릭·신청·설치·가입·권한·생성·확인·수정·완료·재방문을 잇는다.
- 분석 event에는 Timeline 본문, 사진, 위치 같은 생활 데이터 원문을 포함하지 않는다.
- 작은 beta 표본에서는 비율과 실제 사용자 수, 측정 기간을 함께 기록하고 baseline 뒤에 목표치를 정한다.

## Caveats

- 이 초안은 첫 가치 행동을 `첫 일간 회고 완료`로 정의한다. 8월 16일 피드백 반영안은 회고가 MVP에서 제외될 경우 `첫 Timeline 확정·저장`으로 바꿔야 한다고 정정하므로, 운영 정의에는 더 나중 source를 우선한다.
- 일예산, 기간과 채널은 실행 결과가 아닌 제안이다.

## Related Pages

- [[2026-08-16-notes-laimory-midterm-report-feedback-resolution]]
- [[2026-08-17-notes-laimory-beta-test-execution-plan]]
- [[laimory-planning-and-validation]]
- [[laimory]]
