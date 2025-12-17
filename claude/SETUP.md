# Claude Writing Tools Setup

This repo contains writing principles and a documentation editor agent for Claude Code.

## Contents

- `writing-principles.md` - Documentation formatting and quality standards
- `writing-principles.json` - Machine-readable version of the same rules
- `agents/editor-anti-llm.md` - Agent that reviews documentation for AI patterns

## Installation

### 1. Create the slash command

Copy to `~/.claude/commands/writing-principles.md`:

```markdown
Read and apply the writing principles from /Users/vanastassiou/repos/env/claude/writing-principles.md for documentation tasks.

After reading, confirm you understand the key constraints:
- Specificity over vagueness (answer WHAT, WHERE, HOW, WHAT VALUE)
- Testable procedures with verification verbs
- No generic error messages
- Technology-neutral terminology (with exceptions for operational docs)
```

### 2. Copy the agent

```bash
cp agents/editor-anti-llm.md ~/.claude/agents/
```

## Usage

- `/writing-principles` - Load principles before documentation tasks
- `@agent-editor-anti-llm` - Review documentation for AI patterns and quality

### Workflow

1. Run `/writing-principles` before writing documentation
2. Write your content
3. Run `@agent-editor-anti-llm` on the file to review for issues
4. Apply recommended fixes
