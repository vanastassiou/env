# Shell Dotfiles

Personal shell configuration and development environment bootstrap scripts for macOS, Debian/Ubuntu, and WSL2.

## Quick Start

```bash
# Clone the repo
git clone https://github.com/YOUR_USER/shell_dotfiles.git ~/repos/env/shell_dotfiles
cd ~/repos/env/shell_dotfiles

# Run the bootstrap script (auto-detects your platform)
./setup/bootstrap.sh
```

## What Gets Installed

| Category | Tools |
|----------|-------|
| Shell | Bash-It, Oh-My-Zsh, git-completion |
| Package Manager | Homebrew (all platforms) |
| Languages | Python (pyenv), Node.js, OpenJDK, Maven |
| Cloud | AWS CLI, Azure CLI |
| Containers | Docker, kubectl, helm, k9s |
| IaC | Terraform |
| Editor | VS Code |
| Utilities | git-lfs, jq, yq, GNU coreutils |

## Dotfiles

The setup scripts symlink these files to your home directory:

- `.bash_profile` - Bash configuration with Bash-It framework
- `.bashrc` - Bash initialization
- `.zshrc` - Zsh configuration with Oh-My-Zsh
- `.gitconfig` - Git settings and aliases

Existing files are backed up to `~/*.backup` before symlinking.

## Platform-Specific Scripts

Run directly if you prefer not to use auto-detection:

```bash
./setup/macos-setup.sh      # macOS
./setup/debian-setup.sh     # Debian/Ubuntu Linux
./setup/wsl-setup.sh        # WSL2 Ubuntu
```

### WSL Notes

The WSL script enables systemd (required for Docker) and may require a WSL restart:

```powershell
# From PowerShell
wsl --shutdown
# Then restart your WSL terminal
```

## Post-Install

1. Restart your terminal or source your profile:
   ```bash
   source ~/.bash_profile  # or ~/.zshrc
   ```

2. Configure cloud credentials:
   ```bash
   aws configure
   az login
   ```

3. On macOS, launch Docker Desktop to complete Docker setup.

## Customization

### Shell Theme

Both `.bash_profile` and `.zshrc` use the `vtheme` theme. To change:

```bash
# Bash-It
export BASH_IT_THEME='your-theme'

# Oh-My-Zsh
ZSH_THEME="your-theme"
```

### Plugins

Edit the `plugins=()` array in `.bash_profile` or `.zshrc`:

```bash
plugins=(
  git
  dotenv
  macos
  pyenv
  python
)
```

## Re-running

All scripts are idempotent. Re-run anytime to update packages or fix a broken setup.
