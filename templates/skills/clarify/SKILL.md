---
name: clarify
description: "Turn vague requests into structured, testable specs through collaborative design. Auto-triggered when requirements are ambiguous. Explores intent, constraints, and alternatives before implementation. Also available as /clarify."
allowed-tools: Read, Grep, Glob, Write
---

# Clarify: Idea → Design → Spec

Transform vague requirements into implementation-ready specifications through structured dialogue.

## When This Triggers

Automatically when:
- The request is ambiguous or has multiple valid interpretations
- The request spans multiple subsystems or involves architecture decisions
- You'd have to guess at important details to start implementing

Skip when: the request is clear and specific enough to plan directly.

## Process

### 1. Explore Context

Before asking a single question, check the codebase:
- Read ARCHITECTURE.md for system context
- Find related code — are there existing patterns for this type of feature?
- Check recent commits — is there related work in progress?

Don't ask things you can answer by reading.

### 2. Clarify Intent (max 3 questions)

Ask questions **one at a time**. Prefer multiple choice.

Good: "Should this work for unauthenticated users too, or only logged-in? (a) logged-in only (b) both (c) only unauthenticated"
Bad: "What tech stack should we use?" (you can see the codebase)
Bad: Asking 5 questions at once

Focus on: purpose, constraints, success criteria. Not implementation details — that comes in planning.

### 3. Propose Approaches

For non-trivial work, propose 2-3 approaches:
- Lead with your recommendation and why
- Show trade-offs (complexity, time, risk, flexibility)
- YAGNI ruthlessly — remove unnecessary features from all options

### 4. Write the Spec

```markdown
# Spec: [Feature Name]

## Problem
<1-2 sentences: what pain point this solves>

## Solution
<The chosen approach, 2-3 sentences>

## Acceptance Criteria
- [ ] Given [context], when [action], then [result]
- [ ] Edge case: [scenario] → [expected behavior]
- [ ] Error case: [failure mode] → [expected handling]

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

Show the spec. **Don't start implementation until approved.**

If the scope covers multiple independent subsystems, suggest breaking into separate specs — one per subsystem, each with its own plan → implement cycle.

## Rules

- No vague language. "Fast" → "p99 < 200ms". "Secure" → "requires auth + input validation".
- Every acceptance criterion must be independently testable
- If the request is already clear, skip to the spec. Don't over-process.
- Keep specs under 40 lines
- One question per message — don't overwhelm
