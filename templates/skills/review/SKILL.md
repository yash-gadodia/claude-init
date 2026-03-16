---
name: review
description: "Review recent code changes for bugs, security issues, and convention violations. Use after making changes or before committing."
allowed-tools: Read, Grep, Glob, Bash
---

# Review: Check Your Work

Review all uncommitted changes (or recent commits) for issues.

## Process

### 1. Gather Changes
```bash
git diff HEAD
git status
```

### 2. Review Each Changed File

For each file, check:

**Correctness:**
- Does the logic do what it claims?
- Are edge cases handled (null, empty, boundary values)?
- Are there off-by-one errors?
- Do async operations handle errors and race conditions?

**Security:**
- User input validated and sanitized?
- No SQL injection, XSS, or command injection?
- No credentials or secrets in code?
- Auth checks present where needed?

**Conventions:**
- Matches existing patterns in the codebase?
- Uses existing utilities instead of reinventing?
- Follows the naming conventions from CLAUDE.md?

**Tests:**
- New functionality has tests?
- Existing tests still pass?
- Test names describe behavior, not implementation?

### 3. Output

```
## Review Summary

**Files reviewed:** N
**Issues found:** N critical, N important, N suggestions

### Critical
- [file:line] Description. Fix: ...

### Important
- [file:line] Description. Fix: ...

### Suggestions
- [file:line] Description.

### Verdict: APPROVE / REQUEST CHANGES
```

## Rules
- Run `git diff` — don't guess at changes
- Read full files, not just diffs, for context
- Be specific: line numbers, code snippets, concrete fixes
- If everything looks good, say so — don't invent issues
