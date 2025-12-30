# Bash-it Custom Themes

This directory contains custom themes for the Bash-it framework.

## vtheme

A clean, informative bash prompt theme featuring:
- Timestamp display
- Python virtual environment indicator
- User@host information
- Current working directory
- Git branch and status indicators
- Clean prompt arrow

## Installation

The `setup.sh` script in the parent directory will automatically:
1. Install Bash-it if not present
2. Copy vtheme to `~/.bash_it/themes/vtheme/`
3. Configure `.bashrc` to use vtheme

## Manual Installation

If you need to install manually:

```bash
# Install Bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh

# Install vtheme
mkdir -p ~/.bash_it/themes/vtheme
cp vtheme.theme.bash ~/.bash_it/themes/vtheme/

# Set theme in .bashrc
export BASH_IT_THEME='vtheme'
```

## Theme Preview

The vtheme prompt displays as:
```
[ 2025-12-30 11:00:00 ] (venv) user @ hostname in ~/current/directory
|main ✓| →
```

Where:
- Timestamp shows current date/time
- (venv) appears when in a Python virtual environment
- Git status shows branch name and clean (✓) or dirty (✗) state
- → is the prompt character