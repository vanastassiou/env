# Documentation writing principles

Apply to READMEs, runbooks, API docs, setup guides, and error messages.

## Core principles

- Scannable: headers, lists, and whitespace guide the eye
- Actionable: each instruction produces a concrete outcome
- Specific: answer WHAT, WHERE, HOW, and WHAT VALUE

## Formatting

Use numbered lists for ordered procedures. Separate paragraphs with blank lines. Wrap technical identifiers in backticks: paths, config values, commands, identifiers.

Use fenced code blocks with language hints. Include blank lines before and after.

Use ATX headers (`#`, `##`, `###`) not bold text for sections.

## Specificity over vagueness

| Vague | Specific |
|-------|----------|
| "configure the service" | "Set `max_connections` to `100` in `config.yaml`" |
| "check the logs" | "Search `/var/log/app.log` for `ERROR` entries" |
| "enable the option" | "Set `feature.enabled` to `true`" |

## Testable procedures

Verification steps must be executable, not descriptive.

```
Verify the service is running: `systemctl status myapp`
Test the endpoint: `curl localhost:8080/api/health`
Confirm response status is `200` with body `{"status": "ok"}`
```

Not: "Make sure the service is working properly."

## Step structure

Each step should:
1. Start with an action verb
2. Specify the exact target (file, command, setting)
3. Include concrete values

```
1. Open `config/app.yaml`
2. Set `pool_size` to `20`
3. Restart: `systemctl restart myapp`
```

## Error reporting

Errors must include:
- operation: what failed ("Parsing config line 42")
- target: resource involved (`/config/settings.yaml`)
- actual: what happened ("unexpected token")
- remediation: executable fix steps

Forbidden: "Something went wrong", "Invalid input", "Try again", "Check your configuration"

## Severity levels

| Level | Definition | Action |
|-------|------------|--------|
| CRITICAL | Process cannot continue | Halt, require intervention |
| ERROR | Operation cannot complete | Stop, report, await fix |
| WARNING | Degraded results | Log, continue, note in report |
| INFO | Notable but non-blocking | Log, continue |

## Quick reference

Do:
- Use `#` headers, not bold for sections
- Use numbered lists for procedures
- Separate paragraphs with blank lines
- Wrap technical terms in backticks
- Include specific commands and paths
- Make errors actionable with remediation steps
- Use sentence case (exception: media titles)

Don't:
- Write wall-of-text paragraphs
- Use generic errors ("something failed")
- Skip expected outcomes in verification
- Mix multiple concepts in one paragraph
