function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    svn info >/dev/null 2>/dev/null && echo '§' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '>'
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

PROMPT='%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)
$(virtualenv_info)$(prompt_char) '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""
