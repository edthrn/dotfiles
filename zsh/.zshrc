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
ZSH_THEME="edouard-custom"

plugins=(git python docker django zsh-navigation-tools zsh-completions aws kubectl go)

ZSH_THEME="dracula"

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

