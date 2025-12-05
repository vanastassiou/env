#!/bin/bash
# wsl-setup.sh - WSL2 Ubuntu development environment setup
#
# Extends debian-setup.sh with WSL-specific configurations:
# - Enables systemd for Docker
# - Configures Windows interop
# - Handles VS Code remote development

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-setup.sh"

# -----------------------------------------------------------------------------
# WSL Detection
# -----------------------------------------------------------------------------

verify_wsl() {
    if ! grep -qi microsoft /proc/version 2>/dev/null; then
        log_error "This script should only be run in WSL"
        exit 1
    fi
    log_success "Running in WSL"
}

# -----------------------------------------------------------------------------
# Systemd Configuration (required for Docker)
# -----------------------------------------------------------------------------

enable_systemd() {
    log_info "Checking systemd configuration..."

    local wsl_conf="/etc/wsl.conf"
    local systemd_enabled=false

    # Check if systemd is already enabled
    if [[ -f "$wsl_conf" ]] && grep -q "systemd=true" "$wsl_conf"; then
        systemd_enabled=true
    fi

    if [[ "$systemd_enabled" == "true" ]]; then
        log_success "systemd already enabled in WSL"
    else
        log_info "Enabling systemd in WSL..."

        sudo tee -a "$wsl_conf" > /dev/null << 'EOF'

[boot]
systemd=true
EOF
        log_success "systemd enabled"
        log_warn "WSL restart required: run 'wsl --shutdown' from PowerShell, then restart WSL"
        NEEDS_WSL_RESTART=true
    fi

    # Check if systemd is actually running
    if systemctl --version &>/dev/null && [[ "$(ps -p 1 -o comm=)" == "systemd" ]]; then
        log_success "systemd is running"
    else
        log_warn "systemd is not running - restart WSL after this script completes"
        NEEDS_WSL_RESTART=true
    fi
}

# -----------------------------------------------------------------------------
# Docker Configuration for WSL
# -----------------------------------------------------------------------------

configure_docker_wsl() {
    log_info "Configuring Docker for WSL..."

    # Ensure user is in docker group
    if groups "$USER" | grep -q docker; then
        log_success "User already in docker group"
    else
        sudo usermod -aG docker "$USER"
        log_success "Added user to docker group"
    fi

    # Verify Docker daemon
    if systemctl is-active --quiet docker 2>/dev/null; then
        log_success "Docker daemon is running"
    else
        if systemctl --version &>/dev/null; then
            log_info "Starting Docker daemon..."
            sudo systemctl enable docker
            sudo systemctl start docker
        else
            log_warn "Cannot start Docker - systemd not running yet"
        fi
    fi
}

# -----------------------------------------------------------------------------
# Windows Interop Configuration
# -----------------------------------------------------------------------------

configure_windows_interop() {
    log_info "Configuring Windows interop..."

    local wsl_conf="/etc/wsl.conf"

    # Check if interop section exists
    if ! grep -q "\[interop\]" "$wsl_conf" 2>/dev/null; then
        sudo tee -a "$wsl_conf" > /dev/null << 'EOF'

[interop]
enabled=true
appendWindowsPath=true
EOF
        log_success "Windows interop configured"
    else
        log_success "Windows interop already configured"
    fi

    # Add convenience alias for Windows home directory
    local win_home="/mnt/c/Users"
    if [[ -d "$win_home" ]]; then
        # Try to detect Windows username
        local win_user
        win_user=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r' || echo "")

        if [[ -n "$win_user" ]] && [[ -d "$win_home/$win_user" ]]; then
            if ! grep -q "WINHOME" "$HOME/.bashrc" 2>/dev/null; then
                echo "" >> "$HOME/.bashrc"
                echo "# Windows home directory" >> "$HOME/.bashrc"
                echo "export WINHOME=\"$win_home/$win_user\"" >> "$HOME/.bashrc"
                log_success "Added WINHOME environment variable"
            fi
        fi
    fi
}

# -----------------------------------------------------------------------------
# VS Code Remote Development
# -----------------------------------------------------------------------------

configure_remote_dev() {
    log_info "Configuring VS Code remote development..."

    # VS Code Server is auto-installed when connecting from Windows VS Code
    # Just verify the integration is working

    if command_exists code 2>/dev/null; then
        log_success "VS Code CLI available (code command)"
    else
        log_info "VS Code CLI not yet available - install VS Code on Windows and connect to WSL"
    fi

    # Check if Windows VS Code is accessible
    local win_code="/mnt/c/Users/*/AppData/Local/Programs/Microsoft VS Code/bin/code"
    # shellcheck disable=SC2086
    if ls $win_code &>/dev/null 2>&1; then
        log_success "Windows VS Code installation detected"
    fi
}

# -----------------------------------------------------------------------------
# PATH Fixes for WSL
# -----------------------------------------------------------------------------

configure_wsl_path() {
    log_info "Configuring WSL PATH..."

    # Ensure /usr/local/bin is in PATH
    if ! grep -q "/usr/local/bin" "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="/usr/local/bin:$PATH"' >> "$HOME/.bashrc"
    fi

    # Add ~/.local/bin if not present
    mkdir -p "$HOME/.local/bin"
    if ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi

    log_success "PATH configured"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo "============================================"
    echo "  WSL2 Ubuntu Development Environment Setup"
    echo "============================================"
    echo ""

    NEEDS_WSL_RESTART=false

    verify_wsl
    enable_systemd
    configure_wsl_path

    # Run the full Debian setup
    log_info "Running Debian setup..."
    source "$SCRIPT_DIR/debian-setup.sh"

    # Call debian-setup functions directly instead of main
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

    # WSL-specific configurations
    configure_docker_wsl
    configure_windows_interop
    configure_remote_dev

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
    log_success "WSL setup complete!"
    echo ""

    if [[ "$NEEDS_WSL_RESTART" == "true" ]]; then
        echo "IMPORTANT: WSL restart required for systemd!"
        echo "  1. Open PowerShell on Windows"
        echo "  2. Run: wsl --shutdown"
        echo "  3. Start WSL again"
        echo ""
    fi

    echo "Next steps:"
    echo "  1. Log out and back in (for docker group)"
    echo "  2. Run: source ~/.bashrc"
    echo "  3. Run 'aws configure' to set up AWS credentials"
    echo "  4. Run 'az login' to authenticate with Azure"
    echo "  5. Open VS Code on Windows and connect to WSL"
    echo ""
}

main "$@"
