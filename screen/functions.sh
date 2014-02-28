screenload() {
    ### For loading .screenrc template files located in ~/.screens
    screen -S $1 -c ~/.screens/${1}
}
