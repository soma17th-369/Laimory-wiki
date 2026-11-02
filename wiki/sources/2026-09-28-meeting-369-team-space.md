---
title: 369팀 스페이스 회의 요약 - 2026-09-28
source_type: meeting
source_path: raw/meetings/369팀 스페이스_20260928_2300/회의 요약_369팀 스페이스_20260928.md
transcript_path: raw/meetings/369팀 스페이스_20260928_2300/대화 내용_369팀 스페이스_20260928.md
export_summary_path: raw/meetings/369팀 스페이스_20260928_2300/미팅 요약_369팀 스페이스_20260928.md
meeting_date: 2026-09-28
summary_date: 2026-11-02
ingest_date: 2026-11-02
transcript_type: auto-generated
speaker_attribution: available-unverified
status: ingested
tags: [meeting, transcript, 369-team, laimory]
---

# 369팀 스페이스 회의 요약 - 2026-09-28

## 개요

KPI 쿼리·스토어와 랜딩 시각 자료·문의 기능을 준비했다. Service layer transaction 범위를 일관되게 정할 필요성을 논의했으나 보편적 기술 결론은 남기지 않았다.

## 상세 요약

### KPI

- **진행 중**: Notion에 GA4 event를 정리했으며 KPI를 계산할 쿼리가 필요하다고 설명했다. 실제 데이터 산출 완료는 아니다. (`2:13-2:30`)

### Transaction

- **논쟁·검토**: SELECT·UPDATE를 묶는 transaction 필요성과 service layer의 공통 패턴을 논의했다. 명시적 save 대신 transaction을 선호하는 의견도 있었지만 성능·격리 검증이 있는 확정 규칙으로 보지 않는다. (`4:33-5:20; 39:15`)

### 스토어 디자인

- **검토·수정안**: 실제 폰 비율과 Figma 비율 차이를 조정하고, 사진·calendar 등 원본 입력이 어떻게 보이는지에 더 집중하자는 방향을 제시했다. (`7:16-8:03; 15:51; 25:28`)

### 문의

- **전송 시험 보고·확장 계획**: 사진을 넣어 문의를 보내는 시험은 완료했다고 보고했다. 문의 내역 목록 제공 여부를 논의하고 GET endpoint를 열어 server 상태를 앱에 표시하는 안이 나왔다. (`22:20-23:45`)

### 연락 이메일

- **고지 확인 과제**: Social login 정보와 실제 문의 회신 이메일이 다를 수 있어 별도 저장·고지 영향을 검토했다. 구체적 보존·동의 정책은 확인되지 않았다. (`54:33`)

## 결정·진행 상태

| 쟁점 | 회의에서 확인되는 상태 | 근거 |
|---|---|---|
| KPI | 진행 중 | `2:13-2:30` |
| Transaction | 논쟁·검토 | `4:33-5:20; 39:15` |
| 스토어 디자인 | 검토·수정안 | `7:16-8:03; 15:51; 25:28` |
| 문의 | 전송 시험 보고·확장 계획 | `22:20-23:45` |
| 연락 이메일 | 고지 확인 과제 | `54:33` |

## 후속 확인·열린 질문

Transaction 규칙과 측정 근거, 문의 조회 API·이메일 고지, 심사 상태와 KPI query 실데이터 검증이 남아 있다.

## 주의 사항

- 제공 자동 요약으로 쟁점을 찾고 원전 전사의 시각 표시 발언을 발췌 대조한 핵심 요약이다. 전체 발언의 축어 재구성이 아니며 자동 요약의 단정과 원전이 다르면 원전을 우선한다.
- 자동 전사의 화자·기술 용어·수치에는 오인식 가능성이 있다. 회의일은 폴더·파일 날짜 기준이며 정확한 자정 경계는 확인하지 않았다.
- 구현·배포·성과·비용은 해당 시점 참여자의 보고 또는 추정이다. 코드·콘솔·청구서·실데이터로 독립 검증한 결과가 아니며 목표를 완료로 바꾸지 않는다.
- 개인정보가 포함된 원전의 개인 일정·연락처·로그인 접근값은 요약에 재기재하지 않는다.

## 관련 페이지

- [[369-team-meeting-history]]
- [[369-team]]
- [[laimory]]
- [[laimory-planning-and-validation]]
- [[laimory-ai-runtime-and-observability]]
- [[laimory-data-privacy-and-consent]]
- [[android-life-logging-data-collection]]
