---
title: Laimory AI Timeline 핵심 개선 요구사항
source_type: markdown
source_path: raw/markdown/laimory-ai-timeline-core-improvement-requirements.md
source_date: 2026-08-20
ingest_date: 2026-08-20
status: ingested
tags: [laimory, ai-timeline, prompt-engineering, repair, validation]
---

# Laimory AI Timeline 핵심 개선 요구사항

## Summary

기존 `Event Agents → Timeline Agent → Repair Agent` 구조를 유지하면서 일기형 하루 복원, Location journey 추론, Repair의 의미·품질 검증, Candidate·Fragment 공통 계약을 우선 개선하도록 정리한 요구사항이다. prompt 수정과 deterministic validation의 책임을 나누고 이번 단계에서 다룰 범위를 제한한다.

## Key Claims

- Timeline Agent는 Candidate를 복사·나열하지 않고 source 근거 범위 안에서 언제·어디서·누구와·무엇을·어떻게·왜 했는지를 하루 중심 서사로 재구성한다.
- Location Agent는 GPS point와 작은 movement를 나열하지 않고 출발·경유·도착·체류를 실제 journey와 activity 후보로 해석한다.
- Notification은 독립 event가 될 증거와 다른 사건을 보강하는 Fragment를 구분하고 민감 본문은 제거·마스킹한다.
- Repair는 source·시간 정합성뿐 아니라 사건 분할·병합, 근거 없는 의미, 일기 문장 품질과 누락을 high-level 질문으로 검토한다.
- Candidate는 독립 사건으로 발전 가능한 해석이고 Fragment는 다른 사건의 시간·장소·사람·목적을 보강하는 단서다.
- 모든 유효 raw item의 candidate·fragment·noise·failure 상태, 사진 단일 귀속과 환각 rawId 제거를 검증 가능하게 남긴다.
- 우선순위는 prompt 계약, validator, agent tool과 eval 순서이며 기존 graph 전면 교체는 제외한다.

## Caveats

- 구현 요구사항 snapshot이며 완료 보고가 아니다.
- prompt collection의 v2 개선안과 상당 부분 겹치지만 문구·범위가 완전히 동일하지 않다.
- 현재 code가 이미 일부 요구를 다른 방식으로 구현했을 수 있으므로 active contract에는 repository code와 최신 knowledge를 우선한다.

## Related Pages

- [[2026-08-20-markdown-laimory-ai-agent-prompt-collection]]
- [[2026-08-09-markdown-laimory-prompt-engineering]]
- [[2026-08-09-markdown-laimory-deterministic-repair-and-tools]]
- [[ai-daily-timeline-generation]]
