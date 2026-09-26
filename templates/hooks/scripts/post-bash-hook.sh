#!/usr/bin/env bash
# PostToolUse(Bash): arm the Stop gate when a shell command changed source.
#
# In bypass-permissions mode Claude edits with sed, heredocs and scripts, which
# never reach the Edit|Write hook, so a marker keyed on Edit alone leaves the gate
# silently off for a whole class of edits. Detection is by mtime rather than by
# parsing the command: `sed -i`, `> file`, `mv` and a script that writes files are
# all one regex away from a miss, and a file's mtime cannot lie.
set -u
. "$(dirname "$0")/_lib.sh"

stamp="$cache/bash-stamp.$sid"
# No stamp: SessionStart did not run. Seed it rather than arming off all history.
if [ ! -f "$stamp" ]; then
  : >"$stamp"
  exit 0
fi

dirs=""
for d in $SOURCE_DIRS; do
  [ -d "$root/$d" ] && dirs="$dirs $root/$d"
done
names=""
for e in $SOURCE_EXTS; do
  names="$names -o -name *.$e"
done
names="${names# -o }"

if [ -n "$dirs" ] && [ -n "$names" ]; then
  set -f
  # shellcheck disable=SC2086
  changed=$(find $dirs -type f \( $names \) -newer "$stamp" -print -quit 2>/dev/null)
  set +f
  [ -n "$changed" ] && : >"$cache/full-check-needed.$sid"
fi

: >"$stamp"
exit 0
