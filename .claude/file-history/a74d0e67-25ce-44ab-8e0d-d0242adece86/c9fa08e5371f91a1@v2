# Automatic Documentation Review with editor-anti-llm

This guide shows how the global automatic documentation review system works with the editor-anti-llm agent.

## How It Works

The system automatically reviews and improves all documentation files you create or edit in any Claude project. The review happens transparently through hooks configured in `~/.claude/hooks/`.

## Configuration Location

All configuration is stored globally at:
- `~/.claude/hooks/documentation.config.json` - Main configuration
- `~/.claude/hooks/post-write` - Triggers on file creation
- `~/.claude/hooks/post-edit` - Triggers on file edits
- `~/.claude/hooks/pre-commit` - Triggers before git commits
- `~/.claude/agents/documentation-chain.json` - Agent workflows
- `~/.claude/standards/documentation.json` - Quality standards

## Usage Examples

### Automatic Review on File Write

When you create any documentation file, it automatically gets reviewed:

```bash
# You write a file
claude: Write a README.md for this project

# Behind the scenes, the post-write hook:
# 1. Detects README.md matches documentation pattern
# 2. Loads configuration (audience: enduser, mode: strict)
# 3. Runs editor-anti-llm automatically
# 4. Applies improvements
# 5. Logs the review

# You get the improved version automatically
```

### Automatic Review on File Edit

When you edit existing documentation:

```bash
# You edit documentation
claude: Update the API documentation to add the new endpoint

# Behind the scenes, the post-edit hook:
# 1. Detects docs/api/*.md matches pattern
# 2. Loads configuration (audience: developer, mode: strict)
# 3. Runs editor-anti-llm
# 4. Re-stages file for git if modified
# 5. Logs the review
```

### Pre-Commit Review

Before committing documentation changes:

```bash
# You commit changes
git commit -m "Update docs"

# Pre-commit hook runs:
📋 Reviewing staged documentation files before commit...
  Reviewing: README.md (mode: strict, audience: enduser)
    ✓ Reviewed and improved
  Reviewing: docs/api/endpoints.md (mode: strict, audience: developer)
    ✓ Reviewed (no changes needed)

✅ Documentation review complete:
   Files reviewed: 2
   Files improved: 1
```

## Agent Chain Integration

When using documentation generation agents, the review happens automatically:

```bash
# Example 1: Generate API documentation
Task("Generate API Docs", "Create OpenAPI documentation", "api-docs")
# Automatically triggers editor-anti-llm after completion

# Example 2: Create README
Task("Create README", "Generate project README", "base-template-generator")
# Automatically triggers editor-anti-llm with enduser config

# Example 3: Write user guide
Task("Write Guide", "Create installation guide", "documenter")
# Automatically triggers editor-anti-llm with mixed audience config
```

## File Pattern Matching

The system automatically reviews files matching these patterns:

### Included Patterns
- `*.md` - All markdown files in root
- `docs/**/*.md` - All docs directory markdown
- `**/*.mdx` - All MDX files anywhere
- `api/documentation/**` - API documentation
- `guides/**/*.md` - User guides

### Excluded Patterns
- `node_modules/**` - Dependencies
- `.git/**` - Git internals
- `CHANGELOG.md` - Changelog files
- `LICENSE.md` - License files

## Configuration Per File Type

Different documentation types get different review configurations:

### README.md
```json
{
  "mode": "strict",
  "audience": "enduser",
  "rules": {
    "defineTermsOnFirstUse": true,
    "requireSpecificExamples": true,
    "includeVersionNumbers": true
  }
}
```

### docs/api/**
```json
{
  "mode": "strict",
  "audience": "developer",
  "rules": {
    "requireErrorExamples": true,
    "validateCodeExamples": true,
    "includeVersionNumbers": true
  }
}
```

### docs/guides/**
```json
{
  "mode": "strict",
  "audience": "enduser",
  "rules": {
    "defineTermsOnFirstUse": true,
    "noJargon": true
  }
}
```

