#!/bin/bash

# Set colors for print
WARN='\033[0;33m'
ERROR='\033[0;31m'
INFO='\033[0;36m'
SUCCESS='\033[0;32m'
RESET='\033[0m'

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# Helper function to ask yes/no questions
ask_yes_no() {
    local prompt="$1"
    local response
    while true; do
        read -p "$prompt (y/n): " response
        case "$response" in
            [Yy]* ) return 0 ;;
            [Nn]* ) return 1 ;;
            * ) echo "Please answer y or n." ;;
        esac
    done
}

# Helper function to check if a symlink exists and points to the expected target
is_installed() {
    local link_path="$1"
    local expected_target="$2"

    if [ -L "$link_path" ]; then
        local actual_target=$(readlink "$link_path")
        if [ "$actual_target" = "$expected_target" ]; then
            return 0  # Already installed correctly
        else
            return 2  # Symlink exists but points elsewhere
        fi
    elif [ -e "$link_path" ]; then
        return 3  # File/directory exists but is not a symlink
    else
        return 1  # Does not exist
    fi
}

# Helper function to safely create a symlink
safe_symlink() {
    local source="$1"
    local target="$2"
    local description="$3"

    is_installed "$target" "$source"
    local status=$?

    if [ $status -eq 0 ]; then
        echo -e "${INFO}$description already installed (symlink exists)${RESET}"
        if ask_yes_no "Do you want to reinstall?"; then
            rm "$target"
            ln -s "$source" "$target"
            echo -e "${SUCCESS}$description reinstalled!${RESET}"
        else
            echo -e "${WARN}Skipping $description${RESET}"
        fi
    elif [ $status -eq 2 ]; then
        echo -e "${WARN}$description: Symlink exists but points to different location${RESET}"
        echo "  Current target: $(readlink "$target")"
        echo "  Expected target: $source"
        if ask_yes_no "Do you want to replace it?"; then
            rm "$target"
            ln -s "$source" "$target"
            echo -e "${SUCCESS}$description installed!${RESET}"
        else
            echo -e "${WARN}Skipping $description${RESET}"
        fi
    elif [ $status -eq 3 ]; then
        echo -e "${ERROR}$description: File/directory exists but is not a symlink${RESET}"
        echo "  Path: $target"
        if ask_yes_no "Do you want to backup and replace it?"; then
            mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
            ln -s "$source" "$target"
            echo -e "${SUCCESS}$description installed (original backed up)!${RESET}"
        else
            echo -e "${WARN}Skipping $description${RESET}"
        fi
    else
        ln -s "$source" "$target"
        echo -e "${SUCCESS}$description installed!${RESET}"
    fi
}

echo ""
echo "========================================="
echo "  Dotfiles Interactive Installation"
echo "========================================="
echo ""
echo "This script will help you install your dotfiles."
echo "You can choose which components to install."
echo ""

# Git configuration
if ask_yes_no "Install Git configuration?"; then
    echo -e "\n${INFO}Installing Git configuration...${RESET}"
    safe_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig" "Git config"
    safe_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global" "Git ignore global"
    if [ -f "$DOTFILES_DIR/git/.gitattributes_global" ]; then
        safe_symlink "$DOTFILES_DIR/git/.gitattributes_global" "$HOME/.gitattributes_global" "Git attributes global"
    fi
fi

# Bash configuration
if ask_yes_no "Install Bash configuration?"; then
    echo -e "\n${INFO}Installing Bash configuration...${RESET}"
    safe_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc" "Bash config"
fi

# Vim configuration
if ask_yes_no "Install Vim configuration?"; then
    echo -e "\n${INFO}Installing Vim configuration...${RESET}"
    if [ -d "$DOTFILES_DIR/vim/.vim" ]; then
        safe_symlink "$DOTFILES_DIR/vim/.vim" "$HOME/.vim" "Vim directory"
    fi
    safe_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc" "Vim config"
fi

# Tmux configuration
if ask_yes_no "Install Tmux configuration?"; then
    echo -e "\n${INFO}Installing Tmux configuration...${RESET}"
    safe_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" "Tmux config"
fi

