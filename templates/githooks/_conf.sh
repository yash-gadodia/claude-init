#!/usr/bin/env sh
# Shared by the git hooks: load the same gate.conf the Claude hooks read, so a
# push and a turn end are gated by one command.
root=$(git rev-parse --show-toplevel)
conf="$root/.claude/scripts/gate.conf"
# shellcheck disable=SC1090
[ -f "$conf" ] && . "$conf"
true
