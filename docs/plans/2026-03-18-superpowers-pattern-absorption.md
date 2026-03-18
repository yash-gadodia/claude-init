# Superpowers Pattern Absorption Implementation Plan

> **For agentic workers:** Use subagent-driven-development to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Absorb superpowers' best process discipline patterns into claude-init's generated templates.

**Architecture:** Targeted additions to 5 existing markdown templates + 1 new template + 1 generator update. All changes are additive — no existing content is rewritten.

**Tech Stack:** Markdown templates (no build/test system — verification is manual review)

---

## File Structure

- Modify: `templates/skills/plan/SKILL.md` — add Red Flags table
- Modify: `templates/skills/review/SKILL.md` — add Red Flags table
- Modify: `templates/skills/clarify/SKILL.md` — add spec persistence + review loop + user gate + Red Flags table
- Modify: `templates/skills/subagent-dev/SKILL.md` — add finish trigger + read-plan-once + Red Flags table
- Create: `templates/skills/finish/SKILL.md` — new finish workflow template
- Modify: `templates/rules/workflow.md` — add Step 6 Finish + skill discoverability + updated scaling table
- Modify: `.claude/skills/claude-init/SKILL.md` — add finish/ to always-generate list (line ~284)

---

### Task 1: Add Red Flags table to plan/SKILL.md

**Files:**
- Modify: `templates/skills/plan/SKILL.md`

- [ ] **Step 1:** Read the current file (103 lines)
- [ ] **Step 2:** Append the following Red Flags section before the final "Plan Quality Rules" section (before line 97):

```markdown
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
```

- [ ] **Step 3:** Verify file stays under 150 lines
- [ ] **Step 4:** Commit: `feat: add rationalization prevention to plan template`

---

### Task 2: Add Red Flags table to review/SKILL.md

**Files:**
- Modify: `templates/skills/review/SKILL.md`

- [ ] **Step 1:** Read the current file (88 lines)
- [ ] **Step 2:** Append the following Red Flags section at the end, after the existing Rules section:

```markdown
## Red Flags — STOP

These thoughts mean you're about to rubber-stamp:

| Thought | Reality |
|---------|---------|
| "Looks fine to me" | That's not a review. Check spec compliance line by line. |
| "It's just a small change" | Small changes cause big bugs. Review anyway. |
| "I wrote it so I know it works" | Author blindness is real. Review your own code like a stranger's. |
| "Tests pass so it's fine" | Tests verify behavior, not quality or security. |
| "No critical issues" without reading diff | You haven't checked. Read the diff first. |

If you catch yourself thinking any of these: stop, read the diff, follow both stages.
```

- [ ] **Step 3:** Verify file stays under 150 lines
- [ ] **Step 4:** Commit: `feat: add rationalization prevention to review template`

---

### Task 3: Upgrade clarify/SKILL.md with spec persistence + review loop + Red Flags

**Files:**
- Modify: `templates/skills/clarify/SKILL.md`

- [ ] **Step 1:** Read the current file (89 lines)
- [ ] **Step 2:** Replace the current "### 4. Write the Spec" and "### 5. Present for Approval" sections with an upgraded version that adds spec persistence, review loop, and user gate:

The upgraded Step 4 should:
- Keep the existing spec template format
- After writing the spec, save it to `docs/specs/YYYY-MM-DD-<topic>.md`
- Dispatch a spec reviewer subagent (haiku model) to check: completeness, testability, contradictions, scope creep
- Max 2 review iterations — if still failing, surface to user
- Only approved specs are saved; delete spec file if user abandons

The upgraded Step 5 should:
- Present user gate: "Spec saved to `<path>`. Review it before we proceed to planning."
- Wait for user approval before proceeding to `/plan`

- [ ] **Step 3:** Add Red Flags section at the end:

```markdown
## Red Flags — STOP

These thoughts mean you're about to skip clarification:

| Thought | Reality |
|---------|---------|
| "Obvious what they want" | If it's obvious, 3 questions take 30 seconds. Ask anyway. |
| "Just build it and ask later" | Rebuilding costs 10x what clarifying costs. |
| "I'll figure it out as I go" | That's how you build the wrong thing. |
| "Too small to need a spec" | Small specs are fast to write. Skipping = hidden assumptions. |
| "User seems impatient" | Shipping wrong code wastes more time than questions. |

If you catch yourself thinking any of these: stop, ask the question.
```

- [ ] **Step 4:** Verify file stays under 150 lines
- [ ] **Step 5:** Commit: `feat: upgrade clarify template with spec persistence and review loop`

---

### Task 4: Upgrade subagent-dev/SKILL.md with finish trigger + read-plan-once + Red Flags

**Files:**
- Modify: `templates/skills/subagent-dev/SKILL.md`

