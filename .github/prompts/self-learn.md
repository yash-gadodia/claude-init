# Weekly Self-Learning Loop

Study the Claude Code ecosystem and propose AT MOST ONE concrete improvement to claude-init per run. Evidence over speculation. If nothing clears the bar this week, that is a valid outcome.

## Phase 1: Gather

1. Read `LEARNINGS.md` FIRST — the reject list and last-checked dates. Never re-propose anything marked rejected unless its revisit date has passed.
2. Check upstream changes since the `Last checked` dates in LEARNINGS.md:
   - `anthropics/claude-code` CHANGELOG.md — new/changed Claude Code features
   - `anthropics/skills` — new official Agent Skills or format changes
   - Official docs at code.claude.com/docs (skills, hooks, sub-agents, plugins, memory pages)
3. Scan comparable repos for new patterns (recent commits/README changes):
   - `obra/superpowers` — skill methodology
   - `trailofbits/claude-code-config` — security-first config
   - `hesreallyhim/awesome-claude-code` — new ecosystem entries worth studying
   - `VoltAgent/awesome-agent-skills` — cross-platform skill patterns

## Phase 2: Analyze

For each candidate idea, require ALL of:
- Makes claude-init's GENERATED configs better (not just interesting)
- Fits in templates/, docs, or the four self-skills — no core rewrite
- Has a citable source (URL to repo, changelog entry, or doc page)
- Not in LEARNINGS.md as rejected (or revisit date has passed)

Pick the single strongest idea, or none.

## Phase 3: Propose (never auto-merge)

If you have one improvement:
1. Create a branch `self-learn/<YYYY-MM-DD>`
2. Make the change — max ~200 changed lines, templates/docs/skills only
3. Update `LEARNINGS.md`: add this cycle's entry (approved idea + any rejected candidates with reasons), refresh all `Last checked` dates
4. Run `bash tests/run.sh` — must pass; update tests if the structure changed
5. Commit with the source URLs in the message, then open a PR with `gh pr create` — title `[self-learn] <short description>`, body containing: what changed, evidence with URLs, and the guardrails checklist
6. NEVER merge. NEVER push to main.

If you have no improvement:
1. Still update `LEARNINGS.md` on a branch (`Last checked` dates + a one-line "no findings" cycle entry) and open the PR — the audit trail matters.

## Guardrails

- One idea per cycle, max ~200 changed lines
- Every claim cited with a URL
- Never touch: scripts/install.sh logic, .github/workflows/, LICENSE, PRIVACY.md
- Never add speculative config for experimental/preview features — note them in LEARNINGS.md as tracking items instead
- PR only — a human reviews and merges
