---
name: subagent-dev
description: "Execute implementation plans using fresh subagents per task with two-stage review. Auto-triggered for plans with multiple independent tasks. Also available as /subagent-dev."
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent
---

# Subagent-Driven Development

Execute a plan by dispatching a fresh subagent per task, with two-stage review (spec compliance → code quality) after each.

## When to Use

Automatically when:
- You have a plan with 3+ independent tasks
- Tasks are mostly independent (don't tightly depend on each other's output)

Fall back to sequential implementation when tasks are tightly coupled or the plan has fewer than 3 tasks.

## Why Fresh Subagents

- **No context pollution**: Each agent gets exactly the context it needs, not your entire conversation history
- **Better focus**: Agent sees only its task spec, relevant code, and project conventions
- **Preserved orchestrator context**: You keep your context for coordination instead of burning it on implementation details

## The Process

### 1. Setup

- Read the plan file and extract ALL tasks with their full text
- Note any cross-task dependencies or shared context
- Create a task list to track progress

### 2. Per Task

```
For each task:
  a. Dispatch IMPLEMENTATION subagent with:
     - Full task text (exact file paths, expected behavior, test requirements)
     - Project context (test commands, conventions, patterns)
     - Instruction: follow TDD (RED-GREEN-REFACTOR)

  b. If implementer asks questions → answer, re-dispatch
     If implementer reports BLOCKED → assess: context problem? too complex? plan wrong?

  c. Dispatch SPEC REVIEW subagent with:
     - The task spec
     - The git diff of changes made
     - Question: "Does this implementation match the spec? Missing anything? Added anything not requested?"

  d. If spec review fails → implementer fixes → spec review again

  e. Dispatch CODE QUALITY review subagent with:
     - The changed files
     - Question: "Bugs? Security? Convention violations? Test quality?"

  f. If quality review fails → implementer fixes → quality review again

  g. Mark task complete
```

### 3. Completion

After all tasks:
- Run the FULL test suite (not just individual tests)
- Verify all tests pass with fresh output
- Present results to user

## Model Selection

Use the least powerful model that handles each role:

| Role | Complexity Signal | Model |
|------|-------------------|-------|
| Implementation (1-2 files, clear spec) | Mechanical | Fast/cheap (haiku) |
| Implementation (multi-file, integration) | Judgment needed | Standard (sonnet) |
| Spec review | Comparison task | Fast/cheap (haiku) |
| Code quality review | Judgment needed | Standard (sonnet) |

## Handling Subagent Status

- **DONE**: Proceed to spec review
- **DONE_WITH_CONCERNS**: Read concerns. If about correctness, address before review. If observations, note and proceed.
- **NEEDS_CONTEXT**: Provide missing context, re-dispatch
- **BLOCKED**: Assess the blocker. More context? More capable model? Break task smaller? Plan wrong? Never force retry without changes.

## Rules

- **Never skip reviews** — both spec compliance AND code quality
- **Spec compliance before code quality** — wrong order wastes time reviewing code that doesn't meet spec
- **Never dispatch parallel implementation subagents** — they'll conflict on shared files
- **Don't make subagents read the full plan** — provide only the relevant task text
- **Fix issues before moving on** — reviewer found problems = implementer fixes = reviewer re-reviews
- **Never start on main/master** — create a feature branch first
