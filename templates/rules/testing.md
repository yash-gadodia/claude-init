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
- Run the full test suite before committing. Fix failures, don't skip tests.
- Integration tests > unit tests for database operations.
