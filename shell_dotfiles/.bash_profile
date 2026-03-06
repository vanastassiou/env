# Universal bash configuration
# Source platform-specific config automatically

# Determine the directory this script is in
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source platform-specific config
if [[ "$OSTYPE" == "darwin"* ]]; then
  [ -f "$DOTFILES_DIR/.bash_profile.mac" ] && source "$DOTFILES_DIR/.bash_profile.mac"
elif grep -qEi "(microsoft|wsl)" /proc/version 2>/dev/null; then
  [ -f "$DOTFILES_DIR/.bash_profile.wsl" ] && source "$DOTFILES_DIR/.bash_profile.wsl"
fi

# Universal PATH additions
export PATH=/usr/local/bin:$PATH
export PATH=~/.npm-global/bin:$PATH

# Don't check mail when opening terminal
unset MAILCHECK

# Git completion - use system completion if available
if [ -f /usr/share/bash-completion/completions/git ]; then
  . /usr/share/bash-completion/completions/git
elif [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Personal Bash aliases and functions
alias gitpretty="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Homebrew (if installed)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# pyenv (if installed)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init - bash)"
fi

# Source .bashrc if running bash
if [ -n "${BASH_VERSION-}" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
