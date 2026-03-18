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
