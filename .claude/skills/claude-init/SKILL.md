---
name: claude-init
description: "Analyze any codebase and generate a complete .claude/ configuration to make it AI-native. Use when setting up Claude Code for a new or existing repo. Handles cold-start by detecting stack, framework, patterns, and generating tailored CLAUDE.md, agents, skills, rules, and hooks."
argument-hint: "[repo-path]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent
---

# claude-init: Make Any Repo AI-Native

You are an expert at configuring Claude Code for maximum effectiveness on any codebase.

Given a target repository, you will analyze it thoroughly and generate a complete `.claude/` configuration.

## Step 0: Locate Target Repo

If `$ARGUMENTS` is provided, use that as the target repo path.
Otherwise, use the current working directory.

Confirm the target repo path with the user before proceeding.

## Step 1: Analyze the Codebase

Run these analyses IN PARALLEL using subagents:

### 1a. Stack Detection
Detect and document:
- **Language(s)**: Check file extensions, package files (package.json, Cargo.toml, go.mod, requirements.txt, Gemfile, pyproject.toml, pom.xml, build.gradle, mix.exs, pubspec.yaml, Package.swift, etc.)
- **Framework**: Next.js, Rails, Django, FastAPI, Express, Spring, Phoenix, SvelteKit, Nuxt, Laravel, Flutter, React Native, etc.
- **Package manager**: npm/yarn/pnpm/bun, pip/uv/poetry, cargo, go modules, bundler, mix, pub, etc.
- **Build system**: Make, CMake, Bazel, Meson, Gradle, Maven, Turbopack, Vite, webpack, esbuild
- **Platform**: Web, iOS (.xcodeproj, Package.swift), Android (build.gradle.kts + android), mobile (React Native, Flutter), CLI, library
- **Monorepo?**: Check for workspace configs (turbo.json, nx.json, lerna.json, pnpm-workspace.yaml) OR multi-language directory splits (backend/ + frontend/, packages/, apps/)
- **Infrastructure**: Terraform (.tf), Pulumi, CDK, Helm charts, Docker/docker-compose, Kubernetes manifests
- **Environment**: .env.example, docker-compose.yml, Dockerfile, nix flake, direnv (.envrc)

### 1b. Architecture Detection
- **Directory structure**: src/, app/, lib/, api/, components/, services/, etc.
- **Database**: Prisma, Drizzle, TypeORM, SQLAlchemy, ActiveRecord, Ecto, diesel, etc. Read schema files.
- **Auth**: NextAuth, Clerk, Supabase Auth, Passport, Devise, Guardian, etc.
- **API style**: REST, GraphQL, tRPC, gRPC. Check for OpenAPI/Swagger specs or .graphql schema files.
- **State management**: Redux, Zustand, Jotai, Pinia, etc.
- **Containerization**: Dockerfile, docker-compose.yml — how is the app run locally?
- **API specs**: OpenAPI/Swagger files, Postman collections, .graphql schemas

### 1c. Testing & CI Detection
- **Test framework**: Jest, Vitest, pytest, RSpec, ExUnit, go test, cargo test, PHPUnit, Playwright, Cypress
- **Test location**: co-located (foo.test.ts), separate (__tests__/, tests/, spec/)
- **CI/CD**: GitHub Actions, GitLab CI, CircleCI, Jenkins — read workflow files
- **Linting**: ESLint, Prettier, Ruff, RuboCop, Clippy, golangci-lint

