RPROMPT='$(git_prompt_info)'

PROMPT='%{$fg[green]%}%n@%m %{$fg[cyan]%}$(get_pwd)
%{$fg_bold[yellow]%}→ %{$reset_color%} '

# Replace home by ~
function get_pwd() {
  echo "${PWD/$HOME/~}"
}


ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✘"
