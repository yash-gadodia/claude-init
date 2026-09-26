#!/usr/bin/env bash
# SessionStart: seed this session's mtime baseline for post-bash-hook.sh and prune
# gate state older than a day. A session killed while red leaves its marker behind
# forever; it records an edit nobody verified, and keeping it verifies nothing.
set -u
. "$(dirname "$0")/_lib.sh"

: >"$cache/bash-stamp.$sid"
find "$cache" -maxdepth 1 -type f \
  \( -name 'full-check-needed.*' -o -name 'full-check-attempts.*' \
     -o -name 'deps-reinstalled.*' -o -name 'bash-stamp.*' \) \
  -mtime +1 -delete 2>/dev/null || true
exit 0
