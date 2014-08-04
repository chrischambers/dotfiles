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

source_platform_specific_file_for "shell/aliases.sh"
