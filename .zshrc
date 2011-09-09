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
# Load the function-based completion system.
autoload -U compinit
compinit


# Keybindings: {{{
# ----------------------------------------------------------------------------

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey -M emacs '\ee' edit-command-line
# bindkey -M emacs '\e[A': history-search-backward
# bindkey -M emacs '\e[B': history-search-forward

# ----------------------------------------------------------------------------
# }}}

virtualenvwrapper_loc=$HOME/src/py/virtualenvwrapper/virtualenvwrapper.sh
source $virtualenvwrapper_loc
alias l='ls -AlhFG'
# . ~/.zsh_prompt_ft
source ~/.colour_palette

setopt prompt_subst    # Enable substituing variables into prompt
unsetopt prompt_cr     # Suppress prompt printing carriage return before display

function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/${RED}}/(main|viins)/}"
    zle reset-prompt
}

zle -N zle-keymap-select



# PS1="${YELLOW}"'['"${GREEN}"'%!'"${YELLOW}"']'"${BLUE}"' %n'"${YELLOW}"'@'"${BLUE}"'%m '"${YELLOW}"'['"${RED}"'%*'"${YELLOW}"']
# ['"${BLUE}"' %~ '"${YELLOW}"'] '"${RED}"'%# '"${RESET}"

PROMPT='${YELLOW}[${GREEN}%!${YELLOW}]${BLUE} %n${YELLOW}@${BLUE}%m ${YELLOW}[${RED}%*${YELLOW}]
[${BLUE} %~ ${YELLOW}] ${RED}%# ${RESET}${VIMODE}'

setopt correct         # offer spelling suggestion for mistyped command
                       # [no / yes / abort / edit]

# Default Spelling Correction prompt: placed here for easy editing. Can use any
# other prompt escapes.
SPROMPT="zsh: correct '%R' to '%r' [nyae]?"
