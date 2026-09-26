---
name: what-happened
description: "Tight recap of where the session stands so the user can scan it and resume. Use when the user types /what-happened after a break, a tangent or a long subagent run."
disable-model-invocation: true
allowed-tools: Read, Bash
---

# What happened

Drop the user back into the session in under 30 seconds of reading. Their job is to scan and resume, not to re-read the transcript. Write it the way `wait-what` asks: plain short sentences, the project's own names for things.

## Output

These sections, in this order. Skip one only when it is genuinely empty. Under 150 words, hard cap 250.

```
**Now**: <1 line: the active task in concrete terms>
**Why**: <1 line: the trigger or motivation the user gave>
**Goal**: <1 line: the success condition>
**Done**: <up to 4 bullets, most recent first>
**Next**: <1-2 lines: the very next action or open decision>
**Open** (only when blocking): <bullets>
```

## Anchors

Every line carries a concrete handle or a state:

- **Names**: file paths, function names, the branch or worktree, the plan doc, a migration. Keep identifiers exactly as written.
- **States**: gate green or not, committed / pushed / deployed, what a background agent is still doing.
- **Decisions the user confirmed**, stated as settled. Re-justifying a closed decision reopens it.
- **The last meaningful result**: what the last command or agent run produced, not which agent ran.

When the conversation is thin (a fresh session), rebuild state from git: `git status --short`, `git log --oneline -10`, `git branch --show-current`, open worktrees.

## Edge cases

- Barely started: say so ("we just started, you pointed at X, nothing built yet").
- Topic changed mid-session: recap the current topic; give the earlier one a single line if it is still open.
- Blocked on a question: put it under **Open** and make **Next** answering it.

## Before sending

Could the user paste this into a fresh conversation and pick the thread back up? If not, add the missing anchor. Over 250 words: cut **Done** first, then **Why**.
