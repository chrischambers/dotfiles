#!/usr/bin/env zsh

# To profile startup time for zsh, use::
# /usr/bin/time zsh -i -c exit

skip_global_compinit=1  # Performance optimisation, reduces startup time
REPORTTIME=10           # Operations lasting >= 10 seconds have `time` output

# ----------------------------------------------------------------------------
# Activate functions via autoload:

fpath=($DOTFILES/functions $fpath)
autoload -U $DOTFILES/functions/*(:t)

# ----------------------------------------------------------------------------

setopt no_bg_nice          # don't nice background tasks
setopt no_hup              # don't send HUP to running jobs on shell exit
setopt no_list_beep        # don't beep on ambiguous completion
setopt local_options       # any options changed within functions are restored
                           # to the way they were once those function finish.
setopt local_traps         # as above, but for traps (which intercept signals
                           # sent to the shell, e.g. SIGINT (Ctrl-C))
setopt sh_word_split       # enables the following::

                           #     foo="-a -l" && ls $foo
                           #     bar="vim -g" && $bar +5 -c "echo awesome"
                           #
                           # Without this option, we need to use the following
                           # approaches::

                           #     foo="-a -l" && ls ${=foo}
                           #     bar="vim -g" && $=bar +5 -c "echo awesome"

                           # Or we have to use arrays:
                           #     foo=(-a -l) && ls $foo
                           #     bar=(vim -g) && $bar +5 -c "echo awesome"

                           # The latter two approaches are not bash compatible.

# see http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

# multiple stdin/stdout/stderr redirects (you don't have to use ``tee`` to
# output to term and a file, for example). This includes pipes::
#
#   % echo Script started. >logfile | sed 's/started/stopped/'
#   Script stopped.
#   % cat logfile
#   Script started.
#
# Multiple stdin redirects concatenates them in the order specified.
setopt multios
