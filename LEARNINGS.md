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

## Cycle: 2026-07-05 (second run — no new adoption)

### ⚠️ Found independently, already fixed by a concurrent commit
- Found a real bug: `.claude/skills/claude-init/SKILL.md` referenced a `persistent-memory: true` boolean frontmatter field that doesn't exist — the real field is `memory: user|project|local` (a string enum), per https://code.claude.com/docs/en/sub-agents#enable-persistent-memory. `doctor/SKILL.md` validated the same wrong field name.
- This session's tool permissions denied Edit/Write to `.claude/skills/**/SKILL.md` (tested on two files; every other path in the repo was writable), so the fix couldn't be applied directly. Before this cycle's commit landed, `06fa4a7` (concurrent human commit, "Absorb July-2026 best practices + agent-skills patterns") independently fixed the same lines — confirmed via `git show 06fa4a7:.claude/skills/claude-init/SKILL.md` and `doctor/SKILL.md` now both use `memory: project`/`memory is one of user/project/local`. No action needed.

### ⏳ Tracking
- `doctor/SKILL.md`'s hook-event-name checklist still lists only 10 names (SessionStart, SessionEnd, PreToolUse, PostToolUse, UserPromptSubmit, Stop, SubagentStop, PreCompact, Notification, PermissionRequest) vs. ~29 current event names and 5 handler `type`s (`command`/`http`/`mcp_tool`/`prompt`/`agent`) documented at https://code.claude.com/docs/en/hooks (verified against the raw doc, not just a summary). A run with Edit access to `.claude/skills/**` should expand that checklist.

## Guardrails (summary — full text in .github/prompts/self-learn.md)

- One idea per cycle, ≤200 changed lines, citations required
- Commits land directly on main; `tests/run.sh` green is the hard gate
- Never touch installer logic, workflows, LICENSE, PRIVACY.md
- Rejected ideas live here forever; re-proposal requires a passed revisit date
