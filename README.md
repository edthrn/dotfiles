# dotfiles

Personal development environment configuration for terminal-based workflow.

## Installation

Run the interactive installation script:

```bash
cd ~/dotfiles
./install.sh
```

The script will:
- Install Oh-My-Zsh if not present
- Automatically install required Zsh plugins (zsh-completions)
- Install Dracula theme for Zsh
- Create symlinks for all configuration files
- Verify that standard Oh-My-Zsh plugins are available (aws, kubectl, django, go)

## TODO

- Improve live logging in `install.sh`
