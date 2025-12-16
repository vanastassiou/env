# Pre-commit linter and code formatter config

This directory contains configurations used by the [Python `pre-commit` framework](https://pre-commit.com/).

The configurations support the following linters/formatters:

- [MarkdownLint](https://github.com/DavidAnson/markdownlint): Markdown style enforcement (80-char lines, consistent headings)
- [Prettier](https://prettier.io/): Opinionated formatter for JS/TS/JSON/CSS/HTML (80-char lines, YAML at 120)
- [YamlLint](https://github.com/adrienverge/yamllint): YAML style checker (120-char lines, indentation rules)
- [Shellcheck](https://github.com/koalaman/shellcheck): Shell script static analysis (catches common bugs)
- [Black](https://github.com/psf/black): Uncompromising Python formatter (80-char lines)
- [Ruff](https://github.com/astral-sh/ruff): Fast Python linter in Rust (replaces flake8, isort, pyupgrade)

By default, pre-commit hooks enforced by `pre-commit` are defined in the project root in `.pre-commit-config.yaml`.

## Setup

You may use the helper script `install-dev-tools.sh` as a shortcut.

### Install dependencies

- [`python`](https://www.python.org/downloads/)
- [`pipx`](https://pipx.pypa.io/stable/installation/) (recommended for Python CLI tools)
- [`npm`](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- [MarkdownLint](https://github.com/DavidAnson/markdownlint?tab=readme-ov-file#install)
- [Prettier](https://prettier.io/docs/install)
- [YamlLint](https://github.com/adrienverge/yamllint?tab=readme-ov-file#installation)
- [Shellcheck](https://github.com/koalaman/shellcheck?tab=readme-ov-file#installing)
- [Black](https://black.readthedocs.io/en/stable/getting_started.html)
- [Ruff](https://docs.astral.sh/ruff/installation/)

### Install VS Code extensions

When the project is opened as a VS Code workspace, VS Code uses these extensions
according to configuration defined in `.vscode/settings.json` relative to the
project root. You must install the VS Code extensions to support this behaviour.

- [MarkdownLint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- YAML
  - [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml): Syntax validation
  - [YamlLint](https://marketplace.visualstudio.com/items?itemName=prantlf.vscode-yaml-linter): `yamllint` rule enforcement
- [Shellcheck](https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck)
- [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff): Python linting and formatting

## VS Code Format-on-Save Configuration

VS Code can run the same formatting and validation as pre-commit hooks
automatically when you save files. This requires:

1. Installing the VS Code extensions (see above)
2. Copying VS Code settings to your project root's `.vscode/settings.json`

The canonical VS Code settings file lives in the `env` repo at:

```text
~/repos/env/pre-commit-config/.vscode/settings.json
```

### Programmatic Setup

To configure format-on-save programmatically for your project:

```bash
# From your project root, run:
./.pre-commit-config/install-dev-tools.sh
```

Or manually:

```bash
# 1. Copy VS Code settings from env repo to project root
mkdir -p .vscode
cp ~/repos/env/pre-commit-config/.vscode/settings.json .vscode/settings.json

# 2. Install VS Code extensions via CLI
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension esbenp.prettier-vscode
code --install-extension redhat.vscode-yaml
code --install-extension prantlf.vscode-yaml-linter
code --install-extension timonwong.shellcheck
code --install-extension charliermarsh.ruff

# 3. (Optional) Create extensions.json for workspace recommendations
cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "DavidAnson.vscode-markdownlint",
    "esbenp.prettier-vscode",
    "redhat.vscode-yaml",
    "prantlf.vscode-yaml-linter",
    "timonwong.shellcheck",
    "charliermarsh.ruff"
  ]
}
EOF
```

### What Each Setting Does

The `.vscode/settings.json` configures:

| File Type | Formatter | Actions on Save |
|-----------|-----------|-----------------|
| Python | Ruff | Format, fix lint errors, organize imports |
| YAML | Prettier | Format |
| JSON/JSONC | Prettier | Format |
| Markdown | Prettier + MarkdownLint | Format (Prettier), fix lint violations (MarkdownLint) |
| Shell scripts | ShellCheck | Lint (no auto-fix) |

**Note on Markdown:** MarkdownLint is a linter, not a formatter. It highlights
style violations but cannot reformat documents. The settings use Prettier as
the formatter (for consistent whitespace/line breaks) and MarkdownLint's
`source.fixAll.markdownlint` code action to auto-fix linting violations on save.

Global settings applied to all files:

- `editor.formatOnSave`: Run formatter on save
- `files.trimTrailingWhitespace`: Remove trailing whitespace
- `files.insertFinalNewline`: Ensure files end with newline
- `files.eol`: Use Unix line endings (`\n`)

### Configuration File Paths

The settings reference config files in `.pre-commit-config/.config/`:

- `ruff.toml` - Ruff linter/formatter rules
- `.prettierrc.yaml` - Prettier formatting options
- `.markdownlint.yaml` - MarkdownLint rules
- `.shellcheckrc` - ShellCheck exclusions
- `.yamllint.yaml` - YamlLint rules (used by pre-commit, not VS Code)

### Troubleshooting

**Extensions not working:**

```bash
# Verify extensions are installed
code --list-extensions | grep -E 'markdownlint|prettier|yaml|shellcheck|ruff'
```

**Config paths not resolving:**

Ensure you open VS Code at the project root where `.pre-commit-config/` exists.
Settings use relative paths from the workspace root.

**Python formatting not applying:**

```bash
# Verify Ruff extension is using correct config
# Check VS Code Output panel > Ruff for errors
# Ensure ruff.toml syntax is valid
ruff check --config .pre-commit-config/.config/ruff.toml .
```

**Conflicting formatters:**

If you have Black extension installed, it may conflict with Ruff formatting.
The settings explicitly set Ruff as the Python formatter. Disable or uninstall
`ms-python.black-formatter` if conflicts occur.
