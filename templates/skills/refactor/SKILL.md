---
name: refactor
description: "Safely refactor code: identify the smell, plan the transformation, apply it with tests green before and after. Use when code needs restructuring without behavior change."
argument-hint: "[file or area to refactor]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Refactor: Change Structure, Preserve Behavior

Restructure code without changing what it does.

## Input
`$ARGUMENTS` — a file, function, or area to refactor (or a description like "the auth middleware is too complex").

## Process

### 1. Baseline
Before touching anything:
- Run the test suite. Record the result. ALL TESTS MUST PASS.
- If tests don't pass, stop. Fix them first (use `/fix`).
- Read the code to refactor and understand its current behavior completely.

### 2. Identify the Smell
Name the specific problem:
- **Too long**: Function/file exceeds 100 lines
- **Too complex**: Deeply nested conditionals, cyclomatic complexity > 8
- **Duplication**: Same logic in multiple places
- **Wrong abstraction**: Premature or leaky abstraction
- **Naming**: Names don't reflect what things do
- **Coupling**: Components know too much about each other's internals

### 3. Plan the Transformation
Choose ONE transformation per refactor:
- Extract function/method
- Inline overly-abstracted code
- Rename for clarity
- Split file into focused modules
- Replace conditional with polymorphism
- Simplify nested logic (guard clauses, early returns)

Describe the plan before executing: what moves where and why.

### 4. Apply
Make the changes:
- Small, incremental steps — not one massive rewrite
- Each step should be independently valid
- Don't change behavior (no "while I'm here" fixes)
- Don't change the public API unless that's the explicit goal

### 5. Verify
After every change:
- Run the test suite. ALL TESTS MUST STILL PASS.
- If a test breaks, your refactor changed behavior — undo and try again.
- Run the linter.

### 6. Compare
Show before/after:
- Line count change
- Complexity change (if measurable)
- What's easier to understand/modify now

## Rules
- Tests green before AND after. Non-negotiable.
- One smell per refactor. Don't fix everything at once.
- If you need to change tests, the refactor is probably changing behavior — reconsider.
- Don't add new features during a refactor.
- If the code has no tests, write tests FIRST, then refactor.
