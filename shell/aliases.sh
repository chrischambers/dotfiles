# If you don't have the beep utility installed, create a simple system beep
# alias. This may or may not emit a chime depending on the OS (it doesn't do
# anything for cygwin on Windows 7, for example):

if [[ -z $(which beep > /dev/null 2>&1) ]]; then
    alias beep='printf "\a"'
fi

alias h='history | tail -n 10'    # previous 10 history lines, for context

if ls --color -d . >/dev/null 2>&1; then
  alias ls='ls -F --color=auto'   # colorise and use symbolic key for filetypes
  alias l="ls -AlhF --color=auto" # colorised, symbolic key, long listing w/
                                  # hidden files and human-readable file sizes.
elif ls -G -d . >/dev/null 2>&1; then
  alias ls='ls -FG'               # colorise and use symbolic key for filetypes
  alias l="ls -AlhFG"             # colorised, symbolic key, long listing w/
                                  # hidden files and human-readable file sizes.
fi

alias tree='tree -FC'             # colorise and use symbolic key for filetypes
