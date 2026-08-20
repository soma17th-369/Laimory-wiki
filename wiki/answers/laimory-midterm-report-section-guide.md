---
title: Laimory 중간보고서 작성 가이드
kind: answer
status: active
updated: 2026-08-20
tags: [laimory, sw-maestro, midterm-review, report-writing]
---

# Laimory 중간보고서 작성 가이드

## Scope

Laimory의 중간보고서나 이후 유사한 프로젝트 점검 문서를 작성할 때, 필수 목차를 실제 구현·검증 evidence와 연결하는 재사용 가능한 기준이다.

## Core Narrative

보고서는 기능 목록보다 다음 변화가 보이게 쓴다.

> 넓은 Personal AI Memory 비전에서 수정 가능한 일간 Timeline MVP로 범위를 좁혔고, 실제 Android·App Server·AI Server 통합과 alpha test에서 발견한 문제를 source 무결성, 시간·사진·위치, 비동기 처리와 제품 행동 지표로 반복 검증한다.

각 절은 가능한 한 다음 순서를 따른다.

1. 기획 당시 가설
2. 심의 feedback 또는 실제 문제
3. 현재 구현과 검증 evidence
4. 남은 risk와 다음 metric

## Section Guide

### 프로젝트 요약·필요성

- Android와 생활 data source, 수정 가능한 Timeline 결과를 3줄 안에 보여준다.
- 직접 일기 작성의 회상·정리 비용, 파편화된 source, 별도 앱에 data를 맡길 trust를 하나의 문제로 연결한다.
- AI가 완성 일기를 대신 쓰는 것이 아니라 사용자가 자기 기록을 완성할 draft를 만든다고 설명한다.

### 프로젝트 개요·시장·제품 검증

- 사용자 흐름은 `source 선택 → Timeline 생성 → 확인·수정·삭제 → 확정·저장 → 이후 개인화`로 설명한다.
- 경쟁 비교의 기준은 source 수가 아니라 근거가 보존된 수정 가능한 하루 기억으로 연결하는지 여부다.
- 설치·가입보다 첫 Timeline 확정·저장과 반복 확정을 activation·retention의 중심으로 둔다.
- 시장 수치, 가격과 budget은 원출처·지역·plan·확인일을 함께 적고 미검증 값은 가설로 둔다.

### 시스템·AI 활용

- App Server가 source·result·task state를 소유하고 AI Server는 task 단위 무상태 실행을 맡는 경계를 분명히 한다.
- Event Agent, Timeline, Repair, Question의 역할과 User Memory가 사건 source가 아니라 보조 context라는 점을 함께 설명한다.
- structured output과 prompt만 설명하지 말고 rawId, request window, Calendar 보존, Photo 귀속과 privacy를 code가 다시 검사하는 구조를 보여준다.

### 개발 진행현황

가장 많은 지면을 쓰고 각 항목을 `구현 → 발견 → 대응 → metric`으로 정리한다.

- Android: permission, source 수집, background·battery, 편집 UX.
- App Server: source·result ownership, task·callback, failure recovery와 latency.
- AI: source별 Agent, 사건 병합, structured failure, deterministic Repair와 Question.
- 평가·관측: 공통 fixture, Langfuse trace, 운영 event, model·prompt 비교.
- Infra: 실제 EC2 경로와 향후 AgentCore 경로를 현재·계획으로 분리.

### 결과물·기대효과·의견 반영

- 실제로 존재하고 재현 가능한 build, API, AI Server, end-to-end flow와 trace만 결과물로 적는다.
- 사용자 효과는 기억 복원과 correction burden, 기술 효과는 source fidelity·failure·latency, 사업 효과는 campaign cohort와 retention으로 검증한다.
- mentor feedback은 방어적으로 요약하지 않고 의견별 반영 evidence와 남은 검증을 표로 연결한다.

## Evidence Checklist

- 앱 생성·열람·수정·삭제·저장 화면 또는 시연
- 잘못된 날짜·시간, rawId, 사진 귀속과 callback 오류의 before/after
- 같은 fixture에 대한 model·prompt version 비교
- 표본 수·기간을 포함한 activation·retention baseline
- 완료·검증 중·계획·미결 상태의 명시

## Do Not Overclaim

- 기획서의 Kafka, Edge SLM, On-device AI, Reflection Engine과 Memory Graph를 현재 구현처럼 쓰지 않는다.
- 후보 model이 있다는 사실을 비교 평가 완료로 쓰지 않는다.
- 회의에서 제안된 queue, DLQ, AgentCore 전환을 code 확인 없이 완료 처리하지 않는다.
- 다운로드와 beta 신청을 제품 가치나 retention의 증거로 대체하지 않는다.
- 수정·삭제 기능만으로 외부 model 전송과 장기 data trust가 해결됐다고 주장하지 않는다.

## Linked Sources

- [[2026-08-10-notes-laimory-midterm-report-section-guide]]
- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-16-notes-laimory-midterm-report-feedback-resolution]]

## Related Pages

- [[laimory-planning-and-validation]]
- [[ai-daily-timeline-generation]]
- [[laimory]]
