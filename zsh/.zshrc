# Sample config file can be found in ~/.oh-my-zsh/.zshrc.sample

# Miniconda3 - only add if installed
[ -d "$HOME/miniconda3/bin" ] && export PATH="$HOME/miniconda3/bin:$PATH"

# Scala/SBT - only add if installed
if [ -d "/usr/share/scala" ]; then
    export SCALA_HOME=/usr/share/scala
    export PATH=$SCALA_HOME/bin:$PATH
fi
[ -d "/usr/share/sbt/bin" ] && export PATH="/usr/share/sbt/bin:$PATH"

export ZSH=$HOME/.oh-my-zsh

# Use custom theme with Dracula colors
# Falls back to standalone Dracula theme if custom theme is not available
if [ -f "$ZSH/themes/edouard-custom.zsh-theme" ]; then
    ZSH_THEME="edouard-custom"
elif [ -f "$ZSH/themes/dracula.zsh-theme" ]; then
    ZSH_THEME="dracula"
else
    ZSH_THEME="robbyrussell"  # Default Oh-My-Zsh theme
fi

# Only include plugins that are available in Oh-My-Zsh
# Core plugins that should always be available
plugins=(git python docker zsh-navigation-tools)

# Add optional plugins if they exist
[ -d "$ZSH/plugins/aws" ] && plugins+=(aws)
[ -d "$ZSH/plugins/kubectl" ] && plugins+=(kubectl)
[ -d "$ZSH/plugins/django" ] && plugins+=(django)
[ -d "$ZSH/plugins/go" ] && plugins+=(go)

# zsh-completions requires manual installation
[ -d "$ZSH/custom/plugins/zsh-completions" ] && plugins+=(zsh-completions)

# Don't save in history commands that starts by space
# https://superuser.com/a/352858
setopt HIST_IGNORE_SPACE

# Neovim - only add if installed
[ -d "/opt/nvim-linux64/bin" ] && export PATH="$PATH:/opt/nvim-linux64/bin"

alias nv='nvim'
source $ZSH/oh-my-zsh.sh
alias sbcl='rlwrap sbcl'
alias vbox='VBoxManage'
alias clojure='rlwrap clojure'
alias clj='rlwrap clj'


. "$HOME/.local/bin/env"
export GH_PAGER=""

if [[ -n "$TOOLBOX_PATH" ]]; then
    PROMPT="⬢ $PROMPT"
fi
