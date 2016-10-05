" Ultisnips Options: {{{
" --------------------------------------------------------------------------
if globpath(&rtp, 'plugin/UltiSnips.vim') != ''
  " ---------
  " Settings:
  " ---------
  let g:UltiSnipsSnippetsDir = g:vimfiles . '/ultisnippets'
  let g:UltiSnipsSnippetDirectories = [
  \    g:vimfiles . '/ultisnippets', 'ultisnippets'
  \ ]
  " Second list item is a workaround for the following:
  " https://github.com/SirVer/ultisnips/issues/711

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
