---
name: doctor
description: "Validate your .claude/ configuration. Checks that commands work, paths exist, hooks are valid, and agents are well-formed. Use after /claude-init or /update to catch issues."
allowed-tools: Read, Bash, Glob, Grep
---

# Doctor: Validate Your Config

Run diagnostics on the `.claude/` configuration and report issues.

## Checks

### 1. CLAUDE.md Health
- [ ] Exists at repo root
- [ ] Under 80 lines (warn if over, error if over 200)
- [ ] All `@import` paths resolve to existing files
- [ ] Commands section: verify each command actually runs (e.g., `npm test --help`, `cargo test -- --help`)
- [ ] No placeholder text left from templates (e.g., `<your-framework-here>`)
- [ ] No content that merely restates what Claude could derive by reading the codebase (full dependency/version lists duplicating package.json, directory trees `ls` would show, verbatim README paragraphs) — flag for trimming, matching Claude Code's own `/doctor` CLAUDE.md-trimming check (changelog 2.1.206)

### 2. Agents
For each `.claude/agents/*.md`:
- [ ] Valid YAML frontmatter (name, description present)
- [ ] Model is valid (`opus`, `sonnet`, `haiku`, `fable`, `inherit`, or a full model ID)
- [ ] Referenced tools exist
- [ ] `background` is a boolean and `memory` is one of `user`/`project`/`local` if present
- [ ] No empty markdown body

### 3. Skills
For each `.claude/skills/*/SKILL.md`:
- [ ] Valid YAML frontmatter
- [ ] `name` matches the skill's directory name and is lowercase-kebab-case
- [ ] Description is specific enough (not just "does stuff")
- [ ] Description is third-person and contains a when-to-use trigger (`Use when…`, `Use before…`, or `Auto-triggered…`) — descriptions with no trigger won't reliably fire
- [ ] Description is ≤1024 characters
- [ ] Description does NOT summarize the workflow steps — a process summary in the description makes Claude follow the summary instead of reading the skill
- [ ] Skill body has `Red Flags` / rationalization-rebuttal content and a verification step (the generated skills should all carry these)
- [ ] SKILL.md body is under 500 lines (warn over ~150 — push long examples/scripts into sibling reference files)
- [ ] If `context: fork`, verify no Task/Skill tool references in body (forked skills can't spawn subagents)
- [ ] If `paths:` frontmatter exists, verify globs match at least one file (dead scopes = skill never loads)
- [ ] `allowed-tools` uses real tool names (Read, Edit, Write, Bash, Grep, Glob, Agent — not Tool, File, etc.)
- [ ] Any `` !`cmd` `` or ```` ```! ```` shell-preprocessing blocks run read-only commands only (never `rm`, `curl http://...`, writes, or long-running ops)
- [ ] Referenced scripts in `scripts/` directory exist and are executable

### 4. Rules
For each `.claude/rules/*.md`:
- [ ] If `paths:` frontmatter exists, verify those glob patterns match at least one file
- [ ] No duplicate rules across files
- [ ] Content is actionable (not just "write good code")
- [ ] No dangling symlinks under `.claude/rules/` — `find .claude/rules -xtype l` should return nothing (shared rule libraries are linked in via symlink; a broken link silently drops those rules from context)

### 5. Hooks
Read `.claude/settings.json`:
- [ ] Valid JSON (strict — `"//"` comment keys are OK, but trailing commas and JS comments break Claude Code's parser)
- [ ] Hook event names are real — current set (per https://code.claude.com/docs/en/hooks): SessionStart, SessionEnd, Setup, UserPromptSubmit, UserPromptExpansion, PreToolUse, PermissionRequest, PermissionDenied, PostToolUse, PostToolUseFailure, PostToolBatch, Notification, MessageDisplay, SubagentStart, SubagentStop, TaskCreated, TaskCompleted, Stop, StopFailure, TeammateIdle, InstructionsLoaded, ConfigChange, CwdChanged, FileChanged, WorktreeCreate, WorktreeRemove, PreCompact, PostCompact, Elicitation, ElicitationResult — a typo like `preToolUse` or `OnEdit` silently never fires
- [ ] Hook handler `type` is present and one of `command`, `http`, `mcp_tool`, `prompt`, `agent` (required field — no default)
- [ ] Hook commands are executable (if `type: command`)
- [ ] No overly broad matchers that would slow every tool call
- [ ] Deny patterns don't block normal development workflows
- [ ] `PreToolUse` hooks use the current decision schema (`hookSpecificOutput.permissionDecision`), NOT the legacy `{"decision": "allow"|"block"}` form, which `PreToolUse` ignores
- [ ] Regex matchers are anchored with word boundaries where needed (e.g., `git\s+push\s+(-f\b|--force\b)` not `git push.*-f` — the lazy form matches `git push-to-origin --forward`)
- [ ] MCP matchers (if present) use regex form with `.*` (e.g., `mcp__memory__.*`, not `mcp__memory`)
- [ ] PostToolUse formatters use `|| true` or `exit 0` so a missing tool doesn't block writes
- [ ] Hook self-protection exists: `.claude/settings.json`, `.claude/hooks/**`, `.claude/agents/**`, `.claude/skills/**/SKILL.md` should be blocked from Edit/Write

### 5b. Output Styles (if present)
For each `.claude/output-styles/*.md`:
- [ ] Valid YAML frontmatter with `name` and `description`
- [ ] `keep-coding-instructions` is a boolean (not a string) if present
- [ ] The file is referenced by `outputStyle` in `.claude/settings.json` OR documented in CLAUDE.md so users know it exists

### 6. ARCHITECTURE.md
- [ ] Exists at repo root (warn if missing — `/claude-init` should have generated it)
- [ ] Under 120 lines (warn if over)
- [ ] No placeholder text from templates (e.g., `<What this system does>`, `<ASCII diagram>`)
- [ ] Directory Structure section matches actual top-level directories (compare against `ls`)
- [ ] Entry Points section references files that actually exist
- [ ] CLAUDE.md references it (should contain "ARCHITECTURE.md" somewhere)

### 7. Git Integration
- [ ] `.claude/settings.local.json` is in `.gitignore`
- [ ] `.claude/agent-memory-local/` is in `.gitignore`
- [ ] `.claude/checkpoints/` is in `.gitignore` (PreCompact hook writes here)
- [ ] `.claude/settings.local.json.example` IS committed (it's the onboarding artifact)
- [ ] No secrets in any `.claude/` files (grep for API keys, tokens, passwords)

## Output

```
## Doctor Report

Passed: N checks
Warnings: N
Errors: N

### Errors (must fix)
- [file] Description

### Warnings (should fix)
- [file] Description

### All Clear
- [file] OK
```

## Rules
- Run every check, don't skip on first failure
- Be specific about how to fix each issue
- Don't modify any files — only report
