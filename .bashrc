# System Specific Variables:
# --------------------------
virtualenvwrapper_loc=$HOME/src/py/virtualenvwrapper/virtualenvwrapper_bashrc

# Pre OS-specific Customisation Tweaks: {{{
# ----------------------------------------------------------------------------
export EDITOR=vim
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
export PATH="$HOME/bin:$PATH"
# ----------------------------------------------------------------------------
# }}}

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
# ----------------------------------------------------------------------------
# }}}

# Bash Prompt: {{{
# ----------------------------------------------------------------------------
PS1='\[\033[01;31m\]\h\[\033[01;34m\]::\[\033[01;32m\]\u\n\[\033[01;33m\][ \[\033[01;34m\]\w \[\033[01;33m\]]\[\033[01;34m\]$ \[\033[00m\]'
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
if [[ ${OSTYPE:0:6} = 'darwin' ]]; then
    tests_completed_notification() {
        growlnotify -a 'Languagelab Campfire' -st 'Tests Completed'  -m 'Django has finished running your testsuite'
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
# ----------------------------------------------------------------------------
# }}}

