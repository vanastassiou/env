# Environment Configuration Repository

Canonical location for Linux/WSL configuration files, ensuring consistency across machines.

## Quick Setup

```bash
# Clone this repository
git clone <your-repo-url> ~/repos/env

# Run the setup script
cd ~/repos/env
./setup.sh
```

## Directory Structure

```
env/
├── shell_dotfiles/     # Shell configurations
│   ├── .bashrc         # Bash configuration
│   ├── .bash_profile   # Bash profile
│   ├── .zshrc          # Zsh configuration
│   ├── .gitconfig      # Git configuration
│   ├── .gitignore_global # Global gitignore
│   ├── .npmrc          # NPM configuration
│   └── .gitignore.home # Home directory gitignore
├── ssh/                # SSH configuration templates
│   └── config.template # SSH config template
├── pre-commit-config/  # Pre-commit hooks configuration
├── claude/             # Claude AI configuration
├── .config/            # Application configurations
└── setup.sh            # Master setup script
```

## Managed Files

The following files are symlinked from this repository to your home directory:

| File | Source | Target |
|------|--------|--------|
| Bash Config | `shell_dotfiles/.bashrc` | `~/.bashrc` |
| Bash Profile | `shell_dotfiles/.bash_profile` | `~/.bash_profile` |
| Zsh Config | `shell_dotfiles/.zshrc` | `~/.zshrc` |
| Git Config | `shell_dotfiles/.gitconfig` | `~/.gitconfig` |
| Git Ignore Global | `shell_dotfiles/.gitignore_global` | `~/.gitignore_global` |
| NPM Config | `shell_dotfiles/.npmrc` | `~/.npmrc` |
| Home Gitignore | `shell_dotfiles/.gitignore.home` | `~/.gitignore` |
| Claude Config | `.claude/` | `~/.claude` |

## Platform Support

- Linux (native)
- WSL2 (Windows Subsystem for Linux)
- macOS (with platform-specific configurations)

## SSH Configuration

SSH configurations are not automatically linked for security reasons. Instead:

1. Review the template at `ssh/config.template`
2. Copy it to `~/.ssh/config`
3. Customize with your actual key paths

## Development Tools

For development environment setup (linters, formatters, etc.), run:

```bash
./pre-commit-config/install-dev-tools.sh
```

## Adding New Machines

1. Clone this repository to `~/repos/env`
2. Run `./setup.sh`
3. Customize any machine-specific settings
4. Commit changes back to the repository

## Backup Strategy

The setup script automatically backs up existing files before creating symlinks. Backups are stored in `~/.config-backups/` with timestamps.

## Security Notes

- Never commit SSH private keys or other secrets
- Use the SSH config template as a guide only
- Keep sensitive information in environment variables or secure storage

---

# Pre-commit Configuration Notes

## Use of `pre-commit` Python package vs native `.git/hooks`
* Design: `.git` should contain only local repo-specific config, and thus `git` ignores it
* Versioning: YAML config is intended to live outside `.git` and be versioned as normal
* Security: not secure or polite to share code that will automatically run without explicit end-user opt-in

## Use of `detect-secrets`
* [Repo](https://github.com/Yelp/detect-secrets)
* Goals:
  * Take a baseline of the code and enumerate secrets already in code base
  * List any _existing_ secrets, for migration out on yor schedule instead of blocking all commits until this is fixed
  * Prevent committing _new_ secrets
  * Detect when the above protection is intentionally bypassed