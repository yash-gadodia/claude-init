# claude-init

Makes any repo AI-native by generating a complete `.claude/` configuration tailored to the codebase.

## What This Does

Point this at any existing (or new) repo and run `/claude-init` to:
1. Analyze the codebase (language, framework, tests, CI, architecture, patterns)
2. Bootstrap a test suite if none exists
3. Generate ARCHITECTURE.md for deep project context
4. Generate tailored `CLAUDE.md`, agents, rules, skills, and hooks
5. Skills include: clarify (with spec persistence), plan, TDD, review, verify, subagent-dev, finish
6. Every skill has rationalization prevention ("Red Flags — STOP" tables)
7. Auto-triggered workflow rule — Claude follows the full pipeline without slash commands

## Usage

```bash
# Install globally (skills → ~/.claude/skills/, templates → ~/.claude/claude-init-templates/)
curl -fsSL https://raw.githubusercontent.com/yash-gadodia/claude-init/main/scripts/install.sh | bash

# Or load the repo as a plugin
git clone git@github.com:yash-gadodia/claude-init.git ~/claude-init
claude --plugin-dir ~/claude-init

# Then, in the TARGET repo:
cd /path/to/your-existing-repo && claude
# Type: /claude-init
```

## Architecture

See `ARCHITECTURE.md` for the full system map. Quick tour:

- `templates/` — Template files that get customized per-repo during setup
- `.claude/skills/claude-init/` — The main generator skill (analyzes repo, writes config)
- `.claude/skills/onboard/` — Quick onboarding skill for new devs joining a repo
- `.claude/skills/update/` — Refresh config when the repo evolves
- `.claude/skills/doctor/` — Validate generated config
- `scripts/` — Install script and helpers
- `tests/run.sh` — zero-dependency self-test suite; run before committing template changes

## Design Principles

- **Progressive disclosure**: Frontmatter stays tiny (~100 tokens), full content loads on demand
- **Stack-aware**: Detects framework, language, test runner, CI, and tailors everything
- **Opinionated defaults, easy overrides**: Generates best-practice config you can customize
- **Security-first**: Hooks block destructive ops by default
- **Agent personas**: Each role (architect, dev, QA) gets model-appropriate config (Opus for critical thinking, Sonnet for implementation, Haiku for fast ops)
