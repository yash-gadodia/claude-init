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

### 2. Agents
For each `.claude/agents/*.md`:
- [ ] Valid YAML frontmatter (name, description present)
- [ ] Model is valid (opus, sonnet, haiku, or a full model ID)
- [ ] Referenced tools exist
- [ ] No empty markdown body

### 3. Skills
For each `.claude/skills/*/SKILL.md`:
- [ ] Valid YAML frontmatter
- [ ] Description is specific enough (not just "does stuff")
- [ ] If `context: fork`, verify no Task/Skill tool references in body (forked skills can't spawn subagents)
- [ ] Referenced scripts in `scripts/` directory exist and are executable

### 4. Rules
For each `.claude/rules/*.md`:
- [ ] If `paths:` frontmatter exists, verify those glob patterns match at least one file
- [ ] No duplicate rules across files
- [ ] Content is actionable (not just "write good code")

### 5. Hooks
Read `.claude/settings.json`:
- [ ] Valid JSON
- [ ] Hook commands are executable (if `type: command`)
- [ ] No overly broad matchers that would slow every tool call
- [ ] Deny patterns don't block normal development workflows

### 6. Git Integration
- [ ] `.claude/settings.local.json` is in `.gitignore`
- [ ] `.claude/agent-memory-local/` is in `.gitignore`
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
