---
description: "Automatic development workflow — Claude follows this process for every task without manual skill invocation. Covers the full lifecycle: clarify → plan → implement (TDD) → verify → review."
---

# Development Workflow

Follow this process automatically for every development task. You do not need the user to type `/plan`, `/test`, or `/review` — do it as part of your natural workflow.

**If there is even a 1% chance a step applies, do it.** The cost of doing an unnecessary step is minutes. The cost of skipping a necessary one is hours of debugging, broken code, or lost trust.

## The Pipeline

Every task flows through this pipeline. Scale depth to task size — but never skip verification.

### 1. Understand

Read the request. If requirements are ambiguous or incomplete, ask up to 3 clarifying questions (one at a time, prefer multiple choice). Make reasonable assumptions for everything else and state them explicitly.

For non-trivial work: explore the codebase first (ARCHITECTURE.md, related code, existing patterns) before asking questions. Don't ask things you can answer by reading.

### 2. Plan (medium+ tasks)

Before writing any code on non-trivial changes:

- Read ARCHITECTURE.md for structural context
- Identify which files will change and why
- Break work into bite-sized tasks (each completable in 2-5 minutes)
- Each task must specify: exact file paths, what changes, how to verify
- Challenge your own plan: what's the simplest version? What if an assumption is wrong? What's hardest to change later?
- Present the plan and wait for approval before implementing

For large tasks (architecture changes, new systems): write a design doc first, propose 2-3 approaches with trade-offs and your recommendation, get approval, THEN plan.

### 3. Implement (with TDD)

Follow RED-GREEN-REFACTOR for every change:

1. **RED**: Write one failing test that describes the desired behavior
2. **Verify RED**: Run the test. Confirm it fails for the right reason (feature missing, not typo)
3. **GREEN**: Write the minimal code to make the test pass
4. **Verify GREEN**: Run the test. Confirm it passes. Confirm all other tests still pass.
5. **REFACTOR**: Clean up. Keep tests green. Don't add behavior.
6. **Repeat** for the next behavior

**The iron law: no production code without a failing test first.**

Wrote code before the test? Delete it. Write the test first. Implement fresh from the test. No exceptions.

Skip TDD only for: configuration files, generated code, or when the user explicitly says to.

### 4. Verify

**No completion claims without fresh verification evidence.**

Before saying "done", "fixed", "passing", or ANY positive claim:
1. Run the actual verification command (test suite, build, linter)
2. Read the full output
3. Confirm the output supports your claim
4. Only then make the claim, citing the evidence

"Should work now" is not verification. "All 47 tests pass (output above)" is.

### 5. Self-Review

After implementation, review your own changes:
- **Spec compliance**: Does every requirement from the plan/request have corresponding code AND tests?
- **Code quality**: Bugs? Security issues? Convention violations? Missing edge cases?
- Fix any issues found before presenting the result.

## Scaling the Process

Not every change needs every step. Match depth to complexity:

| Task Type | Steps |
|-----------|-------|
| Typo, config tweak | Implement → verify |
| Bug fix | Understand → RED (reproduce as test) → GREEN (fix) → verify |
| Small feature | Plan briefly → TDD → verify → self-review |
| New feature (multi-file) | Understand → plan (with approval) → TDD → verify → self-review |
| Architecture change | Clarify → design doc → plan (with approval) → TDD → verify → self-review |

**But NEVER skip verification.** Even for a typo, run the tests.

## Subagent-Driven Development (large tasks)

For plans with multiple independent tasks, dispatch fresh subagents:

1. Extract all tasks from the plan
2. For each task: dispatch an implementation subagent with the full task spec + project context
3. After each task: dispatch a review subagent to verify spec compliance
4. After spec compliance: dispatch a quality review subagent
5. Fix any issues before moving to the next task
6. After all tasks: run the full test suite, present results

**Why fresh subagents:** No context pollution between tasks. Each agent gets exactly the context it needs. The orchestrator preserves its own context for coordination.

## Principles

- **Don't ask permission to be thorough.** If a feature needs tests, write them. If the plan has a flaw, fix it.
- **Evidence before claims.** Run the command. Read the output. Then claim the result.
- **Proportional rigor.** A typo doesn't need a design doc. An architecture change does.
- **Show, don't tell.** Instead of saying "you should add tests", write the tests.
- **Fail fast.** If something doesn't work, say so immediately. Don't silently skip steps.
- **Delete and redo over patching.** If you wrote code before the test, delete it. Start over with TDD.
