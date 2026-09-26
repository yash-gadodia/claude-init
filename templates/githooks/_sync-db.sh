#!/usr/bin/env sh
# Called by post-merge and post-checkout: when migration paths moved between two
# refs, bring the local database up to date, so a pull never leaves the schema
# behind the code. Never fatal (post-checkout's status IS checkout's status) and
# never in CI, where the runner has its own migrate step.
[ -n "${CI:-}" ] && exit 0
. "$(dirname "$0")/_conf.sh"
[ -n "${MIGRATE_CMD:-}" ] || exit 0
[ -n "${MIGRATION_PATHS_REGEX:-}" ] || exit 0
[ -n "$1" ] && [ -n "$2" ] || exit 0

changed=$(git diff --name-only "$1" "$2" 2>/dev/null | grep -E "$MIGRATION_PATHS_REGEX")
[ -n "$changed" ] || exit 0

echo "schema changed, syncing local database: $MIGRATE_CMD"
(cd "$root" && sh -c "$MIGRATE_CMD") || echo "schema sync failed; run '$MIGRATE_CMD' yourself before testing."
exit 0
