#!/bin/bash
set -euo pipefail

# claude-init installer
# Copies setup, onboard, update, and doctor skills to ~/.claude/skills/

REPO_URL="https://github.com/yash-gadodia/claude-init"
INSTALL_DIR="$HOME/.claude/skills"

echo "Installing claude-init skills to $INSTALL_DIR..."

# Check if git is available
if ! command -v git &>/dev/null; then
  echo "Error: git is required. Install it and retry."
  exit 1
fi

# Clone to temp dir
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT
git clone --depth 1 "$REPO_URL" "$TMPDIR/claude-init" 2>/dev/null

# Create skills directory if needed
mkdir -p "$INSTALL_DIR"

# Copy core skills (the ones that run FROM claude-init, not templates)
for skill in setup onboard update doctor; do
  if [ -d "$TMPDIR/claude-init/.claude/skills/$skill" ]; then
    cp -r "$TMPDIR/claude-init/.claude/skills/$skill" "$INSTALL_DIR/"
    echo "  Installed /skill: $skill"
  fi
done

# Also copy the templates directory so /setup can reference them
TEMPLATES_DIR="$HOME/.claude/claude-init-templates"
if [ -d "$TMPDIR/claude-init/templates" ]; then
  rm -rf "$TEMPLATES_DIR"
  cp -r "$TMPDIR/claude-init/templates" "$TEMPLATES_DIR"
  echo "  Installed templates to $TEMPLATES_DIR"
fi

echo ""
echo "Done! Skills installed:"
echo "  /setup   — Analyze a repo and generate .claude/ config"
echo "  /onboard — Quick onboarding to any codebase"
echo "  /update  — Re-analyze and update existing config"
echo "  /doctor  — Validate your .claude/ setup"
echo ""
echo "Usage: cd /path/to/your-repo && claude"
echo "Then type: /setup"
