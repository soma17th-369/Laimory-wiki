---
title: AI·SW마에스트로 제17기 서울센터 369팀 프로젝트 중간보고서
source_type: pdf
source_path: raw/pdf/3-3. 369. 중간보고서.pdf
pdf_creation_date: 2026-08-17
ingest_date: 2026-08-17
status: ingested
tags: [laimory, midterm-report, sw-maestro, development-status, product-validation]
---

# AI·SW마에스트로 제17기 서울센터 369팀 프로젝트 중간보고서

## Summary

369팀이 2026년 8월 중간 시점의 Laimory 기획, 구현, 검증 계획과 멘토 의견을 정리한 27쪽 공식 프로젝트 보고서다. 5월 기획심의 자료의 문제 정의와 Personal AI Memory 방향을 이어가면서, 1차 MVP를 하루 타임라인 생성·기록으로 좁히고 Android·API Server·AI Server의 구현 진행, 첫 가치 행동과 베타테스트, KPI, 마케팅 소구점 실험을 구체화한다.

보고서상 로그인, 권한 설정·생활 데이터 수집, 비동기 AI 타임라인 생성, 편집·확정, 월별 기록 조회까지 구현·연동을 마치고 App Tester 알파 테스트를 진행 중이다. 이는 완료된 출시나 사용자 검증 결과가 아니라 2026-08-17 문서 작성 시점의 팀 보고 상태다.

## Key Claims

### Product and validation

- 핵심 타깃은 기록·회고에 관심이 있고 사진·일정·메모 사용에 익숙한 20대 후반~30대 사회초년생·저연차 직장인이다.
- 1차 MVP의 핵심 범위는 자동 타임라인 생성과 사용자의 편집·회고 기록 완성이다. 목표 추적과 충분한 데이터 누적 뒤의 일상 기반 AI 대화는 후속 범위로 설명된다.
- 첫 가치 행동은 사용자가 생성된 타임라인을 확인하고 필요하면 수정한 뒤 첫 일간 회고 작성을 완료한 시점으로 정의한다.
- 베타테스트는 약 20명을 대상으로 2026-08-24~08-30 진행할 계획이며, 5개 이상 일기를 쓴 참여자에게 소정의 보상을 제공하고 Google Form·인터뷰로 품질과 사용성을 확인한다.
- 제품 메시지는 `오늘 하루, 얼마나 기억하고 있나요?`와 `일기를 쓰고 싶지만, 매일 기록하는 일이 힘들지 않나요?` 두 소구점을 비교한다. 정식 출시 뒤 Meta 광고 약 30만 원을 균등 배분하고 install referrer와 GA4로 첫 가치 행동까지 연결할 계획이다.
- 앱 KPI는 권한 동의율, 타임라인 완료율, 이벤트 수정·삭제율, 메모 추가율, 평균 메모 수와 D1·D7·D30 리텐션이다. 분석 이벤트에는 메모·사진·위치·타임라인 원문 대신 행동 횟수와 완료 여부만 넣는다고 명시한다.

### Current implementation reported by the team

- Android 앱은 MediaStore, Calendar Provider, Health Connect 등으로 사진·위치·일정·건강·알림을 수집해 공통 구조로 변환하고 Room에 저장한다. 권한 거부·회수는 앱 전체 중단이 아니라 해당 source만 제한하도록 처리한다.
- 위치 수집은 Foreground Service, 체류·이동 구간 변환과 재시작 복원으로 안정화했으며, Android 버전·제조사별 누락과 배터리 영향은 베타에서 추가 검증할 예정이다.
- AI 생성은 약 40초가 걸리는 비동기 작업으로 관리하고, 앱은 task 식별자를 보존해 foreground polling과 background FCM 알림을 결합한다. 완료 뒤 제목·시간·메모·사진의 수정·삭제와 하루 기록 확정을 지원한다.
- API Server는 source와 결과의 소유권, 전처리, 사용자 인증, 콘텐츠 권한, task 상태와 저장을 맡는다. AI Server는 taskId와 작업 전용 token으로 해당 작업의 source만 조회하고 생성 결과를 API Server에 반환한다.
- 위치 보강은 중복 좌표를 제거한 뒤 요청당 최대 50개, 동시 4개씩 Kakao API로 처리한다. 고유 좌표 실패율이 20% 이하이면 부분 성공을 허용하고, 20% 초과 또는 시간순 3개 연속 실패에서는 생성을 중단한다고 설명한다.
- 콘텐츠 영역은 인증 userId와 분리한 무작위 Subject ID를 쓰며, HMAC-SHA-256 조회 키와 비밀키 버전으로 mapping을 검색한다. 비밀키는 AWS Secrets Manager에 두고 S3 경로에는 Subject ID의 SHA-256 namespace를 사용한다고 보고한다.

### AI, quality, and operations

