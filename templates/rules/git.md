---
description: Git workflow conventions
---

# Git Rules

- Write clear commit messages: imperative mood, explain "why" not "what"
- Never force push to main/master
- Never commit .env files, credentials, or large binaries
- Run tests before committing — don't push broken code
- Branch names: `feat/short-description`, `fix/short-description`, `chore/short-description`
- Keep PRs focused — one feature or fix per PR
- Rebase on main before merging to keep history clean
