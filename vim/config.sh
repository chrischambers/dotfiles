#!/bin/sh

# Defaults:
vim=vim
gvim="vim -g"

source_platform_specific_file_for "vim/config.sh"

alias vi="$vim"
alias vim="$vim"
alias gvim="$gvim"

# function visvim () {
#     "$vim" "$1"
# }
# export VISUAL=visvim

export EDITOR="$vim"
export VISUAL="$vim"
export GIT_EDITOR="$vim"

# Vim Profiler:
alias vimprof="$vim --startuptime /dev/stdout -c \"qa\" | grep -v \"^[^0-9].*\" | sort"

function g () {
    # Should ensure that only one GUI is created and that subsequently opened
    # files will be opened within that one GUI.

    # Idea from Derek Wyatt (http://derekwyatt.org/):
    # https://vimeo.com/4446112
    # Implementation adapted from:
    # http://stackoverflow.com/questions/936501/let-gvim-always-run-a-single-instance

    # Launch server if needed
    servername="GVIM1"
    serverlist="`$gvim --serverlist`"
    if [ -z $serverlist ]; then
      $gvim --servername $servername
      # if [[ $os == "osx" ]]; then
      #   sleep 0.1
      # fi
    else
        servername="$($gvim --serverlist | head -n 1)"
    fi

    if [ $1 ]; then
      $gvim --servername $servername --remote-silent "$@"
    fi
    focus_application $servername
}

function focus_application () {
  # Currently hard-coded as "MacVim" for OSX - this is a flaw.
  servername=$1
  os=`detect_os`
  if [[ $os == "linux" ]]; then
    wmctrl -a $servername
  # elif [[ $os == "osx" ]]; then
  #   # open -a "MacVim"
  #   osascript -e 'activate application "MacVim"'
  fi
}
