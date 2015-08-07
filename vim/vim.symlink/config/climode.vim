" Command Line Mode: {{{
" --------------------------------------------------------------------------
    set cmdheight=2 " Sets command-line height
" --------------------------------------------------------------------------
    " Emacs Mappings At Command Line: {{{
    " For Emacs-style editing on the command-line: <url:vimhelp:emacs-keys>
    " See: <url:http://www.vim.org/scripts/script.php?script_id=2908> for the
    " core functionality.
        " recall newer command-line
        :cnoremap <C-N>        <Down>
        " recall previous (older) command-line
        :cnoremap <C-P>        <Up>
        " back one word
        :cnoremap <Esc><C-B>    <S-Left>
        " forward one word
        :cnoremap <Esc><C-F>    <S-Right>
" --------------------------------------------------------------------------
" }}}
