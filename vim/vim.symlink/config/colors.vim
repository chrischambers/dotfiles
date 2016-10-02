" --------------------------------------------------------------------------
" File-Type Highlighting and Configuration. {{{
" --------------------------------------------------------------------------
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
syntax on             " enable per-filetype syntax highlighting
filetype on           " enable filetype detection
filetype plugin on    " enable filetype specific plugins
filetype indent on    " enable filetype-specific indenting where available,
" }}}
" --------------------------------------------------------------------------
" Colorscheme: {{{
" --------------------------------------------------------------------------

" This is necessary for gnome terminal, which otherwise gets confused and uses
" low-colour.
set t_Co=256

set background=dark
let g:jellybeans_use_lowcolor_black = 1
let g:jellybeans_overrides = {
\    'VertSplit':    { 'guifg': '262626', 'guibg': '262626',
\                      'ctermfg': 'darkgray', 'ctermbg': 'darkgray' },
\    'StatusLine':   { 'guifg': 'CCCCCC', 'guibg': '262626', 'gui': 'italic',
\                      'ctermfg': 'white', 'ctermbg': '234' },
\    'StatusLineNC': { 'guifg': '444444', 'guibg': '262626',
\                      'ctermfg': 'blue', 'ctermbg': '234' },
\    'CursorLine':   { 'guifg': '222222', 'guibg': 'bcff7a',
\                      'ctermfg': '222222', 'ctermbg': 'bcff7a' },
\}

colorscheme jellybeans

hi clear SpellBad
hi clear SpellLocal
hi clear SpellRare
hi clear SpellCap
hi SpellBad ctermbg=52 gui=undercurl guisp=#FF5522
hi SpellCap ctermbg=53 gui=undercurl guisp=SlateBlue
hi SpellRare ctermbg=55 gui=undercurl guisp=purple
hi clear Conceal
hi Conceal guibg=#262626
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
