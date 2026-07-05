#!/usr/bin/env bash
#
# claude-init self-tests — zero-dependency bash runner.
#
# Validates the repo's own templates, skills, agents, hooks, and installer.
# claude-init ships a `doctor` skill that validates *other* repos' configs;
# this suite is the same idea turned inward, so template regressions get caught
# before they reach a generated project.
#
# Usage:  bash tests/run.sh        (exit 0 = all pass, 1 = failures)
# No deps required. JSON checks use python3/node when present, else skip.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# ---- output helpers ---------------------------------------------------------
if [ -t 1 ]; then G=$'\033[32m'; R=$'\033[31m'; Y=$'\033[33m'; D=$'\033[2m'; Z=$'\033[0m'
else G=""; R=""; Y=""; D=""; Z=""; fi

PASSED=0; FAILS=0; SKIPS=0
ok()   { PASSED=$((PASSED+1)); printf "  ${G}PASS${Z} %s\n" "$1"; }
no()   { FAILS=$((FAILS+1));  printf "  ${R}FAIL${Z} %s\n" "$1"; }
skip() { SKIPS=$((SKIPS+1));  printf "  ${Y}SKIP${Z} %s ${D}(%s)${Z}\n" "$1" "$2"; }
section() { printf "\n${D}== %s ==${Z}\n" "$1"; }

# ---- assertion helpers ------------------------------------------------------
have_file() { if [ -f "$1" ]; then ok "file exists: $1"; else no "file missing: $1"; fi; }
have_dir()  { if [ -d "$1" ]; then ok "dir exists: $1";  else no "dir missing: $1";  fi; }

is_executable() { if [ -x "$1" ]; then ok "executable: $1"; else no "not executable: $1"; fi; }

# contains FILE LITERAL DESC  — fixed-string match
contains() {
  if grep -qF -- "$2" "$1" 2>/dev/null; then ok "$3"; else no "$3 ${D}[want \"$2\" in $1]${Z}"; fi
}
# matches FILE REGEX DESC  — extended-regex match
matches() {
  if grep -qE -- "$2" "$1" 2>/dev/null; then ok "$3"; else no "$3 ${D}[want /$2/ in $1]${Z}"; fi
}
# absent FILE REGEX DESC  — must NOT match
absent() {
  if grep -qE -- "$2" "$1" 2>/dev/null; then no "$3 ${D}[found /$2/ in $1]${Z}"; else ok "$3"; fi
}

has_frontmatter() {
  local f="$1"
  if [ "$(head -1 "$f" 2>/dev/null)" != "---" ]; then no "frontmatter opens with ---: $f"; return; fi
  if awk 'NR>1 && $0=="---"{found=1} END{exit !found}' "$f"; then ok "frontmatter delimited: $f"
  else no "frontmatter has closing ---: $f"; fi
}

max_lines() {
  local f="$1" limit="$2" n
  n=$(wc -l < "$f" | tr -d ' ')
  if [ "$n" -le "$limit" ]; then ok "$f ($n lines) <= $limit"
  else no "$f is $n lines (limit $limit)"; fi
}

valid_json() {
  local f="$1"
  if command -v python3 >/dev/null 2>&1; then
    if python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$f" 2>/dev/null; then ok "valid JSON: $f"; else no "invalid JSON: $f"; fi
  elif command -v node >/dev/null 2>&1; then
    if node -e 'JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"))' "$f" 2>/dev/null; then ok "valid JSON: $f"; else no "invalid JSON: $f"; fi
  else
    skip "valid JSON: $f" "no python3/node"
  fi
}

valid_model() {
  local f="$1" m
  m=$(grep -m1 '^model:' "$f" 2>/dev/null | sed 's/^model:[[:space:]]*//' | tr -d '"' | tr -d ' ')
  case "$m" in
    opus|sonnet|haiku) ok "valid model ($m): $f" ;;
    claude-*)          ok "valid model ($m): $f" ;;
    "")                no "no model field: $f" ;;
    *)                 no "unknown model '$m': $f" ;;
  esac
}

# ---- tests ------------------------------------------------------------------

test_repo_structure() {
  section "repo structure"
  for s in claude-init onboard update doctor; do
    have_file ".claude/skills/$s/SKILL.md"
  done
  have_file ".claude/skills/claude-init/reference/test-bootstrap.md"
  have_file ".claude/skills/claude-init/reference/architecture-template.md"
  have_file ".github/workflows/self-learn.yml"
  have_file ".github/prompts/self-learn.md"
  have_file "LEARNINGS.md"
  contains ".github/workflows/self-learn.yml" ".github/prompts/self-learn.md" "self-learn workflow reads its prompt file"
  contains ".github/prompts/self-learn.md" "LEARNINGS.md" "self-learn prompt uses the learnings log"
  contains ".claude/skills/claude-init/SKILL.md" "reference/test-bootstrap.md" "generator links its test-bootstrap reference"
  contains ".claude/skills/claude-init/SKILL.md" "reference/architecture-template.md" "generator links its architecture-template reference"
  have_file "README.md"
  have_file "CLAUDE.md"
  have_file "LICENSE"
  have_file ".claude-plugin/plugin.json"
  have_file "scripts/install.sh"
  have_dir  "templates/skills"
  have_dir  "templates/agents"
  have_dir  "templates/rules"
}

