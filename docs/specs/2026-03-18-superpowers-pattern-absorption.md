# Spec: Absorb Superpowers Patterns into claude-init

## Problem
claude-init generates project-specific config but lacks process discipline patterns that superpowers (92.7k stars) has proven effective: rationalization prevention, spec persistence, structured branch completion, and skill discoverability.

## Solution
Targeted upgrades to 6 existing templates + 1 new template + 1 generator update. Inject superpowers' best patterns without duplicating its project-agnostic skills.

## Changes

### 1. Rationalization Prevention (plan, review, clarify, subagent-dev templates)
Add "Red Flags — STOP" table to each skill template. Each table must have 5+ domain-specific rationalizations in `| Thought | Reality |` format.

Required content per template:

**plan/SKILL.md:**
- "Too simple to plan" → Complex surprises hide in "simple" changes
- "I already know what to build" → You know what, not how. Plan catches the how.
- "Just a quick change" → Quick changes break things when unplanned
- "Planning is overhead" → Unplanned work takes 2-5x longer to debug
- "I'll plan as I go" → That's called no plan

**review/SKILL.md:**
- "Looks fine to me" → That's not a review. Check spec compliance line by line.
- "It's just a small change" → Small changes cause big bugs
- "I wrote it so I know it works" → Author blindness is real. Review anyway.
- "Tests pass so it's fine" → Tests verify behavior, not quality/security
- "No critical issues" without checking → You haven't checked. Read the diff.

**clarify/SKILL.md:**
- "Obvious what they want" → If it's obvious, the 3 questions take 30 seconds
- "Just build it and ask later" → Rebuilding costs 10x what clarifying costs
- "I'll figure it out as I go" → That's how you build the wrong thing
- "Too small to need a spec" → Small specs are fast to write. Skip = assumptions.
- "User seems impatient" → Shipping wrong code wastes more time than questions

**subagent-dev/SKILL.md:**
- "Close enough to spec" → Close enough = not done. Spec reviewer decides.
- "Skip review just this once" → The one you skip is the one that breaks prod
- "Force retry, same approach" → If it failed, something must change
- "I can review my own code" → Self-review supplements, never replaces, external review
- "This task is too small to review" → Small tasks have small reviews. Still do them.

### 2. Clarify → Brainstorm Pipeline (clarify template)

Upgrade the clarify flow with spec persistence and review:

**After writing the spec (current Step 4):**
1. Save spec to `docs/specs/YYYY-MM-DD-<topic>.md` (create directory if needed)
2. Dispatch spec reviewer subagent (haiku model) with the saved spec. Reviewer checks: completeness (all requirements covered?), testability (each criterion independently testable?), contradictions (requirements conflict?), scope creep (anything beyond the request?)
3. If reviewer finds issues: fix the spec, re-dispatch reviewer. Max 2 iterations — if still failing, present issues to user for guidance.
4. User gate: "Spec saved to `<path>`. Review it and let me know if you'd like changes before we proceed to planning."
5. Only proceed to `/plan` after user approves.

Only approved specs are saved. If the user abandons the request, delete the spec file.

### 3. Subagent-dev Completion (subagent-dev template)

Add to the "Completion" section:
- After all tasks pass and full test suite is green, trigger the `/finish` workflow to land the work
- Add to "Setup" section: "Read the plan file ONCE. Extract ALL tasks with their full text upfront. For each subagent dispatch, provide the full task text directly — never make the subagent read the plan file."
- Add Red Flags table (see Change 1)

### 4. New finish/ Template

```
---
name: finish
description: "Land completed work — verify tests, present options (merge/PR/keep/discard), execute chosen workflow. Auto-triggered after implementation and review pass. Also available as /finish."
allowed-tools: Read, Bash, Glob, Grep
---
```

**Process:**

1. **Verify** — Run full test suite. If ANY test fails, STOP. Fix before proceeding. No exceptions.

2. **Determine base branch** — Check `git log --oneline --graph` or ask user. Usually main/master.

3. **Present exactly 4 options:**
   1. Merge locally — merge into base branch, delete feature branch
   2. Push & create PR — push branch, create PR with summary + test plan
   3. Keep branch — preserve as-is for later work
   4. Discard — permanently delete branch and all changes

