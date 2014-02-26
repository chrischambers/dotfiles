#!/usr/bin/env bash

detect_os () {
  # Outputs one of the following, depending on your system:

  # * linux
  # * osx
  # * cygwin
  # * windows
  # * freebsd
  # * unknown (fallback)

  # http://stackoverflow.com/questions/394230/detect-the-os-from-a-bash-script

  if [[ "$OSTYPE" == "linux-gnu" ]]; then
      echo linux
  elif [[ "$OSTYPE" == "darwin"* ]]; then
      echo osx
  elif [[ "$OSTYPE" == "cygwin" ]]; then
      echo cygwin
  elif [[ "$OSTYPE" == "win32" ]]; then
      echo windows
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
      echo freebsd
  else
      echo unknown
  fi
}

source_if_readable () {
  if [[ -r $1 ]]; then
    source $1
    # echo "sourced $1"
  fi
  # echo $1
}

source_before_file_for () { source_if_readable ${1}.before }
source_platform_specific_file_for () { source_if_readable ${1}.$(detect_os) }
source_after_file_for () { source_if_readable ${1}.after }
source_local_file_for () { source_if_readable ${1}.local }
