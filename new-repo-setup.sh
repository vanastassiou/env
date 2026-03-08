#!/usr/bin/env bash

# Sets up pre-commit hooks, linter configs, and VS Code settings in a target
# repo by creating relative symlinks back to this env repo.
#
# Usage:
#   ~/repos/env/new-repo-setup.sh /path/to/target-repo

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-}"

if [[ -z "$TARGET_DIR" ]]; then
    echo -e "${RED}Usage: $0 /path/to/target-repo${NC}"
    exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

if [[ ! -d "$TARGET_DIR/.git" ]]; then
    echo -e "${RED}Error: $TARGET_DIR is not a git repository root${NC}"
    exit 1
fi

# Compute the relative path from target repo to env repo.
# Uses Python because reliable cross-platform relpath is hard in pure bash.
rel_env="$(python3 -c "import os; print(os.path.relpath('$ENV_DIR', '$TARGET_DIR'))")"

echo -e "${GREEN}Setting up repo:${NC} $TARGET_DIR"
echo -e "${GREEN}Env repo:${NC}       $ENV_DIR"
echo -e "${GREEN}Relative path:${NC}  $rel_env"
echo ""

# Create a symlink, backing up any existing file/link at the target.
create_symlink() {
    local link_target="$1"  # what the symlink points to (relative)
    local link_path="$2"    # where the symlink is created (absolute)
    local label="$3"        # display name

    if [[ -L "$link_path" ]]; then
        local current
        current="$(readlink "$link_path")"
        if [[ "$current" == "$link_target" ]]; then
            echo -e "${GREEN}ok${NC}      $label (already linked)"
            return
        fi
        echo -e "${YELLOW}update${NC}  $label (was -> $current)"
        rm "$link_path"
    elif [[ -e "$link_path" ]]; then
        local backup="${link_path}.bak"
        echo -e "${YELLOW}backup${NC}  $label -> ${backup}"
        mv "$link_path" "$backup"
    fi

    ln -s "$link_target" "$link_path"
    echo -e "${GREEN}link${NC}    $label -> $link_target"
}

# 1. Pre-commit config directory
create_symlink \
    "$rel_env/pre-commit-config" \
    "$TARGET_DIR/.pre-commit-config" \
    ".pre-commit-config"

# 2. Pre-commit config YAML
create_symlink \
    "$rel_env/.pre-commit-config.yaml" \
    "$TARGET_DIR/.pre-commit-config.yaml" \
    ".pre-commit-config.yaml"

# 3. VS Code workspace settings
create_symlink \
    "$rel_env/.vscode" \
    "$TARGET_DIR/.vscode" \
    ".vscode"

# 4. Install pre-commit hooks if pre-commit is available
echo ""
if command -v pre-commit &> /dev/null; then
    echo "Installing pre-commit hooks..."
    (cd "$TARGET_DIR" && pre-commit install)
    echo -e "${GREEN}ok${NC}      pre-commit hooks installed"
else
    echo -e "${YELLOW}skip${NC}    pre-commit not found -- install with: pipx install pre-commit"
fi

echo ""
echo -e "${GREEN}Done.${NC}"
