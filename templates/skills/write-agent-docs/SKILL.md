---
name: write-agent-docs
description: "How to write and audit the documents agents consume: CLAUDE.md files, .claude/skills, and any doc reached by a pointer. Use when creating or editing a SKILL.md, restructuring or pruning a CLAUDE.md, writing or fixing a skill description that fails to trigger, folding a session's learnings or traps into a skill, deciding whether material belongs bare, in a scoped section, or behind a skill pointer, toning down shouty or blanket rules. Stripping AI tropes from finished prose is the deslop skill. Triggers: 'write a skill', 'new skill', 'improve CLAUDE.md', 'audit this skill', 'skill description', 'scoped section', 'too many MUSTs', 'fold this trap into the skill', 'is this skill still useful'."
allowed-tools: Read, Edit, Write, Glob, Grep
---

# Writing CLAUDE.md and skills

One rule generates the rest: every always-loaded line either changes behavior or teaches the agent to skim. Claude Code also injects CLAUDE.md under a reminder that the content "may or may not be relevant to your tasks", so irrelevant bulk does not merely dilute; it licenses the model to ignore the whole file, including the parts that matter. Lean files get obeyed, fat ones get skimmed. Everything below is a way to stay lean without losing the material.

## Where material lives: three tiers

Decide per piece of material, not per document.

1. **Bare, always loaded.** Project identity, the directory map, the tech stack, the commands. Only what nearly every task needs. In CLAUDE.md this sits as plain markdown at the top.
2. **Inline, scoped by a heading.** Rules for one kind of work sit under a `##` heading that names that work ("Adding or changing API routes"). The heading is the relevance signal: an agent doing that work reads the section, one doing other work skims past it. Give each section the narrowest scope that covers its rules, and keep unrelated rules out of one broad heading like "Writing code". Mark scope with the heading alone; a wrapper such as `<important if>` adds urgency, and urgency makes a rule over-apply outside the case it was written for.
3. **Behind a pointer.** A heavy playbook becomes a skill (live-verify, push-and-watch, a database or deploy playbook) and the CLAUDE.md section shrinks to a line or two naming it and when to read it; a guardrail that must survive a skipped skill read stays in the section as a single line (never push without confirmation, failing test before the fix) while the skill carries the mechanics. Inline what every matching task needs; push behind a pointer what only some tasks reach.

## Pointers do the triggering

A pointer is any always-loaded line that names out-of-context material: a skill's description, a CLAUDE.md line naming a doc. The pointer's wording, not the target's quality, decides whether the material is ever reached. A must-read playbook behind a weak pointer is a variance bug: some runs find it, some do not.

- Front-load the literal phrases a matching task would contain ("rebase onto main", "db:generate", "qa is failing"), because trigger words the user actually types beat abstract category names.
- List one trigger per genuinely distinct branch of the document. Synonyms renaming the same branch are one branch written twice; collapse them.
- Skip restating identity the body already carries; the pointer's job is triggering, not summarizing.
- When a needed doc keeps getting missed, sharpen its pointer first. Inline the material only if sharpening fails.

The house pattern for a description: what it is, the branches it covers, then a Triggers list of literal phrases.

## Skill frontmatter and invocation

- **Model-invoked** (the default): the description stays loaded every turn as the trigger, paying permanent context cost for discoverability. Use when the agent must reach the skill on its own.
- **User-invoked** (`disable-model-invocation: true`): zero context load, but the human is the index that must remember it exists. Use for skills only ever fired by hand.
- `skillOverrides: { "<name>": "name-only" }` in `.claude/settings.json` strips a description from the listing while keeping the skill invocable by name; use it to demote a rarely-triggered vendored skill without deleting it.

## Writing the body

