# Coding Agent — New Project Setup Prompt Template (Generic)

> Layer: development. When a new project/PRD arrives, this makes the agent produce a plan, structure, data model, and verification strategy first, instead of implementing everything.
> Usage: fill the brackets and paste as-is. The first output is a decision artifact, not a pile of code.

---

```md
## Task
Create the initial engineering setup plan for [project name] from the provided requirements.

## Product Context
[Summary of the PRD/request. Only what affects architecture, data model, security, integrations, or scope.]

## Target Outcome
By the end of this step we should have:
- a recommended architecture
- a repository structure
- initial implementation phases
- risks and open questions
- a verification strategy
- a minimal scaffold only if safe

## Technical Preferences
- Frontend: [e.g. Next.js, React Native, Streamlit, none]
- Backend: [e.g. FastAPI, Next.js Route Handlers, Firebase Functions]
- Database: [e.g. PostgreSQL, Firestore, SQLite]
- Auth: [e.g. Clerk, Firebase Auth, SSO, none]
- Deployment: [e.g. Vercel, AWS, GCP, local only]
- Language: [e.g. TypeScript, Python]

## Existing Constraints
- Budget/time: [constraint]
- Team skill: [constraint]
- Compliance/security: [constraint]
- Integrations: [constraint]
- Must reuse: [existing repo/component/service]
- Must avoid: [technology/vendor/dependency/architecture style]

## Scope for This Step
You may:
- inspect the requirements
- propose architecture / folder structure / data model / API boundaries
- create or update planning files such as `README.md`, `PLAN.md`, `ARCHITECTURE.md`, `TASKS.md`
- create a minimal scaffold that does not lock in unapproved decisions

Do not:
- implement full features
- add paid services
- add new dependencies without justification
- create production credentials
- write large amounts of code before the architecture is approved

If a decision is ambiguous, write the options and recommend one. Do not guess silently.

## Required Analysis
1. Product interpretation — what the system does / users / MVP scope / explicit non-goals
2. Architecture proposal — main components / data flow / state ownership / external services / failure points
3. Data model — core entities / required fields / relationships / retention & privacy
4. API/agent/workflow boundaries — what each part owns and must not do
5. Implementation phases — Phase 0 setup & verification / Phase 1 thin vertical slice / Phase 2 core completion / Phase 3 hardening & observability
6. Verification strategy — unit/integration/manual acceptance tests / smoke test procedure

## Definition of Done
- [ ] Architecture recommendation is written.
- [ ] MVP scope and non-goals are explicit.
- [ ] Key risks and open questions are listed.
- [ ] Initial folder structure is proposed.
- [ ] Data model draft is included.
- [ ] Implementation phases are broken into small tasks.
- [ ] Verification strategy is included.
- [ ] No full feature implementation unless explicitly allowed.

## Verification
If code/scaffold changed, run:
```bash
[install/check command]
[typecheck/test command]
```
If no code changed, verify that the planning artifacts cover every Definition of Done item.

## Output
Return: recommended architecture / repository structure / MVP scope & non-goals / phased implementation plan / risks & open questions / verification strategy / files changed (if any).

## Before Returning
Re-read the Definition of Done.
State whether this response is a plan only or also changed files.
Report any unresolved item explicitly.
```
