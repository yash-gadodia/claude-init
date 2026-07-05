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

## Cycle: 2026-07-05 (second run — blocked)

### ⚠️ Attempted, blocked: fix stale `persistent-memory: true` frontmatter field
- **Source:** https://code.claude.com/docs/en/sub-agents#enable-persistent-memory — the real subagent memory field is `memory: user|project|local` (a string enum), not a `persistent-memory: true` boolean. Confirmed by fetching the doc directly (not just a WebFetch summary).
- **Bug found:** `.claude/skills/claude-init/SKILL.md:163` tells the generator to use `persistent-memory: true`, while `.claude/skills/claude-init/SKILL.md:159` (three lines earlier, same file) correctly says `memory: project` — internally inconsistent. `.claude/skills/doctor/SKILL.md:25` also validates the wrong field name (checks that `background`/`persistent-memory` are booleans if present). Neither `persistent-memory` field appears in any `templates/agents/*.md` file, so no generated-repo output is affected yet — the bug is confined to the two self-skill files.
- **Why not fixed this cycle:** this session's tool permissions denied Edit/Write to any `.claude/skills/**/SKILL.md` path (tested on both `doctor/SKILL.md` and `claude-init/SKILL.md`, and confirmed the same paths are writable via plain `git`/file tooling in general — this looks like a session-scoped safety rail on the currently-loaded skill files, not a repo-level permission). Every other path in the repo (`templates/`, root files) was writable.
- **Next step:** on a run with Edit access to `.claude/skills/**`, apply this exact fix — replace `persistent-memory: true` with `memory: project` (or `user`/`local`) in `claude-init/SKILL.md:163`, and update `doctor/SKILL.md:25`'s check to `background is a boolean if present; memory is one of user/project/local if present`. Small, mechanical, ~4 lines.

### ❌ Rejected (no new candidate cleared the bar)
- Also reviewed: hooks doc now lists ~29 event names (vs. 10 in `doctor/SKILL.md:49`'s checklist) and 5 handler `type`s (`command`/`http`/`mcp_tool`/`prompt`/`agent`, per https://code.claude.com/docs/en/hooks) — same self-skill write-block applies; deferred to the same future run as the fix above rather than proposing a second idea this cycle.

## Guardrails (summary — full text in .github/prompts/self-learn.md)

- One idea per cycle, ≤200 changed lines, citations required
- Commits land directly on main; `tests/run.sh` green is the hard gate
- Never touch installer logic, workflows, LICENSE, PRIVACY.md
- Rejected ideas live here forever; re-proposal requires a passed revisit date
