# Sample config file can be found in ~/.oh-my-zsh/.zshrc.sample

export PATH="/home/edouard/miniconda3/bin:$PATH"
export SCALA_HOME=/usr/share/scala
export PATH=$SCALA_HOME/bin:/usr/share/sbt/bin:$PATH
export ZSH=/home/edouard/.oh-my-zsh
ZSH_THEME="edouard-custom"

plugins=(git python docker django zsh-navigation-tools zsh-completions aws kubectl go)

source $ZSH/oh-my-zsh.sh
alias sbcl='rlwrap sbcl'
alias vbox='VBoxManage'
alias clojure='rlwrap clojure'
alias clj='rlwrap clj'

