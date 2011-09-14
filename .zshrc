# Vanilla .zshrc
# --------------


# Turn on some options.
setopt auto_cd         # Change directory by typing a directory name on its own.
setopt extended_glob   # Turn on the more powerful pattern matching features.


# Zsh History Management: {{{
# ----------------------------------------------------------------------------

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt extended_history # Adds extra information to history (timestamps, etc.)
setopt histverify       # History substitutions placed on cli for editing,
                        # not run automatically.
setopt append_history   # Last shell to exit doesn't clobber history file
setopt share_history    # Hurrah!
bindkey ' ' magic-space # Enable 'magic space', which will automatically
                        # perform history substitution when spacebar is
                        # pressed:

setopt hist_ignore_dups   # Consecutive duplicate lines not saved
setopt hist_find_no_dups  # When searching backwards through history, encounter
                          # each different command once, even if repeated
                          # multiple times
setopt hist_ignore_space  # Lines preceded by ' ' character not stored in history
setopt hist_reduce_blanks # Remove extraneous whitespace whens storying history

# ----------------------------------------------------------------------------
# }}}

# Define some aliases.
alias pu=pushd
#

# Keybindings: {{{
# ----------------------------------------------------------------------------

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey -M emacs '\ee' edit-command-line
# bindkey -M emacs '\e[A': history-search-backward
# bindkey -M emacs '\e[B': history-search-forward

bindkey -M viins "\C-a" beginning-of-line
bindkey -M viins "\C-b" backward-char
bindkey -M viins "\C-d" delete-char
bindkey -M viins "\C-e" end-of-line
bindkey -M viins "\C-f" forward-char
bindkey -M viins "\C-k" kill-line
bindkey -M viins "\C-n" next-history
bindkey -M viins "\C-p" previous-history
bindkey -M viins "\C-w" backward-kill-word
bindkey -M viins "\e[A" history-search-backward
bindkey -M viins "\e[B" history-search-forward
bindkey -M viins "\C-h" backward-delete-char

bindkey -M viins "\C-u" undo

set -o vi

KEYTIMEOUT=10  # Default: 40, set lower to reduce escape key delay

# ----------------------------------------------------------------------------
# }}}

# Globbing: {{{
# ----------------------------------------------------------------------------
setopt noglobdots # Ensure that * doesn't automatically match hidden files

setopt csh_null_glob # # If there are several patterns on the command line, at
                     # least one must match a file or files; in that case, any
                     # that don't are removed from the argument list. If no
                     # pattern matches, an error is reported.

setopt numeric_glob_sort  # when using <-> to match ranges, do a numeric sort
                          # on the match (like ``sort -n`` on matched region).
                          #
# ----------------------------------------------------------------------------
# }}}

# Completion: {{{
# ----------------------------------------------------------------------------
autoload -U compinit
compinit
unsetopt list_ambiguous   # ``find -ex<TAB>`` will complete up to 'exec', but
                          # also list the other completions (``-execdir``, in
                          # this case)

# Infer descriptions for options without descriptions, by introspecting their
# argument names:
zstyle ':completion:*' auto-description 'specify: %d'

# Paginate long completions:
zmodload zsh/complist
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Use:
# * Tab to advance screen
# * Enter to advance single line
# * Ctrl-c to exit

# ISSUE: also sends 'q' character after exiting.
bindkey -M listscroll q send-break  # Emulates Ctrl-C when paging, above.

# Something like vim's 'smartcase' - here, completion is case-insensitive where
# lowercase letters are used, but not the reverse:
zstyle ':completion:*:(^approximate):*' matcher-list 'm:{a-z}={A-Z}'

setopt complete_in_word  # Expects characters after cursor to be at the end of
                         # matches. E.g. completing ``h.html`` with the cursor
                         # on the dot finds all files starting with h and
                         # ending in html!

zstyle ':completion:*' insert-tab true # Disables completion on leading tabs
                                       # (prevents pasted commands with leading
                                       # tabs from being interpreted as
                                       # completions):

# ----------------------------------------------------------------------------
# }}}

source ~/.profile
source ~/src/vim/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Prompt: {{{
# ----------------------------------------------------------------------------
# Must occur *after* the sourcing of .profile, which makes the
# commands/variables which comprise the prompt string available.

# . ~/.zsh_prompt_ft

setopt prompt_subst    # Enable substituing variables into prompt
unsetopt prompt_cr     # Suppress prompt printing carriage return before display

bg_red=$'%{\e[00;41m%}'

function zle-keymap-select {
    VIMODE="${${KEYMAP}/(main|viins)/}"
    zle reset-prompt
}

zle -N zle-keymap-select

function v {
    if [[ $VIMODE = 'vicmd' ]]; then
        echo "$bg_red"
    fi
}

setopt correct         # offer spelling suggestion for mistyped command
                       # [no / yes / abort / edit]

# Default Spelling Correction prompt: placed here for easy editing. Can use any
# other prompt escapes.
SPROMPT="zsh: correct '%R' to '%r' [nyae]?"

function prompt_precmd {
    st=$(cache_exit_status)
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_precmd

# Disable automatic modification of PS1 (we handle that ourselves!)
export VIRTUAL_ENV_DISABLE_PROMPT=1

PROMPT='
${hist_num} $(v)${user_sys_info}${RESET} ${time_stamp}$(jobs_count)
$(display_project_env)${cwd_path} $(main_prompt $st)${RESET} '
# ----------------------------------------------------------------------------
# }}}
