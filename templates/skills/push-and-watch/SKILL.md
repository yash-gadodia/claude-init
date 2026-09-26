---
name: push-and-watch
description: "Own a deploy from push to live evidence: read what rides along in the push, get the user's confirmation for this push, watch the deploy to completion, verify the live site, and know the rollback lever before you need it. Use before any push that deploys, when asked to ship, deploy, or push to <DEFAULT_BRANCH>."
allowed-tools: Read, Bash, Glob, Grep
---

# Push and watch

<DEPLOY_TRIGGER: e.g. "A push to origin/main deploys production through <HOST>."> The push is not the end of the work: it starts a chain that ends with live evidence, and whoever pushes owns the whole chain.

## 1. Read what rides along

`git log --format='%h %(trailers:key=Claude-Session,valueonly,separator=) %an %s' origin/<DEFAULT_BRANCH>..HEAD`

Other people's and other sessions' commits deploy with yours. The `Claude-Session:` trailer (stamped by `.githooks/prepare-commit-msg`) says which session wrote each one. For every commit, know what it is and whether it carries a migration or a dependency change.

**Keep migrations and dependency upgrades in separate pushes.** A push with only code changes can be rolled back by redeploying the previous build. A push with a migration can only be fixed forward, because the schema has already moved. Put a risky dependency bump in the same push as a migration and you lose the rollback exactly when you need it.

## 2. Confirm, per push

Tell the user the commit count, anything not built in this session, and whether a migration or dependency change rides. Approval for an earlier push does not carry over. Preconditions: clean tree, gate green on the rebased tree.

## 3. Push, then watch to the end

`git push origin <DEFAULT_BRANCH>`, then <WATCH_CMD: e.g. `gh run watch <id> --exit-status`, `railway deployment list`, `vercel inspect`>. A red build means nothing deployed; read the failing output rather than re-pushing.

## 4. Verify live, immediately

`curl -s -H 'Cache-Control: no-cache' '<LIVE_URL>?cb=$(date +%s)' | grep '<changed text>'` and report the matched string. Then run the live-verify pass on production for the behavior that shipped. If the deploy succeeded but the change is not visible, say so (likely a CDN cache) instead of claiming success. Tell every other session whose commits rode along that the deploy is live.

## 5. If it is bad

- **No migration rode**: <ROLLBACK_CMD: e.g. redeploy the previous deployment in the host's dashboard/CLI, or `git revert` + push>.
- **A migration rode**: fix forward with a new commit. Rolling the code back would run old code against the new schema.
- Repair data damage with a reviewed, hand-run script, never with a follow-up migration written in a hurry.

## Common Rationalizations

| Thought | Reality |
|---------|---------|
| "Push exited 0, it's deployed" | That is the build starting. Watch it finish. |
| "The build is green, it's live" | Curl the live URL and find the change. |
| "Those other commits aren't mine" | They deploy with yours. Know what they are. |

## Red Flags — STOP

- Pushing without the user's go for THIS push
- Reporting "deployed" with no live URL check
- A migration and a dependency bump in the same push

## Verification

Done means: the deploy watched to green, the live URL checked with the matched string quoted, the live pass run, and the user told what was watched.
