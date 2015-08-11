# Makefile
.PHONY: linux mac windows vim-setup install update clean

linux: vim-setup vim-make-vimproc-linux

mac: vim-setup vim-make-vimproc-mac

windows: vim-setup

vim-setup: vim-install-bundle vim-install-plugins

vim-install-bundle:
	mkdir -p ~/.bundle
	git clone git://github.com/Shougo/neobundle.vim.git ~/.bundle/neobundle.vim

vim-make-vimproc-linux:
	cd ~/.bundle/vimproc/ && make -f make_gcc.mak

vim-make-vimproc-mac:
	cd ~/.bundle/vimproc/ && make -f make_mac.mak

install: vim-install-plugins

vim-install-plugins:
	vim -u ./vim/profiles/bundles.vim +NeoBundleInstall +q


update: vim-update-plugins

vim-update-plugins:
	vim -u ./vim/profiles/bundles.vim +NeoBundleInstall! +q


clean: vim-clean-plugins

vim-clean-plugins:
	vim -u ./vim/profiles/bundles.vim +NeoBundleClean +q
