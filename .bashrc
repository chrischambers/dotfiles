source ~/.profile


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

# Other Bash options: {{{
# ----------------------------------------------------------------------------
shopt -u dotglob # Ensure that * doesn't automatically match hidden files
# }}}

# Completion: {{{
# ----------------------------------------------------------------------------
# Enable pimping django bash-completion:
if [[ -r $django_bash_completion ]]; then
    source $django_bash_completion
fi

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

# Disables completion on leading tabs (prevents pasted commands with leading
# tabs from being interpreted as completions):
shopt -s no_empty_cmd_completion
# }}}
