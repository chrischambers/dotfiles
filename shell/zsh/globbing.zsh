#!/usr/bin/env zsh

# setopt extended_glob      # Turn on the more powerful pattern matching
#                           # features.
setopt noglobdots         # Ensure that * doesn't automatically match hidden
                          # files
setopt csh_null_glob      # If there are several patterns on the command line,
                          # at least one must match a file or files; in that
                          # case, any that don't are removed from the argument
                          # list. If no pattern matches, an error is reported.
setopt numeric_glob_sort  # when using <-> to match ranges, do a numeric sort
                          # on the match (like ``sort -n`` on matched region).
