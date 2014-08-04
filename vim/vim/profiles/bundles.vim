" neobundle
set nocompatible
filetype off

if has('vim_starting')
  if isdirectory(expand('~/.bundle/neobundle.vim'))
    set runtimepath+=~/.bundle/neobundle.vim/
  else
    finish
  endif
  call neobundle#rc(expand('~/.bundle'))
endif

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
" NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neomru.vim'

NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'kana/vim-operator-user'

NeoBundle 'thinca/vim-unite-history'

NeoBundle 'Sixeight/unite-grep'

NeoBundle 'tacroe/unite-mark'

NeoBundle 'h1mesuke/unite-outline'

NeoBundle 'jmcantrell/vim-virtualenv'

NeoBundle 'davidhalter/jedi-vim'

NeoBundle 'christoomey/vim-tmux-navigator'

NeoBundle 'tpope/vim-git'
NeoBundle 'tpope/vim-tbone'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'

NeoBundle 'SirVer/ultisnips'

NeoBundle 'vim-scripts/Enhanced-Ex'

NeoBundle 'techlivezheng/vim-plugin-minibufexpl'

NeoBundle 'groenewege/vim-less'

NeoBundleLazy 'scrooloose/nerdtree'
NeoBundleLazy 'scrooloose/syntastic'

NeoBundleLazy 'guns/xterm-color-table.vim'

NeoBundle 'othree/html5.vim'

NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/gist-vim'
