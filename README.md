# claude-init

Make any repo AI-native. Drop this into an existing codebase and run `/setup` to generate a complete Claude Code configuration — tailored to your stack, framework, and patterns.

## The Problem

Starting with AI coding on an existing repo is painful. Claude doesn't know your architecture, conventions, test setup, or deployment flow. You spend the first 20 minutes of every session re-explaining context.

## The Solution

This repo is a **cold-start solver**. Point it at any codebase and it:

1. **Analyzes** your stack (language, framework, DB, tests, CI, patterns)
2. **Generates** a tailored `.claude/` configuration:
   - `CLAUDE.md` — project context, commands, architecture, conventions
   - `agents/` — architect, developer, reviewer, QA, researcher (model-tiered)
   - `skills/` — plan, review, test, devil's advocate, clarify
   - `rules/` — code style, security, testing, git (path-scoped)
   - `hooks` — safety guardrails (block force pushes, credential reads, destructive ops)

## Quick Start

```bash
# Option 1: Install as a global skill
cp -r ~/claude-init/.claude/skills/setup ~/.claude/skills/
cd /path/to/your-repo
claude
# Type: /setup

# Option 2: Run directly
cd /path/to/your-repo
claude --skill-path ~/claude-init/.claude/skills/setup
# Type: /setup

# Option 3: Onboard to a repo you've already set up
# Type: /onboard
```

## What Gets Generated

| Component | Purpose | Customized To |
|-----------|---------|--------------|
| `CLAUDE.md` | Project context (under 80 lines) | Actual commands, architecture, patterns |
| `agents/architect.md` | System design (Opus) | Your DB, API, auth patterns |
| `agents/developer.md` | Implementation (Sonnet) | Your framework and conventions |
| `agents/reviewer.md` | Code review (Sonnet) | Your linter and test setup |
| `agents/qa.md` | Test writing (Sonnet) | Your test framework and patterns |
| `agents/researcher.md` | Codebase exploration (Haiku) | Your directory structure |
| `skills/plan/` | Feature planning with devil's advocate | Your existing patterns |
| `skills/review/` | Pre-commit code review | Your conventions |
| `skills/test/` | Test generation | Your test framework |
| `skills/devils-advocate/` | Challenge designs | Your architecture |
| `skills/clarify/` | Messy request -> clean spec | Your domain |
| `rules/` | Path-scoped rules | Your linter, git, security needs |
| `settings.json` | Safety hooks | Blocks destructive operations |

## Design Principles

- **Progressive disclosure**: Skill descriptions are ~100 tokens. Full content loads on demand. Doesn't burn context window.
- **Stack-aware**: Detects your actual tools and generates config that references real commands, real patterns, real file paths.
- **Opinionated defaults**: Generates best-practice config based on industry research. Easy to customize after.
- **Model-tiered agents**: Opus for critical thinking (architect, devil's advocate), Sonnet for implementation (dev, QA, reviewer), Haiku for exploration (researcher).
- **Security-first**: Hooks block `rm -rf`, force pushes, credential reads out of the box.
- **RALPH loop**: Developer agent uses Read-Act-Log-Pause-Hallucination-check pattern for self-correction.

## Inspired By

- [Ninja Van's 4-stage agent pipeline](https://ninjavan.co) (Shaun's tech sharing)
- [Trail of Bits' security-first Claude config](https://github.com/trailofbits/claude-code-config)
- [obra/superpowers](https://github.com/obra/superpowers) (skill TDD, progressive disclosure)
- [snarktank/ralph](https://github.com/snarktank/ralph) (RALPH autonomous loop)
- [Anthropic's official best practices](https://code.claude.com/docs/en/best-practices)

## License

MIT
