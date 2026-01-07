# Technical documentation writing principles

Apply to READMEs, runbooks, API docs, setup guides, error messages, and related technical documentation.

## Formatting

Wrap technical identifiers in backticks: paths, config values, commands, identifiers.

Use fenced code blocks with language hints. Include blank lines before and after.

## Specificity over vagueness

| Vague | Specific |
|-------|----------|
| "configure the service" | "Set `max_connections` to `100` in `config.yaml`" |
| "check the logs" | "Search `/var/log/app.log` for `ERROR` entries" |
| "enable the option" | "Set `feature.enabled` to `true`" |

## Testable procedures

Verification steps must be executable, not descriptive.

Correct: "Verify the service is running: `systemctl status myapp`"

Incorrect: "Make sure the service is working properly."

## Step structure

Each step should do all of the following:
1. Start with an action verb
2. Specify the exact target (file, command, setting)
3. Include concrete values

Example:

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
- Wrap technical terms in backticks
- Include specific commands and paths
- Make errors actionable with remediation steps

Don't:
- Use generic errors ("something failed")
- Skip expected outcomes in verification
