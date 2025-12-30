#!/usr/bin/env bash

# Environment Setup Script
# Manages configuration files and symlinks for consistent environment across machines

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ENV_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.config-backups/$(date +%Y%m%d-%H%M%S)"

echo -e "${GREEN}=== Environment Setup Script ===${NC}"
echo "Setting up configuration from: $ENV_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo -e "${YELLOW}Backup directory: $BACKUP_DIR${NC}"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ]; then
        # Already a symlink
        local current_source=$(readlink "$target")
        if [ "$current_source" = "$source" ]; then
            echo -e "${GREEN}✓${NC} $target already linked correctly"
            return
        else
            echo -e "${YELLOW}!${NC} $target is linked to $current_source"
            mv "$target" "$BACKUP_DIR/$(basename "$target").link"
        fi
    elif [ -e "$target" ]; then
        # File exists, backup
        echo -e "${YELLOW}→${NC} Backing up existing $target"
        mv "$target" "$BACKUP_DIR/$(basename "$target")"
    fi

    echo -e "${GREEN}+${NC} Creating symlink: $target -> $source"
    ln -s "$source" "$target"
}

echo -e "\n${GREEN}Setting up shell configurations...${NC}"

# Shell dotfiles
SHELL_FILES=(
    ".bashrc"
    ".bash_profile"
    ".bash_logout"
    ".profile"
    ".zshrc"
    ".gitconfig"
    ".gitignore_global"
    ".npmrc"
    ".mcp.json"
    ".gitignore.home:.gitignore"  # source:target format for different names
)

for file in "${SHELL_FILES[@]}"; do
    if [[ "$file" == *":"* ]]; then
        # Handle different source and target names
        source_name="${file%%:*}"
        target_name="${file##*:}"
    else
        source_name="$file"
        target_name="$file"
    fi

    source_path="$ENV_DIR/shell_dotfiles/$source_name"
    target_path="$HOME/$target_name"

    if [ -f "$source_path" ]; then
        create_symlink "$source_path" "$target_path"
    else
        echo -e "${RED}✗${NC} Source not found: $source_path"
    fi
done

# Claude configuration
echo -e "\n${GREEN}Setting up Claude configuration...${NC}"
if [ -d "$ENV_DIR/.claude" ]; then
    create_symlink "$ENV_DIR/.claude" "$HOME/.claude"
fi

# Platform-specific setup
echo -e "\n${GREEN}Detecting platform...${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if grep -q Microsoft /proc/version 2>/dev/null; then
        echo "Platform: WSL2"
        # WSL-specific configurations
        if [ -f "$ENV_DIR/shell_dotfiles/.bash_profile.wsl" ]; then
            echo -e "${YELLOW}→${NC} Found WSL-specific bash_profile"
        fi
        if [ -f "$ENV_DIR/shell_dotfiles/.zshrc.wsl" ]; then
            echo -e "${YELLOW}→${NC} Found WSL-specific zshrc"
        fi
    else
        echo "Platform: Linux"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Platform: macOS"
    # macOS-specific configurations
    if [ -f "$ENV_DIR/shell_dotfiles/.bash_profile.mac" ]; then
        echo -e "${YELLOW}→${NC} Found macOS-specific bash_profile"
    fi
    if [ -f "$ENV_DIR/shell_dotfiles/.zshrc.mac" ]; then
        echo -e "${YELLOW}→${NC} Found macOS-specific zshrc"
    fi
fi

# Bash-it setup
echo -e "\n${GREEN}Setting up Bash-it...${NC}"
if [ ! -d "$HOME/.bash_it" ]; then
    echo -e "${YELLOW}→${NC} Installing Bash-it framework"
    git clone --depth=1 https://github.com/Bash-it/bash-it.git "$HOME/.bash_it"

    # Install custom vtheme
    if [ -f "$ENV_DIR/bash-it-theme/vtheme.theme.bash" ]; then
        echo -e "${GREEN}+${NC} Installing custom vtheme"
        mkdir -p "$HOME/.bash_it/themes/vtheme"
        cp "$ENV_DIR/bash-it-theme/vtheme.theme.bash" "$HOME/.bash_it/themes/vtheme/vtheme.theme.bash"
    fi

    # Run the install script in silent mode
    echo -e "${YELLOW}→${NC} Configuring Bash-it (silent mode)"
    $HOME/.bash_it/install.sh --silent

    # Enable useful plugins
    echo -e "${YELLOW}→${NC} Enabling default plugins"
    source "$HOME/.bash_it/bash_it.sh"
    bash-it enable plugin git base alias-completion
    bash-it enable alias git general
    bash-it enable completion git bash-it system
else
    echo -e "${GREEN}✓${NC} Bash-it already installed"

    # Ensure vtheme is installed/updated
    if [ -f "$ENV_DIR/bash-it-theme/vtheme.theme.bash" ]; then
        mkdir -p "$HOME/.bash_it/themes/vtheme"
        cp "$ENV_DIR/bash-it-theme/vtheme.theme.bash" "$HOME/.bash_it/themes/vtheme/vtheme.theme.bash"
        echo -e "${GREEN}✓${NC} vtheme updated"
    fi
fi

# SSH configuration
echo -e "\n${GREEN}SSH Configuration${NC}"
if [ -f "$ENV_DIR/ssh/config.template" ]; then
    if [ ! -f "$HOME/.ssh/config" ]; then
        echo -e "${YELLOW}!${NC} No SSH config found. Template available at:"
        echo "   $ENV_DIR/ssh/config.template"
        echo "   Copy and customize it to ~/.ssh/config"
    else
        echo -e "${GREEN}✓${NC} SSH config exists. Template available for reference at:"
        echo "   $ENV_DIR/ssh/config.template"
    fi
fi

# Git configuration
echo -e "\n${GREEN}Checking Git configuration...${NC}"
if command -v git &> /dev/null; then
    # Check if global gitignore is configured
    current_excludes=$(git config --global core.excludesfile || echo "")
    expected_excludes="$HOME/.gitignore_global"

    if [ "$current_excludes" != "$expected_excludes" ]; then
        echo -e "${YELLOW}→${NC} Setting global git excludes file"
        git config --global core.excludesfile "$expected_excludes"
    else
        echo -e "${GREEN}✓${NC} Git global excludes configured correctly"
    fi
fi

# Development tools setup (optional)
echo -e "\n${GREEN}Development Tools${NC}"
if [ -f "$ENV_DIR/pre-commit-config/install-dev-tools.sh" ]; then
    echo "Development tools installer available. Run to install:"
    echo "   $ENV_DIR/pre-commit-config/install-dev-tools.sh"
fi

# Final summary
echo -e "\n${GREEN}=== Setup Complete ===${NC}"
echo "Configuration files have been linked from $ENV_DIR"
if [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    echo -e "${YELLOW}Backups saved to: $BACKUP_DIR${NC}"
else
    # Remove empty backup directory
    rmdir "$BACKUP_DIR" 2>/dev/null || true
fi

echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Review and customize SSH config if needed"
echo "2. Source your shell configuration:"
echo "   source ~/.bashrc  # for bash"
echo "   source ~/.zshrc   # for zsh"
echo "3. Consider running the development tools installer"

# Check for shell_dotfiles bootstrap scripts
if [ -d "$ENV_DIR/shell_dotfiles/setup" ]; then
    echo -e "\n${YELLOW}Additional setup scripts available:${NC}"
    ls -1 "$ENV_DIR/shell_dotfiles/setup/"*.sh 2>/dev/null | while read script; do
        echo "   $(basename "$script")"
    done
fi