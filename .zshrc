#!/usr/bin/env zsh

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
                        # pressed.

setopt hist_ignore_dups   # Consecutive duplicate lines not saved
setopt hist_find_no_dups  # When searching backwards through history, encounter
                          # each different command once, even if repeated
                          # multiple times
setopt hist_ignore_space  # Lines preceded by ' ' character not stored in history
setopt hist_reduce_blanks # Remove extraneous whitespace when storing history

# ----------------------------------------------------------------------------
# }}}

# Keybindings: {{{
# ----------------------------------------------------------------------------

autoload -Uz edit-command-line
zle -N edit-command-line

bindkey -M vicmd 'v' edit-command-line
bindkey -M viins "\C-a" beginning-of-line
bindkey -M viins "\C-b" backward-char
bindkey -M viins "\C-d" delete-char
bindkey -M viins "\C-e" end-of-line
bindkey -M viins "\C-f" forward-char
bindkey -M viins "\C-k" kill-line
bindkey -M viins "\C-n" down-line-or-history
bindkey -M viins "\C-p" up-line-or-history
bindkey -M viins "\C-o" accept-line-and-down-history
bindkey -M viins "\C-w" backward-kill-word
bindkey -M viins "\e[A" history-beginning-search-backward
bindkey -M viins "\e[B" history-beginning-search-forward
bindkey -M viins "\C-h" backward-delete-char
bindkey -M viins "\C-r" history-incremental-search-backward
bindkey -M viins "\C-s" history-incremental-search-forward

bindkey -M viins "\C-u" undo

# Integrate this, somehow?
# bindkey -M emacs '\ee' edit-command-line
bindkey -M viins "\C-x\C-e" edit-command-line

set -o vi

KEYTIMEOUT=10  # Default: 40, set lower to reduce escape key delay

# ----------------------------------------------------------------------------
# }}}

# Globbing: {{{
# ----------------------------------------------------------------------------

setopt extended_glob      # Turn on the more powerful pattern matching
                          # features.
setopt noglobdots         # Ensure that * doesn't automatically match hidden
                          # files
setopt csh_null_glob      # If there are several patterns on the command line,
                          # at least one must match a file or files; in that
                          # case, any that don't are removed from the argument
                          # list. If no pattern matches, an error is reported.
setopt numeric_glob_sort  # when using <-> to match ranges, do a numeric sort
                          # on the match (like ``sort -n`` on matched region).

# ----------------------------------------------------------------------------
# }}}

# Oh-my-zsh Plugins Setup (Must be Before Completion section)
# Path to your oh-my-zsh configuration.
OMZSH=$HOME/src/vim/dotfiles/oh-my-zsh
plugins=(git github git-flow pip osx macports mercurial)

fpath=($OMZSH/functions $OMZSH/completions $fpath)
autoload colors; colors;                      # vi-mode plugin depends on this
plugin=${plugin:=()}
for plugin ($plugins) fpath=($OMZSH/plugins/$plugin $fpath)

# Re-aliasing overriden g:
alias g='gvim --servername Vim1 --remote-silent'


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
# Use:
# * Tab to advance screen
# * Enter to advance single line
# * Ctrl-c to exit
zmodload zsh/complist
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
bindkey -M listscroll q send-break  # Emulates Ctrl-C when paging, above.

# Something like vim's 'smartcase' - here, completion is case-insensitive where
# lowercase letters are used, but not the reverse:
zstyle ':completion:*:(^approximate):*' matcher-list 'm:{a-z}={A-Z}'

# Disables completion on leading tabs (prevents pasted commands with leading
# tabs from being interpreted as completions):
zstyle ':completion:*' insert-tab true

setopt complete_in_word  # Expects characters after cursor to be at the end of
                         # matches. E.g. completing ``h.html`` with the cursor
                         # on the dot finds all files starting with h and
                         # ending in html!

# ----------------------------------------------------------------------------
# }}}

source ~/.profile

# Configure sexy syntax-hightlighting:
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

# ----------------------------------------------------------------------------
# }}}

# Oh-my-zsh Plugins activation
for plugin ($plugins); do
  if [ -f $OMZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $OMZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

# Misc:
function zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

# Color grep results
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

function fix_git_dropbox_sync () {
    # Idea derived from the thread here:
    # http://forums.dropbox.com/topic.php?id=5203
    # Test for changes from here:
    # http://stackoverflow.com/questions/5143795/how-can-i-check-in-a-bash-script-if-my-local-git-repo-has-changes-or-not

    if git diff-index --quiet HEAD --; then
        return                                # No local changes, so no-op
    fi

    git config core.fileMode false
    ! git diff-index --quiet HEAD --
    has_local_changes=$?
    if [ $has_local_changes = 0 ]; then
        git stash save
    fi
    git config core.fileMode true && \
    git reset --hard HEAD
    if [ $has_local_changes = 0 ]; then
        git stash pop
    fi
}

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
# Source: http://matt.blissett.me.uk/linux/zsh/zshrc
setopt rm_star_wait

# multiple stdin/stdout/stderr redirects (you don't have to use ``tee`` to
# output to term and a file, for example). This includes pipes::
#
#   % echo Script started. >logfile | sed 's/started/stopped/'
#   Script stopped.
#   % cat logfile
#   Script started.
#
# Multiple stdin redirects concatenates them in the order specified.
setopt multios

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end
