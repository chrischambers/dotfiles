" neobundle
set nocompatible
filetype off

if has('vim_starting')
  if isdirectory(expand('~/.bundle/neobundle.vim'))
    set runtimepath+=~/.bundle/neobundle.vim/
  else
    finish
  endif
  call neobundle#begin(expand('~/.bundle'))
endif

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
" NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \    },
      \ }
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite-outline'

NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'kana/vim-operator-user'

NeoBundle 'thinca/vim-unite-history'

NeoBundle 'Sixeight/unite-grep'

NeoBundle 'tacroe/unite-mark'

NeoBundle 'jmcantrell/vim-virtualenv'

NeoBundle 'davidhalter/jedi-vim'

NeoBundle 'christoomey/vim-tmux-navigator'

NeoBundle 'tpope/vim-pathogen'
NeoBundle 'tpope/vim-git'
NeoBundle 'tpope/vim-tbone'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-fugitive'

NeoBundle 'SirVer/ultisnips'

NeoBundle 'vim-scripts/Enhanced-Ex'
NeoBundle 'vim-scripts/ShowMarks'

NeoBundle 'techlivezheng/vim-plugin-minibufexpl'

NeoBundle 'groenewege/vim-less'

NeoBundleLazy 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'

NeoBundleLazy 'guns/xterm-color-table.vim'

NeoBundle 'othree/html5.vim'

NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/gist-vim'

NeoBundle 'vim-scripts/BufOnly.vim'

NeoBundle 'ap/vim-css-color'

NeoBundle 'vimperator/vimperator.vim'

NeoBundle 'Konfekt/FastFold'

NeoBundle 'mbbill/vim-seattle'

NeoBundle 'pangloss/vim-javascript'
NeoBundle 'ternjs/tern_for_vim', {
  \ 'build' : {
  \     'mac' : 'npm install --update',
  \     'unix' : 'npm install --update',
  \    },
  \ }

NeoBundle 'Rykka/colorv.vim'
NeoBundle 'bigfish/vim-js-context-coloring', {
  \ 'build' : {
  \     'mac' : 'npm install --update',
  \     'unix' : 'npm install --update',
  \    },
  \ }
NeoBundle 'elzr/vim-json'
NeoBundle 'othree/javascript-libraries-syntax.vim'
NeoBundle 'othree/jspc.vim'
NeoBundle 'mxw/vim-jsx'

NeoBundle 'mustache/vim-mustache-handlebars'
NeoBundle 'editorconfig/editorconfig-vim'

call neobundle#end()
