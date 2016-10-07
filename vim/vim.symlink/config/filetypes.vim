" --------------------------------------------------------------------------
" Vim: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  augroup vim_setup
    au!
    autocmd FileType vim setl expandtab softtabstop=2 shiftwidth=2 nowrap
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Text / ReST: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  augroup txt_setup
    au!
    autocmd FileType txt setl textwidth=78
    autocmd BufRead,BufNewFile *.txt set filetype=rst
    autocmd FileType rst setl textwidth=78
    " autocmd FileType txt setl fenc='utf-8'
    " autocmd FileType rst setl fenc='utf-8'
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Javascript / jQuery: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  augroup javascript_setup
    au!
    autocmd BufRead,BufNewFile *.js setl ft=javascript foldmethod=syntax
          \ conceallevel=1 concealcursor=nvic
          \ expandtab softtabstop=2 shiftwidth=2 nowrap
    autocmd BufRead,BufNewFile jquery.*.js setl ft=jquery.javascript syntax=jquery
    let g:javascript_conceal_function       = "λ"
    let g:javascript_conceal_null           = "ø"
    let g:javascript_conceal_this           = "@"
    let g:javascript_conceal_return         = "⇚"
    let g:javascript_conceal_undefined      = "¿"
    let g:javascript_conceal_NaN            = "ℕ"
    let g:javascript_conceal_prototype      = "#"
    let g:javascript_conceal_static         = "•"
    let g:javascript_conceal_super          = "Ω"
    let g:javascript_conceal_arrow_function = "⇒"
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Json: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  augroup json_setup
    au!
    autocmd BufRead,BufNewFile *.json setfiletype json
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" HTML: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  augroup html_setup
    au!
    fun! Html_fold()
      setl autoindent
      setl foldmethod=indent
      setl foldnestmax=10
      setl nofoldenable
      setl foldlevel=1
      " setl foldopen=all foldclose=all
      setl foldtext=substitute(getline(v:foldstart),'\\t','\ \ \ \ ','g')
      setl fillchars=vert:\|,fold:\
      setl expandtab softtabstop=2 shiftwidth=2 nowrap
    endfun
    au FileType htmldjango,htmldjango.*,html call Html_fold()
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Python: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  augroup python_setup
    au!
    fun! Python_fold()
      execute 'syntax clear pythonStatement'
      execute 'syntax keyword pythonStatement break continue del'
      execute 'syntax keyword pythonStatement except exec finally'
      execute 'syntax keyword pythonStatement pass print raise'
      execute 'syntax keyword pythonStatement return try'
      execute 'syntax keyword pythonStatement global assert'
      execute 'syntax keyword pythonStatement lambda yield'
      execute 'syntax match pythonStatement /\<def\>/ nextgroup=pythonFunction skipwhite'
      execute 'syntax match pythonStatement /\<class\>/ nextgroup=pythonFunction skipwhite'
      execute 'syntax region pythonFold start="^\z(\s*\)\%(class\|def\)" end="^\%(\n*\z1\_s\)\@!" transparent fold'
      execute 'syntax sync minlines=2000 maxlines=4000'
      setl foldmethod=syntax
      " setl foldopen=all foldclose=all
      " setl foldtext=substitute(getline(v:foldstart),'\\t','\ \ \ \ ','g')
      " setl fillchars=vert:\|,fold:\
      setl softtabstop=4 shiftwidth=4 nowrap nosmartindent

      " EXPERIMENT: Try to Use '_' as word seperator: {{{
      " let &isk = substitute(&isk, '_,', '', '')
      " removes the underscore from python 'words'
      " PROBLEMS:
      " * affects syntax highlighting (e.g. 'type' will be highlighted as keyword
      " for variable 'sub_type'
      " * affects supertab word completion
      " }}}
    endfun
    au FileType python,python.* call Python_fold()
    " Adds keyword-dictionary as complete option. For the most part, I found this
    " /not/ to be useful:
    " autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(
    " from <url:vimhelp:'complete'>:
    " k{dict}  scan the file {dict}.  Several "k" flags can be given,
    "          patterns are valid too.  For example:
    "          :set cpt=k/usr/dict/*,k~/spanish
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
