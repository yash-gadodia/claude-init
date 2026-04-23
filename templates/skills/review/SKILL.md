---
name: review
description: "Two-stage code review: spec compliance first, then code quality. Auto-triggered after implementation. Also available as /review."
allowed-tools: Read, Grep, Glob, Bash
---

# Review: Two-Stage Code Review

Review all changes in two passes: first check if the spec is met, then check code quality.

## When This Triggers

Automatically after implementing any change. Also useful before committing or creating PRs.

## Process

### Stage 1: Spec Compliance

Does the code match what was requested?

Change summary (loaded fresh when this skill triggers):

!`git diff --stat HEAD 2>/dev/null || git diff --stat`

Recent commits on this branch:

!`git log --oneline -5 2>/dev/null || echo "(no git history)"`

Read the full diff for any file that shows up above before judging it — `git diff HEAD -- <file>` for unstaged + staged, `git diff <base>...HEAD -- <file>` when reviewing a PR. Never review from memory.

For each requirement/acceptance criterion from the plan or request:
- [ ] Is there code implementing it?
- [ ] Is there a test verifying it?
- [ ] Does the implementation match the spec (not over-build, not under-build)?

**Missing requirement?** Flag it. Don't proceed to Stage 2 until spec is met.
**Extra code not in spec?** Flag it. YAGNI — remove unless there's a clear reason.

### Stage 2: Code Quality

For each changed file, check:

**Correctness:**
- Does the logic do what it claims?
- Edge cases handled (null, empty, boundary values)?
- Off-by-one errors?
- Async operations handle errors and race conditions?

**Security:**
- User input validated and sanitized?
- No SQL injection, XSS, or command injection?
- No credentials or secrets in code?
- Auth checks present where needed?

**Conventions:**
- Matches existing patterns in the codebase?
- Uses existing utilities instead of reinventing?
- Follows naming conventions?

**Tests:**
- New functionality has tests that followed TDD (test was written first)?
- Tests assert exact expected values, not ranges?
- Test names describe behavior?

### Output

```
## Review

### Spec Compliance: PASS / FAIL
- [requirement]: ✅ implemented + tested / ❌ missing

### Code Quality
**Critical** (must fix):
- [file:line] Description. Fix: ...

**Important** (should fix):
- [file:line] Description. Fix: ...

**Suggestions** (consider):
- [file:line] Description.

### Verdict: APPROVE / REQUEST CHANGES
```

## Rules

- The preloaded diff stat above tells you what changed. Read the full diff of each file — don't guess.
- Read full files for context, not just diffs
- Be specific: line numbers, code snippets, concrete fixes
- Spec compliance BEFORE code quality — wrong order wastes time
- If everything looks good, say so. Don't invent issues.
- Critical issues block. Don't approve with unresolved critical issues.
