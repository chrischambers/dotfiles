" plugins
" any plugin settings

" operator replace setting {{{
if globpath(&rtp, 'plugin/operator/replace.vim') != ''
  " operator replace
  nmap R <Plug>(operator-replace)
endif
"}}}

" align settings {{{
if globpath(&rtp, 'plugin/AlignPlugin.vim') != ''
  let g:Align_xstrlen=3
  vmap <Leader>al <SID>(setup-align)
  vnoremap <SID>(setup-align) :Align
endif
"}}}

" vimfiler settings {{{
if globpath(&rtp, 'plugin/vimfiler.vim') != ''
  call vimfiler#set_execute_file('vim', 'vim')
  call vimfiler#set_execute_file('txt', 'notepad')
  "let g:vimfiler_split_command = ''

  " Edit file by tabedit.
  let g:vimfiler_edit_command = 'edit'

  "let g:vimfiler_pedit_command = 'vnew'
  let g:vimfiler_external_copy_directory_command = 'cp -r $src $dest'
  let g:vimfiler_external_copy_file_command      = 'cp $src $dest'
  let g:vimfiler_external_delete_command         = 'rm -r $srcs'
  let g:vimfiler_external_move_command           = 'mv $srcs $dest'
  let g:vimfiler_as_default_explorer             = 1

  " Enable file operation commands.
  "let g:vimfiler_safe_mode_by_default = 0
endif
"}}}

" vimshell settings {{{
if globpath(&rtp, 'plugin/vimshell.vim') != ''
  nmap <Leader>; <SID>(launch-vimshell)
  nnoremap <SID>(launch-vimshell) :<C-u>VimShellPop<CR>
  let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
  let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
  let g:vimshell_enable_smart_case = 1

  if has('win32') || has('win64') 
    " Display user name on Windows.
    let g:vimshell_prompt = $USERNAME."% "
  else
    " Display user name on Linux.
    let g:vimshell_prompt = $USER."% "

    call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
    call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
    let g:vimshell_execute_file_list['zip'] = 'zipinfo'
    call vimshell#set_execute_file('tgz,gz', 'gzcat')
    call vimshell#set_execute_file('tbz,bz2', 'bzcat')
  endif

  autocmd VimrcAutoCmd FileType vimshell
\   call vimshell#altercmd#define('g', 'git')
\|  call vimshell#altercmd#define('i', 'iexe')
\|  call vimshell#altercmd#define('l', 'll')
\|  call vimshell#altercmd#define('ll', 'ls -l')
\|  call vimshell#altercmd#define('vi', 'vim')
\|  call vimshell#hook#set('chpwd', ['g:my_chpwd'])
\|  call vimshell#hook#set('emptycmd', ['g:my_emptycmd'])
\|  call vimshell#hook#set('preprompt', ['g:my_preprompt'])
\|  call vimshell#hook#set('preexec', ['g:my_preexec'])

  function! g:my_chpwd(args, context)
    call vimshell#execute('echo "chpwd"')
  endfunction
  function! g:my_emptycmd(cmdline, context)
    call vimshell#execute('echo "emptycmd"')
    return a:cmdline
  endfunction
  function! g:my_preprompt(args, context)
    call vimshell#execute('echo "preprompt"')
  endfunction
  function! g:my_preexec(cmdline, context)
    call vimshell#execute('echo "preexec"')

    let l:args = vimproc#parser#split_args(a:cmdline)
    if len(l:args) > 0 && l:args[0] ==# 'diff'
      call vimshell#set_syntax('diff')
    endif

    return a:cmdline
  endfunction
endif
"}}}

" neocomplcache settings {{{
if globpath(&rtp, 'plugin/neocomplcache.vim') != ''
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 1
  " Use camel case completion.
  let g:neocomplcache_enable_camel_case_completion = 1
  " Use underbar completion.
  let g:neocomplcache_enable_underbar_completion = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
          \ }

  " Define keyword.
  if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  imap <C-k> <Plug>(neocomplcache_start_unite_complete)
  smap <C-k> <Plug>(neocomplcache_start_unite_complete)
  inoremap <expr> <C-g> neocomplcache#undo_completion()
  inoremap <expr> <C-l> neocomplcache#complete_common_string()

  " SuperTab like snippets behavior.
  "imap <expr> <TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplcache#close_popup()
  inoremap <expr><C-e>  neocomplcache#cancel_popup()

  " AutoComplPop like behavior.
  "let g:neocomplcache_enable_auto_select = 1

  " Shell like behavior(not recommended).
  "set completeopt+=longest
  "let g:neocomplcache_enable_auto_select = 1
  "let g:neocomplcache_disable_auto_complete = 1
  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
  "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

  " Enable omni completion.
  autocmd VimrcAutoCmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd VimrcAutoCmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd VimrcAutoCmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd VimrcAutoCmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd VimrcAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
endif
"}}}

" quickrun settings {{{
if globpath(&rtp, 'plugin/quickrun.vim') != ''
  for [key, com] in items({
\     '<Leader>x' : '>:',
\     '<Leader>p' : '>!',
\     '<Leader>w' : '>',
\     '<Leader>q' : '>>',
\   })
    execute 'nnoremap <silent>' key ':QuickRun' com '-mode n -split vertical<CR>'
    execute 'vnoremap <silent>' key ':QuickRun' com '-mode v -split vertical<CR>'
  endfor
endif
"}}}

" vim: expandtab softtabstop=2 shiftwidth=2