4. **Execute chosen option:**
   - **Merge:** checkout base → pull latest → merge feature → run tests again (merges can break) → delete feature branch
   - **PR:** push with `-u` → create PR via `gh pr create` with summary and test plan sections
   - **Keep:** do nothing, note branch name and location
   - **Discard:** require user to type "discard" to confirm → delete branch → delete worktree if applicable

5. **Clean up** — remove git worktree if applicable, summarize what was done

**Rules:**
- Never merge without passing tests
- Never delete work without typed "discard" confirmation
- Always present all 4 options — don't assume
- Re-run tests after merge (merge conflicts can break things)
- If on main/master (no feature branch), skip merge option — only PR/keep/discard

### 5. Workflow.md Upgrade (workflow rule template)

**Add Step 6: Finish** after Step 5 (Self-Review):

```
### 6. Finish (when work is complete)
After implementation passes review and verification, land the work:
- Run full test suite one final time
- Present options: merge locally, push & create PR, keep branch, or discard
- Execute the chosen option with safety checks
```

**Add skill discoverability section** at the end:

```
## Available Skills
These skills trigger automatically per the pipeline above, but can also be invoked manually:
- /clarify — Turn vague requests into testable specs
- /plan — Create implementation plans with bite-sized tasks
- /tdd — Test-driven development (RED-GREEN-REFACTOR)
- /review — Two-stage code review (spec compliance → quality)
- /verify — Verification before completion claims
- /subagent-dev — Fresh subagent per task with two-stage review
- /finish — Land completed work (merge/PR/keep/discard)
```

**Update scaling table** — add finish column:

| Task Type | Steps |
|-----------|-------|
| Typo, config tweak | Implement → verify |
| Bug fix | Understand → RED → GREEN → verify |
| Small feature | Plan briefly → TDD → verify → self-review → finish |
| New feature (multi-file) | Understand → plan → TDD → verify → self-review → finish |
| Architecture change | Clarify → design doc → plan → TDD → verify → self-review → finish |

### 6. Generator Update (SKILL.md)
Add `finish/` as the 7th "always generate" skill, after subagent-dev. It is always generated for all projects (like plan, review, verify) — not conditional.

## Acceptance Criteria
- [ ] plan/SKILL.md has Red Flags table with 5+ rationalizations in `| Thought | Reality |` format
- [ ] review/SKILL.md has Red Flags table with 5+ rationalizations in `| Thought | Reality |` format
- [ ] clarify/SKILL.md saves spec to `docs/specs/YYYY-MM-DD-<topic>.md`, dispatches spec reviewer subagent (haiku), loops max 2x, has user gate, has Red Flags table
- [ ] subagent-dev/SKILL.md triggers /finish after completion, has "read plan once, extract all tasks, provide full text" in Setup, has Red Flags table
- [ ] finish/SKILL.md exists with: test verification gate, 4 named options (merge/PR/keep/discard), typed confirmation for discard, re-test after merge, ~50 lines
- [ ] workflow.md has Step 6 Finish, skill discoverability section listing all 7 skills, updated scaling table with finish column
- [ ] SKILL.md (generator) includes finish/ as 7th always-generate skill after subagent-dev
- [ ] test/SKILL.md unchanged (already has "Rationalizations That Mean Start Over" table, lines 96-106)
- [ ] verify/SKILL.md unchanged (already has "Red Flags — STOP" section, lines 45-54)
- [ ] No template exceeds 150 lines
- [ ] All changes are additive to existing content (no rewrites)

## Assumptions
- Users may or may not have superpowers installed — these changes work standalone
- Spec docs go in project's `docs/specs/` directory (created if needed)
- finish/ is always generated (not conditional)
- Spec reviewer subagent uses haiku model for speed/cost

## Out of Scope
- Systematic debugging skill (project-agnostic, belongs in superpowers)
- Git worktrees skill (project-agnostic)
- Writing-skills meta-skill (for skill authors, not project config)
- Plugin distribution model (deferred to later)
- Detect-and-adapt for superpowers coexistence (deferred)
