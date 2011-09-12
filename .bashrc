

# System Specific Variables:
# --------------------------
virtualenvwrapper_loc=$HOME/src/py/virtualenvwrapper/virtualenvwrapper.sh
django_bash_completion=$HOME/src/py/django/django/extras/django_bash_completion

# Pre OS-specific Customisation Tweaks: {{{
# ----------------------------------------------------------------------------
export EDITOR=vim
alias gvim="vim -g"
# ----------------------------------------------------------------------------
# }}}

# Load OSX-Specific Bash Customisations: {{{
# ----------------------------------------------------------------------------
osx_conf=~/.bashrc_osx
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

shopt -u dotglob # Ensure that * doesn't automatically match hidden files

# Bash History Management: {{{
# ----------------------------------------------------------------------------
# Use -s to set, -u to unset:

# Append to history: don't clobber it when multiple shells are active.
shopt -s histappend
# Using history event/word designator expansion require a further RET keypress
# for confirmation:
shopt -s histverify
# Save all lines of a multi-line command as one history entry:
shopt -s cmdhist
# Don't flatten multi-line commands into single-lines with ; delimiters:
shopt -s lithist
# Avoid adding duplicate commands to history:
export HISTCONTROL=ignoredups
# Ignore commands with preceding whitespace, and some basic commands
# Source: <url:http://www.talug.org/events/20030709/cmdline_history.html>
export HISTIGNORE="&:[ \t]*:ls:[bf]g:exit:clear:h"
# Source: <url:http://djangotricks.blogspot.com/2008/09/note-on-python-paths.html>
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
# Enable 'magic space', which will automatically perform history substitution
# when spacebar is pressed:
bind '" ": magic-space'
# ----------------------------------------------------------------------------
# }}}

# Bash Prompt: {{{
# ----------------------------------------------------------------------------
source ~/.colour_palette
# }}}
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
    local git_branch=`parse_git_branch`
    local virtualenv=`parse_active_virtualenv`
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
    if [[ $(jobs | wc -l | tr -d " ") -gt 0 ]]; then
        echo " ${YELLOW}[${PURPLE}jobs: \j${YELLOW}]";
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
    if [[ $1 = 0 ]]; then
        echo "${BOLD_GREEN}\$"
    else
        echo "${BOLD_RED}\$"
    fi
}

update_titlebar() {
    # Updates the titlebar for suitable terminals.
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

hist_num="${YELLOW}[${BOLD_GREEN}\!${YELLOW}]"
user_sys_info="${BOLD_BLUE}\u${YELLOW}@${BOLD_BLUE}\h"
time_stamp="${YELLOW}[${RED}\t${YELLOW}]"
cwd_path="${YELLOW}[ ${BOLD_BLUE}\w${YELLOW} ]"
PROMPT_COMMAND='status=$(cache_exit_status);
PS1="$(update_titlebar)\n${hist_num} ${user_sys_info} ${time_stamp}$(jobs_count)
$(display_project_env)${cwd_path} $(main_prompt $status)${RESET} "'

# Old Prompts: {{{
# Original prompt:
#PS1='\[\033[01;31m\]\h\[\033[01;34m\]::\[\033[01;32m\]\u\n\[\033[01;33m\][ \[\033[01;34m\]\w \[\033[01;33m\]]\[\033[01;34m\]$ \[\033[00m\]'

# Revised prompt:
#PS1='\[\033[01;34m\]\u\[\033[01;32m\]@\[\033[01;31m\]\h\[\033[01;32m\]$(parse_git_branch)\n\[\033[01;33m\][ \[\033[01;34m\]\w \[\033[01;33m\]]\[\033[01;34m\]\$ \[\033[00m\] '
#PS1='${red}\u${bold_green}@${bold_red}\h${bold_green}$(parse_git_branch)\n${yellow}[ ${bold_blue}\w${yellow}]${bold_blue}\$${reset} '

# Sourced from <url:http://maketecheasier.com/8-useful-and-interesting-bash-prompts/2009/09/04>
#PROMPT_COMMAND='PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.\h: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"'

# function elite
# {
#
# local GRAY="\[\033[1;30m\]"
# local LIGHT_GRAY="\[\033[0;37m\]"
# local CYAN="\[\033[0;36m\]"
# local LIGHT_CYAN="\[\033[1;36m\]"
# local NO_COLOUR="\[\033[0m\]"
#
# case $TERM in
#     xterm*|rxvt*)
#         local TITLEBAR='\[\033]0;\u@\h:\w\007\]'
#         ;;
#     *)
#         local TITLEBAR=""
#         ;;
# esac
#
# local temp=$(tty)
# local GRAD1=${temp:5}
# PS1="$TITLEBAR\
# $GRAY-$CYAN-$LIGHT_CYAN(\
# $CYAN\u$GRAY@$CYAN\h\
# $LIGHT_CYAN)$CYAN-$LIGHT_CYAN(\
# $CYAN\#$GRAY/$CYAN$GRAD1\
# $LIGHT_CYAN)$CYAN-$LIGHT_CYAN(\
# $CYAN\$(date +%H%M)$GRAY/$CYAN\$(date +%d-%b-%y)\
# $LIGHT_CYAN)$CYAN-$GRAY-\
# $LIGHT_GRAY\n\
# $GRAY-$CYAN-$LIGHT_CYAN(\
# $CYAN\$$GRAY:$CYAN\w\
# $LIGHT_CYAN)$CYAN-$GRAY-$LIGHT_GRAY " 
# PS2="$LIGHT_CYAN-$CYAN-$GRAY-$NO_COLOUR "
# }
# }}}
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
alias ls='ls -FG'     # colorise and use symbolic key for filetypes
alias tree='tree -FC' # colorise and use symbolic key for filetypes
alias l="ls -AlhFG"   # colorised, symbolic key, long listing w/ hidden files
                      # and human-readable file sizes.

# Git specific:
alias git-svn='git svn'
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

# Python specific:
alias show_site_packages='python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"'
alias delpyc='find ./ -type f -name "*.pyc" -exec rm -f {} \;'
# ----------------------------------------------------------------------------
# }}}

# Virtualenv and Pip Configuration: {{{
# ----------------------------------------------------------------------------
#workon script
source $virtualenvwrapper_loc
# Note: switching envs seems to undo the PATH manipulation above.

# Pip Stuff:
export PIP_VIRTUALENV_BASE=$WORKON_HOME
# ----------------------------------------------------------------------------
# }}}

# Django Specific: {{{
# ----------------------------------------------------------------------------
# Enable pimping django bash-completion:
source $django_bash_completion

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

# My Projects: Languagelab: {{{
# ----------------------------------------------------------------------------
alias languagelab='screen -S languagelab -c ~/.screenrc.languagelab'
export PGUSER='llab'
export PGDATABASE='langlab'
# ----------------------------------------------------------------------------
# }}}


# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

