# Universal zsh configuration
# Source platform-specific config automatically

# Determine the directory this script is in
DOTFILES_DIR="${0:A:h}"

# Source platform-specific config
if [[ "$OSTYPE" == "darwin"* ]]; then
  [ -f "$DOTFILES_DIR/.zshrc.mac" ] && source "$DOTFILES_DIR/.zshrc.mac"
elif grep -qEi "(microsoft|wsl)" /proc/version 2>/dev/null; then
  [ -f "$DOTFILES_DIR/.zshrc.wsl" ] && source "$DOTFILES_DIR/.zshrc.wsl"
fi

# Universal PATH additions
export PATH=/usr/local/bin:$PATH
export PATH=~/.npm-global/bin:$PATH

# Don't check mail when opening terminal
unset MAILCHECK

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="vtheme"

# Plugins - platform-specific plugins are added conditionally
plugins=(git dotenv pyenv python)
if [[ "$OSTYPE" == "darwin"* ]]; then
  plugins+=(macos)
fi

source $ZSH/oh-my-zsh.sh

# Completions
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Aliases
alias gitpretty="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