test_plugin_manifest() {
  section "plugin manifest"
  local f=".claude-plugin/plugin.json"
  valid_json "$f"
  for s in claude-init onboard update doctor; do
    contains "$f" "skills/$s" "plugin.json registers skills/$s"
    have_dir ".claude/skills/$s"
  done
}

test_core_skill_frontmatter() {
  section "core skill frontmatter (.claude/skills)"
  for f in .claude/skills/*/SKILL.md; do
    has_frontmatter "$f"
    matches "$f" '^name:[[:space:]]*[^[:space:]]' "has name: $f"
    matches "$f" '^description:[[:space:]]*[^[:space:]]' "has description: $f"
  done
}

test_template_skill_frontmatter() {
  section "skill template frontmatter (templates/skills)"
  for f in templates/skills/*/SKILL.md; do
    has_frontmatter "$f"
    matches "$f" '^name:[[:space:]]*[^[:space:]]' "has name: $f"
    matches "$f" '^description:[[:space:]]*[^[:space:]]' "has description: $f"
    matches "$f" '^allowed-tools:[[:space:]]*[^[:space:]]' "has allowed-tools: $f"
  done
}

test_rationalization_prevention() {
  section "rationalization-prevention in discipline skills"
  # The spec requires Red Flags / rationalization tables in these skills.
  # finish/ and devils-advocate/ are intentionally exempt.
  for s in clarify plan review subagent-dev test verify; do
    matches "templates/skills/$s/SKILL.md" 'Red Flags|[Rr]ationaliz' \
      "$s has a Red Flags / rationalization table"
  done
}

test_finish_skill() {
  section "finish skill contract"
  local f="templates/skills/finish/SKILL.md"
  contains "$f" "Merge locally"       "finish offers: Merge locally"
  contains "$f" "Push & create PR"    "finish offers: Push & create PR"
  contains "$f" "Keep branch"         "finish offers: Keep branch"
  contains "$f" "Discard"             "finish offers: Discard"
  contains "$f" 'type "discard"'      "finish requires typed discard confirmation"
  contains "$f" "NEVER merge without passing tests" "finish gates merge on passing tests"
}

test_tdd_skill() {
  section "tdd skill contract"
  local f="templates/skills/test/SKILL.md"
  contains "$f" "NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST" "tdd states the Iron Law"
  contains "$f" "RED-GREEN-REFACTOR" "tdd documents RED-GREEN-REFACTOR"
}

test_clarify_skill() {
  section "clarify skill spec-persistence"
  local f="templates/skills/clarify/SKILL.md"
  contains "$f" "docs/specs/"            "clarify persists specs to docs/specs/"
  contains "$f" "spec reviewer subagent" "clarify dispatches a spec reviewer subagent"
  contains "$f" "Max 2 iterations"       "clarify caps reviewer iterations at 2"
  matches  "$f" "[Ww]ait for user approval" "clarify gates on user approval"
}

test_workflow_rule() {
  section "workflow rule pipeline"
  local f="templates/rules/workflow.md"
  for step in "1. Understand" "2. Plan" "3. Implement" "4. Verify" "5. Self-Review" "6. Finish"; do
    contains "$f" "$step" "workflow has step: $step"
  done
  contains "$f" "Scaling the Process" "workflow documents process scaling"
  for cmd in /clarify /plan /tdd /review /verify /subagent-dev /finish; do
    contains "$f" "$cmd" "workflow lists skill: $cmd"
  done
}