- [ ] **Step 1:** Read the current file (94 lines)
- [ ] **Step 2:** In the "Setup" section (### 1. Setup), add emphasis on reading the plan once and extracting all tasks upfront:

Add after "Read the plan file and extract ALL tasks with their full text":
```markdown
**Read the plan file ONCE.** Extract every task with its full text, file paths, and context upfront. When dispatching each subagent, provide the full task text directly — never make the subagent read the plan file itself.
```

- [ ] **Step 3:** In the "Completion" section (### 3. Completion), add finish trigger:

Replace "Present results to user" with:
```markdown
- Present results to user
- Trigger the `/finish` workflow to land the work (merge, PR, keep, or discard)
```

- [ ] **Step 4:** Add Red Flags section at the end:

```markdown
## Red Flags — STOP

These thoughts mean you're about to cut corners:

| Thought | Reality |
|---------|---------|
| "Close enough to spec" | Close enough = not done. Spec reviewer decides, not you. |
| "Skip review just this once" | The one you skip is the one that breaks prod. |
| "Force retry, same approach" | If it failed, something must change. More context? Better model? Smaller task? |
| "I can review my own code" | Self-review supplements, never replaces, external review. |
| "This task is too small to review" | Small tasks have small reviews. Still do them. |

If you catch yourself thinking any of these: stop, follow the two-stage review.
```

- [ ] **Step 5:** Verify file stays under 150 lines
- [ ] **Step 6:** Commit: `feat: upgrade subagent-dev template with finish trigger and rationalization prevention`

---

### Task 5: Create finish/SKILL.md template

**Files:**
- Create: `templates/skills/finish/SKILL.md`

- [ ] **Step 1:** Create the new file with the complete finish workflow:

```markdown
---
name: finish
description: "Land completed work — verify tests, present options (merge/PR/keep/discard), execute chosen workflow. Auto-triggered after implementation and review pass. Also available as /finish."
allowed-tools: Read, Bash, Glob, Grep
---

# Finish: Land Your Work

Verify, present options, execute, clean up.

## When This Triggers

Automatically after all implementation tasks pass review and verification.

## Process

### 1. Verify

Run the FULL test suite. If ANY test fails, STOP. Fix before proceeding.

### 2. Determine Base Branch

Check what branch you split from (`git log --oneline --graph -10`). Usually main or master. Ask if unclear.

### 3. Present Options

Show exactly these four choices:

1. **Merge locally** — merge feature branch into base, delete feature branch
2. **Push & create PR** — push branch, create PR with summary + test plan
3. **Keep branch** — preserve as-is for later
4. **Discard** — permanently delete branch and all changes

### 4. Execute

**Merge locally:**
1. `git checkout <base>` and `git pull`
2. `git merge <feature-branch>`
3. Run tests again — merges can introduce conflicts that break things
4. `git branch -d <feature-branch>`

**Push & create PR:**
1. `git push -u origin <feature-branch>`
2. Create PR via `gh pr create` with summary and test plan sections

**Keep branch:**
- Do nothing. Note branch name for the user.

**Discard:**
- Ask user to type "discard" to confirm
- `git checkout <base>`
- `git branch -D <feature-branch>`
- Remove worktree if applicable

### 5. Clean Up

- Remove git worktree if applicable
- Summarize what was done

## Rules

- NEVER merge without passing tests
- NEVER delete work without typed "discard" confirmation
- Always present all 4 options — don't assume which one the user wants
- Re-run tests after merge (merge can introduce breakage)
- If on main/master (no feature branch), only offer PR/keep/discard
```

- [ ] **Step 2:** Verify file is ~50-60 lines
- [ ] **Step 3:** Commit: `feat: add finish template for landing completed work`

---

### Task 6: Upgrade workflow.md with Step 6 Finish + skill discoverability + updated scaling table

**Files:**
- Modify: `templates/rules/workflow.md`

- [ ] **Step 1:** Read the current file (105 lines)
- [ ] **Step 2:** Add Step 6 after Step 5 (Self-Review), before the "Scaling the Process" section:

```markdown
### 6. Finish (when work is complete)

After implementation passes review and verification, land the work:
- Run full test suite one final time
- Present options: merge locally, push & create PR, keep branch, or discard
- Execute the chosen option with safety checks
- Never merge without passing tests, never delete without explicit confirmation
```

- [ ] **Step 3:** Update the scaling table to include finish:

Replace the current scaling table with:

| Task Type | Steps |
|-----------|-------|
| Typo, config tweak | Implement → verify |
| Bug fix | Understand → RED (reproduce as test) → GREEN (fix) → verify |
| Small feature | Plan briefly → TDD → verify → self-review → finish |
| New feature (multi-file) | Understand → plan (with approval) → TDD → verify → self-review → finish |
| Architecture change | Clarify → design doc → plan (with approval) → TDD → verify → self-review → finish |

- [ ] **Step 4:** Add skill discoverability section at the end of the file, before the "Principles" section:

```markdown
## Available Skills

These skills trigger automatically per the pipeline above, but can also be invoked manually:

- `/clarify` — Turn vague requests into testable specs
- `/plan` — Create implementation plans with bite-sized tasks
- `/tdd` — Test-driven development (RED-GREEN-REFACTOR)
- `/review` — Two-stage code review (spec compliance → quality)
- `/verify` — Verification before completion claims
- `/subagent-dev` — Fresh subagent per task with two-stage review
- `/finish` — Land completed work (merge/PR/keep/discard)
```

- [ ] **Step 5:** Verify file stays under 150 lines
- [ ] **Step 6:** Commit: `feat: upgrade workflow rule with finish step and skill discoverability`

---

### Task 7: Add finish/ to generator's always-generate list

**Files:**
- Modify: `.claude/skills/claude-init/SKILL.md`

- [ ] **Step 1:** Read the current file
- [ ] **Step 2:** Find the "Always generate" skill list (around line 278-284) and add finish/ as the 7th entry:

After line 284 (`6. **subagent-dev/SKILL.md**...`), add:
```markdown
7. **finish/SKILL.md** — Land completed work. Verify tests, present options (merge/PR/keep/discard), execute with safety checks. Auto-triggered after implementation and review pass.
```

- [ ] **Step 3:** Commit: `feat: add finish/ to always-generate skill list in generator`
