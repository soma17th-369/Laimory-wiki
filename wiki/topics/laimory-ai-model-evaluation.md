---
title: Laimory AI Model Evaluation
kind: topic
status: evaluation-in-progress
updated: 2026-11-02
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

2026-08-24~30 회의는 평가가 실제 전환 trial로 들어갔지만 아직 재현 가능한 결론에 도달하지 못했음을 보여준다. Bedrock 후보는 JSON tool/schema와 max token 문제로 output이 없거나 message에서 실제 행동을 충분히 추론하지 못하는 사례가 보고됐고, 08-30에는 전사상 Nova Lite로 들리는 후보를 Timeline 주력에서 제외하기로 했다. 대신 간단한 event 단계에는 저비용 model, 핵심 Timeline에는 더 강한 model을 쓰는 stage별 routing이 제안됐다. 자동 전사 model명은 일관되지 않고 표본·score·배포 설정이 없으므로 이를 검증된 winner나 production 계약으로 보아서는 안 된다.

평가 도구는 Langfuse 결과를 local에서 분석하는 방향에서, API judge 비용을 줄이기 위해 구독 중인 Codex CLI를 local judge로 연결하는 실험까지 확장됐다. 이 방식은 비용 장점과 별개로 reproducibility, authentication, model/version 고정과 batch automation을 검증해야 한다.

2026-09-01~03 회의에서는 `과도하다`, `강하다` 같은 모호한 prompt 기준을 셀 수 있는 metric으로 바꾸고, 모순·불필요 instruction을 정리해 변경 전후 결과를 동일 score로 비교하는 evaluation system을 거의 확정했다고 보고했다. 실제 metric 목록·fixture·score 결과는 회의 전사에 없으므로 구현 완료나 개선 효과로 볼 수 없다. 같은 기간 Timeline 생성과 User Memory update 한 세트의 평균 비용을 약 `$0.1`로 추정했지만, model·token·retry·image·Repair 포함 범위와 billing sample이 없어 운영 예산의 검증값이 아니라 내부 가정이다.

## 2026-09~11 회의 반영

09-08~09-29에는 V3 개선이 여러 차례 목표 일정보다 길어졌고 09-29 원전은 아직 미완료라고 말한다. 10-10 production 반영 목표 뒤 10-11 전환 보고와 설정 문제를 함께 기록해야 한다. 평가 system 사용 보고는 있지만 동일 fixture의 전후 점수·운영 설정·반복 표본은 제시되지 않았다. 10-20 location·calendar의 LLM event 전처리를 code로 바꾸려는 계획은 8월의 다섯 Agent 문서를 갱신할 후속 검증 후보이며 실제 새 graph로 확정하지 않는다. 근거: [[2026-09-08-meeting-369-team-space]], [[2026-09-29-meeting-369-team-space]], [[2026-10-11-meeting-369-team-space]], [[2026-10-20-meeting-369-team-space]].

장소 추론은 10-08 확대 시험 뒤 10-10 별도 근거가 없으면 주소 수준으로 보수화하는 방향으로 바뀌었다. 10-26~27에는 사진 근거 후보·새 event 유형·장소 선택 schema를 조정했다. 이는 prompt 품질뿐 아니라 입력 데이터·사용자 수정·schema 정합성을 함께 평가해야 하는 변화다. [[2026-10-08-meeting-369-team-space]], [[2026-10-10-meeting-369-team-space]], [[2026-10-26-meeting-369-team-space]], [[2026-10-27-meeting-369-team-space]].

비용은 10-12 prompt 증가로 약 100원 수준 재상승, 10-18 일일 사용량 2.9와 원화 약 4,000원 추산, 11-01 개발 Agent의 실제 API 반복 호출 급증이 서로 다른 범위다. 활성 인원으로 일일 비용을 나눈 약 22원을 생성당 원가로 쓰지 않는다. 11-01 총 700달러에서 기충전 99달러를 뺀 601달러 추가안 역시 청구·납부 완료가 아니다. 광고의 약 5%·4.8%를 AI 성능으로 바꾼 10-07 자동 요약 오류도 재사용하지 않는다. [[2026-10-12-meeting-369-team-space]], [[2026-10-18-meeting-369-team-space]], [[2026-11-01-meeting-369-team-space]], [[2026-10-07-meeting-369-team-space]].

## Key Points

