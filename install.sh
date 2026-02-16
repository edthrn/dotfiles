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

# Available configurations
CONFIG_NAMES=(
    "Git"
    "Bash"
    "Vim"
    "Tmux"
    "Zsh"
    "Neovim"
    "Alacritty"
    "Ghostty"
    "VSCode"
    "PyCharm"
)
CONFIG_COUNT=${#CONFIG_NAMES[@]}

# Track selected configs (0 = not selected, 1 = selected)
declare -a CONFIG_SELECTED
for ((i = 0; i < CONFIG_COUNT; i++)); do
    CONFIG_SELECTED[$i]=0
done

# Display the selection menu
show_menu() {
    echo ""
    echo "Which configs do you want to install?"
    echo ""
    for ((i = 0; i < CONFIG_COUNT; i++)); do
        local num=$((i + 1))
        if [ "${CONFIG_SELECTED[$i]}" -eq 1 ]; then
            printf "  %2d) ● %s\n" "$num" "${CONFIG_NAMES[$i]}"
        else
            printf "  %2d)   %s\n" "$num" "${CONFIG_NAMES[$i]}"
        fi
    done
    echo ""
    echo "Enter a number to toggle selection, or press Enter to proceed."
}

# Interactive selection loop
while true; do
    show_menu
    read -p "> " choice

    # Empty input = done selecting
    if [ -z "$choice" ]; then
        break
    fi

    # Validate input is a number in range
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$CONFIG_COUNT" ]; then
        local_idx=$((choice - 1))
        if [ "${CONFIG_SELECTED[$local_idx]}" -eq 0 ]; then
            CONFIG_SELECTED[$local_idx]=1
        else
            CONFIG_SELECTED[$local_idx]=0
        fi
    else
        echo -e "${ERROR}Invalid choice. Enter a number between 1 and $CONFIG_COUNT.${RESET}"
    fi
done

# Check if anything was selected
selected_count=0
for ((i = 0; i < CONFIG_COUNT; i++)); do
    if [ "${CONFIG_SELECTED[$i]}" -eq 1 ]; then
        selected_count=$((selected_count + 1))
    fi
done

if [ "$selected_count" -eq 0 ]; then
    echo -e "${WARN}No configurations selected. Nothing to install.${RESET}"
    exit 0
fi

# Show summary of what will be installed
echo ""
echo "========================================="
echo "  Dotfiles Installation"
echo "========================================="
echo ""
echo "Installing:"
for ((i = 0; i < CONFIG_COUNT; i++)); do
    if [ "${CONFIG_SELECTED[$i]}" -eq 1 ]; then
        echo "  ● ${CONFIG_NAMES[$i]}"
    fi
done
echo ""

# 1) Git configuration
if [ "${CONFIG_SELECTED[0]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing Git configuration...${RESET}"
    safe_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig" "Git config"
    safe_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global" "Git ignore global"
    if [ -f "$DOTFILES_DIR/git/.gitattributes_global" ]; then
        safe_symlink "$DOTFILES_DIR/git/.gitattributes_global" "$HOME/.gitattributes_global" "Git attributes global"
    fi
fi

# 2) Bash configuration
if [ "${CONFIG_SELECTED[1]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing Bash configuration...${RESET}"
    safe_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc" "Bash config"
fi

# 3) Vim configuration
if [ "${CONFIG_SELECTED[2]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing Vim configuration...${RESET}"
    if [ -d "$DOTFILES_DIR/vim/.vim" ]; then
        safe_symlink "$DOTFILES_DIR/vim/.vim" "$HOME/.vim" "Vim directory"
    fi
    safe_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc" "Vim config"
fi

# 4) Tmux configuration
if [ "${CONFIG_SELECTED[3]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing Tmux configuration...${RESET}"
    safe_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" "Tmux config"
fi

# 5) Zsh configuration
if [ "${CONFIG_SELECTED[4]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing Zsh configuration...${RESET}"

    # Check if Oh-My-Zsh is installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${WARN}Oh-My-Zsh not found.${RESET}"
        if ask_yes_no "Do you want to install Oh-My-Zsh now?"; then
            echo -e "${INFO}Installing Oh-My-Zsh...${RESET}"
            RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
                echo -e "${ERROR}Failed to install Oh-My-Zsh${RESET}"
                echo -e "${WARN}Skipping Zsh configuration.${RESET}"
            }
            echo -e "${SUCCESS}Oh-My-Zsh installed!${RESET}"
        else
            echo -e "${WARN}Skipping Zsh configuration. Install Oh-My-Zsh first: https://ohmyz.sh/${RESET}"
        fi
    fi

    if [ -d "$HOME/.oh-my-zsh" ]; then
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

        # Check and update Oh-My-Zsh if plugins are missing
        plugins_to_check=(aws kubectl django go)
        missing_plugins=()

        for plugin in "${plugins_to_check[@]}"; do
            if [ ! -d "$HOME/.oh-my-zsh/plugins/$plugin" ]; then
                missing_plugins+=("$plugin")
            fi
        done

        if [ ${#missing_plugins[@]} -gt 0 ]; then
            echo -e "${WARN}Missing Oh-My-Zsh plugins: ${missing_plugins[*]}${RESET}"
            if ask_yes_no "Do you want to update Oh-My-Zsh to get the latest plugins?"; then
                echo -e "${INFO}Updating Oh-My-Zsh...${RESET}"
                if (cd "$HOME/.oh-my-zsh" && git pull); then
                    echo -e "${SUCCESS}Oh-My-Zsh updated!${RESET}"

                    # Re-check which plugins are still missing
                    still_missing=()
                    for plugin in "${missing_plugins[@]}"; do
                        if [ ! -d "$HOME/.oh-my-zsh/plugins/$plugin" ]; then
                            still_missing+=("$plugin")
                        fi
                    done

                    if [ ${#still_missing[@]} -eq 0 ]; then
                        echo -e "${SUCCESS}All plugins now available!${RESET}"
                    else
                        echo -e "${WARN}Still missing: ${still_missing[*]}${RESET}"
                        echo -e "${INFO}These plugins may not be in your Oh-My-Zsh version.${RESET}"
                    fi
                else
                    echo -e "${ERROR}Failed to update Oh-My-Zsh${RESET}"
                fi
            else
                echo -e "${INFO}Skipping Oh-My-Zsh update. The .zshrc will only load available plugins.${RESET}"
            fi
        else
            echo -e "${SUCCESS}All Oh-My-Zsh plugins (aws, kubectl, django, go) are available!${RESET}"
        fi
    fi
fi

# 6) Neovim configuration
if [ "${CONFIG_SELECTED[5]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing Neovim configuration...${RESET}"
    mkdir -p "$HOME/.config"
    safe_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim" "Neovim config"
fi

# 7) Alacritty configuration
if [ "${CONFIG_SELECTED[6]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing Alacritty configuration...${RESET}"
    mkdir -p "$HOME/.config"
    safe_symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty" "Alacritty config"
fi

# 8) Ghostty configuration
if [ "${CONFIG_SELECTED[7]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing Ghostty configuration...${RESET}"
    mkdir -p "$HOME/.config"
    safe_symlink "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty" "Ghostty config"
fi

# 9) VSCode configuration
if [ "${CONFIG_SELECTED[8]}" -eq 1 ]; then
    echo -e "\n${INFO}Installing VSCode configuration...${RESET}"
    mkdir -p "$HOME/.config/Code/User"
    safe_symlink "$DOTFILES_DIR/vscode/settings.json" "$HOME/.config/Code/User/settings.json" "VSCode settings"
fi

# 10) PyCharm configuration
if [ "${CONFIG_SELECTED[9]}" -eq 1 ]; then
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