- AI 흐름은 source 조회·전처리, 위치·일정·사진·건강·알림의 5개 Event Agent 병렬 분석, Timeline 병합, Repair 검증·보정, Question 생성, 저장 순서다.
- Calendar 보존, 선택 사진 귀속, source 근거, request 시간 범위, 이벤트 길이와 설명 길이 같은 기준을 prompt에 수치화하고, 누락·중복·시간·장소·source 연결은 결정론적 코드로 다시 검사한다.
- User Memory는 확정 기록을 병합해 다시 쓰는 고정 JSON profile이며 Timeline·Question 개인화에 쓰인다. 성격·가치관·선호는 사용자가 직접 쓴 memo에서만 추출하고 source와 충돌하면 원본을 우선한다.
- 모델 비교군은 GPT-5.4 mini, Gemini 2.5 Flash, Amazon Nova 2 Lite이며 사건 추론, 한국어 품질, JSON 준수, 이미지 이해, 응답 시간과 비용을 동일 service data로 평가 중이라고 한다.
- 운영 event는 stdout JSON, Filebeat, Elasticsearch로 수집하고 Agent·LLM trace는 Langfuse에 기록해 taskId로 연결한다. 현재 AI runtime은 Docker 기반 EC2이고 GitHub Actions–ECR–SSM 자동 배포·rollback을 사용하며, AgentCore on-demand 전환은 향후 계획이다.
- 생성 품질 개선은 Langfuse input/output을 이용한 LLM-as-a-Judge, rule 검증, 문제별 test data 생성과 재검증을 반복하는 구조다. 아직 model별 최종 평가 결과는 제시하지 않는다.

### Mentor feedback

- 기획·AI 멘토는 문제와 핵심 가치, Multi-Agent와 결정론 검증, Evaluation System, 사용자 행동 지표 계획을 강점으로 평가하면서 MVP 핵심 가치와 후속 기능의 분리, 각 지표의 정량 목표와 실제 결과를 요구한다.
- Backend·DB 멘토는 API Server와 AI Server의 책임 분리와 taskId 기반 비동기 구조의 발전을 긍정적으로 평가하면서 callback 유실, 중복 요청, 서버 재시작에서도 정합성과 재처리가 유지되는지 실제 사용자 시나리오로 검증하라고 제안한다.
- Mobile·UX 멘토는 지표 중심의 성장 관측과 life data 수집을 긍정적으로 보면서, 개인의 지난 하루에 관심을 갖게 만드는 더 넓은 시장 발굴 전략이 필요하다고 지적한다.

## Changes Since Planning Review

- 기획심의 당시 넓게 제시된 Timeline·목표 추적·AI 대화 범위에서 1차 MVP를 Timeline 생성·기록으로 좁혔다.
- On-device AI·Memory Graph 중심의 초기 개념 구성도보다 App Server가 데이터를 소유하고 무상태 AI Server가 작업 단위로 실행되는 현재 구조를 구체적으로 제시한다.
- 권한의 단계적 요청, 부분 source 동작, 사용자 선택 데이터 전송, 생성 결과 수정·삭제와 최종 확정을 구체적 UX·처리 방안으로 연결한다.
- 단순 설치·가입보다 첫 일간 회고 완료를 첫 가치 행동으로 두고, 캠페인 attribution에서 반복 행동까지 측정하는 검증 계획을 세웠다.

## Caveats

- `2026-08-17`은 PDF metadata의 생성일이며 별도 제출일 표기는 확인되지 않았다.
- 구현·배포·보안에 관한 내용은 공식 팀 보고이지만 이 ingest에서 각 repository의 code, AWS 설정이나 운영 data까지 교차 검증하지 않았다.
- 8월 24~30일 베타테스트, 9월 초 출시, AgentCore 전환, 모델 비교와 KPI 결과는 향후 계획 또는 진행 중 작업이며 완료 사실이 아니다.
- 첫 가치 행동은 `첫 일간 회고 완료`로 정의하지만 D1·D7·D30은 표에서 `첫 타임라인 생성 후 재생성`으로 정의한다. activation cohort 기준과 retention event 기준을 구현 전에 더 명확히 맞출 필요가 있다.
- 시장 규모, 캠페인 참여·다운로드·해시태그 수, 경쟁 서비스 가격, 운영비와 손익분기점은 보고서가 인용하거나 계산한 수치이며 이 ingest에서 독립 검증하지 않았다.
- PDF의 연간 비교표는 Laimory 가격을 `23,000원 / 78,000원`으로 쓰지만 월 구독안은 Premium 2,300원, Max 7,800원이라 단순 12개월 환산과 일치하지 않는다. 할인 또는 표기 기준은 문서에 설명되지 않는다.

## Document Check

- PDF: A4, 27 pages, tagged, not encrypted.
- SHA-256: `8319A1B7C6BFE60822339907844BE3AC8E4080055C77C18159FF58BD8F60D535`
- 2026-08-17에 전 페이지를 PNG로 렌더링해 표, 시스템 구성도, 앱 화면, AI pipeline과 KPI 표의 가독성을 확인했다.

## Related Pages

- [[laimory]]
- [[369-team]]
- [[laimory-planning-and-validation]]
- [[android-life-logging-data-collection]]
- [[ai-daily-timeline-generation]]
- [[laimory-user-memory]]
- [[laimory-ai-model-evaluation]]
- [[laimory-ai-runtime-and-observability]]
- [[2026-08-09-pdf-laimory-planning-review-report]]
