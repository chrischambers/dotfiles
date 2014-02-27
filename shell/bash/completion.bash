# Disables completion on leading tabs (prevents pasted commands with leading
# tabs from being interpreted as completions):
shopt -s no_empty_cmd_completion

# ----------------------------------------------------------------------------
# Python Completion: {{{
# ------------------

_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# }}}
# ----------------------------------------------------------------------------
# Django Completion: {{{
# ------------------

if [[ -r $django_bash_completion ]]; then
    source $django_bash_completion
fi
# }}}
# ----------------------------------------------------------------------------
