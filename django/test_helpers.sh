# If you don't have the beep utility installed, create a simple system beep
# alias. This may or may not emit a chime depending on the OS (it doesn't do
# anything for cygwin on Windows 7, for example):

if [[ -z $(command -v beep > /dev/null 2>&1) ]]; then
    alias beep='printf "\a"'
fi

tests_completed_notification() {
    echo 'Define a global_notification function for your platform'
}

djtest() {
    ### Provides a friendly wrapper for Django's test runner; includes global
    ### notification facility and audible system-beep.
    if [[ $# -gt 2 ]]; then
        echo "You've specified more than 2 command-line arguments\!"\
             "(Should be only application and test-method-path.)"
        return 1
    elif [[ $# = 1 ]]; then
        local appname="$1"
        local command=$appname
    elif [[ $# = 2 ]]; then
        local appname="$1"
        local path="$2"
        local command="${appname}.${path}"
    else
        local command=""
    fi
    if [[ -e manage.py ]]; then
        echo "python manage.py test $command"
        python manage.py test $command
        tests_completed_notification
        beep
    else
        echo "Error: manage.py file not found; are you sure you're in a"\
             "Django application directory?"
        return 1
    fi
}

tst() {
    nosetests --with-django --django-settings sequin.settings \
              --with-spec --spec-color $1
}

source_platform_specific_file_for "django/test_helpers.sh"
