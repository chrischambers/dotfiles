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

" neocomplete settings {{{
if globpath(&rtp, 'plugin/neocomplete.vim') != ''
  " Note: now requires jedi-vim. Make sure you install jedi in your global
  " python site-packages.

  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Use camel case completion.
  let g:neocomplete#enable_camel_case_completion = 1
  " Use underbar completion.
  let g:neocomplete#enable_underbar_completion = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
  let g:neocomplete#enable_prefetch = 1

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
          \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  " imap <C-k> <Plug>(neocomplete_start_unite_complete)
  " smap <C-k> <Plug>(neocomplete_start_unite_complete)
  inoremap <expr> <C-g> neocomplete#undo_completion()
  inoremap <expr> <C-l> neocomplete#complete_common_string()

  " SuperTab like snippets behavior.
  "imap <expr> <TAB> neocomplete#sources#snippets_complete#expandable() ? "\<Plug>(neocomplete_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <expr><CR>  neocomplete#smart_close_popup() . "\<CR>"
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()

  " AutoComplPop like behavior.
  "let g:neocomplete_enable_auto_select = 1

  " Shell like behavior(not recommended).
  "set completeopt+=longest
  "let g:neocomplete_enable_auto_select = 1
  "let g:neocomplete_disable_auto_complete = 1
  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
  "inoremap <expr><CR>  neocomplete#smart_close_popup() . "\<CR>"

  " Enable omni completion.
  autocmd VimrcAutoCmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd VimrcAutoCmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd VimrcAutoCmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd VimrcAutoCmd FileType python setlocal omnifunc=jedi#completions
  autocmd VimrcAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  let g:neocomplete#force_overwrite_completefunc = 1

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif

  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif

  let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'

  " call neocomplete#custom#source('_', 'sorters', ['sorter_word', 'sorter_rank'])
  " Disable sorting: leave to jedi
  call neocomplete#custom#source('python', 'sorters', [])
  let g:neocomplete#force_omni_input_patterns.python =
      \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
endif

let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0

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

" NERDTree Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=1658>
" --------------------------------------------------------------------------
" Toggle the following off with 'f'!
" let NERDTreeIgnore=['\.pyc$', '\~$', '^#.*#$', '\.swp']
let NERDTreeChDirMode=2 " Tree root ALWAYS equal to CWD
let NERDChristmasTree=1 " Extra-colourful Tree
let NERDTreeMouseMode=2 " If you do use the mouse, this is probably what you want.
if has('gui_running')
  set guioptions-=L
endif

function! NERDTreeVisible()
  let l:visible_buffers = map(tabpagebuflist(), 'bufname(v:val)')
  call filter(l:visible_buffers, 'v:val =~# "NERD_tree"')
  return !empty(l:visible_buffers)
endfunction

function! NERDToggle()
  if !exists('s:gui_active')
    let s:gui_active = has('gui_running')
  endif
  if !s:gui_active
    NERDTreeToggle
    return
  endif

  if NERDTreeVisible()
  " if count(l:visible_buffers, 'NERD_tree_1')
    NERDTreeToggle
    exec 'set columns-=' . g:NERDTreeWinSize
  else
    NERDTreeToggle
    exec 'set columns+=' . g:NERDTreeWinSize
  endif
endfunction
nnoremap <leader>d :call NERDToggle()<CR>
nnoremap <leader><S-d> :call NERDTreeFromBookmark()<CR>

function! NERDTreeFromBookmark()
  if !NERDTreeVisible()
      call NERDToggle()
  endif
  call feedkeys(":NERDTreeFromBookmark \<C-D>", "n")
endfunction
" --------------------------------------------------------------------------
" Python Project Specific:
" We're really not interested in these binary files for the most part:
let NERDTreeIgnore=['\.py\(c\|o\)$', '\.swp', '\~$', '^#.*#$', '\.gif', '\.jpg','\.png','\.jpeg','\.ico', '\.psd', '\.flv', '\.swf', '\.pdf', '\.doc', '\.bmp', '..DS_Store']
" python files will take precedence over .csv, .log, .txt, etc.
let NERDTreeSortOrder=['\/$', '\.py', '*', '\.swp$',  '\.bak$', '\~$']
" --------------------------------------------------------------------------
" }}}

" Ultisnips Options: {{{
" --------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
nnoremap <leader>ue :UltiSnipsEdit<CR>
" --------------------------------------------------------------------------
" }}}

let g:syntastic_always_populate_loc_list = 1

" vim: expandtab softtabstop=2 shiftwidth=2
