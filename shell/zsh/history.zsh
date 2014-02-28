#!/usr/bin/env zsh

# Zsh History Management: {{{
# ----------------------------------------------------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history


setopt extended_history   # Adds extra info to history (esp. timestamps)
setopt histverify         # History substitutions placed on cli for editing,
                          # not run automatically.
setopt inc_append_history # History incrementally appended to file, as opposed
                          # to appending on shell exit (setopt append_history),
                          # or clobbering the history file (neither option set,
                          # and a common issue with bash). History also shared
                          # across sessions.
setopt share_history      # Hurrah!
bindkey ' ' magic-space   # Enable 'magic space', which will automatically
                          # perform history substitution when spacebar is
                          # pressed.

setopt hist_ignore_dups   # Consecutive duplicate lines not saved (use setopt
                          # hist_ignore_all_dups to remove all previous
                          # duplicate lines, as opposed to consecutive ones).
setopt hist_find_no_dups  # When searching backwards through history, encounter
                          # each different command once, even if repeated
                          # multiple times
setopt hist_ignore_space  # Lines preceded by ' ' not stored in history
setopt hist_reduce_blanks # Remove extraneous whitespace when storing history
# ----------------------------------------------------------------------------
# }}}
