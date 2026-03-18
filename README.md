<p align="center">
  <h1 align="center">claude-init</h1>
  <p align="center">Make any repo AI-native in one command.</p>
</p>

<p align="center">
  <a href="#quick-start">Quick Start</a> &middot;
  <a href="#what-gets-generated">What Gets Generated</a> &middot;
  <a href="#stack-detection">Stack Detection</a> &middot;
  <a href="#contributing">Contributing</a>
</p>

---

Point `claude-init` at any existing codebase, run `/claude-init`, and get a complete [Claude Code](https://docs.anthropic.com/en/docs/claude-code) configuration — `CLAUDE.md`, agents, skills, rules, and hooks — all tailored to your stack, framework, and patterns.

## Why

Every time you open Claude Code on an existing repo, you start from zero. Claude doesn't know your architecture, conventions, test commands, or deployment flow. You burn context re-explaining the same things every session.

`claude-init` fixes the cold start. One command analyzes your codebase, bootstraps a test suite if none exists, and generates everything Claude needs to work effectively from the first message.

**No tests? No problem.** If your repo has no test framework, `claude-init` picks the right one for your stack, installs it, and writes a baseline test suite covering your existing code. Tests are the trust layer — without them, AI coding is just vibes.

## Quick Start

**Install globally (recommended):**

```bash
curl -fsSL https://raw.githubusercontent.com/yash-gadodia/claude-init/main/scripts/install.sh | bash
```

**Then in any repo:**

```bash
cd /path/to/your-repo
claude
/claude-init
```

### What Happens When You Run `/claude-init`

1. **Analyze** — Scans your codebase in parallel: stack, framework, architecture, tests, CI, conventions
2. **Bootstrap tests** — If no test framework exists, installs one and writes a baseline test suite
3. **Generate ARCHITECTURE.md** — Creates AI-facing architecture documentation (system map, data flow, design decisions, module boundaries) if none exists
4. **Generate `.claude/` config** — CLAUDE.md, agents, skills, rules, and hooks — all tailored to what was found
5. **Report** — Shows what was generated and suggests next steps

After setup, Claude automatically follows a development workflow (clarify → plan → TDD → verify → review → finish) scaled to task size. No slash commands needed — but you can invoke any step manually:

| Command | When to use |
|---------|-------------|
| `/clarify` | Turn vague requests into testable specs |
| `/plan` | Before starting any non-trivial feature |
| `/tdd` | Enforce test-first development |
| `/review` | Two-stage review: spec compliance → code quality |
| `/verify` | Prove completion claims with fresh evidence |
| `/finish` | Land work: merge, PR, keep branch, or discard |
| `/subagent-dev` | Execute plans with fresh subagent per task |
| `/onboard` | When you or a teammate joins the repo |
| `/update` | After your codebase evolves — refresh config |
| `/doctor` | Validate your `.claude/` setup |

**Or install manually:**

```bash
git clone git@github.com:yash-gadodia/claude-init.git ~/claude-init
cp -r ~/claude-init/.claude/skills/{setup,onboard,update,doctor} ~/.claude/skills/
```

## Commands

| Command | Description |
|---------|------------|
| `/claude-init` | Analyze a repo and generate the full `.claude/` configuration |
| `/onboard` | Get oriented on any codebase — architecture, patterns, how to run things |
| `/update` | Re-analyze and refresh config without overwriting your customizations |
| `/doctor` | Validate your `.claude/` setup — verify commands, paths, hooks, and agents |

## What Gets Generated

### ARCHITECTURE.md

AI-facing architecture documentation at the repo root. Not loaded every conversation (that would waste tokens), but read on demand by `/plan`, `/onboard`, and the architect agent when deep context is needed. Contains system overview, directory map, data flow, design decisions, module boundaries, and entry points. Under 120 lines.

### CLAUDE.md

A lean (under 80 lines) project file containing actual commands, architecture, conventions, and patterns found in your codebase. Every line earns its place. References ARCHITECTURE.md for deeper context.

### Agents

Model-tiered personas that know your stack:

| Agent | Role | Model | Generated |
|-------|------|-------|-----------|
| `architect` | System design, ADRs, API contracts | Opus | Always |
| `developer` | Implementation with RALPH self-correction | Sonnet | Always |
| `reviewer` | Code review against project conventions | Sonnet | Always |
| `qa` | Test writing using your test framework | Sonnet | Always |
| `researcher` | Codebase exploration, architecture mapping | Haiku | Always |
| `devops` | CI/CD, Docker, deployment, infrastructure | Sonnet | When infra detected |
| `writer` | Docs, changelogs, PR descriptions | Haiku | When docs needed |

### Skills

Auto-triggered by the workflow rule — Claude follows these automatically, scaled to task complexity. Users can also invoke manually.

| Skill | Purpose | Generated |
|-------|---------|-----------|
| `/clarify` | Turn vague requests into testable specs with spec persistence and review | Always |
| `/plan` | Feature planning with devil's advocate challenge | Always |
| `/tdd` | RED-GREEN-REFACTOR with rationalization prevention | Always |
| `/review` | Two-stage: spec compliance first, then code quality | Always |
| `/verify` | No completion claims without fresh evidence | Always |
| `/subagent-dev` | Fresh subagent per task + two-stage review | Always |
| `/finish` | Land work: verify → merge/PR/keep/discard | Always |
| `/devils-advocate` | Stress-test a design before shipping | When complex project |

### Rules

Project-specific rules — only generated when they'd prevent Claude from making a mistake on your project:

| Rule | Generated |
|------|-----------|
| `git` | Always — matches your actual commit style from git log |
| `testing` | Always — your actual test framework, patterns, conventions |
| `workflow` | Always — auto-triggered development pipeline (clarify → plan → TDD → verify → review → finish) |
| `code-style` | When non-obvious conventions found (skip if just standard linter) |
| `api` | When API routes detected — actual response shapes, error patterns |
| `database` | When ORM/migrations detected — actual migration patterns |
| `frontend` | When frontend components detected — actual component patterns |
| `security` | When specific security patterns found (not generic OWASP) |
| `performance` | When specific patterns found (caching, connection pooling) |

### Safety Hooks

Deterministic, command-based guardrails — minimal to avoid friction:

**Always:** Block writing to `.env*`, `.pem`, `.key`, `.cert`, credential files

**Team projects** (>1 contributor): Block `git push --force`, `npm publish`, `docker push`, `terraform destroy`. Deny reading `~/.ssh/`, `~/.aws/`, `~/.gnupg/`

**Solo dev:** Minimal hooks only — no false positives on legitimate commands

## Stack Detection

Analyzes and tailors config for:

| Category | Detected |
|----------|----------|
| **Languages** | TypeScript, Python, Rust, Go, Java, Ruby, PHP, Elixir, Swift, Kotlin, Dart, C/C++, Zig |
| **Frameworks** | Next.js, Rails, Django, FastAPI, Express, Spring, Phoenix, SvelteKit, Nuxt, Laravel, Flutter, React Native |
| **Databases** | Prisma, Drizzle, TypeORM, SQLAlchemy, ActiveRecord, Ecto, diesel |
| **Testing** | Jest, Vitest, pytest, RSpec, ExUnit, go test, cargo test, Playwright, Cypress |
| **CI/CD** | GitHub Actions, GitLab CI, CircleCI |
| **Infrastructure** | Docker, Terraform, Pulumi, Kubernetes, Helm |
| **Monorepos** | Turborepo, Nx, pnpm workspaces, or plain directory splits |

## Design Principles

**Auto-triggered workflow** — Generated `workflow.md` rule makes Claude automatically follow clarify → plan → TDD → verify → review → finish, scaled to task size. No slash commands needed.

**Rationalization prevention** — Every skill includes "Red Flags — STOP" tables listing the exact thoughts that signal an agent is about to skip process discipline. Inspired by [obra/superpowers](https://github.com/obra/superpowers).

**Spec persistence** — The clarify skill saves specs to `docs/specs/`, dispatches a reviewer subagent, and gates on user approval before planning. Specs become artifacts that plans trace back to.

**Progressive disclosure** — Skill descriptions are ~100 tokens (always loaded). Full instructions load only when invoked.

**Stack-aware** — Every reference points to real commands, real file paths, and real patterns from your actual codebase.

**Model-tiered agents** — Opus for architecture. Sonnet for implementation and review. Haiku for exploration and docs.

**RALPH loop** — Developer agent uses Read-Act-Log-Pause-Hallucination-check for self-correction.

**Non-destructive updates** — `/update` re-analyzes without overwriting customizations.

## Extras

| File | Description |
|------|------------|
| `templates/ci/claude-review.yml` | GitHub Actions workflow for automatic PR review with Claude |
| `templates/ci/claude-test.yml` | GitHub Actions workflow to run tests on PRs (auto-detects package manager) |
| `.claude-plugin/plugin.json` | Plugin manifest — installable via Claude Code's plugin system |
| `scripts/install.sh` | One-command global installer |

## Contributing

PRs welcome. If you've battle-tested this on a stack we don't cover well, improvements to the templates and detection logic are especially useful.

## Thanks

People and projects that shaped this:

- **Shaun Chong**, CTO @ Ninja Van — 4-stage agent pipeline architecture, RALPH loop concept, "tests as trust layer" framing
- [Trail of Bits' claude-code-config](https://github.com/trailofbits/claude-code-config) — security-first defaults
- [obra/superpowers](https://github.com/obra/superpowers) — rationalization prevention, spec review loops, TDD discipline, subagent status protocol, finish workflow, progressive disclosure
- [snarktank/ralph](https://github.com/snarktank/ralph) — RALPH autonomous loop
- [Anthropic's official best practices](https://code.claude.com/docs/en/best-practices)

## License

[MIT](LICENSE)
