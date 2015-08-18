if [[ $(uname -o) == "Cygwin" ]]; then
    # Overrides virtualenv pip switching:
    # alias pip=pip3
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    source /usr/bin/virtualenvwrapper.sh
fi
