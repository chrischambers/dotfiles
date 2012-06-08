#!/bin/sh

# Elements common to bash and zsh

# System Specific Variables:
# --------------------------
virtualenvwrapper_loc=$HOME/src/py/virtualenvwrapper/virtualenvwrapper.sh
django_bash_completion=$HOME/src/py/django/django/extras/django_bash_completion
django_project_template=$HOME/src/py/django/_mine/templates/project
django_app_template=$HOME/src/py/django/_mine/templates/app
django_pluggable_app_template=$HOME/src/py/django/_mine/templates/pluggable_app

# Pre OS-specific Customisation Tweaks: {{{
# ----------------------------------------------------------------------------
export EDITOR=vim
alias gvim="vim -g"
# ----------------------------------------------------------------------------
# }}}

# Load OSX-Specific Customisations: {{{
# ----------------------------------------------------------------------------
osx_conf=~/.profile_osx
if [[ ${OSTYPE:0:6} = 'darwin' ]] && [[ -r "$osx_conf" ]]; then
    source $osx_conf
fi
# ----------------------------------------------------------------------------
# }}}

# Post OS-specific Customisation Tweaks: {{{
# ----------------------------------------------------------------------------
export SVN_EDITOR=$EDITOR
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export MANPATH="$HOME/man:$MANPATH"
# ...should contain man1/plod.1 to find manfile for plod, for example.
# ----------------------------------------------------------------------------
# }}}

# Prompt: {{{
# ----------------------------------------------------------------------------
source ~/.colour_palette

