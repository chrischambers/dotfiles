" Statusline: {{{
" --------------------------------------------------------------------------
let g:virtualenv_stl_format = '%n'
set laststatus=2  " always include status line, even if only one window
" " Source: <url:http://www.linux.com/archive/feature/120126>
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
" set statusline=%<[%02n]\ %F%(\ %m%h%w%y%r%)\ %a%=\ %8l,%c%V/%L\ (%P)
let &statusline = '%<%f %m%r%h%w[%{virtualenv#statusline()}]%y [%{(&fenc!=""?&fenc:&enc)}][%{&ff}]%= %l,%c%V%8P'
" --------------------------------------------------------------------------
" }}}
