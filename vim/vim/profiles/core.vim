let s:is_win    = has("win16") || has("win32") || has("win64")
let s:is_mac    = has("mac") || has("macunix")
let s:is_linux  = has("unix") && !has("mac")
let s:is_cygwin = has("win32unix")

" --------------------------------------------------------------------------
set nocompatible                    " Force this at the start of the file
                                    " (changes subsequent options)
let mapleader = ','                 " Only affects subsequent <leader> commands

" --------------------------------------------------------------------------
" File-type highlighting and configuration.
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
" NOTE: These define autocmds, so they should come before any other autocmds.
" That way, a later autocmd can override the result of one defined here.
syntax on             " enable per-filetype syntax highlighting
filetype on           " enable filetype detection
filetype plugin on    " enable filetype specific plugins
filetype indent on    " enable filetype-specific indenting where available,

set backspace=indent,eol,start " Intuitive backspacing in insert mode

set nu                " line numbering
set nocul             " disable cursor-line highlighting
set nowrap            " prevent lines from wrapping automatically

set showcmd           " Show (partial) command in status line.
set showmatch         " Show matching brackets...
set matchtime=2       " for only .2 seconds.

"set autoread         " Watch for file changes and update accordingly. Note:
                      " "the above change updates the file without prompting
                      " the user. This could potentially overwrite work.
set autowrite         " Automatically save before commands like :next and :make
set hidden            " Allows you to switch to different buffers without
                      " having to save changes:
                      "
                      " * The current buffer can be put to the background
                      "   without writing to disk
                      " * When a background buffer becomes current again, marks
                      "   and undo-history are remembered.
set history=200       " Command history length.
set tags=tags;/       " Look for tags file up through dirs until one is found.

set scrolloff=2       " Keep 2 lines above/below cursor when scrolling up/down
set sidescrolloff=2   " Keep 2 lines left/right of cursor when scrolling
                      " left/right
