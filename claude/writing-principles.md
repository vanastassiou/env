# Documentation Writing Principles

These principles apply to technical writers, developers writing documentation, and AI systems generating instructional content. Use them when creating READMEs, runbooks, API docs, setup guides, and error messages.

## Purpose

Documentation following these principles should be:

- **Scannable**: Readers locate information without reading everything. Headers, lists, and whitespace guide the eye.
- **Actionable**: Each instruction produces a concrete outcome. Readers know exactly what to do.
- **Consistent**: Similar content uses similar structure. Once readers learn the pattern, they navigate faster.
- **Portable**: The rules work for web services, CLI tools, desktop apps, and hardware. Domain examples change; principles stay constant.

## Markdown Formatting

### Numbered Lists

Use numbered lists for step-by-step procedures where order matters. Use single spacing between list items.

**Format:**

```
1. First step
2. Second step
3. Third step
```

**Correct:**

```
1. Enable the feature in service settings
2. Configure the `timeout` parameter to `30`
3. Validate by checking the status endpoint
```

**Incorrect:**

```
Step 1: Enable the feature; Step 2: Configure timeout; Step 3: Validate.
```

### Paragraph Separation

Separate distinct concepts with blank lines. Each instruction or idea gets its own paragraph.

**Correct:**

```
Verify the configuration by reviewing the settings file.

Test the integration by sending a sample request.

Confirm success by checking the response status code.
```

**Incorrect:**

```
Verify the configuration by reviewing the settings file. Test the integration by sending a sample request. Confirm success by checking the response status code.
```

Dense single-paragraph walls of text are harder to scan and understand.

### Inline Code

Wrap technical identifiers in backticks to distinguish them from prose.

**Categories requiring backticks:**

| Category             | Examples                                       |
| -------------------- | ---------------------------------------------- |
| Configuration values | `true`, `false`, `enabled`, `disabled`, `null` |
| Numeric settings     | `30`, `1024`, `0.5`                            |
| File paths           | `config/settings.yaml`, `/var/log/app.log`     |
| Field paths          | `settings.timeout`, `config.api.endpoint`      |
| Identifiers          | `user-123`, `REQ-001`, `v2.1.0`                |
| Protocols            | `HTTP`, `HTTPS`, `SSH`, `TCP`                  |
| Standards            | `ISO 27001`, `RFC 7231`, `IEEE 802.11`         |
| Algorithms           | `SHA-256`, `RSA-2048`, `AES-128`               |

### Code Blocks

Wrap code and commands in fenced code blocks with language hints.

**Common language identifiers:**

| Language       | Fence             |
| -------------- | ----------------- |
| Shell commands | ` ```bash `       |
| JSON           | ` ```json `       |
| YAML           | ` ```yaml `       |
| SQL            | ` ```sql `        |
| Python         | ` ```python `     |
| JavaScript     | ` ```javascript ` |
| HCL/Terraform  | ` ```hcl `        |
| HTTP requests  | ` ```http `       |

**Spacing:** Include a blank line before and after code blocks.

### Headers

Use ATX-style headers (`#`) rather than underlines or bold text for sections.

**Structure:**

- `#` - Document title (one per document)
- `##` - Major sections
- `###` - Subsections
- `####` - Conditional or variant sections

**Conditional sections** (when content varies by context):

```
#### For Linux systems:
...

#### For Windows systems:
...
```

## Content Quality

### Specificity Over Vagueness

Replace vague terms with specific actions, locations, and values.

| Vague                   | Specific                                          |
| ----------------------- | ------------------------------------------------- |
| "implement the feature" | "Add the handler function to `api/routes.py`"     |
| "configure the service" | "Set `max_connections` to `100` in `config.yaml`" |
| "use appropriate tools" | "Run `npm test` to execute the test suite"        |
| "enable the option"     | "Set `feature.enabled` to `true`"                 |
| "check the logs"        | "Search `/var/log/app.log` for `ERROR` entries"   |

When writing instructions, answer:

- **WHAT** setting or file?
- **WHERE** in the system?
- **HOW** specifically (command, UI path, API call)?
- **WHAT VALUE** to use?

### Testable Procedures

Verification steps must be executable, not descriptive.

**Use verification verbs:**

- Verify
- Test
- Confirm
- Validate
- Examine
- Check

**Include:**

- Specific actions to perform
- Expected outcomes
- Evidence to collect

**Correct:**

```
Verify the service is running by executing `systemctl status myapp`.

Test the endpoint by sending a GET request to `/api/health`.

Confirm success: response status should be `200` and body should contain `{"status": "ok"}`.
```

**Incorrect:**

```
Make sure the service is working properly and the API is accessible.
```

