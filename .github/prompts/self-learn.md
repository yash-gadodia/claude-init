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

## Phase 3: Apply (commit directly to main)

If you have one improvement:
1. Make the change on `main` — max ~200 changed lines, templates/docs/skills only
2. Update `LEARNINGS.md`: add this cycle's entry (adopted idea + any rejected candidates with reasons), refresh all `Last checked` dates
3. Run `bash tests/run.sh` — MUST pass before you commit. If it fails and you can't fix it within the diff budget, revert everything except the LEARNINGS.md entry (log the idea as "attempted, tests failed") and commit only that
4. Commit to main with the source URLs in the message, prefixed `[self-learn]`, and push

If you have no improvement:
1. Update `LEARNINGS.md` on main (`Last checked` dates + a one-line "no findings" cycle entry), commit and push — the audit trail matters.

## Guardrails

- One idea per cycle, max ~200 changed lines
- Every claim cited with a URL
- `bash tests/run.sh` green is a hard gate for any commit that touches more than LEARNINGS.md
- Never touch: scripts/install.sh logic, .github/workflows/, LICENSE, PRIVACY.md
- Never add speculative config for experimental/preview features — note them in LEARNINGS.md as tracking items instead
