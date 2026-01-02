# Global style guidelines

## General principles

- Prefer editing existing files over creating new ones
- Keep changes minimal and focused
- No emojis unless explicitly requested
- Include file paths when referencing code

## Markdown formatting

### Tables

- Align columns with consistent padding
- Use leading and trailing pipes
- Header separator uses dashes only (no colons for alignment)

```markdown
| Column A | Column B | Column C     |
| -------- | -------- | ------------ |
| value    | value    | longer value |
```

### Lists

- Use dashes (-) for unordered lists, not asterisks
- Use consistent indentation (2 spaces for nested items)
- No blank lines between list items unless they contain multi-line content

### Headers

- Use ATX-style headers (#, ##, ###)
- Sentence case for headers ("Getting started", not "Getting Started")
- No trailing punctuation on headers
- Single blank line before and after headers
- Include TOC markers for documents with 3+ sections:
  ```markdown
  <!-- toc -->
  <!-- tocstop -->
  ```

### Line length

- Wrap prose at 80 characters
- Do not wrap tables, code blocks, or URLs

## Terraform conventions

### File organization

Each module follows this structure:

| File              | Purpose                               |
| ----------------- | ------------------------------------- |
| providers.tf      | Terraform and provider configuration  |
| variables.tf      | Input variables with validation       |
| locals.tf         | Computed values and for_each maps     |
| data-sources.tf   | Data source references                |
| outputs.tf        | Output values                         |
| *.tf              | Resource-specific files (project.tf)  |

### Naming conventions

- Resource names: lowercase with hyphens (my-resource)
- Variable names: lowercase with underscores (my_variable)
- Local values: lowercase with underscores
- Use `for_each` over `count` for collections
- Use maps in locals for scalable resource creation

### Variables

- All variables must have `description`
- Use `nullable = false` for required variables
- Include `validation` blocks for constrained inputs
- Group related variables with comment headers

```hcl
# Project configuration

variable "project_name" {
  type        = string
  description = "Project name for resource naming"
  nullable    = false

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must be lowercase alphanumeric with hyphens."
  }
}
```

### Comments

- Use `#` comments for section headers
- Use inline comments sparingly for non-obvious logic
- Reference external docs with URLs when relevant