### Step-by-Step Structure

Remediation and setup instructions use numbered steps with specific actions.

Each step should:

1. Start with an action verb
2. Specify the exact target (file, command, setting)
3. Include concrete values
4. (Optional) Note expected outcome

**Example:**

```
1. Open the configuration file at `config/app.yaml`.

2. Locate the `database` section.

3. Set `pool_size` to `20`.

4. Save the file and restart the service with `systemctl restart myapp`.

5. Verify the change by checking `GET /api/config` returns `pool_size: 20`.
```

### Avoiding Wall-of-Text

Break content into digestible chunks:

- One concept per paragraph
- One action per step
- Use lists for related items
- Use tables for comparisons
- Use headers to organize sections

## Error Reporting

### Required Error Fields

Every error report must include:

| Field         | Description                    | Example                                       |
| ------------- | ------------------------------ | --------------------------------------------- |
| `operation`   | Specific operation that failed | "Parsing configuration file line 42"          |
| `target`      | Resource being operated on     | `/config/settings.yaml`                       |
| `expected`    | What should have happened      | "Valid YAML with required field `api_key`"    |
| `actual`      | What actually happened         | "Parse error: unexpected token at line 42"    |
| `root_cause`  | Why the failure occurred       | "Missing closing quote on line 41"            |
| `remediation` | Steps to fix (with commands)   | "Edit line 41, add closing quote after value" |
| `retryable`   | Whether retry might succeed    | `false` (requires manual fix)                 |

### Forbidden Generic Messages

Never use:

- "Something went wrong"
- "Processing failed"
- "Invalid input"
- "Error occurred"
- "Unable to complete task"
- "Check your configuration"
- "Try again"

These provide no actionable information.

### Actionable Remediation

Remediation steps must be executable.

**Correct:**

```
Remediation:
1. Open `/config/settings.yaml` in an editor
2. Go to line 41
3. Add closing quote: change `api_key: abc123` to `api_key: "abc123"`
4. Save file
5. Re-run: `./validate-config.sh`
```

**Incorrect:**

```
Fix the configuration file and try again.
```

### Severity Levels

| Level    | Definition                               | Action                                 |
| -------- | ---------------------------------------- | -------------------------------------- |
| CRITICAL | Process cannot continue                  | Halt immediately, require intervention |
| ERROR    | Current operation cannot complete        | Stop operation, report, await fix      |
| WARNING  | Operation proceeds with degraded results | Log, continue, note in report          |
| INFO     | Notable but non-blocking                 | Log, continue normally                 |

## Language Precision

### Concrete Over Abstract

Provide specific patterns, syntax, and examples rather than general descriptions.

**Abstract:** "Use a policy to control access."

**Concrete:** "Create a policy file at `policies/access.yaml` with rules specifying `allow` or `deny` for each resource pattern."

### Technology-Neutral Terminology

Use generic terms when documentation should apply across implementations:

| Domain-specific   | Generic                  |
| ----------------- | ------------------------ |
| "S3 bucket"       | "object storage"         |
| "Lambda function" | "serverless function"    |
| "RDS instance"    | "managed database"       |
| "IAM role"        | "service identity"       |
| "Security Group"  | "network access control" |

**When to keep domain-specific terms:** Operational runbooks, debugging guides, and deployment scripts benefit from exact terminology. A reader troubleshooting an AWS outage needs "S3 bucket," not "object storage." Generalize for principles and cross-platform guides; keep specifics for operational docs targeting a known environment.

### Preserve Intent

When generalizing domain-specific instructions, keep the operational meaning intact.

**Before (AWS-specific):**

```
Verify the S3 bucket policy denies public access by running:
aws s3api get-bucket-policy-status --bucket my-bucket
Confirm "IsPublic": false in the response.
```

**After (generalized):**

```
Verify the object storage policy denies public access.
Query the bucket's policy status through your provider's CLI or console.
Confirm the public access indicator is disabled/false.
```

The generalized version preserves: the security objective (deny public access), the verification method (check policy status), and the expected outcome (public access disabled). It loses only the AWS-specific command syntax.

## Quick Reference

### Do

- Use numbered lists for procedures
- Separate paragraphs with blank lines
- Wrap technical terms in backticks
- Use code fences with language hints
- Include specific commands and paths
- Make errors actionable
- Use verification verbs

### Don't

- Use title case except for actual titles of media (articles, books, music, etc.)
- Write wall-of-text paragraphs
- Use vague instructions ("configure appropriately")
- Report generic errors ("something failed")
- Skip expected outcomes in test procedures
- Mix multiple concepts in one paragraph
- Use bold instead of headers for sections
