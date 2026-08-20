# Coding Agent — Existing-Codebase Implementation / Bugfix Prompt Template (Generic)

> Layer: development. The execution contract for implementing a feature, fixing a bug, writing tests, or doing a bounded refactor in an existing repo.
> Usage: fill the brackets and paste as-is. The core purpose is blast-radius control — preventing unreviewable changes.

---

```md
## Task
[One imperative sentence. e.g. Implement organization-level API key rotation on the admin settings page.]

## Business Context
[Only the context needed to make implementation decisions. Exclude roadmap history and stakeholder background.]

## Technical Context
- Repository: [repo name]
- Stack: [framework/language/runtime]
- Relevant files/directories:
  - `[path]` — [why it matters]
  - `[path]` — [why it matters]
- Existing patterns to follow:
  - [sibling feature/service/component/API route/test style]

## Scope
You may modify:
- `[allowed path]`
- `[allowed path]`

Do not modify:
- `[forbidden path]`
- `[forbidden path]`

If the change cannot be completed within this scope, stop and report:
1. what scope expansion is needed
2. why it is needed
3. the smallest safe expansion

## Constraints
- Use only existing dependencies. If a new one seems necessary, stop and explain the missing capability.
- Preserve existing public APIs unless listed under Scope.
- Do not change authentication/authorization/billing/data-retention/migration behavior unless this task explicitly requires it.
- Follow the code style and test patterns of the nearest related files.
- No broad refactors. List unrelated cleanup under "Follow-up" instead of changing it.

## Input / Behavior Requirements
- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

## Definition of Done
- [ ] [Observable behavior]
- [ ] [Test coverage]
- [ ] [Error/edge case handled]
- [ ] [No unrelated files changed]
- [ ] [No new dependency added unless approved]

## Verification
Run before returning:
```bash
[command 1]
[command 2]
```
If a command cannot be run, report the command, why, and what evidence you used instead.

## Output
Return:
1. Summary of changes (max 5 bullets)
2. Files changed
3. Verification results (command outputs summarized)
4. Any unmet Definition of Done item
5. Follow-up (only if necessary)

## Before Returning
Re-read Scope, Constraints, and Definition of Done.
Confirm each against the actual diff.
Report any unsatisfied item explicitly instead of hiding it.
```
