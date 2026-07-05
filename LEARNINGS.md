# Self-Learning Log

Decision log for the weekly self-learning loop (`.github/workflows/self-learn.yml`). Each cycle records what was evaluated, what was adopted, and what was rejected — so future runs never re-propose a rejected idea.

## Sources — last checked

| Source | Last checked |
|--------|--------------|
| anthropics/claude-code CHANGELOG | 2026-07-05 |
| anthropics/skills | 2026-07-05 |
| code.claude.com/docs (skills, hooks, sub-agents, plugins, memory) | 2026-07-05 |
| obra/superpowers | 2026-07-05 |
| trailofbits/claude-code-config | 2026-07-05 |
| hesreallyhim/awesome-claude-code | 2026-07-05 |
| VoltAgent/awesome-agent-skills | 2026-07-05 |

## Cycle: 2026-07-05 (manual bootstrap)

### ✅ Adopted: July 2026 refresh
- **Source:** code.claude.com/docs/en/plugins-reference, /memory, /sub-agents
- **Changes:** fixed plugin.json skills paths (`./`-relative, metadata schema with author object); extracted claude-init SKILL.md detail into `reference/` files (progressive disclosure dogfooding); AGENTS.md symlink interop in generator + README; documented `background`/`persistent-memory` agent frontmatter; doctor validates hook event names; fixed README manual-install skill name (`setup` → `claude-init`).

### ❌ Rejected: scaffold agent-teams / dynamic-workflows config by default
- **Source:** code.claude.com/docs/en/agent-teams
- **Reason:** experimental/preview features; generating opt-in env vars into every project is speculative config. Track instead.
- **Revisit:** when either feature ships as stable.

### ⏳ Tracking
- `.claude/rules/` user-level (`~/.claude/rules/`) symlink patterns for team-shared rule libraries — possible template addition.
- Subagent `persistent-memory` in generated researcher agent — adopt once it proves useful in real projects.

## Guardrails (summary — full text in .github/prompts/self-learn.md)

- One idea per cycle, ≤200 changed lines, citations required
- PR only, human merges; never touch installer logic, workflows, LICENSE, PRIVACY.md
- Rejected ideas live here forever; re-proposal requires a passed revisit date
