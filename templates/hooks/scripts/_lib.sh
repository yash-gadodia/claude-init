#!/usr/bin/env bash
# Shared by the .claude/scripts hooks: read the hook payload, load gate.conf,
# resolve the session's own working tree.

HOOK_PAYLOAD=$(cat 2>/dev/null || true)

field() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$HOOK_PAYLOAD" | jq -r "$1 // empty" 2>/dev/null
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "$HOOK_PAYLOAD" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for k in sys.argv[1].lstrip(".").split("."):
    d = d.get(k) if isinstance(d, dict) else None
print("" if d is None else d)' "$1"
  fi
}

# Per-session so two sessions sharing one checkout never gate on each other's edits.
sid=$(field .session_id | tr -cd 'A-Za-z0-9._-')
[ -n "$sid" ] || sid="default"

# The gate runs on THIS session's tree. CLAUDE_PROJECT_DIR always names the main
# checkout, so a worktree session rooted there would be told to fix a sibling
# session's half-typed edits.
cwd=$(field .cwd)
root=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || true)
fi
[ -n "$root" ] || root="${CLAUDE_PROJECT_DIR:-$PWD}"

cache="${CLAUDE_PROJECT_DIR:-$root}/.claude/.cache"
mkdir -p "$cache"

conf="$root/.claude/scripts/gate.conf"
[ -f "$conf" ] || conf="$(dirname "${BASH_SOURCE[0]}")/gate.conf"
# shellcheck disable=SC1090
. "$conf"

source_file() {
  local f="$1" ext rel d
  ext="${f##*.}"
  case " $SOURCE_EXTS " in *" $ext "*) ;; *) return 1 ;; esac
  rel="${f#"$root"/}"
  for d in $SOURCE_DIRS; do
    case "$rel" in "$d"/*|*/"$d"/*) return 0 ;; esac
  done
  return 1
}
