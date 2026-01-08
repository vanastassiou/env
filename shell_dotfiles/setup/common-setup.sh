#!/bin/bash
# common-setup.sh - Shared functions and configurations for all platforms
#
# This script provides utility functions and common setup tasks used by
# platform-specific setup scripts. Source this file, don't execute directly.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

# -----------------------------------------------------------------------------
# Utility Functions
# -----------------------------------------------------------------------------

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# -----------------------------------------------------------------------------
# Platform Detection
# -----------------------------------------------------------------------------

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "${ID}"
    else
        echo "unknown"
    fi
}

# -----------------------------------------------------------------------------
# Shell Framework Installation
# -----------------------------------------------------------------------------

install_bash_it() {
    local bash_it_dir="$HOME/.bash_it"

    if [[ -d "$bash_it_dir" ]]; then
        log_info "Bash-it already installed, updating..."
        (cd "$bash_it_dir" && git pull origin master --quiet 2>/dev/null || git fetch origin && git reset --hard origin/master --quiet)
        log_success "Bash-it updated"
    else
        log_info "Installing Bash-it..."
        git clone --depth=1 https://github.com/Bash-it/bash-it.git "$bash_it_dir"
        log_success "Bash-it installed"
    fi
}


# -----------------------------------------------------------------------------
# Python Environment Setup (pyenv)
# -----------------------------------------------------------------------------

setup_pyenv() {
    if ! command_exists pyenv; then
        log_warn "pyenv not found - should be installed by platform script"
        return 1
    fi

    log_info "Configuring pyenv..."

    # Initialize pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    # Install latest Python 3 if not present
    local latest_python
    latest_python=$(pyenv install --list | grep -E "^\s*3\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')

    if ! pyenv versions | grep -q "$latest_python"; then
        log_info "Installing Python $latest_python..."
        pyenv install "$latest_python"
        pyenv global "$latest_python"
        log_success "Python $latest_python installed and set as global"
    else
        log_success "Python $latest_python already installed"
    fi
}

# -----------------------------------------------------------------------------
# Node.js/npm Configuration
# -----------------------------------------------------------------------------

setup_npm_global() {
    local npm_global_dir="$HOME/.npm-global"

    log_info "Configuring npm global directory..."

    mkdir -p "$npm_global_dir"

    if command_exists npm; then
        npm config set prefix "$npm_global_dir"
        log_success "npm global prefix set to $npm_global_dir"
    else
        log_warn "npm not found - will configure after Node.js installation"
    fi
}

# -----------------------------------------------------------------------------
# Dotfiles Symlinking
# -----------------------------------------------------------------------------

symlink_dotfiles() {
    log_info "Symlinking dotfiles from $DOTFILES_DIR..."

    local files=(".bash_profile" ".bashrc" ".zshrc" ".gitconfig")

    for file in "${files[@]}"; do
        local src="$DOTFILES_DIR/$file"
        local dest="$HOME/$file"

        if [[ -f "$src" ]]; then
            if [[ -L "$dest" ]]; then
                log_info "Removing existing symlink: $dest"
                rm "$dest"
            elif [[ -f "$dest" ]]; then
                log_info "Backing up existing file: $dest -> ${dest}.backup"
                mv "$dest" "${dest}.backup"
            fi

            ln -s "$src" "$dest"
            log_success "Linked $file"
        else
            log_warn "Source file not found: $src"
        fi
    done
}

# -----------------------------------------------------------------------------
# Git Configuration
# -----------------------------------------------------------------------------

setup_git() {
    log_info "Configuring Git..."

    # Git completion
    local git_completion="$HOME/.git-completion.bash"
    if [[ ! -f "$git_completion" ]]; then
        log_info "Downloading git-completion.bash..."
        curl -sL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "$git_completion"
        log_success "Git completion downloaded"
    fi

    # Create global gitignore if it doesn't exist
    local gitignore_global="$HOME/.gitignore_global"
    if [[ ! -f "$gitignore_global" ]]; then
        log_info "Creating global gitignore..."
        cat > "$gitignore_global" << 'EOF'
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini

# IDEs
.idea/
.vscode/
*.swp
*.swo
*~

# Environment
.env.local
.env.*.local

# Python
__pycache__/
*.py[cod]
.venv/
venv/

# Node
node_modules/
npm-debug.log*
EOF
        log_success "Global gitignore created"
    fi

    log_success "Git configured"
}

# -----------------------------------------------------------------------------
# Verification
# -----------------------------------------------------------------------------

verify_installation() {
    log_info "Verifying installation..."

    local tools=("git" "brew" "pyenv" "node" "npm" "aws" "az" "docker" "kubectl" "helm" "terraform")
    local missing=()

    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            local version
            case "$tool" in
                git) version=$(git --version | cut -d' ' -f3) ;;
                brew) version=$(brew --version | head -1 | cut -d' ' -f2) ;;
                pyenv) version=$(pyenv --version | cut -d' ' -f2) ;;
                node) version=$(node --version) ;;
                npm) version=$(npm --version) ;;
                aws) version=$(aws --version 2>&1 | cut -d' ' -f1 | cut -d'/' -f2) ;;
                az) version=$(az version --query '"azure-cli"' -o tsv 2>/dev/null || echo "installed") ;;
                docker) version=$(docker --version | cut -d' ' -f3 | tr -d ',') ;;
                kubectl) version=$(kubectl version --client -o json 2>/dev/null | jq -r '.clientVersion.gitVersion' || echo "installed") ;;
                helm) version=$(helm version --short 2>/dev/null | cut -d'+' -f1) ;;
                terraform) version=$(terraform version -json 2>/dev/null | jq -r '.terraform_version' || terraform --version | head -1 | cut -d'v' -f2) ;;
                *) version="installed" ;;
            esac
            echo -e "  ${GREEN}✓${NC} $tool ($version)"
        else
            missing+=("$tool")
            echo -e "  ${RED}✗${NC} $tool (not found)"
        fi
    done

    if [[ ${#missing[@]} -eq 0 ]]; then
        log_success "All tools installed successfully!"
    else
        log_warn "Missing tools: ${missing[*]}"
    fi
}

# -----------------------------------------------------------------------------
# Main (when sourced, these functions become available)
# -----------------------------------------------------------------------------

run_common_setup() {
    log_info "Running common setup tasks..."

    install_bash_it
    setup_npm_global
    symlink_dotfiles
    setup_git

    log_success "Common setup complete!"
}

# Export functions for use by other scripts
export -f log_info log_success log_warn log_error
export -f command_exists detect_os detect_distro
export -f install_bash_it
export -f setup_pyenv setup_npm_global
export -f symlink_dotfiles setup_git
export -f verify_installation run_common_setup
