source_platform_specific_file_for "python/virtualenv.sh"

# Virtualenv and Pip Configuration: {{{
# ----------------------------------------------------------------------------
export WORKON_HOME="$HOME/.virtualenvs"
if [[ -r $virtualenvwrapper_loc ]]; then
    source $virtualenvwrapper_loc
fi
# Note: switching envs seems to undo the PATH manipulation above.

export PIP_VIRTUALENV_BASE=$WORKON_HOME
# makes pip detect an active virtualenv and install to it, without having to
# pass it the -E parameter
# Source: <http://www.doughellmann.com/docs/virtualenvwrapper/tips.html>
export PIP_RESPECT_VIRTUALENV=true

# }}}
# ----------------------------------------------------------------------------
