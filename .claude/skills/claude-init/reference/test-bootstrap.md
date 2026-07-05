# Test Bootstrap Reference

Detail for Step 1.5 of `/claude-init`. Read this when bootstrapping a test suite.

## Framework selection by stack

| Stack | Test Framework | Why |
|-------|---------------|-----|
| TypeScript/JavaScript (Vite, Next.js, SvelteKit) | Vitest | Fast, native ESM, Vite-compatible |
| TypeScript/JavaScript (legacy, webpack) | Jest | Widest ecosystem support |
| Python | pytest | Industry standard, simple, powerful |
| Rust | cargo test (built-in) | No setup needed |
| Go | go test (built-in) | No setup needed |
| Ruby/Rails | RSpec | Community standard |
| PHP/Laravel | PHPUnit / Pest | Framework-native |
| Elixir/Phoenix | ExUnit (built-in) | No setup needed |
| Java/Spring | JUnit 5 | Framework standard |
| Dart/Flutter | flutter test (built-in) | No setup needed |

## Baseline suite: parallel subagents per layer

**Subagent A — Unit tests:**
- Find pure functions, utilities, helpers, validators
- Write tests for each with happy path + edge cases
- Target: every file in `utils/`, `lib/`, `helpers/`, or equivalent

**Subagent B — Integration tests (if API exists):**
- Find route handlers / controllers / resolvers
- Write request-response tests for each endpoint
- Cover: success, auth failure, validation error, not found
- Use the framework's built-in test client (supertest, httpx, etc.)

**Subagent C — Component tests (if frontend exists):**
- Find key UI components (not every component — focus on ones with logic)
- Write render + interaction tests
- Use the framework's testing library (Testing Library, Vue Test Utils, etc.)

**Subagent B is NOT optional.** If the project has API routes, you MUST write integration tests for them using the framework's test client (Hono `app.request()`, supertest, httpx, etc.). Skipping API tests and only testing utilities leaves the most critical layer untested.

Each subagent must produce tests that would actually catch a real bug if the code regressed — not just verify "it runs without crashing."

## Test quality bar

- Every test has a descriptive name (`should reject expired tokens`, not `test 1`)
- Tests are independent (no shared mutable state)
- Tests are deterministic (no timing dependencies, no random data without seeding)
- Tests verify behavior, not implementation details
- Mocks only at system boundaries (external APIs, email, etc.)
- **Assert exact expected values, not just ranges.** For known inputs, assert the exact expected output. Use `toBeCloseTo` for floating point, but always with a specific expected value.
- **Pick one import style and be consistent.** If the config enables `globals: true` (Vitest) or uses `@jest/globals`, don't also import `describe`/`it`/`expect` in every test file. If you prefer explicit imports, don't enable globals. Inconsistency confuses contributors.

## Examples — BAD vs GOOD assertions

```typescript
// BAD: passes even if calculation is completely wrong
expect(result.total).toBeGreaterThan(0);
expect(result.count).toBeTruthy();
expect(formatted).toContain('1');

// GOOD: catches regressions — exact expected values
expect(result.total).toBe(42.5);
expect(result.count).toBe(3);
expect(formatted).toBe('1,234.50');

// GOOD: floating point with specific expected value
expect(calculateVolume(1, 1000, 1000, 1000, 'mm', 'M3')).toBeCloseTo(1.0, 5);

// GOOD: locale-sensitive — pin the locale or match precisely
expect(formatNumber(1234.5, 2, 'en-US')).toBe('1,234.50');
```
