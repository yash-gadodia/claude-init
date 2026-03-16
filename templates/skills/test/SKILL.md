---
name: test
description: "Generate and run tests for recent changes or specific files. Uses the project's actual test framework and patterns. Use after writing features or fixing bugs."
argument-hint: "[file or feature to test]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Test: Write and Run Tests

Generate tests for the specified file/feature using this project's test framework and conventions.

## Process

### 1. Identify What to Test
If `$ARGUMENTS` is provided, test that file/feature.
Otherwise, test all uncommitted changes: `git diff --name-only HEAD`

### 2. Learn the Test Patterns
- Find existing tests near the target code (Glob for `*.test.*`, `*.spec.*`, `*_test.*`)
- Read 2-3 existing tests to learn:
  - Import style and test structure
  - How mocks/fixtures are set up
  - Assertion style (expect, assert, should)
  - Setup/teardown patterns

### 3. Write Tests
Follow the existing patterns EXACTLY. Generate:

**Unit tests** for pure functions and business logic:
- Happy path with typical inputs — assert exact expected output, not just ranges
- Edge cases (empty, null, zero, negative, boundary)
- Error cases (invalid input, expected failures)
- For calculations: compute the expected value by hand and assert it. `expect(result).toBeGreaterThan(0)` is not a test.

**Integration tests** for API routes and DB operations:
- Request → response with expected status and body
- Auth (authenticated, unauthenticated, wrong permissions)
- Validation (missing fields, invalid formats)

### 4. Run Tests
Execute the test suite and verify:
- All new tests pass
- All existing tests still pass
- No flaky behavior (run twice if needed)

### 5. Report
```
## Test Results

**New tests:** N added
**Total suite:** N passed, N failed, N skipped
**Coverage gaps:** [list any untested paths]
```

## Rules
- Match existing test patterns exactly — don't introduce new test utilities
- Test behavior, not implementation — tests should survive refactoring
- Don't mock internal modules — only mock at system boundaries
- Every test must have a descriptive name: `should reject expired tokens` not `test case 3`
- Every assertion must be specific enough to catch a regression. Ask: "would this test still pass if the function returned a wrong but plausible value?" If yes, tighten the assertion.
