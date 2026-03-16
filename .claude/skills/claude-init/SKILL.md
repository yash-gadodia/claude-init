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
Generate topic-specific rules:

Always generate:
1. **code-style.md** — Based on detected linter config, import style, naming conventions
2. **security.md** — Stack-specific security rules (SQL injection for DB projects, XSS for web, etc.)
3. **testing.md** — Based on detected test framework and patterns
4. **git.md** — Based on detected commit style and branching conventions

Conditionally generate based on detected stack:
5. **api.md** — Only if API routes/endpoints detected. Scope with `paths:` to API directories.
6. **database.md** — Only if ORM/migrations detected. Scope to schema/migration directories.
7. **frontend.md** — Only if frontend components detected. Scope to component directories.
8. **performance.md** — Include for web apps and APIs, skip for CLIs and libraries.

Use `paths:` frontmatter to scope rules to relevant directories:
```yaml
---
paths:
  - "src/api/**"
---
```

### 2d. Skills (`.claude/skills/`)
Generate these skills:

1. **plan/SKILL.md** — Planning skill that uses the devil's advocate pattern. Outputs specs to `specs/` directory.
2. **review/SKILL.md** — Code review skill that checks against project conventions.
3. **test/SKILL.md** — Test generation skill that uses the project's actual test framework and patterns.
4. **devils-advocate/SKILL.md** — Challenges architectural decisions. Asks "what if this fails?"
5. **clarify/SKILL.md** — Product clarifier that turns messy requests into structured specs.
6. **fix/SKILL.md** — Debug a specific error or failing test. Reproduce → locate → fix → regression test.
7. **debug/SKILL.md** — Open-ended investigation when the cause is unknown. Hypothesize → isolate → root cause.
8. **refactor/SKILL.md** — Structured refactoring with tests green before and after.

### 2e. Hooks (`.claude/settings.json`)
Generate deterministic command-based safety hooks (NOT prompt-based — they're slow and unreliable):
- **PreToolUse (Bash)**: Block `rm -rf`, `git push --force`, `git reset --hard`, `git clean -fd`, `curl | sh`, `npm publish`, `docker push`, `terraform destroy`, `kubectl delete namespace`
- **PreToolUse (Write)**: Block writing to `.env`, `.pem`, `.key`, `.cert`, credential files
- **Permissions deny list**: Block reading `~/.ssh/`, `~/.aws/`, `~/.gnupg/`, `.env` files

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
