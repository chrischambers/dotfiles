setopt prompt_subst   # Enable substituting variables into prompt
unsetopt prompt_cr    # Suppress prompt printing carriage return before display

bg_red=$'%{\e[00;41m%}'

function zle-keymap-select zle-line-init {
    VIMODE="${${KEYMAP}/(main|viins)/}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

function v {
    if [[ $VIMODE = 'vicmd' ]]; then
        echo "$bg_red"
    fi
}

function accept_line {
    # Ensures that hitting return will reset the VIMODE variable - prevents,
    # say, backwards searching for command and then confirming (with return)
    # from showing that vi-cmd mode is active in the following prompt.

    # http://pthree.org/2009/03/28/add-vim-editing-mode-to-your-zsh-prompt/
    VIMODE=''
    builtin zle .accept-line
}
zle -N accept_line
bindkey -M vicmd "^M" accept_line


# Stolen from oh-my-zsh vi-mode plugin:
autoload colors; colors;
MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi

function prompt_precmd {
    st=$(cache_exit_status)
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_precmd

PROMPT='
${hist_num} $(v)${user_sys_info}${RESET} ${time_stamp}$(jobs_count)
$(display_project_env)${cwd_path} $(main_prompt $st)${RESET} '

setopt correct         # offer spelling suggestion for mistyped command
                       # [no / yes / abort / edit]

# Default Spelling Correction prompt: placed here for easy editing. Can use any
# other prompt escapes.
SPROMPT="zsh: correct '%R' to '%r' [nyae]?"
