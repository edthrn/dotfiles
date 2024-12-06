#!/bin/bash

# Set colors for print
WARN='\033[0;33m'
ERROR='\033[0;31m'
INFO='\033[0;36m'
SUCCESS='\033[0;32m'

echo "\nInstalling dotfiles..."
echo -e "${INFO}Renaming directory..."
mv $HOME/dotfiles $HOME/.dotfiles

ln -s $HOME/.dotfiles/git/.gitconfig $HOME
ln -s $HOME/.dotfiles/git/.gitignore_global $HOME
echo ".gitconfig copied!"
ln -s $HOME/.dotfiles/bash/.bashrc $HOME
echo ".bashrc copied!"
ln -s $HOME/.dotfiles/vim/.vim $HOME
ln -s $HOME/.dotfiles/vim/.vimrc $HOME
echo "Vim conf-files copied!"
ln -s $HOME/.dotfiles/tmux/.tmux.conf $HOME
echo ".tmux-conf copied!"
ln -s $HOME/.dotfiles/zsh/.zshrc $HOME
echo ".zshrc copied!"
ln -s $HOME/.dotfiles/zsh/edouard-custom.zsh-theme $HOME/.oh-my-zsh/themes/
ln -s $HOME/.dotfiles/zsh/edouard-root.zsh-theme $HOME/.oh-my-zsh/themes/
echo "zsh-themes copied!"
ln -s $HOME/.dotfiles/nvim $HOME/.config/nvim
echo "Nvim config copied!"
ln -s $HOME/.dotfiles/alacritty $HOME/.config/alacritty
echo "Alacritty config copied!"
