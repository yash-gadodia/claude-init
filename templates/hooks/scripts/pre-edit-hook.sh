#!/usr/bin/env bash
# PreToolUse(Edit|Write): refuse hand-edits to generated and append-only files.
# Exit 2 blocks the call and shows the reason to Claude.
set -u
. "$(dirname "$0")/_lib.sh"

f=$(field .tool_input.file_path)
[ -n "$f" ] || exit 0

if [ -n "$GENERATED_REGEX" ] && printf '%s' "$f" | grep -qE "$GENERATED_REGEX"; then
  echo "BLOCK: $f is generated. Regenerate it with its tool instead of editing it by hand." >&2
  exit 2
fi

# Append-only files (applied migrations): a new file arrives via Write, which is
# allowed; editing an existing one is how environments silently diverge.
if [ -n "$APPEND_ONLY_REGEX" ] && [ "$(field .tool_name)" = "Edit" ] \
  && printf '%s' "$f" | grep -qE "$APPEND_ONLY_REGEX"; then
  echo "BLOCK: $f is append-only (it may already have run elsewhere). Write the next file instead." >&2
  exit 2
fi

exit 0
