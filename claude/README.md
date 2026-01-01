# Claude Code configuration

Shared configuration files for Claude Code across projects.

## File references

The `@path` syntax includes file contents in CLAUDE.md. References do not chain transitively (a file included via `@` won't expand its own `@` references).

### Organizing shared standards

Multiple files (use when projects need different subsets):
```markdown
@~/repos/env/claude/general-writing-principles.md
@~/repos/env/claude/tech-writing-principles.md
```

Single combined file (use when standards always apply together):
```markdown
@~/repos/env/claude/writing-standards.md
```

No processing difference between approaches. Choose based on reusability needs.

## Instructions vs agent definitions

### Instructions files (CLAUDE.md and referenced files)

Apply automatically to every interaction. Use for:
- Universal standards and formatting preferences
- Project context and architecture notes
- Things you never want to repeat or remind about

Examples:
- "Use sentence case for headers"
- "This project uses proxy-based state management"

### Agent definitions

Invoked selectively via Task tool. Use for:
- Specialized behavior for specific task types
- Repeatable workflows with consistent behavior
- Long guidance that shouldn't consume context on every interaction

Examples:
- Editor that rewrites text to remove LLM patterns
- Code reviewer that checks for security issues
- Commit message generator following conventional commits

### Rule of thumb

"Always do X" → instructions file

"When doing Y, do X" → agent definition
