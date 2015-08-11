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