# Zsh configuration
if ask_yes_no "Install Zsh configuration?"; then
    echo -e "\n${INFO}Installing Zsh configuration...${RESET}"

    # Check if Oh-My-Zsh is installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${WARN}Oh-My-Zsh not found.${RESET}"
        if ask_yes_no "Do you want to install Oh-My-Zsh now?"; then
            echo -e "${INFO}Installing Oh-My-Zsh...${RESET}"
            RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
                echo -e "${ERROR}Failed to install Oh-My-Zsh${RESET}"
                echo -e "${WARN}Skipping Zsh configuration.${RESET}"
                continue
            }
            echo -e "${SUCCESS}Oh-My-Zsh installed!${RESET}"
        else
            echo -e "${WARN}Skipping Zsh configuration. Install Oh-My-Zsh first: https://ohmyz.sh/${RESET}"
            continue
        fi
    fi

    # Install .zshrc
    safe_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" "Zsh config"

    # Install custom themes
    if [ -f "$DOTFILES_DIR/zsh/edouard-custom.zsh-theme" ]; then
        safe_symlink "$DOTFILES_DIR/zsh/edouard-custom.zsh-theme" "$HOME/.oh-my-zsh/themes/edouard-custom.zsh-theme" "Zsh custom theme"
    fi
    if [ -f "$DOTFILES_DIR/zsh/edouard-root.zsh-theme" ]; then
        safe_symlink "$DOTFILES_DIR/zsh/edouard-root.zsh-theme" "$HOME/.oh-my-zsh/themes/edouard-root.zsh-theme" "Zsh root theme"
    fi

    # Install Dracula theme
    if [ ! -f "$HOME/.oh-my-zsh/themes/dracula.zsh-theme" ]; then
        echo -e "${INFO}Installing Dracula theme for Zsh...${RESET}"
        if curl -fsSL https://raw.githubusercontent.com/dracula/zsh/master/dracula.zsh-theme -o "$HOME/.oh-my-zsh/themes/dracula.zsh-theme"; then
            echo -e "${SUCCESS}Dracula theme installed!${RESET}"
        else
            echo -e "${ERROR}Failed to install Dracula theme${RESET}"
        fi
    else
        echo -e "${INFO}Dracula theme already installed${RESET}"
    fi

    # Ensure custom plugins directory exists
    mkdir -p "$HOME/.oh-my-zsh/custom/plugins"

    # Install zsh-completions plugin
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
        echo -e "${INFO}Installing zsh-completions plugin...${RESET}"
        if git clone https://github.com/zsh-users/zsh-completions "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" 2>/dev/null; then
            echo -e "${SUCCESS}zsh-completions plugin installed!${RESET}"
        else
            echo -e "${ERROR}Failed to install zsh-completions plugin${RESET}"
        fi
    else
        echo -e "${INFO}zsh-completions plugin already installed${RESET}"
    fi

    # Verify standard plugins exist
    echo -e "${INFO}Verifying Oh-My-Zsh standard plugins...${RESET}"
    local missing_plugins=()
    for plugin in aws kubectl django go; do
        if [ ! -d "$HOME/.oh-my-zsh/plugins/$plugin" ]; then
            missing_plugins+=("$plugin")
        fi
    done

    if [ ${#missing_plugins[@]} -eq 0 ]; then
        echo -e "${SUCCESS}All standard plugins (aws, kubectl, django, go) are available!${RESET}"
    else
        echo -e "${WARN}Missing standard plugins: ${missing_plugins[*]}${RESET}"
        echo -e "${INFO}These should be included with Oh-My-Zsh. Consider updating Oh-My-Zsh:${RESET}"
        echo "  cd ~/.oh-my-zsh && git pull"
    fi
fi

# Neovim configuration
if ask_yes_no "Install Neovim configuration?"; then
    echo -e "\n${INFO}Installing Neovim configuration...${RESET}"
    # Ensure .config directory exists
    mkdir -p "$HOME/.config"
    safe_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim" "Neovim config"
fi

# Alacritty configuration
if ask_yes_no "Install Alacritty configuration?"; then
    echo -e "\n${INFO}Installing Alacritty configuration...${RESET}"
    # Ensure .config directory exists
    mkdir -p "$HOME/.config"
    safe_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty" "Alacritty config"
fi

# PyCharm configuration
if ask_yes_no "Install PyCharm configuration?"; then
    echo -e "\n${INFO}Installing PyCharm configuration...${RESET}"
    if [ -f "$DOTFILES_DIR/pycharm/pycharm-settings.jar" ]; then
        echo -e "${INFO}PyCharm settings file found: $DOTFILES_DIR/pycharm/pycharm-settings.jar${RESET}"
        echo "To import these settings:"
        echo "1. Open PyCharm"
        echo "2. Go to File > Manage IDE Settings > Import Settings"
        echo "3. Select: $DOTFILES_DIR/pycharm/pycharm-settings.jar"
    else
        echo -e "${WARN}PyCharm settings file not found.${RESET}"
    fi
fi

echo ""
echo "========================================="
echo -e "${SUCCESS}Installation complete!${RESET}"
echo "========================================="
echo ""
