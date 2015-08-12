" Ultisnips Options: {{{
" --------------------------------------------------------------------------
if globpath(&rtp, 'plugin/UltiSnips.vim') != ''
  " ---------
  " Settings:
  " ---------
  let g:UltiSnipsSnippetsDir = $HOME . '/.vim/ultisnippets'
  let g:UltiSnipsSnippetDirectories = [
  \    $HOME . '/.vim/ultisnippets'
  \ ]

  " ---------
  " Mappings:
  " ---------
  let g:UltiSnipsExpandTrigger="<C-j>"
  let g:UltiSnipsJumpForwardTrigger="<C-j>"
  let g:UltiSnipsJumpBackwardTrigger="<C-k>"
  nnoremap <leader>ue :UltiSnipsEdit<CR>

  " -------
  " Extras:
  " -------
  source ~/.vim/ultisnippets/viml_functions.vim
endif
" --------------------------------------------------------------------------
" }}}