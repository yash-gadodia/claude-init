---
name: onboard
description: "Quick onboarding to an existing codebase. Generates a mental model of the architecture, key patterns, and how things connect. Use when joining a new repo or when a teammate needs to get up to speed fast."
argument-hint: "[focus-area]"
allowed-tools: Read, Bash, Glob, Grep, Agent
---

# Onboard: Get Up to Speed Fast

You are onboarding to this codebase. Your goal is to build a complete mental model and share it concisely.

If `$ARGUMENTS` is provided, focus on that area (e.g., "auth", "payments", "API layer").

## Process

### Phase 1: Structural Scan (use subagents in parallel)

**Agent 1 — Architecture:**
- Read CLAUDE.md, ARCHITECTURE.md, README, any docs/ directory
- Map the directory tree (top 3 levels)
- Identify framework, language, key dependencies

**Agent 2 — Data Layer:**
- Find schema files (Prisma, migrations, models)
- Map entities and relationships
- Identify the ORM/query layer

**Agent 3 — API Surface:**
- Find route definitions, controllers, resolvers
- Map endpoints/operations to handlers
- Identify auth middleware, validation

**Agent 4 — Frontend (if applicable):**
- Map pages/routes to components
- Identify state management
- Find shared UI components

### Phase 1.5: ARCHITECTURE.md Freshness Check

If `ARCHITECTURE.md` exists:
- Compare its Directory Structure section against the actual top-level directories
- Check if modules/services mentioned still exist
- Check if new top-level directories have appeared that aren't documented
- If stale sections are found, flag them in the output and offer to update ARCHITECTURE.md

If `ARCHITECTURE.md` does NOT exist:
- Note this as a gap in the output
- Suggest running `/claude-init` or `/update` to generate one

### Phase 2: Pattern Extraction

From the codebase, identify:
1. **The happy path**: How does a typical request flow from user action to database and back?
2. **Error handling pattern**: How are errors caught, logged, and surfaced?
3. **Auth pattern**: How is authentication/authorization enforced?
4. **Testing pattern**: What's tested, what's not, how to run tests?
5. **Deploy pattern**: How does code get to production?

### Phase 3: Output

Present a concise onboarding doc:

```
# [Project Name] — Onboarding

## What This Does
<1-2 sentences>

## Stack
<language, framework, DB, key deps>

## Architecture
<ASCII diagram or bullet-point flow>

## Key Patterns
<The 3-5 most important patterns to follow>

## Where Things Live
<Map of important directories/files>

## How to Run
<Dev server, tests, build, deploy commands>

## Gotchas
<Non-obvious things that will trip you up>
```

Keep the output under 100 lines. Density over verbosity.
