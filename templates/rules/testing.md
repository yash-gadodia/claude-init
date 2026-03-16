---
description: Testing conventions (customize per project)
---

# Testing Rules

- Every new feature needs tests. Every bug fix needs a regression test.
- Test behavior, not implementation — tests should survive refactoring.
- Don't mock internal modules. Only mock at system boundaries (external APIs, email, etc.).
- Test names describe the behavior: `should reject expired tokens` not `test auth 3`.
- Tests must be independent — no shared mutable state between tests.
- Tests must be deterministic — no timing-dependent assertions, no random data without seeding.
- Assert exact expected values for known inputs. `toBeGreaterThan(0)` on a calculation is a smoke test, not a unit test. Use `toBeCloseTo(expected, precision)` for floats.
- For locale-sensitive output (number formatting, dates), pin the locale in the test or match a precise pattern.
- Run the full test suite before committing. Fix failures, don't skip tests.
- Integration tests > unit tests for database operations.
