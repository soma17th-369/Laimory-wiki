---
source_type: notion
source_url: https://app.notion.com/p/b53cdc4d240a822eb96a018359517051
title: Specification
captured_at: 2026-06-15
capture_method: Notion MCP fetch
status: raw-text-snapshot
---

# Specification

## 작성 가이드

### Columns

- 카테고리: 기능의 대분류. 유사 기능끼리 묶어서 작성. 새 카테고리 추가 시 팀과 합의.
- Depth_1: 카테고리 하위 기능 그룹. 카테고리 없이 단독 작성 금지.
- Depth_2: Depth_1의 세부 기능. Depth_1 없이 단독 작성 금지.
- Depth_3: 실제 구현 단위 기능. 개발자가 바로 작업할 수 있는 수준으로 구체적으로 작성.
- Priority: 개발 우선순위. 팀 전체 합의 후 설정.
- Apply: 현 스프린트 적용 여부. Yes = 이번 개발에 포함, No = 제외 또는 보류.
- Status: 진행 상태. 주 1회 이상 업데이트 권장.
- MVP: MVP 포함 여부. Open = MVP 확정 스펙, Update = MVP 이후 업데이트 예정.
- Description: 참고사항, 정책, 스펙 세부 사항, 디자인 링크, 법무 검토 필요 여부, 외부 연동 정보 등.

### Priority 기준

- 매우높음: MVP 필수. 없으면 서비스 불가.
- 높음: 초기 출시 권장. 핵심 UX에 영향.
- 보통: 2차 릴리즈 고려. 있으면 좋은 기능.
- 낮음: 여유 있을 때 개발. 편의 수준.
- 매우낮음: 현재 로드맵 밖. 백로그 유지.

### Status 기준

- Backlog: 미착수. 일정 미정.
- Design: 디자인/기획 단계.
- OnTrack: 일정대로 개발 진행 중.
- QA: 테스트 진행 중.
- Done: 개발 완료, QA 전.
- COMPLETE: QA 포함 전 단계 완료.
- ISSUE: 이슈 발생, 블로킹 상태.
- HOLDING: 의사결정 대기 또는 보류.

### MVP 기준

- Open: MVP 스펙 확정. 변경 없이 진행.
- Update: MVP 이후 업데이트 예정 또는 스펙 변경 가능성 있음.

### Apply 기준

- Yes: 현재 프로젝트에 적용 예정인 기능.
- No: 현재 개발 범위에서 제외된 기능.

## Linked specification pages

- Epic - 시스템 초기 설계 및 구축: https://app.notion.com/p/956cdc4d240a837d971f811eb4086fe1
- AI 하루 타임라인 기능 MVP 개발: https://app.notion.com/p/27fcdc4d240a82519d78012ee0702a42
