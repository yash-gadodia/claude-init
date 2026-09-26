---
name: deslop
description: "Remove AI slop from prose or code without changing what it means or does. Prose: strip the tropes models drift into (negative parallelism, self-answered questions, invented labels, bold-first bullets, filler transitions, stacked triples, em dashes) from a doc, skill, reply or commit. Code: a bounded, deletion-first cleanup (dead code, duplicate logic, pass-through wrappers, tests that assert nothing) with behavior pinned by a test first. Use when asked to clean up, tighten or de-AI something, or when reviewing text a model wrote. Triggers: 'deslop', 'AI slop', 'this reads like AI', 'tighten this doc', 'dead code', 'too many wrappers'."
allowed-tools: Read, Edit, Bash, Glob, Grep
---

# Deslop

Slop is text or code that displays the writer instead of carrying the idea: a metaphor where a literal phrase exists, a wrapper where a call exists, a third sentence restating the first. Removing it never changes the meaning of the prose or the behavior of the code; if a pass would change either, it is a rewrite or a fix, not a deslop. Bound every pass to what was named (a file, a doc, a diff) and report what was deleted.

## Prose

The catalog is `references/prose-tropes.md`: each trope, one example, and the plain sentence that replaces it.

1. Read the text once and write down, in one line, what it claims. Every edit is checked against that line.
2. Walk the catalog by category (word choice, sentence structure, composition, tone, formatting) and mark every hit. Read for structure too: three sentences opening the same way, a section that previews itself.
3. Replace each hit with the literal sentence. Negative parallelism keeps only the positive half. A self-answered question becomes one declarative sentence. An invented label becomes the argument it stood in for. A summary that restates the section is deleted.
4. Read the result against step 1's line: every claim present, none added, and the piece shorter than before. A deslop that grew the text added slop.

## Code

1. **Pin behavior first.** Run the narrowest existing test that covers it; where none does, write the one test that would fail if the cleanup broke it, before the first edit.
2. **Bound the scope** to the files named. A smell outside it is a follow-up in the report.
3. **Classify each smell** before editing: duplication, dead code, needless abstraction, boundary violation, weak test.
4. **One smell per pass, safest first**: dead code, then duplicates, then wrappers and boundaries, then tests. Run the pinning test after each pass and the project gate at the end. A failing gate means back that pass out.
5. Prefer deleting to adding; add no dependency. A wrapper whose comment records a decision (acquiring a scope, a documented workaround) is not needless: read the comment before collapsing it.

## Red Flags — STOP

- The cleaned text lost a claim, or the cleaned code changed behavior
- The pass widened beyond the files named
- Editing code with nothing pinning its behavior

## Verification

Report: files changed, what was deleted or consolidated, the test that pinned behavior and the gate result, and every classified smell as either fixed or deliberately left with the reason. With `--review`, make no edits and return the list of hits.
