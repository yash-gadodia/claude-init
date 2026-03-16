# app-starter-app

Makes any repo AI-native by generating a complete `.claude/` configuration tailored to the codebase.

## What This Does

Point this at any existing (or new) repo and run `/setup` to:
1. Analyze the codebase (language, framework, tests, CI, architecture, patterns)
2. Generate a tailored `CLAUDE.md` with project-specific commands, architecture docs, and conventions
3. Generate agent personas (architect, developer, QA, reviewer, researcher) tuned to the stack
4. Generate rules for code style, security, testing, and git workflows
5. Generate skills for planning, code review, testing, and devil's advocate challenges
6. Generate hooks for safety guardrails (block force pushes, credential reads, etc.)

## Usage

```bash
# Clone this repo
git clone git@github.com:yash-gadodia/app-starter-app.git

# Open the TARGET repo in Claude Code
cd /path/to/your-existing-repo

# Run setup pointing to this starter pack
claude --skill-path ~/app-starter-app/.claude/skills/setup

# Or copy the skills into the target repo first
cp -r ~/app-starter-app/.claude/skills/setup /path/to/repo/.claude/skills/
cd /path/to/repo && claude
# Then type: /setup
```

## Architecture

- `templates/` — Template files that get customized per-repo during setup
- `.claude/skills/setup/` — The main generator skill (analyzes repo, writes config)
- `.claude/skills/onboard/` — Quick onboarding skill for new devs joining a repo
- `.claude/agents/` — Agent definitions used by the setup process itself
- `scripts/` — Helper scripts for stack detection

## Design Principles

- **Progressive disclosure**: Frontmatter stays tiny (~100 tokens), full content loads on demand
- **Stack-aware**: Detects framework, language, test runner, CI, and tailors everything
- **Opinionated defaults, easy overrides**: Generates best-practice config you can customize
- **Security-first**: Hooks block destructive ops by default
- **Agent personas**: Each role (architect, dev, QA) gets model-appropriate config (Opus for critical thinking, Sonnet for implementation, Haiku for fast ops)
