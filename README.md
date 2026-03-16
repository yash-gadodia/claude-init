# claude-init

Make any repo AI-native. Point it at an existing codebase, run `/setup`, and get a complete Claude Code configuration — tailored to your stack, framework, and patterns.

## The Problem

Starting with AI coding on an existing repo is painful. Claude doesn't know your architecture, conventions, test setup, or deployment flow. You spend the first 20 minutes of every session re-explaining context.

## The Solution

This is a **cold-start solver**. It analyzes your codebase and generates a complete `.claude/` configuration:

- `CLAUDE.md` — project context, commands, architecture, conventions (under 80 lines)
- `agents/` — architect, developer, reviewer, QA, researcher, devops, writer (model-tiered)
- `skills/` — plan, review, test, fix, debug, refactor, devil's advocate, clarify
- `rules/` — code style, security, testing, git, API, database, frontend, performance (path-scoped)
- `hooks` — deterministic safety guardrails (block force pushes, credential reads, destructive ops)

## Quick Start

```bash
# One-command install
curl -fsSL https://raw.githubusercontent.com/yash-gadodia/claude-init/main/scripts/install.sh | bash

# Then in any repo:
cd /path/to/your-repo
claude
# Type: /setup
```

Or manually:
```bash
git clone git@github.com:yash-gadodia/claude-init.git ~/claude-init
cp -r ~/claude-init/.claude/skills/setup ~/.claude/skills/
cp -r ~/claude-init/.claude/skills/onboard ~/.claude/skills/
cp -r ~/claude-init/.claude/skills/update ~/.claude/skills/
cp -r ~/claude-init/.claude/skills/doctor ~/.claude/skills/
```

## Commands

| Command | What It Does |
|---------|-------------|
| `/setup` | Analyze repo and generate full `.claude/` config |
| `/onboard` | Quick orientation to any codebase |
| `/update` | Re-analyze and update existing config (preserves customizations) |
| `/doctor` | Validate your `.claude/` setup — check commands work, paths exist, hooks are valid |

## What Gets Generated

### Agents (model-tiered)

| Agent | Role | Model | When |
|-------|------|-------|------|
| `architect` | System design, ADRs, API contracts | Opus | Always |
| `developer` | Implementation with RALPH self-correction | Sonnet | Always |
| `reviewer` | Code review against project conventions | Sonnet | Always |
| `qa` | Test writing using project's test framework | Sonnet | Always |
| `researcher` | Codebase exploration, architecture mapping | Haiku | Always |
| `devops` | CI/CD, Docker, deployment, infrastructure | Sonnet | If infra detected |
| `writer` | Docs, changelogs, PR descriptions, ADRs | Haiku | If docs needed |

### Skills

| Skill | Purpose |
|-------|---------|
| `/plan` | Feature planning with built-in devil's advocate |
| `/review` | Pre-commit code review against conventions |
| `/test` | Test generation using project's actual framework |
| `/fix` | Fix a specific error: reproduce -> locate -> fix -> regression test |
| `/debug` | Open-ended investigation: hypothesize -> isolate -> root cause |
| `/refactor` | Safe refactoring: tests green before AND after |
| `/devils-advocate` | Challenge designs — find every flaw before shipping |
| `/clarify` | Messy request -> clean, testable spec |

### Rules (path-scoped)

| Rule | Scope | When |
|------|-------|------|
| `code-style` | Global | Always |
| `security` | Global | Always |
| `testing` | Global | Always |
| `git` | Global | Always |
| `api` | `src/api/**`, `routes/**` | If API routes detected |
| `database` | `prisma/**`, `migrations/**` | If ORM/migrations detected |
| `frontend` | `src/components/**`, `app/**` | If frontend components detected |
| `performance` | Global | If web app or API |

### Hooks (deterministic, command-based)

Blocks: `rm -rf`, `git push --force`, `git reset --hard`, `git clean -fd`, `curl | sh`, `npm publish`, `docker push`, `terraform destroy`, credential file writes, reading `~/.ssh/`, `~/.aws/`, `~/.gnupg/`

## Stack Detection

Detects and tailors config for:
- **Languages**: TypeScript, Python, Rust, Go, Java, Ruby, PHP, Elixir, Swift, Kotlin, Dart, C/C++, Zig
- **Frameworks**: Next.js, Rails, Django, FastAPI, Express, Spring, Phoenix, SvelteKit, Nuxt, Laravel, Flutter, React Native
- **Databases**: Prisma, Drizzle, TypeORM, SQLAlchemy, ActiveRecord, Ecto, diesel
- **Testing**: Jest, Vitest, pytest, RSpec, ExUnit, go test, cargo test, Playwright, Cypress
- **CI/CD**: GitHub Actions, GitLab CI, CircleCI
- **Infrastructure**: Docker, Terraform, Pulumi, Kubernetes, Helm
- **Monorepos**: Turborepo, Nx, pnpm workspaces, or plain directory splits

## Design Principles

- **Progressive disclosure**: Descriptions load always (~100 tokens), full content loads on demand
- **Stack-aware**: References real commands, real patterns, real file paths from YOUR codebase
- **Deterministic hooks**: Command-based (not prompt-based) for reliable safety guardrails
- **Model-tiered**: Opus for critical thinking, Sonnet for implementation, Haiku for exploration
- **RALPH loop**: Developer agent uses Read-Act-Log-Pause-Hallucination-check for self-correction
- **Monorepo-aware**: Generates per-package CLAUDE.md files with scoped context
- **Never overwrites**: `/update` preserves your customizations, only updates generated sections

## Extras

- **`templates/ci/claude-review.yml`** — GitHub Actions workflow for automatic PR review with Claude
- **Plugin manifest** — installable as a Claude Code plugin via `.claude-plugin/plugin.json`

## Inspired By

- [Ninja Van's 4-stage agent pipeline](https://ninjavan.co) (Shaun's tech sharing)
- [Trail of Bits' security-first Claude config](https://github.com/trailofbits/claude-code-config)
- [obra/superpowers](https://github.com/obra/superpowers) (skill TDD, progressive disclosure)
- [snarktank/ralph](https://github.com/snarktank/ralph) (RALPH autonomous loop)
- [Anthropic's official best practices](https://code.claude.com/docs/en/best-practices)

## License

MIT
