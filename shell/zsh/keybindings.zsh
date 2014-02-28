#!/usr/bin/env zsh

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
