---
name: debug
description: "Investigate unexpected behavior when the cause is unknown. Structured debugging: reproduce, isolate, bisect, fix. Use when something is wrong but you don't know what or where."
argument-hint: "[description of unexpected behavior]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Debug: Something Is Wrong, Find Out What

You don't know exactly what's broken or where. Work systematically to find out.

## Input
`$ARGUMENTS` — a description of the unexpected behavior (e.g., "the dashboard shows stale data", "login works locally but not in staging").

## Process

### Phase 1: Define the Problem
- What is the expected behavior?
- What is the actual behavior?
- When did it start? (check git log for recent changes)
- Is it reproducible? (always, sometimes, only in certain conditions)

### Phase 2: Form Hypotheses
List the 3 most likely causes, ranked by probability:
```
1. [Most likely] — because [evidence]
2. [Likely] — because [evidence]
3. [Possible] — because [evidence]
```

### Phase 3: Investigate (cheapest test first)
For each hypothesis, design the quickest test to confirm or eliminate it:
- Add a log statement or console.log
- Check a config value
- Run a query manually
- Read the relevant code path

Eliminate hypotheses one by one. Don't fix anything yet.

### Phase 4: Isolate
Once you've found the area:
- What's the smallest reproducible case?
- Does it happen with minimal data?
- Can you trigger it from a test?

If the bug is in a recent change, use git bisect logic:
- Check if the bug exists at HEAD~5, HEAD~10, etc.
- Narrow down to the introducing commit

### Phase 5: Root Cause
Write a clear root cause statement:
```
The bug is in [file:line].
[Component] does [X] when it should do [Y]
because [reason — the actual "why"].
This was introduced by [commit/change] on [date].
```

### Phase 6: Fix
Apply the minimal fix. Then:
- Verify the fix resolves the reported behavior
- Run the full test suite
- Write a regression test

### Phase 7: Document
If this was a non-obvious bug, leave a code comment:
```
// Note: X must be Y because Z (see commit abc123)
```

## Rules
- Never shotgun-debug (changing random things to see what sticks)
- Test one hypothesis at a time
- Remove all debug logging before declaring done
- If you've spent 10 minutes without progress, re-examine your assumptions