" --------------------------------------------------------------------------
" Colorscheme: {{{
" --------------------------------------------------------------------------
set background=dark
let g:jellybeans_background_color = "black"
let g:jellybeans_background_color_256 = 232
let g:jellybeans_overrides = {
\    'VertSplit':    { 'guifg': '262626', 'guibg': '262626',
\                      'ctermfg': 'darkgray', 'ctermbg': 'darkgray' },
\    'StatusLine':   { 'guifg': 'CCCCCC', 'guibg': '262626', 'gui': 'italic',
\                      'ctermfg': 'white', 'ctermbg': '234' },
\    'StatusLineNC': { 'guifg': '444444', 'guibg': '262626',
\                      'ctermfg': 'blue', 'ctermbg': '234' },
\    'CursorLine':   { 'guibg': '1c1c1c', 'ctermbg': '1c1c1c' },
\}
colorscheme jellybeans
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Indentation: {{{
" --------------------------------------------------------------------------
" An excellent guide to the following options can be found here:
" http://tedlogan.com/techblog3.html
set tabstop=4     " Column-width of real Tab character
set softtabstop=4 " Column-width of Tab: if < tabstop and noexpandtab set, a
                  " combination of spaces and tabs are used. if == tabstop and
                  " noexpandtab set, vim will always use tabs. If set
                  " alongside expandtab, vim will always use spaces.
set expandtab     " replaces Tabs with spaces
set shiftwidth=4  " no. spaces used for auto-indent, <<, >>, etc.
set shiftround    " Rounds indent to multiple of shiftwidth
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
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
" --------------------------------------------------------------------------
" Basic Mappings: {{{
" --------------------------------------------------------------------------
" Edit .vimrc easily!
nnoremap <Home> :e $MYVIMRC<CR>

" Y behaves like D rather than like dd
nnoremap Y y$

" Convenient alias for switching back and forth between alternate buffer:
nnoremap <leader>. <C-^>

" Toggle Highlight search off when redrawing screen:
nnoremap <silent> <leader><C-l> :nohl<CR> :call feedkeys("\<C-l>", "n")<CR>

" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Search: {{{
" --------------------------------------------------------------------------
set hlsearch      " Highlight searches by default.
set incsearch     " Incrementally search while typing a /regex
set ignorecase    " Default to using case insensitive searches...
set smartcase     " unless uppercase letters are used in the regex.
" These two options, when set together, will make /-style searches
" case-sensitive only if there is a capital letter in the search expression.
" }}}
" --------------------------------------------------------------------------
" British English Spelling: {{{
" --------------------------------------------------------------------------
set spell
setlocal spell spelllang=en_gb
nnoremap <silent> <leader>sp :exe (&spell ? ":set nospell" : ":set spell")<CR>
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Shell Like Filename Completion: {{{
" --------------------------------------------------------------------------
" By default, pressing <TAB> in command mode will choose the first possible
" completion with no indication of how many others there might be. The
" following configuration lets you see what your other options are:
set wildmenu
" To have the completion behave similarly to a shell, i.e. complete only up to
" the point of ambiguity (while still showing you what your options are), also
" add the following:
set wildmode=list:longest,full
" list:longest    - When > 1 match, list all matches and
"                   complete till longest common string.
" full            - enables you to tab through the remaining completions
set wildignore+=*.pyc,*.zip,*.gz,*.bz,*.tar,*.jpg,*.png,*.gif,*.avi,*.wmv,*.ogg,*.mp3,*.mov,*.chm

" set complete=.,w,b,u,t,i
" set completeopt=menu,longest
" preview:         displays python help files when using omni-completion:
"                  (awesome, but induces a performance hit).
" longest:         only tab-completes up to the common elements, if any:
"                  allows you to hit tab, type to reduce options, hit tab to
"                  complete.
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Useful Python Modules Already Imported: {{{
" --------------------------------------------------------------------------
if has("python")
  py import os, sys, vim
  py from pprint import pprint as pp
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
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
" }}}
" --------------------------------------------------------------------------
" Show Invisible Characters: {{{
" --------------------------------------------------------------------------
" from godlygeek:
if &enc =~ '^u\(tf\|cs\)' " When running in a Unicode environment,
  set list " visually represent certain invisible characters:
  let s:arr = nr2char(9655) " using U+25B7 (▷) for an arrow, and
  let s:dot = nr2char(8901) " using U+22C5 (⋅) for a very light dot,
  " display tabs as an arrow followed by some dots (▷⋅⋅⋅⋅⋅⋅⋅),
  exe "set listchars=tab:" . s:arr . s:dot
  " and display trailing and non-breaking spaces as U+22C5 (⋅).
  exe "set listchars+=trail:" . s:dot
  exe "set listchars+=nbsp:" . s:dot
  " Also show an arrow+space (↪ ) at the beginning of any wrapped long lines?
  " I don't like this, but I probably would if I didn't use line numbers.
  let &sbr=nr2char(8618).' '
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Resume Last Editing Spot When Reading File: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  " Try to jump to the last spot the cursor was at in a file when reading it.
  augroup resume_last_editing_spot
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" |
        \ endif
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------

" Elements from profiles/default you're evaluating:
" -------------------------------------------------

" break undo sequence on <C-w>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" Load .gvimrc after .vimrc edited at GVim.
nmap <Leader>lv <SID>(load-vimrc)
nmap <Leader>lg <SID>(load-gvimrc)
nnoremap <silent> <SID>(load-vimrc)  :<C-u>source $MYVIMRC \| if has('gui_running') \| source $MYGVIMRC \| endif <CR>
nnoremap <silent> <SID>(load-gvimrc) :<C-u>source $MYGVIMRC<CR>

" syntax completetion on any language
autocmd VimrcAutoCmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif

set pumheight=20
set completefunc=
set omnifunc&
set omnifunc+=

" open popup in always
set completeopt=menuone,preview
" completion targets
set complete=.,w,b,u,t,i

" encoding settings
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,ucs-bom,euc-jp,eucjp-ms,cp932
set fileencoding=utf-8
set fileformat=unix

set foldmethod=marker
