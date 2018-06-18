#!/bin/bash

# Set colors for print
WARN='\033[0;33m'
ERROR='\033[0;31m'
INFO='\033[0;36m'
SUCCESS='\033[0;32m'

echo "\nInstalling dotfiles..."
echo -e "${INFO}Renaming directory..."
mv ~/dotfiles ~/.dotfiles

ln -s ~/.dotfiles/git/.gitconfig ~/
ln -s ~/.dotfiles/git/.gitignore_global ~/
echo ".gitconfig copied!"
ln -s ~/.dotfiles/bash/.bashrc ~/
echo ".bashrc copied!"
ln -s ~/.dotfiles/vim/.vim ~/
ln -s ~/.dotfiles/vim/.vimrc ~/
echo "Vim conf-files copied!"
ln -s ~/.dotfiles/tmux/.tmux.conf ~/
echo ".tmux-conf copied!"
ln -s ~/.dotfiles/zsh/.zshrc ~/
echo ".zshrc copied!"
ln -s ~/.dotfiles/zsh/edouard-custom.zsh-theme ~/.oh-my-zsh/themes/
ln -s ~/.dotfiles/zsh/edouard-root.zsh-theme ~/.oh-my-zsh/themes/
echo "zsh-themes copied!"
