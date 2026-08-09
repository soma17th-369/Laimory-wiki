---
title: LLM Provider 구조와 모델 비교 계획
source_type: markdown
source_path: raw/markdown/ai system document/06-llm-providers-and-model-evaluation.md
ingest_date: 2026-08-09
status: ingested
tags: [laimory, llm, openai, gemini, bedrock, evaluation]
source_commit: c36799389ce449ad3b8500865476e1b7fb859a47
last_verified_at: 2026-08-09
---

# LLM Provider 구조와 모델 비교 계획

## Summary

OpenAI, Gemini, Bedrock SDK를 text, vision, JSON, Pydantic structured output의 공통 `LLMProvider` 계약으로 감싼 구조와 모델 평가 계획을 설명한다. 현재 prompt는 GPT 기준으로 개선됐지만 실제 운영 provider는 환경 설정에 따라 달라지고, 문서에 적힌 Nova 2 Lite, Gemini 2.5 Flash, GPT 5.4 mini 비교는 아직 완료된 결과가 아니라 평가 대상이다.

평가는 같은 commit, prompt version, fixture, User Memory, temperature와 Repair 상한을 고정한 1차 공통 prompt 비교와, 최소한의 모델별 튜닝을 허용한 2차 비교로 분리한다.

## Key Claims

- provider를 바꿔도 Agent 입력과 Pydantic 최종 계약은 같아야 한다.
- 품질 평가는 source 충실도, 사건 병합, hallucination, 문체, structured output, Repair, 질문, User Memory 안전성, latency·비용과 vision을 함께 본다.
- 평균적인 하루뿐 아니라 source 공백, 누락, 중복, 민감정보와 fallback을 자극하는 fixture가 필요하다.
- hard gate를 먼저 적용한 뒤 사실 충실도와 사용자 품질 중심 가중 평가를 제안한다.
- 모델당 한 번이 아니라 중요한 fixture를 여러 번 반복하고 Agent 단위와 end-to-end 결과를 분리한다.
- 최신 가격, availability, quota와 공개 benchmark는 평가 시점의 공식 자료와 실제 청구로 별도 검증해야 한다.

## Caveats

- 이 source에는 실제 세 모델의 비교 결과가 없다.
- Docker image 기본 provider와 실제 EC2/AgentCore runtime provider는 다를 수 있어 배포 환경 확인이 필요하다.

## Related Pages

- [[laimory-ai-model-evaluation]]
- [[ai-daily-timeline-generation]]
- [[laimory-ai-runtime-and-observability]]

