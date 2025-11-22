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