### 1d. Existing Conventions
- **Existing CLAUDE.md**: Read and preserve any existing instructions
- **Existing .claude/**: Preserve existing config, only add what's missing
- **README**: Extract project description, setup commands, architecture notes
- **Contributing guide**: Extract coding standards
- **Git history**: Check recent commit message style (conventional commits? Jira refs?)

## Step 1.5: Bootstrap Test Suite (if none exists)

This is critical. Without tests, Claude can't verify its own work. The entire "AI-native" setup collapses — no QA agent, no `/test` skill, no `/refactor` safety net, no `/review` verification. Tests are the trust layer.

### If NO test framework is detected:

**1. Pick the right framework for the stack:**

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

**2. Install the test framework:**
- Run the actual install command (e.g., `npm install -D vitest`, `pip install pytest`)
- Add test scripts to package.json / Makefile / pyproject.toml as appropriate
- Create the config file if needed (vitest.config.ts, pytest.ini, jest.config.js)

**3. Write a baseline test suite:**

Use subagents in parallel to write tests for different layers:

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

**4. Run the suite and fix failures:**
- Execute the full test suite
- Fix any failures (the tests should pass against the current code)
- Ensure CI-friendly (no browser needed for unit/integration tests)

**5. Add test commands to package.json / Makefile:**
- `test` — run full suite
- `test:watch` — watch mode for development
- `test:coverage` — with coverage reporting (if framework supports it)

### If tests ALREADY exist:
- Read existing tests to learn patterns (assertion style, fixtures, mocking approach)
- Identify coverage gaps (files/routes with no tests)
- Note gaps in the report but DON'T write additional tests — the user didn't ask for that
- Configure the QA agent and `/test` skill to match existing patterns exactly

### Test quality bar:
- Every test has a descriptive name (`should reject expired tokens`, not `test 1`)
- Tests are independent (no shared mutable state)
- Tests are deterministic (no timing dependencies, no random data without seeding)
- Tests verify behavior, not implementation details
- Mocks only at system boundaries (external APIs, email, etc.)
- **Assert exact expected values, not just ranges.** For known inputs, assert the exact expected output. Use `toBeCloseTo` for floating point, but always with a specific expected value.
- **Pick one import style and be consistent.** If the config enables `globals: true` (Vitest) or uses `@jest/globals`, don't also import `describe`/`it`/`expect` in every test file. If you prefer explicit imports, don't enable globals. Inconsistency confuses contributors.

**Examples — BAD vs GOOD assertions:**
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

### Subagent requirements:
- **Subagent B is NOT optional.** If the project has API routes, you MUST write integration tests for them using the framework's test client (Hono `app.request()`, supertest, httpx, etc.). Skipping API tests and only testing utilities leaves the most critical layer untested.
- Each subagent must produce tests that would actually catch a real bug if the code regressed — not just verify "it runs without crashing."

## Step 1.75: Generate ARCHITECTURE.md (if none exists)

If the repo has no `ARCHITECTURE.md` (or equivalent like `docs/architecture.md`), generate one at the repo root.

This is the AI-facing documentation layer. CLAUDE.md is the quick reference (loaded every conversation), but ARCHITECTURE.md is the deep context that `/plan`, `/onboard`, and the architect agent read on demand — keeping CLAUDE.md lean while giving Claude full project understanding when it needs it.

### What to include:

```markdown
# [Project Name] — Architecture

## Overview
<What this system does, who uses it, in 2-3 sentences>

## System Map
<ASCII diagram or structured list showing major modules/services and how they connect>

## Directory Structure
<Top-level directories with one-line descriptions of responsibility>
<Only include directories that matter — skip node_modules, .git, etc.>

## Data Flow
<How a typical request/action moves through the system>
<From entry point (HTTP request, CLI command, event) to response/output>

## Key Design Decisions
<Why the stack was chosen — inferred from package files, framework, and patterns>
<Major architectural patterns in use (MVC, hexagonal, microservices, monolith, etc.)>
<Any non-obvious choices visible in the code (why X over Y)>

## Module Boundaries
<Which modules own what responsibility>
<How modules communicate (imports, events, APIs, shared DB, message queue)>

## External Dependencies
<Third-party services, APIs, databases the system talks to>
<How they're configured (env vars, config files)>

## Entry Points
<Main entry points into the codebase — where to start reading>
<CLI: main.ts/app.py, Web: route definitions, Library: public API surface>
```

### Rules for ARCHITECTURE.md:
- Write it based on what you ACTUALLY found in the code, not generic templates
- Keep it under 120 lines — density over verbosity
- Focus on "what connects to what" and "why" — Claude can read individual files itself
- Don't duplicate CLAUDE.md content (commands, conventions)
- If an ARCHITECTURE.md already exists, read it but don't overwrite — suggest additions only

## Step 2: Generate Configuration

Based on the analysis, generate these files in the target repo. Use the templates as starting points, but CUSTOMIZE everything to the specific codebase.

**Template resolution:** Check these paths in order and use the first that exists:
1. `${CLAUDE_SKILL_DIR}/../../../templates/` (running from cloned repo)
2. `~/.claude/claude-init-templates/` (global install via install script)
If neither exists, generate config from scratch using the analysis — templates are helpful but not required.

### 2a. CLAUDE.md
Generate at the repo root. Must include:
- One-line project description
- **Commands section**: Actual dev/test/build/lint commands found in package.json/Makefile/etc.
- **Architecture section**: Actual framework, DB, auth, API patterns found
- **Code style section**: Actual conventions found (or sensible defaults for the stack)
- **Testing section**: Actual test framework, location, and run commands
- **Git section**: Actual commit style from git log
- **Patterns to follow**: Key patterns found in the codebase (import style, error handling, etc.)
- **Workflow section**: Include these three rules — they prevent Claude's most common failure modes:
  - "After 2 failed attempts at the same approach, stop and rethink"
  - "Verify before claiming done — run tests/commands and show output"
  - "Delegate verbose operations (test runs, log analysis) to subagents to preserve context"
- **Do NOT section**: Stack-specific anti-patterns

Keep it under 80 lines. Every line must earn its place.

Include this line in the CLAUDE.md: `Read ARCHITECTURE.md for detailed architecture context before planning or making structural changes.`

Include a brief note: `Claude automatically follows a development workflow (clarify → plan → implement → test → self-review) scaled to task size. You don't need to invoke /plan or /test manually.`

### 2b. Agents (`.claude/agents/`)
Generate these agent personas, tuned to the detected stack:

1. **architect.md** — System design, uses detected DB/API/auth patterns. Model: opus.
2. **developer.md** — Implementation, knows the framework and conventions. Model: sonnet. Includes RALPH self-correction loop.
3. **reviewer.md** — Code review, knows the test framework and linting rules. Model: sonnet.
4. **qa.md** — Test writing and execution, uses the actual test runner commands. Model: sonnet.
5. **researcher.md** — Codebase exploration, architecture docs generation. Model: haiku.

Conditionally include based on detected stack:
6. **devops.md** — Only if Docker, CI workflows, Terraform, or deployment configs detected. Model: sonnet.
7. **writer.md** — Only if the project has docs/, README needs work, or API specs exist. Model: haiku.

Each agent must:
- Reference ACTUAL project patterns, not generic advice
- Include `memory: project` for architect and developer agents
- Include "Read and follow all rules in `.claude/rules/`" in their instructions
- **Use the exact version numbers detected** — if Vitest 3.2.4 is installed, the QA agent must say "Vitest 3.x", not "Vitest 2.x". Cross-check versions against package.json/lockfile.

### 2c. Rules (`.claude/rules/`)

**Only generate rules with project-specific content.** Generic advice like "validate user input" or "write clean code" is stuff Claude already knows. Every rule must capture something Claude CAN'T infer from reading the code — deployment gotchas, team conventions, architectural decisions, domain-specific constraints.

Always generate:
1. **git.md** — Based on ACTUAL commit style from git log (conventional commits? Jira refs? squash policy?)
2. **testing.md** — Based on the ACTUAL test framework, patterns, and conventions (from Step 1.5)
3. **workflow.md** — Automatic development workflow. This is the rule that makes Claude automatically clarify → plan → implement → test → self-review without the user needing to type slash commands. Scale rigor to task size (trivial = just do it, large = full workflow with devil's advocate).

Conditionally generate (only if project-specific content found):
4. **code-style.md** — Only if there are non-obvious conventions (unusual import ordering, specific naming patterns, etc.). Skip if the project just uses a standard linter config.
5. **api.md** — Only if API routes detected. Must reference actual response shapes, error patterns, auth middleware found in the code. Scope with `paths:`.
6. **database.md** — Only if ORM/migrations detected. Must reference actual migration patterns, schema conventions. Scope with `paths:`.
7. **frontend.md** — Only if frontend components detected. Must reference actual component patterns, state management conventions. Scope with `paths:`.
8. **security.md** — Only if the project has specific security patterns (auth middleware, input sanitization, CSP headers). Don't generate generic OWASP advice.
9. **performance.md** — Only if specific performance patterns found (caching, connection pooling, lazy loading).

**The test**: for each rule file, ask "would removing this cause Claude to make a mistake on THIS project?" If no, don't generate it.

**When updating existing rules (via `/update`):** Never remove project-specific information that was already there. If the existing rule says "React Query staleTime is 5 minutes", keep it — that's a real project detail Claude can't infer. You may restructure, clarify, or add to existing rules, but don't drop specific values, thresholds, or patterns.

### 2d. Skills (`.claude/skills/`)

Skills are detailed playbooks for specific development activities. They are **auto-triggered by the `workflow.md` rule** — Claude follows the development workflow automatically without the user typing slash commands. Users CAN still invoke them manually (e.g., `/plan` to force just a planning step), but the default is automatic.

Only generate skills that add value beyond what Claude already does. A skill must change Claude's behavior, not just describe a process Claude would follow anyway.

**Always generate (auto-triggered by workflow rule):**
1. **plan/SKILL.md** — Bite-sized implementation planning with devil's advocate challenge. Tasks should be 2-5 minutes each with exact file paths and TDD steps. Auto-triggered for medium+ tasks.
2. **tdd/SKILL.md** (in `skills/test/`) — RED-GREEN-REFACTOR cycle with rationalization prevention. Must reference the project's actual test framework and commands. Auto-triggered during implementation. This replaces a generic "write tests" skill — it enforces test-FIRST, not test-after.
3. **review/SKILL.md** — Two-stage review: spec compliance first (does it match what was requested?), then code quality (bugs, security, conventions). Auto-triggered after implementation.
4. **verify/SKILL.md** — Verification before completion. No success claims without fresh evidence. Auto-triggered before any "done"/"fixed"/"passing" claim.
5. **clarify/SKILL.md** — Collaborative design through structured dialogue. Explores intent, proposes approaches, writes testable specs. Auto-triggered when requirements are ambiguous.
6. **subagent-dev/SKILL.md** — Subagent-driven development. Fresh subagent per task + two-stage review (spec compliance → code quality). Auto-triggered for plans with 3+ independent tasks.
7. **finish/SKILL.md** — Land completed work. Verify tests, present options (merge/PR/keep/discard), execute with safety checks. Auto-triggered after implementation and review pass.

**Conditionally generate:**
8. **devils-advocate/SKILL.md** — Only for projects with complex architecture or multiple contributors. Overkill for simple apps.

**Do NOT generate by default (Claude already does these well without a skill):**
- `/fix` — Claude's default debugging is already "reproduce → locate → fix"
- `/debug` — Same as above, Claude naturally investigates systematically
- `/refactor` — Claude already runs tests before/after when asked to refactor

These can be added later via `/update` if the user wants the structured process.

**Every generated skill must be project-specific.** Reference the actual test framework and commands (`pytest -x`, `vitest run`, etc.), not generic `npm test`. Reference actual file patterns, conventions, and tools detected during analysis. This is the advantage over generic workflow plugins — every skill is tailored to THIS project.

**Path-scope project-specific skills.** Workflow skills (plan, tdd, verify, review, clarify, subagent-dev) apply everywhere — no `paths:` needed. Any project-specific skill you generate (e.g., a Supabase RLS skill, a Prisma migrations skill, an API-conventions skill) MUST include a `paths:` frontmatter entry so it only loads when Claude is working in the relevant directory. Example:

```yaml
---
name: api-conventions
description: "Response shapes, error handling, and auth middleware patterns for this project's REST API. Auto-loads when editing API routes."
paths: src/api/**, src/routes/**, app/api/**
allowed-tools: Read, Grep, Glob
---
```

Use dynamic shell context where it helps — `` !`git diff --stat` `` in review/verify preloads fresh state without a tool-call round-trip. Do NOT use `` !`cmd` `` for commands that write, delete, or take long to run.

### 2e. Settings and hooks (two-tier split)

Split the settings into a committed file and a personal file. This mirrors how real teams actually use Claude Code: everyone shares the safety net, each dev adds their own approve-without-prompting shortcuts.

**`.claude/settings.json` — committed, team-wide safety:**

- **PreToolUse (Bash)**: Regex-block `git push --force`, `npm publish`, `docker push`, `terraform destroy`, `kubectl delete namespace`, `rm -rf /` / `rm -rf ~`. Use word-boundaries (`\b`) so `rm -rf ./dist` doesn't match.
- **PreToolUse (Write|Edit)**: Hard-block writes to `.env*`, `*.pem`, `*.key`, `*.cert`, `*.p12`, `~/.ssh/`, `~/.aws/`, `~/.gnupg/` based on the basename (not full path — so `src/env.ts` stays allowed, only `.env` / `local.env` / `.env.production` match).
- **permissions.ask (not deny)** for `.claude/settings.json` and `.claude/hooks/**` (both project and `~/.claude/`): prompts the user before Claude edits the safety layer, but doesn't hard-block. Hard-block would kill `/update` — `ask` gives the user control without the friction. This is slavaspitsyn's "hook self-protection" pattern softened for real-world UX.
- **PostToolUse (Write|Edit)**: Auto-format the file that was just written (prettier for JS/TS/JSON/MD/CSS, ruff/black for Python, gofmt for Go, rustfmt for Rust). Non-blocking — `|| true` if the formatter isn't installed. This is Boris Cherny's #1 tip: tight feedback loops are the single biggest Claude Code quality lever.
- **PreCompact**: Snapshot the branch name, `git status --short`, and last 10 commits into `.claude/checkpoints/checkpoint-<ts>.md` before compaction. Survives context loss.
- **permissions.deny**: `~/.ssh/**`, `~/.aws/**`, `~/.gnupg/**`, `.env*`, and the four dangerous-bash patterns in duplicate (belt + suspenders — permission rules catch what hook regex might miss).
- **MCP deny patterns** (only if `.mcp.json` or `mcp_servers` detected): add regex entries like `mcp__.*__write.*`, `mcp__.*__delete.*`, `mcp__.*__create.*` so MCP side effects need explicit approval. Remember MCP matchers use JS regex — `mcp__memory` alone matches nothing; you need `mcp__memory__.*`.

**`.claude/settings.local.json.example` — committed, acts as onboarding, NOT loaded by Claude Code:**

- Show the shape of `permissions.allow` with project-relevant entries (`Bash(npm test:*)`, `Bash(pytest:*)`, `Bash(git status:*)`, `Bash(gh pr view:*)`) so a new dev can `cp settings.local.json.example settings.local.json` and have sensible personal approvals on day one.
- Header `//` comment explaining: "copy to `settings.local.json` for PERSONAL overrides — gitignored, your teammates won't see it."

**`.claude/settings.local.json` is gitignored** — each dev maintains their own. Do NOT generate it; just generate the `.example` so they know the shape.

**Skip for solo dev projects:**
- Skip the Bash destructive-op regex hook — solo devs running `rm -rf ./dist` get false positives and will disable hooks entirely. Keep the credential-file Write|Edit block (universal value) and the hook self-protection block (always valuable).

### 2f. Output styles (`.claude/output-styles/`)

Output styles inject rules into Claude's **system prompt**, not just CLAUDE.md. That makes them stronger than rules for anything that must never be skipped — Claude sees them earlier and can't "forget" them under pressure.

**Generate `tdd.md` automatically when tests exist (or were bootstrapped in Step 1.5).** The template at `templates/output-styles/tdd.md` enforces the RED-GREEN-REFACTOR loop and the verification gate at the system-prompt level. Copy it as-is — do not inline-edit with project-specific commands (the TDD skill already handles commands). The user enables it by running `/config` → Output style → TDD, or by adding `"outputStyle": "TDD"` to `.claude/settings.json`.

**Mention it in the final report** so the user knows it exists and how to activate it.

Do NOT generate additional output styles speculatively. They're powerful — one is plenty unless the user asks.

### 2g. Monorepo Support
If a monorepo is detected:
- Generate a root `CLAUDE.md` with shared conventions
- Generate a root `ARCHITECTURE.md` with the system-level view (how packages/services connect, shared infrastructure, deployment topology)
- Generate per-package/app `CLAUDE.md` files with package-specific commands and architecture
- For complex packages (>20 source files or their own API surface), generate per-package `ARCHITECTURE.md` covering that package's internal architecture
- Scope rules to specific packages via `paths:` frontmatter
- Each package's CLAUDE.md should reference the root with `@../../CLAUDE.md`

### 2h. .gitignore additions
Ensure the following are gitignored:
- `.claude/settings.local.json` (personal overrides)
- `.claude/agent-memory-local/` (per-session memory)
- `.claude/checkpoints/` (PreCompact hook drops checkpoint files here — regenerable, no value in git)

Do NOT gitignore `.claude/settings.local.json.example` — that's the onboarding artifact, must be committed.

## Step 3: Verify & Report

After generation:
1. Count files generated
2. Show the CLAUDE.md and ARCHITECTURE.md to the user for review
3. List all agents, skills, rules, hooks, and output styles created
4. Report test suite status (framework installed, number of tests, all passing?)
5. Tell the user about the TDD output style and how to activate it (`/config` → Output style → TDD)
6. If a `settings.local.json.example` was generated, tell them to `cp .claude/settings.local.json.example .claude/settings.local.json` to get personal allow-lists on day one
7. Suggest next steps (e.g., "Run `/onboard` to get oriented", "Run `/doctor` to validate the config", "Customize CLAUDE.md further")

## Rules

- NEVER overwrite existing `.claude/` files without asking. Merge with existing config.
- Keep CLAUDE.md under 80 lines. Be ruthless.
- Every agent must reference actual project patterns, not generic advice.
- Skills must use the actual test/build/lint commands from the project.
- Prefer `paths:` scoped rules over global rules.
- Use `@imports` in CLAUDE.md to keep it lean (e.g., `@docs/architecture.md`).
