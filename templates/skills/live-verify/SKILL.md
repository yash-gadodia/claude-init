---
name: live-verify
description: "Prove a behavior change on the running system, not just the test suite: reproduce a bug as a failing test before the fix, then run an adversarial live pass across every path that reaches the behavior and read the resulting artifacts back. Use when fixing a bug, investigating a production issue, or before claiming a feature works. Triggers: 'is it fixed', 'does it work', 'verify this in the app', 'reproduce this bug'."
allowed-tools: Read, Bash, Glob, Grep
---

# Live verify

Green gates (types, lint, the suite) prove the code compiles and passes the tests its author wrote. They say nothing about what the author never imagined. A behavior claim is proven only by watching the behavior happen on the real surfaces.

## 1. Reproduce before you fix

1. Capture the exact shape that breaks from the real system: the request body, the database row, the job payload, the API response. The shape, not a description of it.
2. Turn it into a fixture next to the test, named for the scenario, and anonymize it while preserving structure: field presence versus absence, nesting, empty versus null. The structure is usually where the bug lives, so a tidied fixture stops reproducing it.
3. Run the test and confirm it fails for the same reason the bug happens. A test that fails for a different reason pins nothing.
4. Make the minimal fix and watch the test go green.

## 2. The live pass, run as an attack

1. **List every path that reaches the behavior**: each UI surface that renders it, the API route, the CLI, background jobs and cron, any bot or webhook, and every user role that can reach it. A fix wired into one path and not its sibling is the most common way a "fixed" bug ships again.
2. **Probe each path on the running app**, as the same role and database user production uses. A dev server connected as a superuser bypasses row-level security and passes code that fails in production.
3. **Attack your own rule**: the boundary value and one past it, empty, null, unicode, legacy rows that predate the change, and the mirror image of whatever you guarded against.
4. **Read the artifact, not the success message**: the row in the database, the rendered page (an HTTP 200 is not proof the page rendered), the message actually sent.
5. **Read the attempt, not only the answer**: a job that crashes and succeeds on retry looks like a slow success. Check the logs for the probe's time window, and treat any retry as a failure until explained.
6. Every catch becomes a failing test before its fix (section 1). Restore any state the probes changed.

## Common Rationalizations

| Thought | Reality |
|---------|---------|
| "The tests pass, so it works" | Tests prove what the author imagined. The live pass finds the rest. |
| "I checked the main page" | List every path. The sibling path is where it breaks. |
| "It returned 200" | Read the body. A crashed render can still return 200. |
| "It worked on the second try" | A retry is a crash nobody saw. Find out why the first attempt failed. |

## Red Flags — STOP

- Reporting "verified" having only run the test suite
- Probing only as an admin or superuser
- Trusting a toast, a status code or an agent's own "done"

## Verification

Report what you WATCHED happen: each path probed, what was read back, and every catch with its test. "Tests pass" is a gate result, not a verification claim.
