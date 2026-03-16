---
description: Code style and conventions (customize per project)
---

# Code Style

- Follow existing patterns in the codebase — consistency over personal preference
- Keep functions under 50 lines. If longer, extract a helper.
- Name things clearly. Long descriptive names > short cryptic ones.
- No premature abstractions — three similar lines is fine, don't DRY everything
- Handle errors at system boundaries. Trust internal code.
- No `any` types (TypeScript), `interface{}` (Go), or equivalent escape hatches without explicit justification
- Imports: group by stdlib, external deps, internal modules (with blank lines between groups)
- No commented-out code — delete it, git has history
- No TODO comments without a linked issue
