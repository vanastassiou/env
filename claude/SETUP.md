# Claude writing standards setup

This directory contains writing principles and tools for Claude Code.

## Contents

- `writing-principles.md` - documentation formatting and quality standards
- `writing-principles.json` - machine-readable version of the same rules
- `agents/editor-anti-llm.md` - agent that reviews documentation for AI patterns
- `setup-claude.sh` - setup script

## Installation

### Automatic setup (recommended)

Run the setup script:

```bash
cd ~/repos/env/claude
./setup-claude.sh
```

### Manual setup

1. Create global CLAUDE.md:

   ```bash
   cat > ~/.claude/CLAUDE.md << 'EOF'
   # Universal Standards
   @~/repos/env/claude/writing-principles.md
   EOF
   ```

2. Symlink agents:

   ```bash
   ln -sfn ~/repos/env/claude/agents ~/.claude/agents
   ```

## What this does

- Writing principles apply automatically to all projects
- No need to invoke slash commands
- Project-level CLAUDE.md files can extend or override these standards

## Usage

### Automatic application

After setup, writing standards apply to every Claude Code session. No action needed.

### Editor agent

To review documentation for AI patterns and quality issues:

```
@agent-editor-anti-llm path/to/file.md
```

### Project overrides

Individual projects can extend or override standards by creating their own `.claude/CLAUDE.md`:

```markdown
# Project Standards

Extends universal standards with project-specific guidelines.

@~/.claude/CLAUDE.md

## Project-specific rules

- Additional rules here...
```
