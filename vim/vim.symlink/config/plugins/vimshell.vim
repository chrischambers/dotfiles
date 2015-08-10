" Vimshell Settings: {{{
" --------------------------------------------------------------------------
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
" --------------------------------------------------------------------------
"}}}
