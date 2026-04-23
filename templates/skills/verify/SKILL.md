---
name: verify
description: "Verification before completion — no success claims without fresh evidence. Auto-triggered before any completion claim. Also available as /verify."
allowed-tools: Read, Bash, Glob, Grep
---

# Verification Before Completion

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle: evidence before claims, always.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this response, you cannot claim it passes.

## Current Repo State

Loaded fresh when this skill triggers — so you can't claim "tests passed" from a stale mental model:

Uncommitted changes:

!`git status --short 2>/dev/null || echo "(not a git repo)"`

Last commit:

!`git log -1 --oneline 2>/dev/null || echo "(no git history)"`

## The Gate

Before claiming ANY status (done, fixed, passing, working, complete):

1. **Identify**: What command proves this claim?
2. **Run**: Execute the full command (fresh, not cached from earlier)
3. **Read**: Full output, check exit code, count pass/fail
4. **Confirm**: Does the output support the claim?
   - **No**: State actual status with evidence
   - **Yes**: State claim WITH the evidence ("All 47 tests pass — see output above")
5. **Only then**: Make the claim

Skip any step = unverified claim.

## What Counts as Verification

| Claim | Requires | NOT Sufficient |
|-------|----------|----------------|
| "Tests pass" | Test command output showing 0 failures | Previous run, "should pass" |
| "Build succeeds" | Build command with exit 0 | "Linter passed" |
| "Bug is fixed" | Test reproducing the bug now passes | "Code changed" |
| "Requirements met" | Line-by-line checklist against spec | "Tests pass" |
| "Linter clean" | Linter output showing 0 errors | Partial check |

## Red Flags — STOP

These thoughts mean you're about to make an unverified claim:

- Using "should", "probably", "seems to", "looks correct"
- Feeling satisfied before running verification
- About to say "Done!" or "Fixed!" or "All good!"
- Trusting that a change you just made works without running it
- Thinking "just this once" or "it's obvious it works"

**Replace each with**: run the command, read the output, cite the evidence.

## Rules

- Run the FULL test suite, not just the new test
- A test passing once doesn't prove it's not flaky — run twice if in doubt
- If a subagent reports "success", verify independently
- If you can't run verification (no test command, CI-only tests), say so explicitly instead of claiming success
