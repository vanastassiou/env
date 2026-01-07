# General writing principles

## Core principles

- Scannable: headers, lists, and whitespace guide the eye
- Actionable: each instruction produces a concrete outcome
- Specific: answer WHAT, WHERE, HOW, and WHAT VALUE

## Formatting

Use numbered lists for ordered procedures.

Separate paragraphs with blank lines.

Use ATX headers (`#`, `##`, `###`) for sections, not bold text.

Use sentence case, not title case, except for actual titles of media (books, movies, songs, etc.)

Use hyphens or double-dashes instead of em dashes.

## Tone and wording

One main idea per paragraph. Each paragraph should contain information that is new to the document and useful. No filler.

State the point directly; avoid parallel constructions like "it's not just X, it's Y".

Avoid empty summaries that restate what was already said; end sections with new information or omit the summary.

Only use demonstrative pronouns with clear antecedents. Incorrect: "This is important"; correct: "This constraint is important".

Use topic-appropriate subjects ("The API returns..." not "It returns..." when introducing a concept).

Vary sentence lengths.

When using jargon, verify it is actually used in the domain. Define on first use: Full Name (ACRONYM).

When making claims, include specific examples or data, citing a reputable source. Incorrect: "improves performance"; correct: "reduces latency by 40ms".

Do not use rhetorical questions for drama (examples to avoid: "The twist?", "The kicker?").

Maintain a measured tone. Avoid marketing speak or exaggerated enthusiasm: "game-changing", "incredibly powerful", "exciting".

Do not use emoji unless explicitly requested.

## Step structure for instructions

Each step should:
1. Start with an imperative
2. Specify the exact target (file, command, setting)
3. Include concrete values

```
1. Open `config/app.yaml`
2. Set `pool_size` to `20`
3. Restart: `systemctl restart myapp`
```
