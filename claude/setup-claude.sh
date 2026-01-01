#!/bin/bash
# Setup script for Claude Code writing standards
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR/rules"

# Create global CLAUDE.md if it doesn't exist
if [ ! -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    cat > "$CLAUDE_DIR/CLAUDE.md" << 'EOF'
# Universal Standards

These standards apply to all my projects.

## Writing Standards

@~/repos/env/claude/writing-principles.md
EOF
    echo "Created ~/.claude/CLAUDE.md"
else
    echo "~/.claude/CLAUDE.md already exists, skipping"
fi

# Symlink agents directory
ln -sfn "$SCRIPT_DIR/agents" "$CLAUDE_DIR/agents"
echo "Linked agents directory"

echo "Done. Writing standards now apply to all projects."
