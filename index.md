# Index

Primary catalog for the LLM Wiki maintained in this vault.

## Sources

- Backend and database decision notes:
  - [Backend version decision - Spring Boot and Java](wiki/sources/2026-06-15-notes-backend-version-decision.md)
  - [Database choice decision - MySQL](wiki/sources/2026-06-15-notes-database-choice-decision.md)
  - [Timeline Card Grouping And Typed Payload Design](wiki/sources/2026-06-16-notes-timeline-card-grouping-design.md)
  - [Timeline Draft API Thought Process](wiki/sources/2026-06-17-notes-timeline-draft-api-thought-process.md)
  - [Timeline Implementation Reconciliation](wiki/sources/2026-06-19-notes-timeline-implementation-reconciliation.md)
  - [Timeline Backend Change Plan](wiki/sources/2026-06-20-notes-item-type-column-plan.md)
  - [AI Daily Timeline Agent Draft](wiki/sources/2026-06-20-notes-ai-daily-timeline-agent-draft.md)

- AWS infrastructure and cost notes:
  - [VPC Cost Investigation - SSM Interface Endpoints](wiki/sources/2026-06-21-notes-vpc-ssm-endpoint-cost.md)

- Android laboratory data extraction:
  - [Laboratory Mobile Data Extraction](wiki/sources/2026-06-27-github-laboratory-mobile-data-extraction.md)

- GitHub collaboration rules:
  - [GitHub Co-work Rule](wiki/sources/2026-06-28-github-github-co-work-rule.md)

- Notion 369 team raw capture:
  - [Notion 369팀 루트](wiki/sources/2026-06-15-markdown-notion-369-team-root.md)
  - [Notion 369팀 소개 페이지](wiki/sources/2026-06-15-markdown-notion-369-team-introduction.md)
  - [Notion 369팀 일정 DB](wiki/sources/2026-06-15-markdown-notion-369-team-schedule.md)
  - [Notion 369팀 회의록 허브](wiki/sources/2026-06-15-markdown-notion-meeting-records.md)
  - [Notion 369팀 회고록 허브](wiki/sources/2026-06-15-markdown-notion-retrospective-records.md)
  - [Notion 369팀 아이디어 리스트](wiki/sources/2026-06-15-markdown-notion-ideas-list.md)
  - [Notion 369팀 Tech Spec 허브](wiki/sources/2026-06-15-markdown-notion-tech-spec.md)
  - [Notion 369팀 Specification](wiki/sources/2026-06-15-markdown-notion-specification.md)
  - [Notion 369팀 ERD](wiki/sources/2026-06-15-markdown-notion-erd.md)
- Notion Laimory raw capture:
  - [Notion Laimory](wiki/sources/2026-06-15-markdown-notion-laimory.md)
  - [Notion 모바일 기반 AI 라이프 로깅 앱 (1)](wiki/sources/2026-06-15-markdown-notion-mobile-ai-lifelogging-app-1.md)
  - [Notion AI 일기 초안 작성 서비스](wiki/sources/2026-06-15-markdown-notion-ai-diary-draft-service.md)
  - [Notion AI 일기 리뉴얼](wiki/sources/2026-06-15-markdown-notion-ai-diary-renewal.md)
  - [Notion AI 하루 타임라인 기능 MVP 개발](wiki/sources/2026-06-15-markdown-notion-ai-daily-timeline-mvp.md)
  - [Notion Epic - 시스템 초기 설계 및 구축](wiki/sources/2026-06-15-markdown-notion-epic-system-initial-setup.md)
  - [Notion 백그운드 위치 가져오기](wiki/sources/2026-06-15-markdown-notion-background-location.md)
  - [Notion Laimory 기획심의 보고서](wiki/sources/2026-06-15-markdown-notion-laimory-planning-review-report.md)
  - [Notion Laimory 기획심의 발표 스크립트 260529](wiki/sources/2026-06-15-markdown-notion-laimory-presentation-script-260529.md)
  - [Notion Laimory 기획심의 평가의견](wiki/sources/2026-06-15-markdown-notion-laimory-planning-review-evaluation.md)

## Topics

- [AI Life Logging](wiki/topics/ai-life-logging.md): mobile AI life-logging and Personal AI Memory pattern synthesized from Laimory planning sources.
- [AI Daily Timeline Generation](wiki/topics/ai-daily-timeline-generation.md): Laimory AI timeline generation architecture using Event normalization, Reflection, and selective re-orchestration.
- [Laimory Planning And Validation](wiki/topics/laimory-planning-and-validation.md): Laimory planning, metrics, risks, and validation questions.
- [Android Life Logging Data Collection](wiki/topics/android-life-logging-data-collection.md): Android location/background-data constraints for life-logging apps.

## Entities

- [369팀](wiki/entities/369-team.md): SW Maestro team, operating model, roles, and workspace structure.
- [Laimory](wiki/entities/laimory.md): Android Personal AI Memory / AI life-logging product concept.

## Answers

- [Server-to-server auth for Laimory](wiki/answers/server-to-server-auth-for-laimory.md): recommended server-to-server authentication path for app server and AI server callbacks.
- [Timeline Draft API Sequence Diagrams](wiki/answers/timeline-draft-api-sequence-diagrams.md): Mermaid sequence diagrams for the current timeline draft creation, AI callback, and polling APIs.
- [Laimory Backend Feedback Code Mapping](wiki/answers/laimory-backend-feedback-code-mapping.md): maps mentor/backend review feedback to the planned server code changes.
- [AWS root user vs IAM user](wiki/answers/aws-root-user-vs-iam-user.md): why AWS root should be reserved for root-only tasks and daily work should use IAM Identity Center, roles, or scoped IAM identities.
- [AWS Organizations and Identity Center account model](wiki/answers/aws-organizations-identity-center-account-model.md): how management accounts, member accounts, Identity Center users, permission sets, and resources relate.
- [Mobile Data Extraction Payload Structure](wiki/answers/mobile-data-extraction-payload-structure.md): proposed JSON and human-readable table structure for sending Laboratory mobile extraction data as typed timeline source items.

## Domains

No domain pages yet.

## References

- [llm-wiki-karpathy.md](references/llm-wiki-karpathy.md): local reference for the Karpathy LLM Wiki pattern.

## Team Explanation Documents

- [Karpathy의 LLM-wiki 설명.md](<Karpathy의 LLM-wiki 설명.md>): explanation of the local Karpathy LLM Wiki reference for teammates.
- [Agents.md 설명.md](<Agents.md 설명.md>): explanation of the vault operating schema for teammates.
- [GBrain과 Karpathy의 LLM wiki 비교.md](<GBrain과 Karpathy의 LLM wiki 비교.md>): comparison between GBrain and the Karpathy LLM Wiki pattern.

## Control Files

- [README.md](README.md): human-facing guide for using this LLM Wiki vault.
- [AGENTS.md](AGENTS.md): schema and operating rules for this vault.
- [CLAUDE.md](CLAUDE.md): Claude-facing pointer to the AGENTS.md schema.
- [log.md](log.md): append-only maintenance log.
