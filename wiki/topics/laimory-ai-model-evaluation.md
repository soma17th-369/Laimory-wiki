---
title: Laimory AI Model Evaluation
kind: topic
status: evaluation-planned
updated: 2026-08-17
tags: [laimory, llm, model-evaluation, benchmark, langfuse]
---

# Laimory AI Model Evaluation

## Scope

Laimory의 multi-Agent Timeline과 User Memory pipeline에서 provider와 모델을 공정하게 비교하고 운영 모델을 선택하는 방법.

## Current Synthesis

OpenAI, Gemini와 Bedrock은 공통 `LLMProvider` facade 아래 text, vision, tolerant JSON과 Pydantic structured output 계약을 공유한다. Provider native schema는 보조 수단이고 최종 계약은 Pydantic 검증이 맡는다.

현재 prompt 품질 개선이 GPT를 기준으로 진행됐다는 사실과 실제 운영 모델 선택은 구분해야 한다. 비교 후보로 Nova 2 Lite, Gemini 2.5 Flash, GPT 5.4 mini가 적혀 있지만 아직 승자나 실제 비용·품질 결과는 없다. 1차 평가는 같은 commit, prompt version, fixture, temperature, User Memory, Repair 상한과 이미지 bytes를 고정해 기본 호환성을 비교하고, 모델별 prompt tuning은 별도 2차 실험으로 분리한다.

평가의 중심은 최종 문장이 그럴듯한지가 아니라 source 충실도와 구조적 신뢰성이다. hallucinated rawId, structured failure, fallback, 질문 coverage와 Repair 행동을 먼저 보고, 자연스러운 한국어 일기 문체, latency, token, 실제 청구 비용과 vision 품질을 함께 비교한다.

2026-08-06 회의에서는 LLM 생성 결과의 품질 검증 프로그램을 local에서 개발 중이며 완성 후 repository에 반영할 예정이라고 보고되었다. 다만 전사에는 평가 fixture, metric, 실행 결과가 없으므로 기존 평가 계획이 구현되었다고 보기는 어렵다.

2026-08-17 공식 중간보고서는 GPT-5.4 mini, Gemini 2.5 Flash, Amazon Nova 2 Lite를 동일 service data에서 사건 추론, 한국어 Timeline 품질, JSON 준수, image 이해, latency와 cost로 비교 중이라고 재확인한다. Langfuse input/output을 LLM-as-a-Judge로 평가하고 발견 문제를 test data로 되돌리는 loop를 설명하지만 model별 표본, 점수와 winner는 제시하지 않는다.

## Key Points

- 평균적인 하루와 함께 source 공백, 겹침, 누락, 민감정보, vision 실패, 깨진 profile fixture가 필요하다.
- 중요한 fixture는 모델별로 여러 번 반복해 stochastic variance를 본다.
- Agent 단위 결과와 end-to-end task 결과를 분리해야 실패 원인을 찾을 수 있다.
- source hallucination, structured failure, timeout, privacy 회귀와 Photo 요구 충족을 hard gate로 둔다.
- 품질 평가는 모델 이름을 가린 blind review와 source 원본 대조가 바람직하다.
- 가격과 availability는 평가 시점의 공식 문서와 실제 사용량·청구 snapshot으로 검증한다.

## Open Questions

- fixture와 golden behavior를 누가, 어떤 버전 정책으로 관리할 것인가?
- 모델별 반복 횟수와 통계적 최소 표본을 어느 수준으로 정할 것인가?
- production 사용자 데이터를 사용하지 않고도 한국어 일상 분포를 충분히 재현할 수 있는가?
- hard gate와 품질·latency·비용 가중치를 제품 단계별로 어떻게 바꿀 것인가?
- 회의에서 언급된 local 품질 검증 프로그램이 기존 평가 계획의 어떤 metric과 fixture를 구현하는가?

## Linked Sources

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-09-markdown-laimory-prompt-engineering]]
- [[2026-08-09-markdown-laimory-llm-provider-model-evaluation]]
- [[2026-08-09-markdown-laimory-observability]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]
- [[2026-07-30-meeting-369-team-space]]
- [[2026-08-02-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]
- [[2026-08-06-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-runtime-and-observability]]
