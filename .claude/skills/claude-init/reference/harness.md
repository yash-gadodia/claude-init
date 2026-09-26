# The harness: hook chain, gate config, git hooks

What Step 2e installs, why each piece exists, and how to prove it works. The scripts are in `templates/hooks/scripts/` and `templates/githooks/`; copy them as-is and customize only `gate.conf`.

## Pieces

| File | Event | Job |
|------|-------|-----|
| `.claude/scripts/gate.conf` | (config) | The one place stack-specific values live: `CHECK_CMD`, source dirs and extensions, generated/append-only paths, reinstall and environment-failure patterns, `MIGRATE_CMD`, `DEFAULT_BRANCH`. Every hook below, Claude's and git's, reads it. |
| `_lib.sh` | (shared) | Reads the payload (jq, else python3), resolves the session id and the session's own working tree, loads gate.conf. |
| `pre-edit-hook.sh` | PreToolUse Edit\|Write | Blocks hand-edits to generated files, and Edit (not Write) on append-only files such as applied migrations. |
| `post-edit-hook.sh` | PostToolUse Edit\|Write | Arms `.claude/.cache/full-check-needed.<session>` when a source file changed. |
| `post-bash-hook.sh` | PostToolUse Bash | Arms the same marker when any source file's mtime is newer than the session's stamp. |
| `session-start-hook.sh` | SessionStart | Seeds the mtime stamp; prunes gate state older than a day. |
| `stop-hook.sh` | Stop | If armed, runs `CHECK_CMD` once; exit 2 feeds failures back until green; 3-attempt cap. |
| `.githooks/pre-push` | git | Refuses when origin/<default> is not an ancestor of HEAD, then runs `CHECK_CMD`. |
| `.githooks/post-merge`, `post-checkout`, `_sync-db.sh` | git | Runs `MIGRATE_CMD` when migration paths changed between the two refs. Never fatal, skipped in CI. |
| `.githooks/prepare-commit-msg` | git | Adds `Claude-Session: <name> (<id>)` to commits made from a Claude session. |

## Why it is shaped this way (each line is an incident)

- **One gate command, never a list.** A hook that runs "typecheck and two guards" keeps passing while nine new guards are added. Point `CHECK_CMD` at the project's own runner; if the project has no single command, add one to package.json/Makefile first.
- **The marker is per session.** Two sessions sharing a checkout must not block each other on half-finished edits.
- **The gate roots at the payload's `cwd`, not `CLAUDE_PROJECT_DIR`.** The project dir always names the main checkout, so a worktree session would be gated on a sibling's tree.
- **Bash edits arm the gate by mtime.** In bypass-permissions mode Claude edits with sed and heredocs, which never reach an Edit|Write hook. A marker keyed on Edit alone leaves the gate off for that whole class of edit, silently.
- **Environment failures warn, code failures block.** A stopped database is not a bug in the session's code; blocking sends the session hunting one.
- **One dependency reinstall, then trust the result.** A concurrent install makes a package vanish for a few seconds.
- **Schema sync on pull, not in the gate.** Migrating inside the Stop hook papers over the drift; the post-merge hook removes it where it starts.

## Permission rules that actually match

- File rules are `Edit(path)`. Edit rules apply to every built-in file-writing tool; `Write(path)` rules match nothing and give false comfort.
- `Bash(...)` rules prefix-match, so `Bash(git push --force*)` does not catch `git -C x push --force`. They are a floor; the PreToolUse regex hook is the second layer.
- Deny `git commit --no-verify`, `git commit -n`, `git push --no-verify` and `git config core.hooksPath`, so the git hooks cannot be skipped or unset by the agent.

## Installing

1. Copy `templates/hooks/scripts/*` to `.claude/scripts/` and `templates/githooks/*` to `.githooks/`; `chmod +x` all of them.
2. Fill `gate.conf` from the analysis. Leave `MIGRATE_CMD` empty when the project has no migrations.
3. Run `git config core.hooksPath .githooks` **before** writing `.claude/settings.json`: the settings deny that command, and Claude Code can pick up a settings change mid-session. Document the command in CLAUDE.md for every new clone.
4. Add `.claude/.cache/` to `.gitignore`.

## Proving it works (do this, do not read the scripts instead)

Pipe a simulated payload into each hook from the target repo root and show the exit codes:

```bash
p() { printf '{"session_id":"smoke","cwd":"%s","tool_name":"%s","tool_input":{"file_path":"%s"}}' "$PWD" "$1" "$2"; }
p Edit "$PWD/package-lock.json" | .claude/scripts/pre-edit-hook.sh; echo "pre-edit lockfile: $?"      # 2
p Write "$PWD/src/x.ts" | .claude/scripts/post-edit-hook.sh; ls .claude/.cache/full-check-needed.smoke  # exists
p "" "" | .claude/scripts/stop-hook.sh; echo "stop: $?"   # 0 when CHECK_CMD passes, 2 when it fails
```

For the Bash path: run `session-start-hook.sh`, `sed -i` a source file, then run `post-bash-hook.sh` with the same payload and confirm the marker appears. `bash -n` every script. Delete `.claude/.cache/*.smoke` afterwards.
