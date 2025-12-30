# SSH Configuration

This directory contains SSH configuration templates.

## Setup

1. Copy `config.template` to `~/.ssh/config`
2. Update the placeholders with your actual key names
3. Ensure your SSH keys have proper permissions: `chmod 600 ~/.ssh/*`

## Security Notes

- NEVER commit actual SSH private keys to version control
- Keep your `~/.ssh` directory permissions at 700: `chmod 700 ~/.ssh`
- Keep individual key permissions at 600: `chmod 600 ~/.ssh/id_*`

## Adding New Hosts

Edit `config.template` to add new host configurations that should be shared across machines.