unsetopt list_ambiguous  # ``find -ex<TAB>`` will complete up to 'exec', but
                         # also list the other completions (``-execdir``, in
                         # this case)
setopt complete_in_word  # Expects characters after cursor to be at the end of
                         # matches. E.g. completing ``h.html`` with the cursor
                         # on the dot finds all files starting with h and
                         # ending in html!

# Infer descriptions for options without descriptions, by introspecting their
# argument names:
zstyle ':completion:*' auto-description 'specify: %d'

# Paginate long completions:
#
#  Use:
#  * Tab to advance screen
#  * Enter to advance single line
#  * Ctrl-c to exit
#
zmodload zsh/complist
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
bindkey -M listscroll q send-break  # Emulates Ctrl-C when paging, above.

# Something like vim's 'smartcase' - here, completion is case-insensitive where
# lowercase letters are used, but not the reverse:
zstyle ':completion:*:(^approximate):*' matcher-list 'm:{a-z}={A-Z}'

# Disables completion on leading tabs (prevents pasted commands with leading
# tabs from being interpreted as completions):
zstyle ':completion:*' insert-tab true

