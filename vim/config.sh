#!/bin/sh

# Defaults:
vim=vim
gvim=gvim

source_platform_specific_file_for "vim/config.sh"

alias vi=$vim

function visvim () { $vim $1 }
export EDITOR=$vim
export VISUAL=visvim
export GIT_EDITOR=$vim

# Vim Profiler:
alias vimprof="vim --startuptime /dev/stdout -c \"qa\" | grep -v \"^[^0-9].*\" | sort"

function g () {
    # Should ensure that only one GUI is created and that subsequently opened
    # files will be opened within that one GUI.
    $gvim --nofork --servername Vim1 --remote-silent "$@" &
}
