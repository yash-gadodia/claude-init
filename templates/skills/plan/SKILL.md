---
name: plan
description: "Create a detailed implementation plan with bite-sized tasks. Auto-triggered for non-trivial work. Includes design exploration, devil's advocate challenge, and subagent review. Also available as /plan."
allowed-tools: Read, Grep, Glob, Agent
---

# Plan: Design Before You Build

Turn a feature request into a vetted, executable implementation plan.

## When This Triggers

Automatically for any non-trivial change (multi-file, new feature, architecture change). Skip for trivial fixes (typos, config tweaks, one-liner bug fixes).

## Process

### Phase 1: Understand

- Read CLAUDE.md and ARCHITECTURE.md for project context
- Explore related code (Grep for keywords, read files that will change)
- Identify existing patterns to follow
- If the request is vague, ask up to 3 clarifying questions (one at a time, prefer multiple choice)
- Make reasonable assumptions and state them explicitly

### Phase 2: Explore Approaches

For medium+ tasks, propose 2-3 approaches:
- Lead with your recommendation and why
- Show trade-offs for each
- Consider: simplest version? Existing patterns to reuse? What's hardest to change later?

### Phase 3: Design

Write the plan with bite-sized tasks. Each task should take 2-5 minutes.

```markdown
## Plan: [Feature Name]

### Problem
<What we're solving, 1-2 sentences>

### Approach
<How we solve it, chosen from Phase 2>

### File Structure
<Which files will be created or modified, what each is responsible for>

### Tasks

#### Task 1: [Component Name]
**Files:**
- Create: `exact/path/to/file.ts`
- Modify: `exact/path/to/existing.ts`
- Test: `exact/path/to/test.ts`

- [ ] Write failing test for [behavior]
- [ ] Verify test fails
- [ ] Implement [specific change]
- [ ] Verify test passes + full suite green
- [ ] Commit

#### Task 2: [Next Component]
...

### Risks
<What could go wrong, ordered by impact>

### Out of Scope
<What this explicitly does NOT include>
```

### Phase 4: Devil's Advocate

Challenge your own plan before presenting it:
- What's the simplest version of this? Can we ship less?
- What happens if an assumption is wrong?
- Is there an existing pattern we should use instead of a new one?
- What will be hardest to change later if we get it wrong?
- What happens under 10x load? What if an external service is down?
- What are the race conditions?

Update the plan based on this challenge.

### Phase 5: Present and Get Approval

Show the plan to the user. **Wait for approval before ANY implementation.**

## Task Granularity Rules

- Each task should be completable in 2-5 minutes
- Every task specifies exact file paths (not "update the relevant files")
- Every task follows TDD: write test → verify fail → implement → verify pass → commit
- Tasks should be independently verifiable — each one leaves the codebase in a working state
- If a task is too big to hold in your head, split it

## Red Flags — STOP

These thoughts mean you're about to skip the process:

| Thought | Reality |
|---------|---------|
| "Too simple to plan" | Complex surprises hide in "simple" changes. Plan takes 2 minutes. |
| "I already know what to build" | You know what, not how. Planning catches the how. |
| "Just a quick change" | Quick changes break things when unplanned. |
| "Planning is overhead" | Unplanned work takes 2-5x longer to debug. |
| "I'll plan as I go" | That's called no plan. |

If you catch yourself thinking any of these: stop, follow the process.

## Plan Quality Rules

- Plans should be under 50 lines. If longer, the scope is too big — split it.
- Every file change must have a "why"
- Never plan work that doesn't trace back to the original request
- Don't plan features the user didn't ask for (YAGNI)
- Include exact commands for verification (test commands, build commands)
