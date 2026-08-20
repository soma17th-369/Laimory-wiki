---
title: Laimory 중간보고서 목차별 작성 가이드
source_type: notes
source_path: raw/notes/2026-08-10-laimory-midterm-report-section-guide-draft.md
source_date: 2026-08-10
approved_date: 2026-08-20
ingest_date: 2026-08-20
status: ingested
tags: [laimory, sw-maestro, midterm-review, report-writing, evaluation]
---

# Laimory 중간보고서 목차별 작성 가이드

## Summary

기획심의 원안과 평가의견, 7월 말~8월 초 alpha test, 8월 9일 AI 시스템 문서를 중간보고서 필수 목차에 연결한 작성 가이드다. 기능 목록보다 `초기 가설 → 심의 피드백·실제 문제 → 현재 구현 증거 → 남은 검증과 지표`를 각 절에서 보여주는 것을 핵심 서사로 둔다.

## Key Claims

- MVP는 넓은 Personal AI Memory 비전 전체가 아니라 수정 가능한 일간 Timeline 생성·편집·저장 경험으로 좁혀 설명한다.
- 개발 진행현황에 가장 많은 지면을 배정하고 Android, App Server, AI Timeline, User Memory, 관측·평가, Infra를 `구현 → 발견 → 대응 → 지표` 순서로 쓴다.
- 시장성과 마케팅은 다운로드가 아니라 source 연결, Timeline 생성·열람·수정·memo·저장, 반복 사용으로 이어지는 funnel로 검증한다.
- AI 품질은 structured output, source 충실성, 사건 병합, 사진 귀속, 사용자 수정 부담, latency와 비용을 공통 fixture에서 반복 측정한다.
- App Server의 데이터 소유권, AI Server의 무상태 실행, 결정론적 Repair와 User Memory의 보조-context 경계를 현재 구조의 핵심으로 설명한다.
- Kafka, Edge SLM, On-device AI, Reflection Engine, Memory Graph처럼 기획 시점에 있던 요소를 현재 구현으로 과장하지 않는다.
- 목표 수치와 모델 비교 결과는 baseline이나 실제 평가가 없으면 임의로 채우지 않는다.

## Caveats

- 공식 중간보고서가 완성되기 전의 작성용 가이드이며 실제 제출 문서와 동일하지 않다.
- 당시 회의·설계 문서를 결합한 초안이므로 현재 코드 계약과 충돌하면 코드와 이후 source를 우선한다.
- 마케팅 예산, persona, 평가 threshold와 미래 일정에는 팀이 채워야 할 빈칸이 남아 있다.

## Related Pages

- [[laimory-midterm-report-section-guide]]
- [[2026-08-17-pdf-laimory-midterm-report]]
- [[laimory-planning-and-validation]]
- [[ai-daily-timeline-generation]]
- [[laimory]]
