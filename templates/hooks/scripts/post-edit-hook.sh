#!/usr/bin/env bash
# PostToolUse(Edit|Write): arm the Stop gate when a source file changed, so the
# whole gate runs once per turn instead of once per edit.
set -u
. "$(dirname "$0")/_lib.sh"

f=$(field .tool_input.file_path)
[ -n "$f" ] || exit 0
source_file "$f" && : >"$cache/full-check-needed.$sid"
exit 0
