# Global Rules

## Task Tracking with TodoWrite

Complex tasks fail when tracked mentally. Use TodoWrite to externalize progress for any task with 3+ steps, multi-file changes, or agent-provided recommendations.

The goal is preventing partial completions where items get skipped or forgotten mid-task. When an agent provides numbered recommendations, each becomes a separate todo item—working from memory of agent output leads to missed items.

Mark items complete immediately after finishing (not batched). Add a final "verify against original requirements" step to catch drift.

## Scope Discipline

Make only the changes requested. Avoid:
- Adding abstractions, helpers, or "improvements" beyond the ask
- Refactoring adjacent code during bug fixes
- Adding docstrings, comments, or type annotations to unchanged code
- Building for hypothetical future requirements

Three similar lines of code is better than a premature abstraction. The right complexity level is the minimum needed for the current task.

## When Explaining Workflows

Provide structural solutions, not aspirational advice. Instead of "be more careful," suggest file-based rules, configurations, or process changes that enforce the desired behavior.
