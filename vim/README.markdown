# vimrc-builder

*Simple vim-setting builder using [neobundle.vim][]*

Customize or copy sample settings for yourself.

## Product Requirements

git and Vim >= 7.3


## Usage

Simple make commands are prepared.

### Build

If you already have neobundle.vim and ~/.bundle directory, you input following command

    $ make vim-install-plugins

and

    $ make vim-make-vimproc-linux

or

    $ make vim-make-vimproc-mac


If you don't have neobundle.vim or don't use ~/.bundle directory, you can use prepared simple command at first.


#### on Linux

    $ git clone git://github.com/kmnk/vimrc-builder.git
    $ cd vimrc-builder
    $ make linux

#### on Mac

    $ git clone git://github.com/kmnk/vimrc-builder.git
    $ cd vimrc-builder
    $ make mac

### Use

Input following command on vimrc-builder directory to use on sample setting

    $ vim -u ./dotfiles/dot.vimrc

or add following line to your vimrc.

    source /path/to/vimrc-builder/dotfiles/dot.vimrc


### Install added vim-plugins

    $ make install


### Update vim-plugins

    $ make update


## Customize

Edit dotfiles/dot.vimrc and read following sample setting files.

- vim/profiles/bundles.vim
- vim/profiles/default.vim
- vim/profiles/plugins.vim
- vim/profiles/unite.vim

For example, if you want to use neobundle.vim like sample setting, copy all lines of vim/profiles/bundles.vim to top of your vimrc file.


## Default Installing Plugins

- [neobundle.vim][] *required*
- [unite.vim][]
- [vimproc][]
- [vimfiler][]
- [vimshell][]
- [vimproc][]
- [neocomplcache][]
- [vim-surround][]
- [vim-textobj-indent][]
- [vim-textobj-user][]
- [vim-operator-replace][]
- [vim-operator-user][]
- [vim-unite-history][]
- [unite-grep][]
- [unite-mark][]
- [unite-outline][]


[neobundle.vim]:         https://github.com/Shougo/neobundle.vim
[unite.vim]:             https://github.com/Shougo/unite.vim
[vimproc]:               https://github.com/Shougo/vimproc
[vimfiler]:              https://github.com/Shougo/vimfiler
[vimshell]:              https://github.com/Shougo/vimshell
[vimproc]:               https://github.com/Shougo/vimproc
[neocomplcache]:         https://github.com/Shougo/neocomplcache
[vim-surround]:          https://github.com/kana/vim-surround
[vim-textobj-indent]:    https://github.com/kana/vim-textobj-indent
[vim-textobj-user]:      https://github.com/kana/vim-textobj-user
[vim-operator-replace]:  https://github.com/kana/vim-operator-replace
[vim-operator-user]:     https://github.com/kana/vim-operator-user
[vim-unite-history]:     https://github.com/thinca/vim-unite-history
[unite-grep]:            https://github.com/Sixeight/unite-grep
[unite-mark]:            https://github.com/tacroe/unite-mark
[unite-outline]:         https://github.com/h1mesuke/unite-outline
