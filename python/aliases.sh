#!/bin/sh

alias show_site_packages='python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"'
alias delpyc='find ./ -type f -name "*.pyc" -exec rm -f {} \;'
