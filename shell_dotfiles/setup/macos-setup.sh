#!/bin/bash
# macos-setup.sh - macOS development environment setup
#
# Installs and configures all development tools using Homebrew.
# Safe to re-run - will update existing packages.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-setup.sh"

# -----------------------------------------------------------------------------
# Xcode Command Line Tools
# -----------------------------------------------------------------------------

install_xcode_cli() {
    log_info "Checking Xcode Command Line Tools..."

    if xcode-select -p &>/dev/null; then
        log_success "Xcode CLI tools already installed"
    else
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install

        # Wait for installation to complete
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
        log_success "Xcode CLI tools installed"
    fi
}

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------

install_homebrew() {
    log_info "Checking Homebrew..."

    if command_exists brew; then
        log_success "Homebrew already installed"
        log_info "Updating Homebrew..."
        brew update
    else
        log_info "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for this session
        eval "$(/opt/homebrew/bin/brew shellenv)"
        log_success "Homebrew installed"
    fi
}

# -----------------------------------------------------------------------------
# Core CLI Tools
# -----------------------------------------------------------------------------

install_core_tools() {
    log_info "Installing core CLI tools..."

    local formulae=(
        git
        git-lfs
        jq
        yq
        coreutils
    )

    for formula in "${formulae[@]}"; do
        if brew list "$formula" &>/dev/null; then
            log_info "Upgrading $formula..."
            brew upgrade "$formula" 2>/dev/null || true
        else
            log_info "Installing $formula..."
            brew install "$formula"
        fi
    done

    # Initialize Git LFS
    git lfs install

    log_success "Core tools installed"
}

# -----------------------------------------------------------------------------
# Cloud CLIs
# -----------------------------------------------------------------------------

install_cloud_clis() {
    log_info "Installing cloud CLIs..."

    # AWS CLI
    if brew list awscli &>/dev/null; then
        log_info "Upgrading AWS CLI..."
        brew upgrade awscli 2>/dev/null || true
    else
        log_info "Installing AWS CLI..."
        brew install awscli
    fi

    # Azure CLI
    if brew list azure-cli &>/dev/null; then
        log_info "Upgrading Azure CLI..."
        brew upgrade azure-cli 2>/dev/null || true
    else
        log_info "Installing Azure CLI..."
        brew install azure-cli
    fi

    log_success "Cloud CLIs installed"
}

# -----------------------------------------------------------------------------
# Language Runtimes
# -----------------------------------------------------------------------------

install_pyenv() {
    log_info "Installing pyenv..."

    if brew list pyenv &>/dev/null; then
        log_info "Upgrading pyenv..."
        brew upgrade pyenv 2>/dev/null || true
    else
        brew install pyenv
    fi

    # Also install pyenv build dependencies
    brew install openssl readline sqlite3 xz zlib tcl-tk 2>/dev/null || true

    log_success "pyenv installed"
}

install_nodejs() {
    log_info "Installing Node.js..."

    if brew list node &>/dev/null; then
        log_info "Upgrading Node.js..."
        brew upgrade node 2>/dev/null || true
    else
        brew install node
    fi

    log_success "Node.js installed"
}

install_java() {
    log_info "Installing Java and Maven..."

    # OpenJDK
    if brew list openjdk &>/dev/null; then
        log_info "Upgrading OpenJDK..."
        brew upgrade openjdk 2>/dev/null || true
    else
        brew install openjdk
    fi

    # Create symlink for system Java wrappers
    local jdk_path="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk"
    local system_jvm="/Library/Java/JavaVirtualMachines/openjdk.jdk"
    if [[ -d "$jdk_path" ]] && [[ ! -L "$system_jvm" ]]; then
        log_info "Symlinking OpenJDK to system location (requires sudo)..."
        sudo ln -sfn "$jdk_path" "$system_jvm" || log_warn "Could not create system symlink - run manually with sudo"
    fi

    # Maven
    if brew list maven &>/dev/null; then
        log_info "Upgrading Maven..."
        brew upgrade maven 2>/dev/null || true
    else
        brew install maven
    fi

    log_success "Java and Maven installed"
}

# -----------------------------------------------------------------------------
# Docker
# -----------------------------------------------------------------------------

install_docker() {
    log_info "Installing Docker Desktop..."

    if brew list --cask docker &>/dev/null; then
        log_info "Docker Desktop already installed"
        brew upgrade --cask docker 2>/dev/null || true
    else
        brew install --cask docker
        log_info "Docker Desktop installed - please launch it to complete setup"
    fi

    log_success "Docker installed"
}

# -----------------------------------------------------------------------------
# Kubernetes Tools
# -----------------------------------------------------------------------------

install_kubernetes_tools() {
    log_info "Installing Kubernetes tools..."

    local tools=(kubectl helm k9s)

    for tool in "${tools[@]}"; do
        if brew list "$tool" &>/dev/null; then
            log_info "Upgrading $tool..."
            brew upgrade "$tool" 2>/dev/null || true
        else
            log_info "Installing $tool..."
            brew install "$tool"
        fi
    done

    log_success "Kubernetes tools installed"
}

# -----------------------------------------------------------------------------
# Terraform
# -----------------------------------------------------------------------------

install_terraform() {
    log_info "Installing Terraform..."

    if brew list terraform &>/dev/null; then
        log_info "Upgrading Terraform..."
        brew upgrade terraform 2>/dev/null || true
    else
        brew install terraform
    fi

    log_success "Terraform installed"
}

# -----------------------------------------------------------------------------
# VS Code Editor
# -----------------------------------------------------------------------------

install_vscode() {
    log_info "Installing VS Code..."

    if brew list --cask visual-studio-code &>/dev/null; then
        log_info "VS Code already installed"
        brew upgrade --cask visual-studio-code 2>/dev/null || true
    else
        brew install --cask visual-studio-code
    fi

    log_success "VS Code installed"
}

# -----------------------------------------------------------------------------
# C++ Development (for native extensions)
# -----------------------------------------------------------------------------

configure_cpp_paths() {
    log_info "Configuring C++ include paths..."

    # This is set in .bash_profile but we verify the SDK exists
    local sdk_path="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
    if [[ -d "$sdk_path" ]]; then
        log_success "macOS SDK found at $sdk_path"
    else
        log_warn "macOS SDK not found - C++ compilation may have issues"
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo "========================================"
    echo "  macOS Development Environment Setup"
    echo "========================================"
    echo ""

    install_xcode_cli
    install_homebrew
    install_core_tools
    install_cloud_clis
    install_pyenv
    install_nodejs
    install_java
    install_docker
    install_kubernetes_tools
    install_terraform
    install_vscode
    configure_cpp_paths

    # Run common setup tasks
    run_common_setup

    # Setup pyenv Python
    setup_pyenv

    echo ""
    echo "========================================"
    echo "  Verifying Installation"
    echo "========================================"
    verify_installation

    echo ""
    log_success "macOS setup complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.bash_profile"
    echo "  2. Launch Docker Desktop to complete Docker setup"
    echo "  3. Run 'aws configure' to set up AWS credentials"
    echo "  4. Run 'az login' to authenticate with Azure"
    echo ""
}

main "$@"
