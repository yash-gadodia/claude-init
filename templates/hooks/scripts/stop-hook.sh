#!/usr/bin/env bash
# Stop: the whole project gate at the turn boundary. When this session changed
# source this turn (marker from post-edit or post-bash), run CHECK_CMD once and
# block finishing (exit 2) until it is green. A 3-attempt cap turns an
# unsatisfiable failure into a loud warning instead of an endless fix loop.
set -u
. "$(dirname "$0")/_lib.sh"

max_attempts=3
marker="$cache/full-check-needed.$sid"
attempts_file="$cache/full-check-attempts.$sid"
reinstalled="$cache/deps-reinstalled.$sid"

[ -f "$marker" ] || exit 0
cd "$root/${CHECK_DIR:-.}" || exit 0

run_gate() { out=$(bash -c "$CHECK_CMD" 2>&1); }

run_gate
status=$?

# Another agent's install was mid-flight: re-sync once, then trust the result.
if [ "$status" -ne 0 ] && [ -n "$REINSTALL_REGEX" ] && [ ! -f "$reinstalled" ] \
  && printf '%s' "$out" | grep -Eq "$REINSTALL_REGEX"; then
  : >"$reinstalled"
  bash -c "$REINSTALL_CMD" >/dev/null 2>&1 || true
  run_gate
  status=$?
fi

# The environment is down, not the code. Warn and step aside; the marker stays
# armed so the gate runs once the service is back.
if [ "$status" -ne 0 ] && [ -n "$ENV_FAILURE_REGEX" ] \
  && printf '%s' "$out" | grep -Eq "$ENV_FAILURE_REGEX"; then
  {
    echo "Quality gate could not run: $ENV_FAILURE_HINT"
    echo "Nothing about this turn's edits has been verified."
  } >&2
  exit 0
fi

if [ "$status" -eq 0 ]; then
  rm -f "$marker" "$attempts_file"
  echo "Quality gate passed: $CHECK_CMD" >&2
  exit 0
fi

attempts=$(cat "$attempts_file" 2>/dev/null || echo 0)
case "$attempts" in '' | *[!0-9]*) attempts=0 ;; esac
attempts=$((attempts + 1))

if [ "$attempts" -ge "$max_attempts" ]; then
  rm -f "$marker" "$attempts_file"
  {
    echo "$out" | tail -60
    echo
    echo "-- Quality gate still failing after $max_attempts attempts; leaving it for a human. It re-arms on the next source edit. Run: $CHECK_CMD --"
  } >&2
  exit 0
fi

echo "$attempts" >"$attempts_file"
{
  echo "$out" | tail -60
  echo
  echo "-- Quality gate failed ($CHECK_CMD). Fix the above before finishing (attempt $attempts/$max_attempts). --"
} >&2
exit 2
