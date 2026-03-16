---
name: fix
description: "Fix a specific error, failing test, or bug. Takes an error message or test name, traces to root cause, and applies a minimal fix. Use when you have a concrete error to resolve."
argument-hint: "[error message or test name]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Fix: Error -> Root Cause -> Minimal Fix

You have a specific error to fix. Work methodically.

## Input
`$ARGUMENTS` — an error message, stack trace, failing test name, or bug description.

## Process

### 1. Reproduce
Make the error happen:
- If it's a test: run the specific test and capture output
- If it's a runtime error: find the code path and trace the inputs
- If you can't reproduce it, say so before guessing

### 2. Locate
Find the root cause (not the symptom):
- Read the stack trace bottom-up — the root cause is usually NOT the top frame
- Grep for the error message to find where it's thrown
- Read the surrounding code to understand the expected behavior
- Check recent git changes: `git log --oneline -10 -- <file>` — did something break recently?

### 3. Understand
Before writing any code, explain:
- **What's happening**: The actual behavior
- **What should happen**: The expected behavior
- **Why it's wrong**: The root cause (not "it throws an error" but "the null check on line 47 doesn't account for empty arrays")

### 4. Fix
Apply the minimal change that fixes the root cause:
- Change as few lines as possible
- Don't refactor surrounding code
- Don't fix other issues you noticed (note them, but don't fix them)
- If the fix is in a hot path, consider performance

### 5. Verify
- Run the failing test/scenario — it should pass now
- Run the full test suite — nothing else should break
- If the fix changes behavior, explain what changed

### 6. Prevent
Write a regression test if one doesn't exist:
- The test should fail without your fix
- The test should pass with your fix
- Name it descriptively: `should handle empty array in user lookup`

## Rules
- NEVER guess at fixes without reproducing first
- NEVER apply a fix you can't verify
- Fix the root cause, not the symptom
- One fix per invocation. If there are multiple bugs, fix them separately.
