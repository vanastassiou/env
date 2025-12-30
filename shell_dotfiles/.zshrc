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

# Enable colors
autoload -U colors && colors

# Set prompt (simple and clean)
PROMPT='%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ '

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Basic auto/tab complete
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive

# Key bindings
bindkey -e  # Emacs key bindings
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias gitpretty="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Git prompt (if git is installed)
if command -v git &> /dev/null; then
  autoload -Uz vcs_info
  precmd_vcs_info() { vcs_info }
  precmd_functions+=( precmd_vcs_info )
  setopt prompt_subst
  RPROMPT='${vcs_info_msg_0_}'
  zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f'
  zstyle ':vcs_info:*' enable git
fi

# Load pyenv if available
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# Load nvm if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Homebrew (if installed)
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi