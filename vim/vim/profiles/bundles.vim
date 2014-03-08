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
" NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neomru.vim'

NeoBundle 'kana/vim-surround'
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

NeoBundle 'SirVer/ultisnips'

NeoBundle 'vim-scripts/Enhanced-Ex'

NeoBundle 'techlivezheng/vim-plugin-minibufexpl'

NeoBundle 'groenewege/vim-less'

NeoBundle 'scrooloose/nerdtree'

filetype plugin on
filetype indent on
