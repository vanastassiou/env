#!/bin/bash
# debian-setup.sh - Debian/Ubuntu Linux development environment setup
#
# Installs Homebrew on Linux for consistent tooling with macOS.
# Uses official Docker repo for better systemd integration.
# Safe to re-run - will update existing packages.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-setup.sh"

# -----------------------------------------------------------------------------
# System Prerequisites
# -----------------------------------------------------------------------------

install_apt_prerequisites() {
    log_info "Installing apt prerequisites..."

    sudo apt-get update
    sudo apt-get install -y \
        build-essential \
        procps \
        curl \
        file \
        git \
        ca-certificates \
        gnupg \
        lsb-release

    log_success "apt prerequisites installed"
}

# -----------------------------------------------------------------------------
# Homebrew for Linux
# -----------------------------------------------------------------------------

install_homebrew() {
    log_info "Checking Homebrew..."

    if command_exists brew; then
        log_success "Homebrew already installed"
        log_info "Updating Homebrew..."
        brew update
    else
        log_info "Installing Homebrew for Linux..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        log_success "Homebrew installed"
    fi

    # Configure Homebrew PATH
    configure_homebrew_path
}

configure_homebrew_path() {
    log_info "Configuring Homebrew PATH..."

    local brew_shellenv='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

    # Add to current session
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Add to shell profiles if not already present
    for profile in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do
        if [[ -f "$profile" ]] && ! grep -q "linuxbrew" "$profile"; then
            echo "" >> "$profile"
            echo "# Homebrew" >> "$profile"
            echo "$brew_shellenv" >> "$profile"
            log_info "Added Homebrew to $profile"
        fi
    done

    log_success "Homebrew PATH configured"
}

# -----------------------------------------------------------------------------
# Core CLI Tools (via Homebrew)
# -----------------------------------------------------------------------------

install_core_tools() {
    log_info "Installing core CLI tools via Homebrew..."

    local formulae=(
        git-lfs
        jq
        yq
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
# Cloud CLIs (via Homebrew)
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

    # Install pyenv dependencies first
    sudo apt-get install -y \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxml2-dev \
        libxmlsec1-dev \
        libffi-dev \
        liblzma-dev

    if brew list pyenv &>/dev/null; then
        log_info "Upgrading pyenv..."
        brew upgrade pyenv 2>/dev/null || true
    else
        brew install pyenv
    fi

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
    log_info "Installing Java..."

    # OpenJDK via Homebrew
    if brew list openjdk &>/dev/null; then
        log_info "Upgrading OpenJDK..."
        brew upgrade openjdk 2>/dev/null || true
    else
        brew install openjdk
    fi

    log_success "Java installed"
}

# -----------------------------------------------------------------------------
# Docker Engine (Official Repo - better than brew on Linux)
# -----------------------------------------------------------------------------

install_docker() {
    log_info "Installing Docker Engine..."

    if command_exists docker; then
        log_success "Docker already installed"
        return
    fi

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release && echo "$ID")/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add current user to docker group
    sudo usermod -aG docker "$USER"

    # Start and enable Docker
    sudo systemctl enable docker
    sudo systemctl start docker

    log_success "Docker installed"
    log_warn "Log out and back in for docker group membership to take effect"
}

# -----------------------------------------------------------------------------
# Kubernetes Tools (via Homebrew)
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
# Terraform (via Homebrew)
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
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo "============================================"
    echo "  Debian/Ubuntu Development Environment Setup"
    echo "============================================"
    echo ""

    install_apt_prerequisites
    install_homebrew
    install_core_tools
    install_cloud_clis
    install_pyenv
    install_nodejs
    install_java
    install_docker
    install_kubernetes_tools
    install_terraform

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
    log_success "Debian/Ubuntu setup complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Log out and back in (for docker group)"
    echo "  2. Run: source ~/.bashrc"
    echo "  3. Run 'aws configure' to set up AWS credentials"
    echo "  4. Run 'az login' to authenticate with Azure"
    echo ""
}

# Only run main if executed directly (not sourced by wsl-setup.sh)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