- Prefer a procedure with a worked bad/good pair over an essay about principles. One compact example carries a mechanism; a full input/output transcript doubles the file for no extra transfer.
- End steps on a completion criterion the agent can check: "every modified model accounted for" says when the step is done, where "produce a change list" leaves the bound vague.
- Phrase the positive. A prohibition activates the banned behavior and half-reads as an instruction to do it; state the target behavior instead, and pair any unavoidable hard guardrail with its positive form.
- State the situation before the rule. "The user is not watching in real time and cannot answer mid-task" lets the model work out when to keep going without asking, and it generalizes to cases no rule listed, where a bare prohibition covers only the case it names.
- Write rules at normal volume. Current models follow their instructions closely, so ALL-CAPS words, IMPORTANT / CRITICAL / MUST markers and `!!` make a rule over-trigger, and the anxious register of the file leaks into the output. When every rule is marked critical the marks carry no information. State each rule once, in plain case, with its reason.
- Leave out blanket behavior directives: "be concise", "be thorough", "don't stop until done", "always ask before acting", "always summarize at the end". Current models are proactive and size their answers on their own, and a blanket line over-applies (a "be concise" rule trims the one answer that needed detail). When a behavior genuinely needs steering, name the specific case and its reason: "surface design decisions as options, each with how it fails at scale" instead of "always ask".
- A skill's frontmatter description is routing text and may carry literal trigger phrases; the body is behavior text and explains rather than insists.
- Define an anti-pattern by the substitution it makes, plus one pair, instead of naming it. "Mannered prose swaps a literal phrase for a flourish: a dial worth turning for a parameter worth varying" lands where "do not be flowery" does not. For a behavior the model gets subtly wrong (reproducing a source without marking the quotation), one complete example followed by a sentence saying why it is correct beats a rule.
- Write the prose itself plainly, then run the deslop skill over it. Its prose lane carries the catalog of tropes a model drifts into and the literal sentence that replaces each; the catalog lives there, behind a pointer, and never in an always-loaded file.
- Cache only what the environment cannot confess: the unwritten convention, the reason behind a choice, the gotcha no config admits. Commands, flags, and scripts live in package.json and --help output; restating them creates a copy that goes stale. Staleness is worse for agents than for humans: a human reads old docs with skepticism, an agent trusts whatever loads, so a stale line actively poisons every run that reads it.
- Cut what a linter or hook already enforces, what consistent code patterns teach by example, and code snippets that will drift (point at a real file instead).
- Anchor recurring ideas to one short term used consistently ("trap", "gate") instead of re-explaining the idea at each site.
- House style: skill bodies are LLM-facing prose, so plain sentences and plain punctuation with no em dashes, and no hard wrapping at 80 columns.

## Maintaining a skill

- Fold a new trap into the owning skill in the same session it bites; an unwritten trap is relearned by the next session. An end-of-file trap checklist is a fine recap, but each fact's authoritative statement lives in one place in the body.
- One appended rule per agent mistake compounds into a ball of mud. When a mistake recurs, first try enforcing the fix mechanically (a hook, a lint rule, a check script), then try sharpening an existing line; add a new rule only when neither works.
- Before appending, hunt the stale line your new fact contradicts. A contradiction makes agent behavior a coin flip, so deleting the stale line matters more than adding the new one.
- Apply the no-op test line by line: would the model already do this by default? If yes, delete the whole sentence, not just words from it. Settle disagreements by running the document, not by debate.
- A tic-suppression rule expires with the model. "No bullets, no bold" was written against models that over-formatted; a newer model may under-format, so the same line now overshoots and strips structure the content needs. Write such a rule as when the behavior is right ("lists when the content is multifaceted enough that they help") and note which model tic it corrects, then re-run the no-op test on every such line when the model changes.
- Only write facts you are sure of. A confidently stated wrong mechanic misleads every future run; leave an uncertain trap out or mark what is unverified.

## Checklist before committing

- Description front-loads literal trigger phrases, one per distinct branch.
- Every CLAUDE.md rule sits under the narrowest heading that covers it; unscoped content is truly universal.
- No ALL-CAPS emphasis, IMPORTANT / CRITICAL / MUST markers, or blanket be-concise, be-thorough, don't-stop, always-ask or always-summarize lines; each rule names the specific behavior and its reason.
- Heavy reference is behind a pointer, not buried between steps.
- No line restates package.json, --help, or config.
- No prohibition without its positive target, and every tic-suppression rule says when, not never.
- New facts left no contradicting old line behind.
- No em dashes, no hard wraps.
