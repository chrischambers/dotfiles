# Common Configuration:
# ---------------------

prepend_to_path "$HOME/bin"
prepend_to_path "${DOTFILES}/bin"
export MANPATH="$HOME/man:$MANPATH"
# ...should contain man1/plod.1 to find manfile for plod, for example.

# Colour grep results - regex match in green
alias grep="grep --color=auto"
export GREP_COLOR='1;32'

# export TERM=xterm-color
# export COLORTERM=xterm
export CLICOLOR=true
export PAGER=less
export LESS=-r    # Outputs raw control characters: necessary if you're piping
                  # in colourised output (as ipython does)

source_platform_specific_file_for "shell/config.sh"
