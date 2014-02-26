# Prompt: {{{
# ----------------------------------------------------------------------------
source ~/.colour_palette

# Disable automatic virtualenv modification of PS1 (we handle that ourselves!)
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Utility Functions for Prompt: {{{
parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_active_virtualenv() {
    if [[ -z $VIRTUAL_ENV ]]; then
        echo ''
    else
        echo `basename $VIRTUAL_ENV`
    fi
}

display_project_env() {
    # Displays virtualenv information and VCS branch.
    local git_branch="`parse_git_branch`"
    local virtualenv="`parse_active_virtualenv`"
    # echo $git_branch
    # echo $virtualenv
    if [[ -z $virtualenv ]] && [[ -z $git_branch ]]; then
        echo ''
    elif [[ -z $virtualenv ]]; then
        echo ${WHITE}'('${BOLD_GREEN}${git_branch}${WHITE}') '
    elif [[ -z $git_branch ]]; then
        echo ${WHITE}'('${BOLD_BLUE}${virtualenv}${WHITE}') '
    else
        echo ${WHITE}'('${BOLD_BLUE}${virtualenv}${WHITE}'/'${BOLD_GREEN}${git_branch}${WHITE}') '
    fi
}

jobs_count() {
    # Formats and returns the jobs count, in the format 'jobs: NUM'.
    if [[ -n $BASH_VERSION ]]; then
        jobs_prompt='\j'
    else
        jobs_prompt='%j'
    fi

    if [[ $(jobs | wc -l | tr -d " ") -gt 0 ]]; then
        echo " ${YELLOW}[${PURPLE}jobs: ${jobs_prompt}${YELLOW}]";
    fi
}
cache_exit_status() {
    # Stores the exit status of the previously executed command: /this/ is the
    # value we're interested in if we want to indicate the previous command's
    # success/failure status via our prompt.
    # If we don't use this cached value, it will instead use the
    # exit status of the last run utility function, and will therefore always
    # display as a success.
    exit_status="$?"
    echo $exit_status
}

main_prompt() {
    # Takes the cached exit status as its only argument; returns an
    # appropriately coloured prompt, using the appropriate symbol ($ for
    # standard user, # for root user).
    if [[ -n $BASH_VERSION ]]; then
        main_prompt='\$'
    else
        main_prompt='%#'
    fi
    if [[ $1 = 0 ]]; then
        echo "${BOLD_GREEN}${main_prompt}"
    else
        echo "${BOLD_RED}${main_prompt}"
    fi
}

if [[ -n $BASH_VERSION ]]; then
    hist_prompt='\!'
    user_prompt='\u'
    host_prompt='\h'
    timestamp_prompt='\t'
    cwd_prompt='\w'
else
    hist_prompt='%!'
    user_prompt='%n'
    host_prompt='%m'
    timestamp_prompt='%*'
    cwd_prompt='%~'
fi

hist_num="${YELLOW}[${BOLD_GREEN}${hist_prompt}${YELLOW}]"
user_sys_info="${BOLD_BLUE}${user_prompt}${YELLOW}@${BOLD_BLUE}${host_prompt}"
time_stamp="${YELLOW}[${RED}${timestamp_prompt}${YELLOW}]"
cwd_path="${YELLOW}[ ${BOLD_BLUE}${cwd_prompt}${YELLOW} ]"
# ----------------------------------------------------------------------------
# }}}
