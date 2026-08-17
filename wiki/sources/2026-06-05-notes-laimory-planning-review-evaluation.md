---
title: AI·SW마에스트로 제17기 Laimory 기획심의 종합의견
source_type: notes
source_path: raw/notes/2026-06-05-laimory-planning-review-evaluation.md
secondary_source_path: raw/markdown/notion/369-team/laimory-planning-review-evaluation.md
source_url: https://app.notion.com/p/d62cdc4d240a83aba0f781b75528824c
source_date: 2026-06-05
ingest_date: 2026-08-10
status: ingested
tags: [laimory, planning-review, feedback, sw-maestro, product-validation]
---

# AI·SW마에스트로 제17기 Laimory 기획심의 종합의견

## Summary

2026-06-05 등록된 AI·SW마에스트로 제17기 Laimory 기획심의 종합의견이다. 평가자는 사진·위치·일정 등 파편화된 생활 데이터를 하루 Timeline과 장기기억형 회고로 연결하는 문제 정의, 디지털 저널링 수요, 자동 라이프 로깅의 발상과 복합 기술 구조를 긍정적으로 평가했다. 동시에 8월 중간점검에서 즉시 체감 가치, permission UX, Android background 안정성, 차별성과 신뢰, 제한된 source만으로 제공할 결과, AI의 구체적 부가가치, On-device SLM의 한국어 성능·배터리, 장기 retention과 유료 전환을 개선해 반영하도록 요구했다.

## Key Claims

- 프로젝트 기술분류는 `소프트웨어 - 기반 SW`다.
- 사진·위치·일정 등 모바일 생활 데이터를 자동 통합해 하루 Timeline을 구조화하는 문제 정의와 아이디어는 명확하고 우수하다고 평가되었다.
- 초기 사용자가 민감 데이터 접근 권한을 허용할 만큼의 즉시 체감 가치와, 무료 장기기억 경험에서 유료 기능으로 전환되는 시점의 구체화가 필요하다.
- 필수 permission 획득 허들을 낮추는 UX와 기기별 background data 유실 방지 시나리오를 보완해야 한다.
- 유사한 life logging 시도의 성공 사례가 많지 않으므로 Apple Journal, Day One 등과 비교한 독창성, 별도 앱에 장기 데이터를 맡길 이유와 신뢰 형성을 명확히 해야 한다.
- 20~30대 직장인 대신 50대 이상 active senior와 자서전 방향으로 pivot하는 대안이 제안되었지만, 이는 평가자의 제안이지 확정된 제품 결정은 아니다.
- 사진·위치·일정처럼 실제 자동 수집 가능한 source가 제한된 상황에서 어떤 유용한 결과를 만들고 지속 사용을 이끌지 검증해야 한다.
- 자동 생성된 기억이 실제 맥락과 다를 수 있으므로 사용자가 쉽게 수정·삭제·비공개 처리할 수 있어야 하고, On-device 처리 범위와 외부 model 전송 기준을 보강해야 한다.
- Android·Spring Boot·Kafka·자체 Agent·상용 LLM API를 결합한 기획 시점 architecture는 체계적이라고 평가되었지만, Android version별 background 동작과 battery cost의 실현 가능성 검증이 필요하다.
- On-device SLM의 한국어 일상 event 요약·감정 추출 성능과 최적화·battery risk를 고려해야 한다.
- 단순한 mobile data 시각화를 넘어 AI가 기존 정보를 어떻게 조합해 기억 복원, pattern 분석, 변화 인식과 새로운 정보를 제공하는지 구체화해야 한다.
- 무료 장기기억 위에 고급 회고·생활 pattern·AI 대화·과거 기억 검색을 유료화하는 전략은 합리적이라고 평가되었지만, 반복 방문률과 유료 전환 지점은 정량 검증이 필요하다.

## Midterm Review Obligations

- permission 이전에 사용자가 체감할 첫 가치를 정의하고 증거로 보여준다.
- background 수집·battery·data loss를 실제 Android 환경에서 검증한다.
- 제한된 source로 만든 Timeline의 품질과 사용자 수정 가능성을 보여준다.
- source 조합에서 AI가 만드는 부가가치와 실패 통제 방식을 설명한다.
- privacy, 비공개, 외부 model 전송과 장기 데이터 신뢰 정책을 구체화한다.
- 다운로드가 아니라 반복 방문과 유료 전환으로 이어지는 행동 지표를 제시한다.

## Caveats

- raw note는 2026-08-10 사용자가 제공한 공식 평가의견 문구를 `ㅇ` 단락 구조와 함께 보존한다. 기존 Notion raw capture는 `secondary_source_path`에 남겼다.
- 평가자는 여러 명일 수 있으나 원문에는 항목별 작성자 구분이 없다.
- 50대 이상 active senior·자서전은 제안이며 팀이 수용했다고 단정할 수 없다.
- 기획 시점의 Kafka, Edge SLM과 On-device AI 계획은 현재 구현 계약이 아니다. 현재 상태를 판단할 때는 최신 source와 code 검증을 우선한다.
- Apple Journal의 기능과 지속 사용에 관한 평가는 심의 의견에 포함된 주장으로, 독립 검증 전에는 확정 사실로 일반화하지 않는다.

## Related Pages

- [[laimory]]
- [[laimory-planning-and-validation]]
- [[android-life-logging-data-collection]]
- [[2026-08-09-pdf-laimory-planning-review-report]]
- [[2026-06-15-markdown-notion-laimory-presentation-script-260529]]
