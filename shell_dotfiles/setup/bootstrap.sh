#!/bin/bash
# bootstrap.sh - Universal development environment bootstrap
#
# Auto-detects the platform and runs the appropriate setup script.
# Supports: macOS, Debian/Ubuntu Linux, WSL2 Ubuntu
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/YOUR_USER/shell_dotfiles/main/setup/bootstrap.sh | bash
#
# Or clone and run locally:
#   git clone https://github.com/YOUR_USER/shell_dotfiles.git ~/repos/env/shell_dotfiles
#   cd ~/repos/env/shell_dotfiles/setup
#   ./bootstrap.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# -----------------------------------------------------------------------------
# Platform Detection
# -----------------------------------------------------------------------------

detect_platform() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            elif [[ -f /etc/os-release ]]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu|debian)
                        echo "debian"
                        ;;
                    *)
                        echo "linux-other"
                        ;;
                esac
            else
                echo "linux-unknown"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# -----------------------------------------------------------------------------
# Repository Setup
# -----------------------------------------------------------------------------

ensure_dotfiles_repo() {
    local dotfiles_dir="$HOME/repos/env/shell_dotfiles"

    if [[ -d "$dotfiles_dir" ]]; then
        log_success "Dotfiles repo found at $dotfiles_dir"
        DOTFILES_DIR="$dotfiles_dir"
    elif [[ -d "$(dirname "${BASH_SOURCE[0]}")/.." ]]; then
        # Script is being run from within the repo
        DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
        log_success "Running from dotfiles repo at $DOTFILES_DIR"
    else
        log_info "Cloning dotfiles repository..."
        mkdir -p "$HOME/repos/env"
        # Replace with your actual repo URL
        git clone https://github.com/YOUR_USER/shell_dotfiles.git "$dotfiles_dir"
        DOTFILES_DIR="$dotfiles_dir"
        log_success "Dotfiles repo cloned to $dotfiles_dir"
    fi

    export DOTFILES_DIR
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo "========================================"
    echo "  Development Environment Bootstrap"
    echo "========================================"
    echo ""

    # Detect platform
    local platform
    platform=$(detect_platform)

    log_info "Detected platform: $platform"

    # Ensure we have the dotfiles repo
    ensure_dotfiles_repo

    local setup_script="$DOTFILES_DIR/setup"

    # Run appropriate setup script
    case "$platform" in
        macos)
            log_info "Running macOS setup..."
            exec "$setup_script/macos-setup.sh"
            ;;
        wsl)
            log_info "Running WSL setup..."
            exec "$setup_script/wsl-setup.sh"
            ;;
        debian)
            log_info "Running Debian/Ubuntu setup..."
            exec "$setup_script/debian-setup.sh"
            ;;
        linux-other)
            log_warn "Unsupported Linux distribution"
            log_info "Attempting Debian setup (may require modifications)..."
            exec "$setup_script/debian-setup.sh"
            ;;
        *)
            log_error "Unsupported platform: $platform"
            echo ""
            echo "Supported platforms:"
            echo "  - macOS (Darwin)"
            echo "  - Ubuntu / Debian Linux"
            echo "  - WSL2 Ubuntu"
            echo ""
            exit 1
            ;;
    esac
}

main "$@"
