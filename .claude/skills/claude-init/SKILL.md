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

## Step 2: Generate Configuration

Based on the analysis, generate these files in the target repo. Use the templates from `${CLAUDE_SKILL_DIR}/../../../templates/` as starting points, but CUSTOMIZE everything to the specific codebase.

### 2a. CLAUDE.md
Generate at the repo root. Must include:
- One-line project description
- **Commands section**: Actual dev/test/build/lint commands found in package.json/Makefile/etc.
- **Architecture section**: Actual framework, DB, auth, API patterns found
- **Code style section**: Actual conventions found (or sensible defaults for the stack)
- **Testing section**: Actual test framework, location, and run commands
- **Git section**: Actual commit style from git log
- **Patterns to follow**: Key patterns found in the codebase (import style, error handling, etc.)
- **Do NOT section**: Stack-specific anti-patterns

Keep it under 80 lines. Every line must earn its place.

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

### 2c. Rules (`.claude/rules/`)

**Only generate rules with project-specific content.** Generic advice like "validate user input" or "write clean code" is stuff Claude already knows. Every rule must capture something Claude CAN'T infer from reading the code — deployment gotchas, team conventions, architectural decisions, domain-specific constraints.

Always generate:
1. **git.md** — Based on ACTUAL commit style from git log (conventional commits? Jira refs? squash policy?)
2. **testing.md** — Based on the ACTUAL test framework, patterns, and conventions (from Step 1.5)

Conditionally generate (only if project-specific content found):
3. **code-style.md** — Only if there are non-obvious conventions (unusual import ordering, specific naming patterns, etc.). Skip if the project just uses a standard linter config.
4. **api.md** — Only if API routes detected. Must reference actual response shapes, error patterns, auth middleware found in the code. Scope with `paths:`.
5. **database.md** — Only if ORM/migrations detected. Must reference actual migration patterns, schema conventions. Scope with `paths:`.
6. **frontend.md** — Only if frontend components detected. Must reference actual component patterns, state management conventions. Scope with `paths:`.
7. **security.md** — Only if the project has specific security patterns (auth middleware, input sanitization, CSP headers). Don't generate generic OWASP advice.
8. **performance.md** — Only if specific performance patterns found (caching, connection pooling, lazy loading).

**The test**: for each rule file, ask "would removing this cause Claude to make a mistake on THIS project?" If no, don't generate it.

### 2d. Skills (`.claude/skills/`)

Only generate skills that add value beyond what Claude already does. A skill must change Claude's behavior, not just describe a process Claude would follow anyway.

**Always generate (these genuinely change behavior):**
1. **plan/SKILL.md** — Planning skill with built-in devil's advocate challenge. Forces structured thinking before implementation.
2. **review/SKILL.md** — Code review against THIS project's conventions (not generic). Must reference actual linter config, patterns, and anti-patterns.
3. **test/SKILL.md** — Test generation using the project's actual test framework, patterns, and conventions from Step 1.5.
4. **clarify/SKILL.md** — Product clarifier that turns messy requests into structured, testable specs.

**Conditionally generate (only if the project benefits from structured process):**
5. **devils-advocate/SKILL.md** — Only for projects with complex architecture or multiple contributors. Overkill for simple apps.

**Do NOT generate by default (Claude already does these well without a skill):**
- `/fix` — Claude's default debugging is already "reproduce → locate → fix"
- `/debug` — Same as above, Claude naturally investigates systematically
- `/refactor` — Claude already runs tests before/after when asked to refactor

These can be added later via `/update` if the user wants the structured process.

### 2e. Hooks (`.claude/settings.json`)

Keep hooks minimal. Overly aggressive hooks create friction that makes people disable them entirely.

**Always include:**
- **PreToolUse (Write)**: Block writing to `.env`, `.pem`, `.key`, `.cert`, credential files — this catches real mistakes with near-zero false positives

**For team projects (>1 contributor detected via git log):**
- **PreToolUse (Bash)**: Block `git push --force`, `npm publish`, `docker push`, `terraform destroy`
- **Permissions deny list**: Block reading `~/.ssh/`, `~/.aws/`, `~/.gnupg/`

**Skip for solo dev projects:**
- Don't add Bash hooks for `rm -rf`, `git reset --hard`, etc. — these cause false positives on legitimate commands like `rm -rf ./dist` and a solo dev knows what they're doing

### 2f. Monorepo Support
If a monorepo is detected:
- Generate a root `CLAUDE.md` with shared conventions
- Generate per-package/app `CLAUDE.md` files with package-specific commands and architecture
- Scope rules to specific packages via `paths:` frontmatter
- Each package's CLAUDE.md should reference the root with `@../../CLAUDE.md`

### 2g. .gitignore additions
Ensure `.claude/settings.local.json` and `.claude/agent-memory-local/` are gitignored.

## Step 3: Verify & Report

After generation:
1. Count files generated
2. Show the CLAUDE.md to the user for review
3. List all agents, skills, rules, and hooks created
4. Suggest next steps (e.g., "Run `/onboard` to get oriented", "Customize CLAUDE.md further")

## Rules

- NEVER overwrite existing `.claude/` files without asking. Merge with existing config.
- Keep CLAUDE.md under 80 lines. Be ruthless.
- Every agent must reference actual project patterns, not generic advice.
- Skills must use the actual test/build/lint commands from the project.
- Prefer `paths:` scoped rules over global rules.
- Use `@imports` in CLAUDE.md to keep it lean (e.g., `@docs/architecture.md`).