test_agents() {
  section "agent templates"
  for f in templates/agents/*.md; do
    has_frontmatter "$f"
    matches "$f" '^name:[[:space:]]*[^[:space:]]' "has name: $f"
    matches "$f" '^description:[[:space:]]*[^[:space:]]' "has description: $f"
    valid_model "$f"
  done
  # model tiering invariant: critical-reasoning persona on opus, fast persona on haiku
  matches "templates/agents/architect.md"  '^model:[[:space:]]*opus'  "architect runs on opus"
  matches "templates/agents/researcher.md" '^model:[[:space:]]*haiku' "researcher runs on haiku"
}

test_hooks() {
  section "safety hooks template"
  local f="templates/hooks/settings.json"
  valid_json "$f"
  contains "$f" "git push --force" "hooks deny force-push"
  contains "$f" "Read(~/.ssh/**)"  "hooks deny reading ~/.ssh"
  matches  "$f" 'npm[[:space:]]+publish|npm publish' "hooks guard npm publish"
  # PreToolUse must use the modern decision schema, not the legacy {"decision":...} form
  contains "$f" "hookSpecificOutput"   "hooks use modern hookSpecificOutput schema"
  contains "$f" "permissionDecision"   "hooks use permissionDecision field"
  absent   "$f" '"decision"[[:space:]]*:' "hooks avoid the legacy decision field (ignored by PreToolUse)"
}

test_skill_descriptions() {
  section "skill descriptions: third-person + when-to-use trigger"
  # Every skill template's description must carry a discovery trigger so it fires reliably.
  for f in templates/skills/*/SKILL.md; do
    local desc
    desc=$(awk -F'description:' '/^description:/{print $2; exit}' "$f")
    if printf '%s' "$desc" | grep -qiE 'use when|use before|auto-triggered|use after|use during'; then
      ok "trigger phrase in description: $f"
    else
      no "description lacks a when-to-use trigger: $f"
    fi
    # third-person guard: description must not open in first/second person
    if printf '%s' "$desc" | grep -qiE '^[[:space:]]*"?(I |I'\''|You |You'\''|We |We'\'')'; then
      no "description not third-person: $f"
    else
      ok "third-person description: $f"
    fi
  done
}

test_tdd_guard_optional() {
  section "optional tdd-guard hook template"
  local f="templates/hooks/tdd-guard.md"
  have_file "$f"
  contains "$f" "tdd-guard"          "tdd-guard references the upstream project"
  contains "$f" "hookSpecificOutput" "tdd-guard documents the modern hook schema"
  matches  "$f" "[Oo]pt-in"          "tdd-guard is documented as opt-in"
}

test_update_template_sync() {
  section "update skill: template-sync mode"
  local f=".claude/skills/update/SKILL.md"
  matches  "$f" "[Tt]emplate [Ss]ync"   "update has a template-sync step"
  contains "$f" "claude-init-templates"  "template sync resolves the installed templates"
  # it must know about the specific stale patterns it is meant to repair
  contains "$f" '"decision"'             "template sync flags the legacy hook decision form"
  contains "$f" "hookSpecificOutput"     "template sync names the modern hook schema as the fix"
  contains "$f" "(template sync)"         "template-sync changes are tagged in the proposal"
}

test_line_limits() {
  section "template line limits (<=150)"
  for f in $(find templates -name '*.md' | sort); do
    max_lines "$f" 150
  done
}

test_installer() {
  section "installer"
  local f="scripts/install.sh"
  is_executable "$f"
  if bash -n "$f" 2>/dev/null; then ok "install.sh passes bash -n syntax check"; else no "install.sh has syntax errors"; fi
  contains "$f" "set -euo pipefail" "install.sh uses strict mode"
  for s in claude-init onboard update doctor; do
    contains "$f" "$s" "install.sh installs skill: $s"
  done
}

test_no_conflict_markers() {
  section "no merge-conflict markers"
  # scan tracked text files; '=======' alone is legit (markdown rules), so anchor on <<<<<<< / >>>>>>>
  local hit=0
  while IFS= read -r f; do
    if grep -qE '^(<<<<<<<|>>>>>>>) ' "$f" 2>/dev/null; then no "conflict marker in $f"; hit=1; fi
  done < <(git ls-files '*.md' '*.json' '*.sh' '*.yml' 2>/dev/null)
  [ "$hit" -eq 0 ] && ok "no conflict markers in tracked files"
}

# ---- run --------------------------------------------------------------------
printf "${D}claude-init self-tests — %s${Z}\n" "$ROOT"
test_repo_structure
test_plugin_manifest
test_core_skill_frontmatter
test_template_skill_frontmatter
test_rationalization_prevention
test_finish_skill
test_tdd_skill
test_clarify_skill
test_workflow_rule
test_agents
test_hooks
test_skill_descriptions
test_tdd_guard_optional
test_update_template_sync
test_line_limits
test_installer
test_no_conflict_markers

TOTAL=$((PASSED + FAILS))
printf "\n${D}----------------------------------------${Z}\n"
printf "checks: %d   passed: %d   failed: %d   skipped: %d\n" "$TOTAL" "$PASSED" "$FAILS" "$SKIPS"
if [ "$FAILS" -eq 0 ]; then
  printf "${G}RESULT: PASS${Z}\n"
  exit 0
else
  printf "${R}RESULT: FAIL${Z}\n"
  exit 1
fi
