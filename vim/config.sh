#!/bin/sh

export EDITOR=vim
export VISUAL="vim -g"
export GIT_EDITOR="vim"
alias vi="vim"
alias gvim="vim -g"
alias g='gvim --servername Vim1 --remote-silent'
alias vimprof='vim --startuptime /dev/stdout -c "qa" | grep -v "^[^0-9].*" | sort'

source_platform_specific_file_for "vim/config.sh"
