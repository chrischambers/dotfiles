# Common Configuration:
# ---------------------

export PATH="/$HOME/bin:$PATH"
export MANPATH="$HOME/man:$MANPATH"
# ...should contain man1/plod.1 to find manfile for plod, for example.

# Colour grep results - regex match in green
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# export TERM=xterm-color
# export COLORTERM=xterm
export CLICOLOR=true
export PAGER=less
export LESS=-r    # Outputs raw control characters: necessary if you're piping
                  # in colourised output (as ipython does)

source_platform_specific_file_for "$DOTFILES/shell/config.sh"
