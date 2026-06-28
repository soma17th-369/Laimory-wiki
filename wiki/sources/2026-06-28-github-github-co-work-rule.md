---
title: GitHub Co-work Rule
source_type: github
source_path: raw/github/github-co-work-rule.md
ingest_date: 2026-06-28
status: ingested
tags: [github, collaboration, branch-rule, commit-convention, issue-template, pull-request]
---

# GitHub Co-work Rule

## Summary

Team collaboration rule document for GitHub-based development. It defines branch roles, branch naming expectations, commit message conventions, issue template categories, and pull request description structure.

The document is an operating convention source, not evidence that GitHub repository settings such as branch protection, required reviews, or repository rulesets are configured.

## Key Claims

- `main` is the deployment branch after testing is complete.
- `dev` is the branch for integrating development commits.
- Working branches should be created from `dev`.
- Working branch prefixes include `feat`, `fix`, and `refactor`.
- Branch names should include the issue number, such as `feat/#33` or `fix/#25`.
- Commit messages should use a commit type followed by a colon and a short description.
- Commit types include `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `design`, `comment`, `rename`, and `remove`.
- Issue templates are grouped into three types: Feature, Refactor, and Bug.
- Feature issues should describe planned functionality, implementation details, references, DB changes, and checklists.
- Refactor issues should describe the planned refactoring target, reason, and checklist.
- Bug issues should describe the affected feature, discovered environment, error log, and solution.
- Pull request titles should follow the related issue title. When extra clarification is needed, the title can use a format like `[issue title] : [additional note]`.
- Pull request bodies should link the related issue, summarize work, note DB changes, include references, and mention changed APIs when relevant.

## Caveats

- This source records team process guidance, not machine-enforced GitHub policy.
- No `.github/` templates or workflow files were present in the local repository at ingest time, so the issue and PR templates described here are not currently represented as GitHub template files in this vault.
- The branch naming examples include slashes and issue-number fragments. Actual Git branch names should be checked against the team's tooling and shell behavior before standardizing automation around them.

## Related Pages

- [[laimory]]
