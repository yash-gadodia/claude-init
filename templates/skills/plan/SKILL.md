---
name: plan
description: "Create an implementation plan for a feature or change. Includes devil's advocate review. Use before starting any non-trivial work."
argument-hint: "[feature description]"
allowed-tools: Read, Grep, Glob, Agent
---

# Plan: Design Before You Build

Turn a feature request into a vetted implementation plan.

## Input
`$ARGUMENTS` — a description of what to build or change.

## Process

### Phase 1: Clarify
- Read CLAUDE.md for project context
- If the request is vague, ask up to 3 clarifying questions (no more)
- Make reasonable assumptions and state them explicitly

### Phase 2: Explore
Understand what exists:
- Find related code (Grep for keywords)
- Read the files that will need to change
- Identify patterns to follow

### Phase 3: Design
Write a plan:
```
## Plan: [Feature Name]

### Problem
<What we're solving, in 1-2 sentences>

### Approach
<How we solve it, step by step>

### Files to Change
- `path/to/file.ts` — what changes and why
- `path/to/test.ts` — new tests needed

### Data Model Changes
<If any schema/migration changes are needed>

### API Changes
<If any endpoints change or are added>

### Risks
<What could go wrong>

### Out of Scope
<What this plan explicitly does NOT include>
```

### Phase 4: Devil's Advocate
Challenge your own plan:
- What's the simplest version of this? Can we ship less?
- What happens if an assumption is wrong?
- Is there an existing pattern we should use instead of introducing a new one?
- What will be hardest to change later if we get it wrong?

Update the plan based on this challenge.

### Phase 5: Present
Show the plan to the user. Wait for approval before any implementation.

## Rules
- Plans should be under 50 lines. If it's longer, the scope is too big — split it.
- Every file change must have a "why"
- Never plan work that doesn't trace back to the original request