## What Gets Fixed Automatically

The editor-anti-llm agent removes AI patterns and improves quality:

| Issue | Before | After |
|-------|--------|-------|
| Empty intro | "This section describes authentication" | Direct explanation of OAuth flow |
| Parallel construction | "It's not just secure, it's fast" | "The API provides secure, fast authentication" |
| Undefined acronym | "Use the CLI" | "Use the CLI (Command Line Interface)" |
| Vague example | "Various options available" | List of specific configuration options |
| Em dash | "important—critical" | "important and critical" or restructured |
| Filler conclusion | "In summary, we covered..." | Removed or replaced with new information |

## Monitoring Reviews

All reviews are logged to `~/.claude/logs/reviews.log`:

```
2025-11-21T20:30:15-08:00 | README.md | strict | enduser
2025-11-21T20:31:22-08:00 | EDIT | docs/api/auth.md | strict | developer
2025-11-21T20:35:45-08:00 | PRE-COMMIT | Reviewed: 3 | Modified: 2
```

## Enabling/Disabling

### Disable Globally
Edit `~/.claude/hooks/documentation.config.json`:
```json
{
  "auto-review": {
    "enabled": false
  }
}
```

### Disable Specific Hooks
```json
{
  "auto-review": {
    "hooks": {
      "post-write": true,
      "post-edit": false,
      "pre-commit": true
    }
  }
}
```

### Enable Verbose Notifications
```json
{
  "auto-review": {
    "notifications": {
      "enabled": true,
      "verbose": true
    }
  }
}
```

## Special Cases

### Legal Documentation
Legal docs get review-only mode (no auto-apply):
```json
{
  "special-cases": {
    "legal-documentation": {
      "config": {
        "mode": "review-only",
        "autoApply": false,
        "requireApproval": true
      }
    }
  }
}
```

### External Documentation
Public-facing docs get multiple reviews:
```json
{
  "special-cases": {
    "external-documentation": {
      "auto-chain": {
        "after": ["editor-anti-llm", "reviewer"]
      }
    }
  }
}
```

## Troubleshooting

### Hook not running
1. Check hooks are executable: `ls -la ~/.claude/hooks/`
2. Verify config exists: `cat ~/.claude/hooks/documentation.config.json`
3. Check enabled: `jq '.["auto-review"].enabled' ~/.claude/hooks/documentation.config.json`

### Reviews not applying changes
1. Check autoApply setting in config
2. Verify file permissions
3. Check log for errors: `tail ~/.claude/logs/reviews.log`

### File not matched
1. Check pattern matching in config
2. Verify file not in exclude list
3. Enable verbose notifications to see matching logic

## Best Practices

1. **Let it run automatically** - Don't disable unless necessary
2. **Trust the improvements** - The agent follows strict quality rules
3. **Review the logs** - Check what's being changed over time
4. **Adjust patterns** - Add project-specific patterns to config
5. **Configure per-project** - Override global config in project `.claude/hooks/` if needed
6. **Monitor impact** - Check git diffs to see improvements

## Integration with Workflows

The automatic review integrates seamlessly with documentation workflows:

```bash
# API Documentation Workflow
1. Task("code-analyzer") → Extract API signatures
2. Task("api-docs") → Generate documentation
3. [Automatic] editor-anti-llm → Review and improve
4. Task("tester") → Validate examples

# README Generation Workflow
1. Task("researcher") → Analyze project
2. Task("base-template-generator") → Create README
3. [Automatic] editor-anti-llm → Remove boilerplate
4. Task("reviewer") → Final check

# User Guide Workflow
1. Task("planner") → Outline structure
2. Task("documenter") → Write content
3. [Automatic] editor-anti-llm → Ensure clarity
```

The key advantage is you never have to manually trigger the review - it happens automatically at the right points in your workflow.
