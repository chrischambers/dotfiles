" Ultisnips Options: {{{
" --------------------------------------------------------------------------
if globpath(&rtp, 'plugin/UltiSnips.vim') != ''
  " ---------
  " Settings:
  " ---------
  let g:UltiSnipsSnippetsDir = g:vimfiles . '/ultisnippets'
  let g:UltiSnipsSnippetDirectories = [
  \    g:vimfiles . '/ultisnippets'
  \ ]

  " ---------
  " Mappings:
  " ---------
  let g:UltiSnipsExpandTrigger="<C-j>"
  let g:UltiSnipsJumpForwardTrigger="<C-j>"
  let g:UltiSnipsJumpBackwardTrigger="<C-k>"
  nnoremap <leader>ue :UltiSnipsEdit<CR>
endif
" --------------------------------------------------------------------------
" }}}
