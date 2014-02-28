#!/usr/bin/env zsh

# To profile startup time for zsh, use::
# /usr/bin/time zsh -i -c exit

skip_global_compinit=1  # Performance optimisation, reduces startup time
REPORTTIME=10           # Operations lasting >= 10 seconds have `time` output

# ----------------------------------------------------------------------------

fpath=($DOTFILES/functions $fpath)

autoload -U $DOTFILES/functions/*(:t)

setopt no_bg_nice          # don't nice background tasks
setopt no_hup              # don't send HUP to running jobs on shell exit
setopt no_list_beep        # don't beep on ambiguous completion
setopt local_options       # any options changed within functions are restored
                           # to the way they were once those function finish.
setopt local_traps         # as above, but for traps (which intercept signals
                           # sent to the shell, e.g. SIGINT (Ctrl-C))

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
# Source: http://matt.blissett.me.uk/linux/zsh/zshrc
setopt rm_star_wait

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
