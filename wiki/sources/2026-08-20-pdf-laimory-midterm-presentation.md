---
title: Laimory 프로젝트 중간점검 발표자료
source_type: pdf
source_path: raw/pdf/라이모리 중간 발표.pdf
source_date: 2026-08-20
ingest_date: 2026-08-20
status: ingested
tags: [laimory, sw-maestro, presentation, midterm-review, project-status]
---

# Laimory 프로젝트 중간점검 발표자료

## Summary

중간보고서 내용을 63쪽 16:9 발표 흐름으로 재구성한 최종 presentation PDF다. 문제 인식, 프로젝트·시장·사용자, 시스템·팀·일정, 모바일·서버·AI 개발 진행현황, 제품 검증·KPI, 수행 방법, 사업 가정, 기획심의 의견 반영과 결론을 section divider와 함께 설명한다.

## Key Claims

- MVP 핵심은 모바일 생활 데이터를 AI Timeline으로 만들고 사용자가 확인·수정·확정하는 흐름이다.
- 개발 진행현황은 모바일 수집·background 안정성, App Server 책임 분리·geocoding·비식별화, AI Agent pipeline·결정론 검증·User Memory·evaluation·관측으로 나눈다.
- beta는 약 20명, 2026-08-24~30, 5개 이상 기록 보상과 두 소구점 검증을 계획한다.
- KPI는 campaign 행동과 앱 내부 권한·Timeline·수정·memo·retention을 연결한다.
- 가격·운영비·손익분기와 AgentCore 전환은 발표 시점의 가정 또는 계획으로 구분해야 한다.

## Caveats

- 발표용 요약이므로 공식 중간보고서보다 세부 근거와 예외가 적다.
- 63쪽에는 section divider와 전환용 page가 포함되어, 발표 대본이 작성된 50쪽 버전과 page number가 일치하지 않는다.
- 사업 수치와 구현 상태는 발표 작성 시점 snapshot이며 이후 source·code로 재검증해야 한다.

## Document Check

- PDF: 63 pages, not encrypted.
- 2026-08-20에 63쪽 전체를 contact sheet로 렌더해 빈 page, clipping과 깨진 glyph가 없는지 확인했다.
- `pypdf`는 6개의 잘못된 object reference를 무시한다는 경고를 냈지만 PDFium은 63쪽을 모두 렌더했다. 배포 전 다른 viewer에서도 한 번 열어보는 편이 안전하다.
- SHA-256: `59EA823C35671FDA18CEA31C061B11C330CA4641EB4AC141C4056BE29DA90342`.

## Related Pages

- [[2026-08-17-pdf-laimory-midterm-report]]
- [[2026-08-19-notes-laimory-midterm-presentation-script]]
- [[2026-08-17-notes-laimory-midterm-presentation-html]]
- [[laimory]]
- [[369-team]]
