update_titlebar() {
    # Updates the titlebar for suitable terminals.
    # Hardcoded for bash, atm.
    case $TERM in
        xterm*|rxvt*)
            local TITLEBAR='\[\033]0;\u@\h:\w\007\]'
            echo $TITLEBAR
            ;;
        *)
            local TITLEBAR=""
            echo $TITLEBAR
            ;;
    esac
}
