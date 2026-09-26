# Coding standards

Rules for writing and reviewing code in this repo. CLAUDE.md imports this file, and `/code-review` reads it as its standards: a rule here overrides the reviewer's built-in baseline.

Mechanical rules are already enforced by the linter, the type checker and the project's check scripts (`<CHECK_CMD>`). Never spend a review finding on something a check already fails.

## Keep changes surgical

- Change what the task needs, and nothing else: no drive-by refactors, renames, reformats or dependency bumps.
- A pre-existing bug found on the way is reported as a follow-up, never fixed in the same change unless the requested behavior cannot work without it.
- Where the task is ambiguous, build the reading its wording and the surrounding code most directly support, and state that reading in the summary.
- A wide mechanical sweep is correct when a shared contract moves. Do the judged part first, then the mechanical part, and judge the sweep on whether it is complete, not on how wide it is.

## Do not add speculative complexity

- The simplest thing that works. No abstraction until there is a second real caller; no options, flags or generality the task did not ask for.
- Prefer deleting to adding. A change that only ever adds is how a codebase doubles without getting better; name what the change removed.
- No compatibility shims, aliases or re-exports kept "just in case". Update the call sites instead. (A schema change and its consumers still ship in the order that keeps production up.)

## Tests pin real failures

- A test earns its place by being seen failing against the bug it names. A fix without a reproducing test is a guess.
- Revert-check each assertion alone: a redundant sibling assertion can keep a vacuous one green.
- Vacuous shapes to reject: asserting against its own mock, sampling the wrong property, a selector that matches nothing, waiting for an absence. Any "nothing is present" assertion needs a positive control in the same test.
- Test the seam, not the halves. When a reader feeds a renderer (a database row into a formatter, a payload into a template), one test runs real rows through both. Two green halves with a typed interface between them is how a string reaches `.getTime()` in production.
- Scratch checks stay scratch: a script written to verify one change is deleted, not promoted to a committed test.

## Comments say why

- Worth a comment: why this value and not the obvious one, what was rejected and what it cost, which incident forced the shape, a trap that fails silently.
- Not worth a comment: restating the next line, section banners, commented-out code. If a routine change would make a comment wrong without anyone changing a decision, delete the comment.

## Review overrides

- Duplicated knowledge is worse than duplicated code: keep one copy, next to what it governs.
- Ask of every caught-and-retried failure in a diff: would someone watching production see it? A path that swallows an error and retries needs a visible trace (a log line with the attempt count, an alert), or it is a hidden crash.
