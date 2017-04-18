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

" neocomplete settings {{{
if globpath(&rtp, 'plugin/neocomplete.vim') != ''

  " ============================================================================
  " Stolen from the following to make jspc work:
  " https://github.com/davidosomething/dotfiles/blob/master/vim/plugin/completion.vim
  " ============================================================================
  let s:REGEX = {}
  let s:REGEX.any_word        = '\h\w*'
  let s:REGEX.nonspace        = '[^-. \t]'
  let s:REGEX.nonspace_dot    = s:REGEX.nonspace . '\.\w*'
  let s:REGEX.nonspace_arrow  = s:REGEX.nonspace . '->\w*'
  let s:REGEX.word_scope_word = s:REGEX.any_word . '::\w*'

  " For jspc.vim
  let s:REGEX.keychar   = '\k\zs \+'
  let s:REGEX.parameter = s:REGEX.keychar . '\|' . '(' . '\|' . ':'

  " ----------------------------------------------------------------------------
  " Regexes to use completion engine
  " See plugins sections too (e.g. phpcomplete and jspc)
  " ----------------------------------------------------------------------------

  " Neocomplete
  " - String or list of vim regex
  let s:neo_patterns = {}
  "
" javascript
" default: https://github.com/Shougo/neocomplete.vim/blame/34b42e76be30c0f365110ea036c8490b38fcb13e/autoload/neocomplete/sources/omni.vim
let s:neo_patterns.javascript =
\          s:REGEX.any_word
\ . '\|' . s:REGEX.nonspace_dot
  " ============================================================================

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
  autocmd VimrcAutoCmd FileType htmldjango,html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  " autocmd VimrcAutoCmd FileType javascript setlocal omnifunc=tern#Complete
  autocmd VimrcAutoCmd FileType python setlocal omnifunc=jedi#completions
  autocmd VimrcAutoCmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  let g:neocomplete#force_overwrite_completefunc = 1

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
    call extend(g:neocomplete#sources#omni#input_patterns, s:neo_patterns)
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

  if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
    let g:neocomplete#sources#omni#functions.javascript = [
        \   'jspc#omni',
        \   'tern#Complete',
        \ ]
    endif
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
  if !has('gui_running')
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

nnoremap <leader>d :NeoBundleSource nerdtree <Bar> :call NERDToggle()<CR>
nnoremap <leader><S-d> :NeoBundleSource nerdtree <Bar> :call NERDTreeFromBookmark()<CR>

function! NERDTreeFromBookmark()
  if !NERDTreeVisible()
      call NERDToggle()
  endif
  call feedkeys(":NERDTreeFromBookmark \<C-D>", "n")
endfunction
" --------------------------------------------------------------------------
" Python Project Specific:
" We're really not interested in these binary files for the most part:
let NERDTreeIgnore=['\.py\(c\|o\)$', '\.swp$', '\~$', '^#.*#$', '\.gif$', '\.jpe?g$','\.png$', '\.psd$', '\.flv$', '\.swf$', '\.pdf$', '\.doc$', '\.bmp"', '\.DS_Store$', '__pycache__$']
" python files will take precedence over .csv, .log, .txt, etc.
let NERDTreeSortOrder=['\/$', '\.py', '*', '\.swp$',  '\.bak$', '\~$']
" --------------------------------------------------------------------------
" }}}

" Syntastic Options: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  augroup lazyload
  au!
  au BufWritePre * :NeoBundleSource syntastic
  augroup END
endif
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_filetype_map = { 'htmldjango.html': 'htmldjango' }

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'eslint_d'
" let g:syntastic_python_checkers = ['python', 'pep8', 'flake8', 'pyflakes']
let g:syntastic_python_checkers=['flake8']
" E501: Max line length
" E225: Missing whitespace around operators
let g:syntastic_python_flake8_args='--ignore=E501,E225'


" --------------------------------------------------------------------------
" }}}

" Html5 Vim Options: {{{
" --------------------------------------------------------------------------
if globpath(&rtp, 'autoload/xml/html5.vim') != ''
  function! SetupHtmlCompletion ()
    let b:html_omni_flavor = 'html5'
    let b:html_doctype = 1
    if exists('g:xmldata_'.b:html_omni_flavor)
      exe 'let b:html_omni = g:xmldata_'.b:html_omni_flavor
    else
      exe 'runtime! autoload/xml/'.b:html_omni_flavor.'.vim'
      exe 'let b:html_omni = g:xmldata_'.b:html_omni_flavor
    endif
  endfunction

  if has("autocmd")
    augroup html5_completion_for_htmldjango
    au!
    " autocmd FileType htmldjango,htmldjango.* set ft=htmldjango.html
    autocmd FileType htmldjango,htmldjango.* call SetupHtmlCompletion()
    augroup END
  endif
endif
" --------------------------------------------------------------------------
" }}}

" Gist Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=2423>
" --------------------------------------------------------------------------
if globpath(&rtp, 'plugin/gist.vim') != ''
  " Detect syntax-colorisation to use based on filetype:
  let g:gist_detect_filetype = 1

  " Command to use to copy to clipboard for ``Gist -c XXXXX``:
  if g:is_mac
    let g:gist_clip_command = 'pbcopy'
  elseif g:is_linux
    let g:gist_clip_command = 'xclip -selection clipboard'
  elseif g:is_win
    " Not sure here
  elseif g:is_cygwin
    let g:gist_clip_command = 'putclip'
  endif

  if g:is_mac
    let g:gist_open_browser_after_post = 1
    let g:gist_browser_command = "open %URL%"
  elseif g:is_linux
    let g:gist_open_browser_after_post = 1
    let g:gist_browser_command = "xdg-open %URL%"
  endif
endif
" --------------------------------------------------------------------------
" }}}

" Bufonly Options: {{{
" --------------------------------------------------------------------------
nmap <silent> <leader>bo :BufOnly<CR>
" --------------------------------------------------------------------------
" }}}

" Showmarks Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=152>
" --------------------------------------------------------------------------
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let g:showmarks_enable = 1
" For marks a-z
highlight ShowMarksHLl gui=bold guibg=LightBlue guifg=Blue
" For marks A-Z
highlight ShowMarksHLu gui=bold guibg=LightRed guifg=DarkRed
" For all other marks
highlight ShowMarksHLo gui=bold guibg=LightYellow guifg=DarkYellow
" For multiple marks on the same line.
highlight ShowMarksHLm gui=bold guibg=LightGreen guifg=DarkGreen
" --------------------------------------------------------------------------
" }}}

" Minibufexpl Options: {{{
" --------------------------------------------------------------------------
let g:miniBufExplAutoStart = 1
let g:miniBufExplBuffersNeeded = 0
" --------------------------------------------------------------------------
" }}}

" Tern For Vim Options: {{{
" --------------------------------------------------------------------------
let g:tern_show_argument_hints = 'on_hold'
" --------------------------------------------------------------------------
" }}}

" Javascript Libraries Syntax Options: {{{
" --------------------------------------------------------------------------
let g:used_javascript_libs = 'jquery,underscore,jasmine,chai'
" --------------------------------------------------------------------------
" }}}
"
" Netrw Options: {{{
" --------------------------------------------------------------------------
" Make sure "gx" works properly on linux:

if g:is_linux
  let g:netrw_browsex_viewer='firefox'
  " Use whole "words" when opening URLs.
  " This avoids cutting off parameters (after '?') and anchors (after '#').
  " See http://vi.stackexchange.com/q/2801/1631
  let g:netrw_gx="<cWORD>"
endif
" --------------------------------------------------------------------------
" }}}

" vim: expandtab softtabstop=2 shiftwidth=2
