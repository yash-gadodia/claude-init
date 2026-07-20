# Self-Learning Log

Decision log for the weekly self-learning loop (`.github/workflows/self-learn.yml`). Each cycle records what was evaluated, what was adopted, and what was rejected — so future runs never re-propose a rejected idea.

## Sources — last checked

| Source | Last checked |
|--------|--------------|
| anthropics/claude-code CHANGELOG | 2026-07-20 |
| anthropics/skills | 2026-07-20 |
| code.claude.com/docs (skills, hooks, sub-agents, plugins, memory) | 2026-07-20 |
| obra/superpowers | 2026-07-20 |
| trailofbits/claude-code-config | 2026-07-20 |
| hesreallyhim/awesome-claude-code | 2026-07-20 |
| VoltAgent/awesome-agent-skills | 2026-07-20 |

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

## Cycle: 2026-07-06

### ✅ Adopted: expand doctor's hook event/handler-type checklist
- **Source:** https://code.claude.com/docs/en/hooks (fetched fresh, not summarized)
- **Changes:** `.claude/skills/doctor/SKILL.md` Check 5 previously listed only 10 hook event names; the docs now list 30 (SessionStart, SessionEnd, Setup, UserPromptSubmit, UserPromptExpansion, PreToolUse, PermissionRequest, PermissionDenied, PostToolUse, PostToolUseFailure, PostToolBatch, Notification, MessageDisplay, SubagentStart, SubagentStop, TaskCreated, TaskCompleted, Stop, StopFailure, TeammateIdle, InstructionsLoaded, ConfigChange, CwdChanged, FileChanged, WorktreeCreate, WorktreeRemove, PreCompact, PostCompact, Elicitation, ElicitationResult). Updated the checklist to the full list and added a new check that hook handler `type` is present and one of `command`/`http`/`mcp_tool`/`prompt`/`agent` (confirmed via the docs' handler-fields table that `type` is a required field with no default — this closes out the prior cycle's tracking item). `templates/hooks/settings.json` was already spot-checked and every handler already specifies `type` correctly, so no template change was needed there.
- **Note:** Edit access to `.claude/skills/**/SKILL.md` was available this run (unlike the prior cycle where it was denied).

### ⏳ Tracking
- `.claude/rules/` user-level (`~/.claude/rules/`) symlink patterns for team-shared rule libraries — possible template addition (carried over, not yet actioned).

## Cycle: 2026-07-13

### ✅ Adopted: flag CLAUDE.md content that merely restates what's derivable from the codebase
- **Source:** https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md — 2.1.206: "Added a `/doctor` check that proposes trimming checked-in `CLAUDE.md` files by cutting content Claude could derive from the codebase"
- **Changes:** Claude Code's own `/doctor` now polices exactly the anti-pattern claude-init's generator and doctor skill exist to prevent, so both were updated to match: `.claude/skills/claude-init/SKILL.md` (2a. CLAUDE.md) now explicitly tells the generator not to restate dependency/version lists, directory trees, or verbatim README content; `.claude/skills/doctor/SKILL.md` Check 1 gained a matching checklist item to flag such content in already-generated CLAUDE.md files. Reinforces the existing "under 80 lines, every line earns its place" rule with a concrete, citable failure mode rather than adding a new principle.
- **Rejected (same cycle):** Codex-portal packaging work in `obra/superpowers` (2026-06-30/07-02 commits) — cross-tool (Codex, not Claude Code) packaging concerns, out of scope for a Claude Code-focused generator. `trailofbits/claude-code-config` and `VoltAgent/awesome-agent-skills` had no commits since last check with a citable, in-scope idea (VoltAgent's activity is all community skill submissions to their catalog, not methodology/pattern changes).

### ⏳ Tracking (carried over)
- `.claude/rules/` user-level (`~/.claude/rules/`) symlink patterns for team-shared rule libraries — possible template addition, not yet actioned across three cycles.

## Cycle: 2026-07-20

### ✅ Adopted: document `.claude/rules/` symlink sharing + user-level rules
- **Source:** https://code.claude.com/docs/en/memory (fetched fresh 2026-07-20) — "Share rules across projects with symlinks" section: `.claude/rules/` supports symlinks (resolved normally, circular links detected and handled), e.g. `ln -s ~/shared-claude-rules .claude/rules/shared` or `ln -s ~/company-standards/security.md .claude/rules/security.md`; plus a "User-level rules" section documenting `~/.claude/rules/` (personal, every project, loaded before project rules).
- **Changes:** `.claude/skills/claude-init/SKILL.md` section 2c (Rules) now documents both patterns, gated so the generator only surfaces them when the project's setup implies multi-repo/team rule sharing or existing personal cross-project rules — not generated speculatively. `.claude/skills/doctor/SKILL.md` Check 4 gained a dangling-symlink check (`find .claude/rules -xtype l`) since a broken symlink silently drops those rules from context with no error. This closes out the tracking item carried since the 2026-07-05 cycle (three cycles waiting on an official citable source).
- **Investigated, no action needed:** CHANGELOG 2.1.215 ("/verify and /code-review skills no longer run automatically; invoke them explicitly") looked like it could undercut claude-init's core "auto-triggered workflow" design principle (`templates/rules/workflow.md`). Confirmed by reading `.claude/skills/claude-init/SKILL.md` section 2d: claude-init's generated skills are auto-triggered by an always-loaded rule file instructing the model to self-direct the pipeline, not by Claude Code's built-in skill-matching auto-invoke (which is what 2.1.215 changed for Anthropic's own bundled `/verify`/`/code-review`). Different mechanism, no template change needed — but worth re-checking if Anthropic publishes guidance discouraging rule-driven auto-triggering generally.
- **Rejected (same cycle):** anthropics/skills `fa0fa64b` (2026-07-17) added symlink/path-traversal rejection when extracting docx/pptx/xlsx archives — a good hardening pattern, but claude-init doesn't generate any skill that unpacks archives, so there's no template to apply it to. `obra/superpowers`, `trailofbits/claude-code-config`, `VoltAgent/awesome-agent-skills` had zero commits since 2026-07-13. `hesreallyhim/awesome-claude-code` only had new community resource-catalog entries, no methodology/format changes.

## Guardrails (summary — full text in .github/prompts/self-learn.md)

- One idea per cycle, ≤200 changed lines, citations required
- Commits land directly on main; `tests/run.sh` green is the hard gate
- Never touch installer logic, workflows, LICENSE, PRIVACY.md
- Rejected ideas live here forever; re-proposal requires a passed revisit date