- 평균적인 하루와 함께 source 공백, 겹침, 누락, 민감정보, vision 실패, 깨진 profile fixture가 필요하다.
- 중요한 fixture는 모델별로 여러 번 반복해 stochastic variance를 본다.
- Agent 단위 결과와 end-to-end task 결과를 분리해야 실패 원인을 찾을 수 있다.
- source hallucination, structured failure, timeout, privacy 회귀와 Photo 요구 충족을 hard gate로 둔다.
- 품질 평가는 모델 이름을 가린 blind review와 source 원본 대조가 바람직하다.
- 가격과 availability는 평가 시점의 공식 문서와 실제 사용량·청구 snapshot으로 검증한다.
- Stage별 model routing은 전체 평균만 비교하지 말고 event 단계와 Timeline 단계의 품질 gate·fallback·비용을 각각 측정해야 한다.
- 회의에서 관찰된 structured output 실패와 notification 과잉 event는 task ID·trace·fixture로 보존해야 model attribution 오류를 피할 수 있다.
- 자연어 평가 기준은 관찰 가능한 count·ratio·hard violation으로 변환하고, prompt version별 동일 fixture score와 원본 failure를 함께 보존해야 한다.
- request당 비용은 Timeline과 User Memory 단계별 token·retry·vision·Repair를 분리해 실제 billing과 대조해야 한다.

## Open Questions

- fixture와 golden behavior를 누가, 어떤 버전 정책으로 관리할 것인가?
- 모델별 반복 횟수와 통계적 최소 표본을 어느 수준으로 정할 것인가?
- production 사용자 데이터를 사용하지 않고도 한국어 일상 분포를 충분히 재현할 수 있는가?
- hard gate와 품질·latency·비용 가중치를 제품 단계별로 어떻게 바꿀 것인가?
- 회의에서 언급된 local 품질 검증 프로그램이 기존 평가 계획의 어떤 metric과 fixture를 구현하는가?
- 8월 말 회의에서 언급된 model들의 정확한 identifier, region, SCP·cross-region 조건과 실제 release 설정은 무엇인가?
- Codex CLI judge를 반복 실행할 때 model/version, prompt, rate limit과 결과 provenance를 어떻게 고정할 것인가?
- Stage별 routing의 fallback과 quality threshold를 어떤 offline·beta signal로 승인할 것인가?
- 9월 초에 거의 확정됐다고 보고한 정량 metric의 정확한 정의, 가중치, fixture와 regression threshold는 무엇인가?
- `$0.1` 내부 추정의 sample 수와 model·token·retry·image·Repair 포함 범위는 무엇인가?

## Linked Sources

- [[2026-09-05-meeting-369-team-space]]
- [[2026-09-08-meeting-369-team-space]]
- [[2026-09-10-meeting-369-team-space]]
- [[2026-09-15-meeting-369-team-space]]
- [[2026-09-29-meeting-369-team-space]]
- [[2026-10-10-meeting-369-team-space]]
- [[2026-10-11-meeting-369-team-space]]
- [[2026-10-12-meeting-369-team-space]]
- [[2026-10-13-meeting-369-team-space]]
- [[2026-10-18-meeting-369-team-space]]
- [[2026-11-01-meeting-369-team-space]]

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-09-markdown-laimory-prompt-engineering]]
- [[2026-08-09-markdown-laimory-llm-provider-model-evaluation]]
- [[2026-08-09-markdown-laimory-observability]]
- [[2026-08-09-markdown-laimory-ai-invariants-and-known-gaps]]
- [[2026-07-30-meeting-369-team-space]]
- [[2026-08-02-meeting-369-team-space]]
- [[2026-08-05-meeting-369-team-space]]
- [[2026-08-06-meeting-369-team-space]]
- [[2026-08-10-meeting-369-team-space]]
- [[2026-08-12-meeting-369-team-space]]
- [[2026-08-19-meeting-369-team-space]]
- [[2026-08-24-meeting-369-team-space]]
- [[2026-08-25-meeting-369-team-space]]
- [[2026-08-27-meeting-369-team-space]]
- [[2026-08-30-meeting-369-team-space]]
- [[2026-09-01-meeting-369-team-space]]
- [[2026-09-02-meeting-369-team-space]]
- [[2026-09-03-meeting-369-team-space]]

## Related Pages

- [[laimory]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-runtime-and-observability]]
