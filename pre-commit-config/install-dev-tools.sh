#!/bin/bash

set -e  # Exit on error

echo "==================================="
echo "Installing Development Tools"
echo "==================================="

# Update package list
echo ""
echo "Updating package list..."
sudo apt-get update

# Install Python and pip
echo ""
echo "Installing Python and pip..."
sudo apt-get install -y python3 python3-pip

# Install Node.js and npm
echo ""
echo "Installing Node.js and npm..."
if ! command -v node &> /dev/null; then
    # Install Node.js LTS via NodeSource repository
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js already installed ($(node --version))"
fi

# Install Shellcheck
echo ""
echo "Installing Shellcheck..."
sudo apt-get install -y shellcheck

# Install npm packages globally
echo ""
echo "Installing MarkdownLint CLI..."
sudo npm install -g markdownlint-cli

echo ""
echo "Installing Prettier..."
sudo npm install -g prettier

# Install Python packages
echo ""
echo "Checking for pipx..."
if ! command -v pipx &> /dev/null; then
    echo "Installing pipx..."
    sudo apt-get install -y pipx
    pipx ensurepath
fi

echo ""
echo "Installing YamlLint..."
pipx install yamllint --force

echo ""
echo "Installing Black (Python formatter)..."
pipx install black --force

echo ""
echo "Installing Ruff (Python linter)..."
pipx install ruff --force

# Install VS Code extensions
echo ""
echo "==================================="
echo "Installing VS Code Extensions"
echo "==================================="

if command -v code &> /dev/null; then
    echo "Installing MarkdownLint extension..."
    code --install-extension DavidAnson.vscode-markdownlint

    echo "Installing Prettier extension..."
    code --install-extension prettier.prettier-vscode

    echo "Installing YAML extension..."
    code --install-extension redhat.vscode-yaml

    echo "Installing YamlLint extension..."
    code --install-extension prantlf.vscode-yaml-linter

    echo "Installing ShellCheck extension..."
    code --install-extension timonwong.shellcheck

    echo "Installing Ruff extension..."
    code --install-extension charliermarsh.ruff

    echo ""
    echo "VS Code extensions installed successfully!"
else
    echo "VS Code CLI not found. Please install extensions manually:"
    echo "  - MarkdownLint: DavidAnson.vscode-markdownlint"
    echo "  - Prettier: esbenp.prettier-vscode"
    echo "  - YAML: redhat.vscode-yaml"
    echo "  - YamlLint: prantlf.vscode-yaml-linter"
    echo "  - ShellCheck: timonwong.shellcheck"
    echo "  - Ruff: charliermarsh.ruff"
fi

# Configure VS Code settings for format-on-save
echo ""
echo "==================================="
echo "Configuring VS Code Format-on-Save"
echo "==================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_REPO="$HOME/repos/env"
ENV_VSCODE_SETTINGS="$ENV_REPO/pre-commit-config/.vscode/settings.json"

# Create .vscode directory in project root if it doesn't exist
mkdir -p "$PROJECT_ROOT/.vscode"

# Copy settings.json from env repo to project root .vscode
if [ -f "$ENV_VSCODE_SETTINGS" ]; then
    cp "$ENV_VSCODE_SETTINGS" "$PROJECT_ROOT/.vscode/settings.json"
    echo "Copied VS Code settings from $ENV_VSCODE_SETTINGS"
    echo "  to $PROJECT_ROOT/.vscode/settings.json"
else
    echo "Warning: Source settings.json not found at $ENV_VSCODE_SETTINGS"
    echo "Clone the env repo to ~/repos/env or copy settings.json manually."
fi

# Create extensions.json with recommendations
cat > "$PROJECT_ROOT/.vscode/extensions.json" << 'EOF'
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
echo "Created VS Code extensions recommendations at $PROJECT_ROOT/.vscode/extensions.json"

# Verify installations
source ~/.bashrc

echo ""
echo "==================================="
echo "Verification"
echo "==================================="
echo "Python: $(python3 --version)"
echo "pip: $(pip3 --version)"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
echo "markdownlint: $(markdownlint --version)"
echo "prettier: $(prettier --version)"
echo "yamllint: $(yamllint --version)"
echo "black: $(black --version)"
echo "ruff: $(ruff --version)"
echo "shellcheck: $(shellcheck --version | head -n 2)"

echo ""
echo "==================================="
echo "Installation Complete!"
echo "==================================="
echo ""
echo "Note: You may need to restart your terminal or run 'source ~/.bashrc'"
echo "to ensure all PATH changes take effect."
