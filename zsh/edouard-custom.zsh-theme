RPROMPT='$(git_prompt_info)'

# prompt turns red if the previous command didn't exit with 0
local arrow="%(?:%{$fg_bold[yellow]%}➜ :%{$fg_bold[red]%}➜ )"
# local conda_env="%(%{$CONDA_PROMPT_MODIFIER%})"
PROMPT='
%{$fg[green]%}%n@%m %{$fg[cyan]%}$(get_pwd)
%{$fg_bold[{$COLOR}]%}${arrow}%{$reset_color%}'

# Replace home by ~
function get_pwd() {
  echo "${PWD/$HOME/~}"
}


ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✘"
