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

# Git completion
[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash


if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Prefer GNU utilities over Mac OS X (different behaviour on Mac than expected in Linux)
# https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities
# https://gist.github.com/skyzyx/3438280b18e4f7c490db8a2a2ca0b9da
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Enable autocompletion

## AWS
export PATH=/opt/homebrew/bin/aws_completer:$PATH
complete -C '/opt/homebrew/bin/aws_completer' aws

## Azure
source /opt/homebrew/etc/bash_completion.d/az

## Homebrew
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# Personal Bash aliases and functions
alias gitpretty="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# To install claude-flow globally
export CPLUS_INCLUDE_PATH=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1

# VS Code
export PATH="$PATH:/mnt/c/Users/V/AppData/Local/Programs/Microsoft VS Code/bin"
# Aliases
alias gitpretty="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev-commit"
