# claude-init — Architecture

## Overview

claude-init is a generator that turns any existing codebase into an AI-native one by producing a tailored `.claude/` configuration (CLAUDE.md, ARCHITECTURE.md, agents, skills, rules, hooks, output styles). The value is in the opinionation — this isn't a YAML DSL, it's a set of vetted templates + a skill that reads your repo and customizes them.

## System Map

```
~/claude-init (this repo)
├── .claude/skills/           ← self-skills (claude-init, onboard, update, doctor)
│   └── claude-init/SKILL.md  ← the generator (reads repo, writes config)
├── .claude/agents/           ← personas used *during* generation
├── .claude/rules/            ← rules applied to this repo's own work
├── templates/                ← stuff that gets copied/customized into target repos
│   ├── agents/               ← architect, developer, qa, reviewer, researcher, devops, writer
│   ├── skills/               ← plan, tdd, verify, review, clarify, subagent-dev, + optional
│   ├── rules/                ← workflow, testing, git, + conditional api/db/frontend/etc.
│   ├── hooks/                ← settings.json (committed) + settings.local.json.example
│   ├── output-styles/        ← tdd.md (system-prompt TDD enforcement)
│   └── ci/                   ← claude-test.yml, claude-review.yml for GH Actions
└── scripts/install.sh        ← one-liner curl installer → puts skills in ~/.claude/
```

## Flow: running /claude-init on a target repo

1. User clones claude-init or runs the install script (puts skills into `~/.claude/skills/` and templates into `~/.claude/claude-init-templates/`).
2. User `cd`s into their target repo and types `/claude-init`.
3. `.claude/skills/claude-init/SKILL.md` fires — the generator.
4. Parallel subagents detect: stack, architecture, tests, CI, conventions.
5. If no tests exist, Step 1.5 bootstraps a real test suite (parallel subagents for unit/integration/component layers) — the "trust layer" for all subsequent AI work.
6. Step 1.75 generates `ARCHITECTURE.md` — the machine-readable system map that `/plan` and the architect agent load on demand.
7. Step 2 writes: `CLAUDE.md`, `.claude/agents/*`, `.claude/skills/*`, `.claude/rules/*`, `.claude/settings.json` (+ `.local.json.example`), `.claude/output-styles/tdd.md`. All customized to the detected stack.
8. Step 3 reports what was generated and suggests next steps (`/doctor` to validate, `/onboard` for new devs, `/update` when the codebase evolves).

## Key Design Decisions

- **Progressive disclosure**: frontmatter stays tiny (~100 tokens per skill), full content loads only when invoked. Keeps baseline context lean.
- **Path-scoped rules and project-specific skills**: `paths: src/api/**` on a rule/skill means it only loads when Claude touches those files. Critical for large repos.
- **Model tiering**: Opus for architectural work, Sonnet for implementation + review, Haiku for research/exploration. Generic Opus-everywhere wastes tokens.
- **Auto-triggered workflow**: `rules/workflow.md` makes Claude follow `clarify → plan → TDD → verify → review` automatically. Users don't type slash commands.
- **Two-tier settings**: `settings.json` (committed deny + ask layer) vs `settings.local.json.example` (shows the shape for personal allows; gitignored real file). Mirrors how teams actually split safety defaults from personal ergonomics.
- **Deterministic hooks, not LLM hooks**: shell-regex PreToolUse/PostToolUse catches the 5 things you absolutely must block (credentials, force-push, `rm -rf /`) and auto-formats on write. No LLM-in-the-loop for safety.
- **Output style for TDD**: injects the RED-GREEN-REFACTOR rule into the system prompt, which is stronger than a rule file (Claude can't "forget" it).

## Module Boundaries

- `templates/` is pure content — no code runs there, it's strings copied (and customized) into target repos.
- `.claude/skills/claude-init/SKILL.md` is the only "active" artifact — it's the procedural description of what to analyze, detect, and write.
- `scripts/install.sh` is installer-only; no runtime behavior.
- The generated target-repo `.claude/` is the actual AI-native surface; claude-init's own `.claude/` is just for working on this repo.

## External Dependencies

None at runtime. The skills use only tools Claude Code already provides (Read, Write, Edit, Bash, Grep, Glob, Agent). The optional GitHub Actions templates assume `gh` / `npm` / `pytest` depending on detected stack.

## Entry Points

- **Generate config on a new repo**: invoke `/claude-init` inside target repo.
- **Refresh config when repo evolves**: invoke `/update` inside target repo.
- **Validate config**: invoke `/doctor` inside target repo.
- **Onboard a new dev**: invoke `/onboard` inside target repo.
- **Modify generator behavior**: edit `.claude/skills/claude-init/SKILL.md` in this repo.
- **Modify what gets generated**: edit files under `templates/` in this repo.
