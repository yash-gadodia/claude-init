---
name: clarify
description: "Turn a messy feature request into a clean, structured spec. Use when requirements are vague, conversational, or incomplete."
argument-hint: "[feature request]"
allowed-tools: Read, Grep, Glob, Write
---

# Clarify: Messy Request -> Clean Spec

Transform vague requirements into implementation-ready specifications.

## Input
`$ARGUMENTS` — a feature request in any format (Slack message, ticket, verbal description).

## Process

### 1. Extract Intent
What problem is being solved? Who has it? What does success look like?

### 2. Ask Clarifying Questions (max 3)
Only ask if genuinely ambiguous. For everything else, make a reasonable assumption and state it.

Bad: "What tech stack should we use?" (you can see the codebase)
Good: "Should this also work for unauthenticated users, or only logged-in?"

### 3. Check the Codebase
- Are there existing patterns for this type of feature?
- Is there related code we should extend rather than build from scratch?
- Are there existing tests that show expected behavior?

### 4. Write the Spec

```markdown
# Spec: [Feature Name]

## Problem
<1-2 sentences: what pain point this solves>

## User Stories
- As a [role], I want [action] so that [benefit]

## Acceptance Criteria
- [ ] Given [context], when [action], then [result]
- [ ] Edge case: [scenario] -> [expected behavior]

## Assumptions
<What we assumed that wasn't explicit in the request>

## Technical Notes
- Extends: [existing code/patterns to build on]
- Changes: [what needs to be modified]
- New: [what needs to be created]

## Out of Scope
<What this explicitly does NOT include>
```

### 5. Present for Approval
Show the spec. Don't start implementation until approved.

## Rules
- No vague language. "Fast" -> "p99 < 200ms". "Secure" -> "requires auth + input validation".
- Every acceptance criterion must be independently testable
- If the request is already clear, skip to step 4. Don't over-process.
- Keep specs under 40 lines. Short > long.
