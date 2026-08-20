# Coding Agent — Bounded Loop Prompt Template (Generic)

> Layer: development. The execution contract you attach when giving a task to a coding agent (Claude Code, etc.).
> Usage: fill the brackets and paste as-is. Do not ask it to finish in one shot; make it run a bounded Plan→Implement→Verify→Repair loop for a fixed number of iterations.

---

## Loop prompt

```md
## Task
[One imperative sentence. e.g. Implement password-reset resend on the auth settings page.]

## Contract
You work in a bounded loop:
1. Inspect the relevant files.
2. Create a short plan.
3. Implement the smallest change that satisfies the next unchecked Done item.
4. Run verification.
5. If it fails, repair once using the failure output.
6. Repeat until Done is fully satisfied or a stop condition is reached.

## Scope
You may modify:
- `[allowed path]`

Do not modify:
- `[forbidden path]`

## Definition of Done
- [ ] [Done item 1]
- [ ] [Done item 2]
- [ ] [Done item 3]

## Verification
Run:
```bash
[command 1]
[command 2]
```

## Loop Limits
- Maximum implementation iterations: 3
- Maximum repair attempts per failing command: 2
- If the same verification command fails twice for different reasons, stop and report the failure pattern.
- If a required file, env var, credential, or external service is missing, stop and report what is missing.

## Output
Return:
1. The final plan actually followed
2. Summary of changes
3. Verification results
4. Remaining failed checks, if any
5. Files changed
6. Recommended next step

## Before Returning
Compare the final state against every Definition of Done item.
Do not claim success if verification was not run or did not pass.
```

---

## Progress file template (PROGRESS.md, for long tasks)

```md
# Progress

## Task
[One sentence]

## Current Status
[in progress | blocked | done]

## Done Checklist
- [x] [done item]
- [ ] [pending item]

## Verification Log
| Command | Result | Notes |
|---|---:|---|
| `[command]` | [passed/failed/pending] | [note] |

## Blockers
[None if none]

## Next Step
[smallest next action]
```

> One PROGRESS.md is enough for small tasks. Split into PLAN.md / VERIFY.md / BLOCKERS.md when files grow.
