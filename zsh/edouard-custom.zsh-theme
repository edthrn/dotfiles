# Dracula-themed custom prompt
# Uses Dracula color palette: https://draculatheme.com/

# prompt turns red if the previous command didn't exit with 0
local arrow="%(?:%{$fg_bold[green]%}>:%{$fg_bold[red]%}>)"
# local conda_env="%(%{$CONDA_PROMPT_MODIFIER%})"
PROMPT='%{$fg[cyan]%}%n@%m %{$fg[magenta]%}$(get_pwd) $(git_prompt_info)
 %{$fg_bold[{$COLOR}]%}${arrow}%{$reset_color%} '

# Replace home by ~
function get_pwd() {
  echo "${PWD/$HOME/~}"
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}[git:"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%}✘"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color]%}"
