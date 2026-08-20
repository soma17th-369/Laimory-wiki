---
title: Laimory AI Agent 프롬프트와 alpha 개선 기록 컬렉션
source_type: markdown
source_path: raw/markdown/laimory-ai-agent-prompts/
source_date: 2026-08-20
ingest_date: 2026-08-20
status: ingested
tags: [laimory, ai-agent, prompt-engineering, alpha-test, timeline]
---

# Laimory AI Agent 프롬프트와 alpha 개선 기록 컬렉션

## Summary

Laimory의 Calendar, Location, Notification, Photo, Sleep/Activity, Timeline과 Repair prompt의 v1·v2·current snapshot, review prompt, alpha test 결과, 세 차례 개선 계획과 외부 best-practice 참고자료를 보존한 42-file Markdown collection이다. 현재 코드 정본이 아니라 prompt와 품질 기준이 어떻게 구체화됐는지 보여주는 설계·실험 이력이다.

## Key Claims

- pipeline은 source별 Event Agent 병렬 처리, Candidate·Fragment 취합, Timeline 병합과 Repair 순서로 설명된다.
- alpha test에서 timezone·하루 경계, 장거리 이동의 과분할, 사진 누락·중복 귀속, Calendar와 Location의 결합 실패, 알림의 맥락 분절, 귀가 누락과 sensor-like 문장이 반복 문제로 기록됐다.
- 개선 방향은 모든 raw item의 처리 상태 추적, 하나의 사진을 하나의 최종 event에 귀속, 연속 이동을 상위 journey로 병합, source 간 근거 우선순위와 uncertainty 보존이다.
- Timeline은 Candidate를 나열하지 않고 `이날은 어떤 날이었는가`를 중심으로 실제 하루를 일기형 사건으로 재구성해야 한다.
- 의미 판단은 LLM이 맡되 rawId, 시간 범위, 사진 귀속, privacy와 구조적 계약은 결정론적 validator와 Repair가 확인한다.
- v3 계획은 prompt mission·출력 조건, state ownership, structured output, prompt injection 경계, external eval과 regression test를 하나의 실행 계약으로 묶는다.

## Collection Layout

- Top level: index, alpha 결과, 실제 값·모범 답안, 개선 계획 v1~v3.
- Agent folders: Calendar 3, Location 5, Notification 3, Photo 9, Repair 3, Sleep/Activity 5, Timeline 3 files.
- Best practice: LangGraph diary prompt, coding loop, project setup와 enterprise coding template 4 files.

## Caveats

- collection에는 실제 alpha test의 taskId, 위치·관계·일정 같은 생활 맥락이 포함돼 있어 운영 log나 일반 답변에 원문을 재노출하지 않는다.
- credential pattern scan에서는 실제 JWT·API key를 찾지 못했지만, 한 note는 당시 원본 data에 token이 있었다고 언급한다. source page는 그 값을 인용하지 않는다.
- `prompt.md`가 source collection에서 current라는 뜻이지 현재 `Laimory-AI` repository의 active prompt와 동일하다는 뜻은 아니다. 현재 구현 판단에는 code와 2026-08-09 이후 system document를 우선한다.

## Related Pages

- [[2026-08-20-markdown-laimory-ai-timeline-core-improvement-requirements]]
- [[2026-08-09-markdown-laimory-prompt-engineering]]
- [[2026-08-09-markdown-laimory-timeline-graph-and-agents]]
- [[2026-08-09-markdown-laimory-deterministic-repair-and-tools]]
- [[ai-daily-timeline-generation]]
