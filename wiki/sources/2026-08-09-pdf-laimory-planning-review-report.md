---
title: AI·SW마에스트로 제17기 369팀 프로젝트 기획심의 보고서
source_type: pdf
source_path: raw/pdf/2026-05-24-ai-sw-maestro-17-369-laimory-planning-review-report.pdf
source_url: https://app.notion.com/p/dd4cdc4d240a832f8286017888f6f3c9
pdf_creation_date: 2026-05-24
ingest_date: 2026-08-09
status: ingested
tags: [laimory, planning-review, sw-maestro, business-model, product-planning]
---

# AI·SW마에스트로 제17기 369팀 프로젝트 기획심의 보고서

## Summary

369팀의 Laimory 기획심의용 12쪽 PDF. 문제 인식과 기획 의도, 핵심 기능, 시장·경쟁 분석, 시스템 및 AI 활용 구상, 팀·멘토 구성, 일정, 사용자 검증 지표, 예상 리스크, 결과물, 구독 모델, 운영비 추정, 담당 멘토 의견을 담는다. 이전 Notion 부분 텍스트 캡처보다 본문이 완전하고 표·도식·화면 예시를 보존하므로 이를 대체하는 원본으로 채택했다.

## Key Claims

- Laimory는 사진·위치·일정·메모 등 모바일 생활 데이터를 자동 연결해 하루 타임라인, 구조화된 회고, 장기 맥락 기반 AI 대화를 제공하는 Personal AI Memory 서비스로 기획되었다.
- 문제 정의는 기록 수요 증가와 기록 피로, 모바일 데이터의 파편화, 기존 AI 서비스가 사용자의 실제 장기 생활 맥락을 충분히 이해하지 못한다는 한계에 초점을 둔다.
- 초기 페르소나는 바쁜 일상 속에서 자신의 삶을 돌아볼 시간이 부족한 30대 직장인이다.
- 비교 대상은 Limitless Pendant, Day One·Reflectly·마이모리 계열 AI 저널링 앱, Apple Journal·Google Journal 계열 플랫폼 저널이다. 문서는 자동 기록, 회고 지원, 생활 데이터 기반, 낮은 진입 장벽을 Laimory의 차별점으로 제시한다.
- 계획상 시스템은 Android client의 On-device AI, backend orchestration·reflection·memory 계층, 외부 LLM, Timeline DB·Vector DB·Memory Graph 저장 계층으로 구성된다.
- AI 활용 계획은 On-device 추출·분류·요약, Timeline Agent, Memory Agent, Reflection Agent와 Personal Coach Agent, AI 대화 Agent, 작업별 자체 LLM·상용 LLM의 동적 선택으로 설명된다.
- 팀 역할은 이동건(팀장·AI·Backend), 정수현(Infra·Backend), 전형선(Android·Google Play Store 배포)이다. 멘토 역할은 서비스·AI 품질·LLM 비용, Spring·Backend·Cloud architecture, Android 안정성·성능으로 나뉜다.
- 일정은 5월 기획·분석, 6월 설계, 6~7월 MVP, 7월 최초 배포, 8월 일상 기반 AI 대화·구독 결제 확장, 9월 2차 확장, 9~11월 2주 단위 추가 배포와 운영으로 계획되었다.
- 제품 검증 지표는 권한 허용률, 타임라인 조회·사용·수정률, 회고 완독·재방문율, AI 대화 메시지 수·만족도·재방문율, D7·D30 리텐션 등이다.
- 주요 리스크는 초기 데이터 부족, 동시 AI 요청에 따른 부하, Android 권한·백그라운드 제약, 민감 데이터 유출 우려, MVP 범위 확장, 초기 가치 체감 전 이탈이다.
- 사업화 가설은 Free, Premium(월 2,300원), Max(월 7,800원)의 3단계 구독이다. 7~11월 운영비를 월 125만~175만 원, 총 625만~875만 원으로 추산하고 Premium 약 550~760명 또는 Max 약 160~230명을 손익분기점 사용자 수로 제시한다.
- 담당 멘토 의견은 주제 도출과 시장·기술 검토를 긍정적으로 보면서도 MVP 범위, 개인정보·AI 품질 검증, 사용자 지속성과 사업화 가능성의 구체화를 강조한다.

## Comparison With Superseded Capture

- PDF 추출 텍스트는 약 18,101자이고 기존 Notion 부분 캡처는 약 4,955자였다.
- 공백을 제거한 단순 문자열 유사도는 약 40.5%였다. 기존 캡처는 핵심 표 일부를 옮겼지만 시장 근거, 경쟁 분석, 시스템 도식, 구체적 AI 단계, 멘토 구성, 화면 예시와 담당 멘토 의견을 충분히 보존하지 못했다.
- 기존 `raw/markdown/notion/369-team/laimory-planning-review-report.md`와 대응 source page는 중복·불완전 자료로 제거했다.

## Caveats

- PDF 표지는 파일명과 달리 내부 제목을 `2026년도 AI·SW마에스트로 제17기 프로젝트 기획서`로 표시한다. 이 페이지는 사용자 제공 파일명과 기존 Notion 문서명을 따라 `기획심의 보고서`로 식별한다.
- `2026-05-24`는 PDF 메타데이터의 생성일이며 본문에 명시된 제출일로 확인된 값은 아니다.
- 시장 규모, 캠페인 참여 수치, 해시태그 게시물 수, 경쟁 서비스 가격, 운영비와 손익분기점은 기획 문서의 주장이다. 독립 검증 전에는 확정 사실이 아닌 계획 가정으로 취급한다.
- 문서의 Agent·Reflection·Memory Graph 구조와 개발환경은 기획 시점 제안이다. 2026-08-09 현재 구현 계약은 최신 AI 시스템 문서를 우선한다.

## Related Pages

- [[laimory]]
- [[369-team]]
- [[laimory-planning-and-validation]]
- [[2026-06-15-markdown-notion-laimory-presentation-script-260529]]
- [[2026-06-15-markdown-notion-laimory-planning-review-evaluation]]
