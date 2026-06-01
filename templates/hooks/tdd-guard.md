# Optional: TDD-Guard Hook

The `/tdd` skill enforces test-first development through *instruction* — it tells Claude to write a failing test before production code. That works because Claude follows it, but it is not a hard gate.

For teams who want **deterministic, tool-level enforcement** — a hook that physically blocks `Write`/`Edit` to source files until a failing test exists — wire in [`nizos/tdd-guard`](https://github.com/nizos/tdd-guard). It ships language-specific test reporters (Vitest, Jest, pytest, PHPUnit, Go, RSpec) and a `PreToolUse` hook that reads the latest test run and blocks implementation that runs ahead of the tests.

This is **opt-in**. `claude-init` does not install it by default because it adds a dependency and can frustrate exploratory work. Add it when the team has decided TDD is non-negotiable.

## Install (per tdd-guard docs)

```bash
npm install -D tdd-guard            # or the language-specific reporter
```

Then add a `PreToolUse` matcher to `.claude/settings.json` that invokes the guard. Use the modern hook decision schema — `hookSpecificOutput.permissionDecision`, never the legacy `{"decision": "..."}` form:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "npx tdd-guard check",
            "timeout": 10000,
            "statusMessage": "TDD guard..."
          }
        ]
      }
    ]
  }
}
```

The guard command exits non-zero (or emits `permissionDecision: "deny"` with a reason) when implementation outpaces a failing test, and exits 0 silently otherwise — letting the call proceed through the normal permission flow.

## When to skip

- Solo prototypes and spikes — the friction outweighs the safety.
- Repos where config files or generated code dominate (the guard targets source edits).
- Codebases without a supported test reporter.

In those cases the instruction-level `/tdd` skill is the right tool, not a hard hook.