# Disable automatic virtualenv modification of PS1 (we handle that ourselves!)
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Utility Functions for Prompt: {{{
parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_active_virtualenv() {
    if [[ -z $VIRTUAL_ENV ]]; then
        echo ''
    else
        echo `basename $VIRTUAL_ENV`
    fi
}

display_project_env() {
    # Displays virtualenv information and VCS branch.
    local git_branch="`parse_git_branch`"
    local virtualenv="`parse_active_virtualenv`"
    # echo $git_branch
    # echo $virtualenv
    if [[ -z $virtualenv ]] && [[ -z $git_branch ]]; then
        echo ''
    elif [[ -z $virtualenv ]]; then
        echo ${WHITE}'('${BOLD_GREEN}${git_branch}${WHITE}') '
    elif [[ -z $git_branch ]]; then
        echo ${WHITE}'('${BOLD_BLUE}${virtualenv}${WHITE}') '
    else
        echo ${WHITE}'('${BOLD_BLUE}${virtualenv}${WHITE}'/'${BOLD_GREEN}${git_branch}${WHITE}') '
    fi
}

jobs_count() {
    # Formats and returns the jobs count, in the format 'jobs: NUM'.
    if [[ -n $BASH_VERSION ]]; then
        jobs_prompt='\j'
    else
        jobs_prompt='%j'
    fi

    if [[ $(jobs | wc -l | tr -d " ") -gt 0 ]]; then
        echo " ${YELLOW}[${PURPLE}jobs: ${jobs_prompt}${YELLOW}]";
    fi
}
cache_exit_status() {
    # Stores the exit status of the previously executed command: /this/ is the
    # value we're interested in if we want to indicate the previous command's
    # success/failure status via our prompt.
    # If we don't use this cached value, it will instead use the
    # exit status of the last run utility function, and will therefore always
    # display as a success.
    exit_status="$?"
    echo $exit_status
}

main_prompt() {
    # Takes the cached exit status as its only argument; returns an
    # appropriately coloured prompt, using the appropriate symbol ($ for
    # standard user, # for root user).
    if [[ -n $BASH_VERSION ]]; then
        main_prompt='\$'
    else
        main_prompt='%#'
    fi
    if [[ $1 = 0 ]]; then
        echo "${BOLD_GREEN}${main_prompt}"
    else
        echo "${BOLD_RED}${main_prompt}"
    fi
}

update_titlebar() {
    # Updates the titlebar for suitable terminals.
    # Hardcoded for bash,atm.
    case $TERM in
        xterm*|rxvt*)
            local TITLEBAR='\[\033]0;\u@\h:\w\007\]'
            echo $TITLEBAR
            ;;
        *)
            local TITLEBAR=""
            echo $TITLEBAR
            ;;
    esac
}
# }}}
# [498] ajax@Locris (jobs:1)
# (languagelab/redesign[!])[/Users/ajax/src/py/django/_mine/languagelab/llab-trunk/llcom] $ 
    if [[ -n $BASH_VERSION ]]; then
        hist_prompt='\!'
        user_prompt='\u'
        host_prompt='\h'
        timestamp_prompt='\t'
        cwd_prompt='\w'
    else
        hist_prompt='%!'
        user_prompt='%n'
        host_prompt='%m'
        timestamp_prompt='%*'
        cwd_prompt='%~'
    fi

hist_num="${YELLOW}[${BOLD_GREEN}${hist_prompt}${YELLOW}]"
user_sys_info="${BOLD_BLUE}${user_prompt}${YELLOW}@${BOLD_BLUE}${host_prompt}"
time_stamp="${YELLOW}[${RED}${timestamp_prompt}${YELLOW}]"
cwd_path="${YELLOW}[ ${BOLD_BLUE}${cwd_prompt}${YELLOW} ]"

# Bash only:
PROMPT_COMMAND='status=$(cache_exit_status);
PS1="$(update_titlebar)\n${hist_num} ${user_sys_info} ${time_stamp}$(jobs_count)
$(display_project_env)${cwd_path} $(main_prompt $status)${RESET} "'
# ----------------------------------------------------------------------------
# }}}

# Useful Variables: {{{
# ----------------------------------------------------------------------------
# export TERM=xterm-color
# export COLORTERM=xterm
# export CLICOLOR=true
export PAGER=less
export LESS=-r    # Outputs raw control characters: necessary if you're piping
                  # in colourised output (as ipython does)
# ----------------------------------------------------------------------------
# }}}

# Useful aliases: {{{
# ----------------------------------------------------------------------------
# If you don't have the beep utility installed, create a simple system beep
# alias:
if [[ -z $(which beep) ]]; then
    alias beep='printf "\a"'
fi
alias h='history | tail -n 10' # previous 10 history lines, for context

if ls --color -d . >/dev/null 2>&1; then
    alias ls='ls -F --color=auto'    # colorise and use symbolic key for filetypes
    alias l="ls -AlhF --color=auto"  # colorised, symbolic key, long listing w/
                                     # hidden files and human-readable file sizes.
elif ls -G -d . >/dev/null 2>&1; then
    alias ls='ls -FG'                # colorise and use symbolic key for filetypes
    alias l="ls -AlhFG"              # colorised, symbolic key, long listing w/
                                     # hidden files and human-readable file sizes.
fi

alias tree='tree -FC'          # colorise and use symbolic key for filetypes

# Git specific:
alias git-svn='git svn'

# Python specific:
alias show_site_packages='python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"'
alias delpyc='find ./ -type f -name "*.pyc" -exec rm -f {} \;'
# ----------------------------------------------------------------------------
# }}}

# Useful functions: {{{
# ----------------------------------------------------------------------------
screenload() {
    ### For loading .screenrc template files located in ~/.screens
    screen -S $1 -c ~/.screens/${1}
}
# ----------------------------------------------------------------------------
# }}}

# Virtualenv and Pip Configuration: {{{
# ----------------------------------------------------------------------------
export WORKON_HOME="$HOME/.virtualenvs"
source $virtualenvwrapper_loc
# Note: switching envs seems to undo the PATH manipulation above.

export PIP_VIRTUALENV_BASE=$WORKON_HOME
# makes pip detect an active virtualenv and install to it, without having to
# pass it the -E parameter
# Source: <http://www.doughellmann.com/docs/virtualenvwrapper/tips.html>
export PIP_RESPECT_VIRTUALENV=true


# ----------------------------------------------------------------------------
# }}}

# Django Specific: {{{
# ----------------------------------------------------------------------------
if [[ ${OSTYPE:0:6} = 'darwin' ]]; then
    tests_completed_notification() {
        growlnotify -a 'Languagelab Campfire' -t 'Tests Completed'  -m 'Django has finished running your testsuite'
    }
else
    tests_completed_notification() {
        echo 'Define a global_notification function for your platform - and check $OSTYPE, numbnuts!'
    }
fi

djtest() {
    ### Provides a friendly wrapper for Django's test runner; includes global
    ### notification facility and audible system-beep.
    if [[ $# -gt 2 ]]; then
        echo "You've specified more than 2 command-line arguments! (Should be only application and test-method-path.)"
        return 1
    elif [[ $# = 1 ]]; then
        local appname="$1"
        local command=$appname
    elif [[ $# = 2 ]]; then
        local appname="$1"
        local path="$2"
        local command="${appname}.${path}"
    else
        local command=""
    fi
    if [[ -e manage.py ]]; then
        echo "python manage.py test $command"
        python manage.py test $command
        tests_completed_notification
        beep
    else
        echo "Error: manage.py file not found; are you sure you're in a Django application directory?"
        return 1
    fi
}
# ----------------------------------------------------------------------------
# }}}
djproject() {
    django-admin.py startproject $1 --verbosity=2 --extension="py,txt,rst,json" --template="$django_project_template"
}
djapp() {
    django-admin.py startapp $1 --verbosity=2 --extension="py,txt,rst,json" --template="$django_app_template"
}
djplugapp() {
    django-admin.py startapp $1 --verbosity=2 --extension="py,txt,rst,json" --template="$django_pluggable_app_template"
}
