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

After setup, you get these commands in your repo:

| Command | When to use |
|---------|-------------|
| `/plan` | Before starting any non-trivial feature — reads ARCHITECTURE.md for context |
| `/onboard` | When you or a teammate joins the repo — instant mental model |
| `/test` | Write tests using your actual framework and patterns |
| `/review` | Pre-commit review against your project's conventions |
| `/update` | After your codebase evolves — refresh config without losing customizations |
| `/doctor` | Validate that everything in `.claude/` is working correctly |

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

| Skill | Purpose |
|-------|---------|
| `/plan` | Feature planning with built-in devil's advocate challenge |
| `/review` | Pre-commit code review against project conventions |
| `/test` | Generate tests using your actual test framework and patterns |
| `/fix` | Fix a specific error: reproduce, locate, fix, regression test |
| `/debug` | Open-ended investigation: hypothesize, isolate, root cause |
| `/refactor` | Safe refactoring with tests green before and after |
| `/devils-advocate` | Stress-test a design — find every flaw before shipping |
| `/clarify` | Turn a messy request into a clean, testable spec |

### Rules

Path-scoped rules that only activate for relevant files:

| Rule | Scope | Generated |
|------|-------|-----------|
| `code-style` | Global | Always |
| `security` | Global | Always |
| `testing` | Global | Always |
| `git` | Global | Always |
| `api` | `src/api/**`, `routes/**` | When API routes detected |
| `database` | `prisma/**`, `migrations/**` | When ORM/migrations detected |
| `frontend` | `src/components/**`, `app/**` | When frontend detected |
| `performance` | Global | When web app or API |

### Safety Hooks

Deterministic, command-based guardrails that block destructive operations:

`rm -rf` · `git push --force` · `git reset --hard` · `git clean -fd` · `curl | sh` · `npm publish` · `docker push` · `terraform destroy` · credential file writes · `~/.ssh/` reads · `~/.aws/` reads

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

**Progressive disclosure** — Skill descriptions are ~100 tokens (always loaded). Full instructions load only when invoked. Dozens of skills without burning your context window.

**Stack-aware** — Every reference in the generated config points to real commands, real file paths, and real patterns from your actual codebase. No generic placeholders.

**Deterministic safety** — Hooks use shell commands with pattern matching, not LLM evaluation. Fast, reliable, zero false negatives on destructive operations.

**Model-tiered agents** — Opus for architecture and critical thinking. Sonnet for implementation and review. Haiku for exploration and docs. Cost-effective by default.

**RALPH loop** — The developer agent uses Read-Act-Log-Pause-Hallucination-check for structured self-correction during long tasks.

**Non-destructive updates** — `/update` re-analyzes your repo and proposes changes. It never overwrites your customizations — only generated sections get refreshed.

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
- [obra/superpowers](https://github.com/obra/superpowers) — skill TDD and progressive disclosure patterns
- [snarktank/ralph](https://github.com/snarktank/ralph) — RALPH autonomous loop
- [Anthropic's official best practices](https://code.claude.com/docs/en/best-practices)

## License

[MIT](LICENSE)
