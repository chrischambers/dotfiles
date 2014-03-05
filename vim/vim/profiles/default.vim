" default.vim
" sample settings

"
syntax on

" 256 colors
set t_Co=256

" status line settings
set laststatus=2
let &statusline = '%<%f %m%r%h%w[%{(&fenc!=""?&fenc:&enc)}][%{&ff}]%= %l,%c%V%8P'

" default tab space settings
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" show last command
set showcmd

" show matching bracket
set showmatch

"
set hlsearch

" backspace
set backspace=indent,eol,start

" break undo sequence on <C-w>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" Load .gvimrc after .vimrc edited at GVim.
nmap <Leader>lv <SID>(load-vimrc)
nmap <Leader>lg <SID>(load-gvimrc)
nnoremap <silent> <SID>(load-vimrc)  :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
nnoremap <silent> <SID>(load-gvimrc) :<C-u>source $MYGVIMRC<CR>

" syntax completion settings {{{
filetype on
filetype plugin on
filetype plugin indent on

" syntax completetion on any language {{{
autocmd VimrcAutoCmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif
"}}}

set pumheight=20
set completefunc=
set omnifunc&
set omnifunc+=
"}}}

" open popup in always
set completeopt=menuone,preview
" completion targets
set complete=.,w,b,u,t,i

" encoding settings {{{
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,ucs-bom,euc-jp,eucjp-ms,cp932
set fileencoding=utf-8
set fileformat=unix
"}}}

"
set foldmethod=marker

" vim: expandtab softtabstop=2 shiftwidth=2
