---
name: tdd
description: "Test-driven development — RED-GREEN-REFACTOR cycle. Auto-triggered during implementation. Write the test first, watch it fail, write minimal code to pass. Also available as /tdd."
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Test-Driven Development

Write the test first. Watch it fail. Write minimal code to pass.

**If you didn't watch the test fail, you don't know if it tests the right thing.**

## When to Use

**Always** — new features, bug fixes, refactoring, behavior changes.

**Exceptions (only if user explicitly says so):** throwaway prototypes, generated code, configuration files.

Thinking "skip TDD just this once"? Stop. That's rationalization.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Wrote code before the test? Delete it. Start over. Don't keep it as "reference." Don't "adapt" it. Delete means delete. Implement fresh from tests.

## RED-GREEN-REFACTOR

### RED — Write One Failing Test

Write a minimal test showing what SHOULD happen. One behavior per test.

Requirements:
- Descriptive name: `should reject expired tokens` not `test case 3`
- Tests real behavior, not mocks (mock only at system boundaries — external APIs, email, databases)
- Asserts exact expected values, not ranges: `expect(result).toBe(42.5)` not `expect(result).toBeGreaterThan(0)`

### Verify RED — Watch It Fail

**MANDATORY. Never skip.**

Run the test. Confirm:
- Test **fails** (not errors — a syntax error isn't a failing test)
- Failure message matches what you expect
- Fails because the feature is missing, not because of a typo

Test passes immediately? You're testing existing behavior. Rewrite the test.

### GREEN — Minimal Code

Write the **simplest** code that makes the test pass.

Don't add features. Don't refactor surrounding code. Don't "improve" beyond what the test requires. YAGNI.

### Verify GREEN — Watch It Pass

**MANDATORY.**

Run the test. Confirm:
- The new test passes
- ALL other tests still pass
- No warnings or errors in output

Test fails? Fix the code, not the test.
Other tests break? Fix them now.

### REFACTOR — Clean Up (Optional)

Only after green:
- Remove duplication
- Improve names
- Extract helpers

Keep tests green throughout. Don't add new behavior during refactor.

### Repeat

Next failing test for next behavior.

## Bug Fix Flow

Bug reported → write a test that reproduces the bug → watch it fail → fix the bug → watch it pass.

The test proves the fix and prevents regression. Never fix a bug without a test.

## Test Quality Bar

- **Specific assertions**: For known inputs, assert exact expected output. `expect(result).toBeGreaterThan(0)` is not a test — it passes if the function returns 999999.
- **Independent tests**: No shared mutable state between tests
- **Deterministic**: No timing dependencies, no random data without seeding
- **Behavior over implementation**: Tests should survive refactoring. Don't test private internals.
- **Match existing patterns**: Read 2-3 existing tests before writing new ones. Follow the same imports, structure, assertion style, setup/teardown.

## Rationalizations That Mean "Start Over"

| Thought | Reality |
|---------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll write tests after" | Tests written after pass immediately. Proves nothing. |
| "I already manually tested" | Ad-hoc ≠ systematic. No record, can't re-run. |
| "Deleting X hours of work is wasteful" | Sunk cost fallacy. Keeping unverified code is tech debt. |
| "Keep as reference, write tests first" | You'll adapt it. That's testing after. Delete means delete. |
| "TDD is dogmatic, I'm being pragmatic" | TDD IS pragmatic. Finds bugs before commit. Enables refactoring. |
| "This is different because..." | It's not. Write the test. |

## Verification Checklist

Before marking any implementation complete:
- [ ] Every new function/method has a test
- [ ] Watched each test fail before implementing
- [ ] Each test failed for expected reason
- [ ] Wrote minimal code to pass each test
- [ ] All tests pass (run the FULL suite, not just the new test)
- [ ] Tests use real code (mocks only at system boundaries)
- [ ] Edge cases covered (empty, null, zero, boundary, error cases)

Can't check all boxes? You skipped TDD. Start over.
