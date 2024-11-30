# prompt turns red if the previous command didn't exit with 0
local arrow="%(?:%{$fg_bold[green]%}>:%{$fg_bold[red]%}>)"
# local conda_env="%(%{$CONDA_PROMPT_MODIFIER%})"
PROMPT='%{$fg[green]%}%n@%m %{$fg[cyan]%}$(get_pwd) $(git_prompt_info)
 %{$fg_bold[{$COLOR}]%}${arrow}%{$reset_color%} '

# Replace home by ~
function get_pwd() {
  echo "${PWD/$HOME/~}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}[git:"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%}✘"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color]%}"
