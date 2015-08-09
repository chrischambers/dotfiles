let s:default_excludes = [ '^-MiniBufExplorer-$', '^NERD_tree_\d*$' ]

" --------------------------------------------------------------------------
" Utility Functions: {{{
" --------------------------------------------------------------------------
function! BufferNameMatchesPatterns(buffername, pattern_list)
  for pattern in a:pattern_list
    if a:buffername =~# pattern
      return 1
    endif
  endfor
endfunction

function! PreventClosingLastWindow()
  """ Prevents closing the last window, *exclusive* of special buffers.
  let opt = (a:0 >= 1 ? a:1 : {})
  let exclude_patterns = get(opt, 'exclude_buffers', s:default_excludes)
  let all_buffers = map(tabpagebuflist(), "bufname(v:val)")
  let curr_buff_special = BufferNameMatchesPatterns(
        \ bufname('%'), exclude_patterns
        \ )
  let special_buffers = filter(
        \ copy(all_buffers),
        \ 'BufferNameMatchesPatterns(v:val, exclude_patterns)'
        \ )
  if (len(special_buffers) + 1 == len(all_buffers)) && !curr_buff_special
    " ..this is the only non-special buffer remaining: don't close it.
    echoerr "E444: Cannot close last window"
  else
    " call feedkeys("\<C-W>c", "n")
    " Better alternative: issue the command that the mapping points to
    " directly. feedkeys is only resolved once the entire mapping is finished,
    " so any commands following this invocation will actually fire *before* the
    " feedkeys command, not after.
    :close
  endif
endfunction
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Mapping Fixes: {{{
" --------------------------------------------------------------------------
function! VimSpecialBufferFixEqualizeWindows(...)
  let opt = (a:0 >= 1 ? a:1 : {})
  let exclude_patterns = get(opt, 'exclude_buffers', s:default_excludes)
  let record_size = {}
  for pat in exclude_patterns
    let buffs = map(tabpagebuflist(), "bufname(v:val)")
    " let matching_buffers = filter(buffers, "v
    for b in buffs
      if b =~# pat
          let fixheight = getbufvar(b, '&winfixheight')
          let fixwidth  = getbufvar(b, '&winfixwidth')
          let record_size[b] = [fixwidth, fixheight]

          let height = getbufvar(b, '&winheight')
          let width  = getbufvar(b, '&winwidth')
          call setbufvar(b, '&winfixheight', height)
          call setbufvar(b, '&winfixwidth', width)
      endif
    endfor
  endfor
  call feedkeys("\<C-W>=", "n")
  for k in keys(record_size)
    let fixwidth  = record_size[k][0]
    let fixheight = record_size[k][1]
    call setbufvar(b, '&winfixheight', fixheight)
    call setbufvar(b, '&winfixwidth', fixwidth)
  endfor
endfunction

function! VimSpecialBufferFixCloseWindow(...)
  let window_is_nerdtree = getbufvar('%', '&ft') == "nerdtree"
  if !window_is_nerdtree
    call PreventClosingLastWindow()
  else
    call NERDToggle()
  endif
endfunction

function! VimSpecialBufferFixOnlyWindow(...)
  if exists('*NERDTreeVisible') && NERDTreeVisible()
    call NERDToggle()
    let g:restore_nerdtree = 1
  endif
  :only
  MBEOpen
  call feedkeys("\<C-W>j", "n")
endfunction

nnoremap <C-W>= :call VimSpecialBufferFixEqualizeWindows()<CR>
nnoremap <silent> <C-W>c :call VimSpecialBufferFixCloseWindow()<CR>
nnoremap <silent> <C-W>o :call VimSpecialBufferFixOnlyWindow()<CR>
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Command Fixes: {{{
" --------------------------------------------------------------------------
function! VimSpecialBufferFixOpenCmds(...)
  """ The current implementation could get stuck in an infinite loop if all
  """ the buffers match the exclude patterns.
  let opt = (a:0 >= 1 ? a:1 : {})
  let exclude_patterns = get(opt, 'exclude_buffers', s:default_excludes)
  let cmd = get(opt, 'cmd', ':enew')

  let bufn = bufname('%')
  while 1
  if BufferNameMatchesPatterns(bufn, exclude_patterns)
    wincmd w
    let bufn = bufname('%')
    continue
  else
    exec cmd
    return
  endif
endfunction

function! VimSpecialBufferFixEditCmd(path, ...)
  """ The current implementation could get stuck in an infinite loop if all
  """ the buffers match the exclude patterns.
  let opt = (a:0 >= 1 ? a:1 : {})
  let opt['cmd'] = ':e ' . fnameescape(a:path)
  call VimSpecialBufferFixOpenCmds(opt)
endfunction

function! VimSpecialBufferFixTagsCmd(path, ...)
  """ Wrapper function: handles :tj command
  let opt = (a:0 >= 1 ? a:1 : {})
  let cmd = get(opt, 'cmd', ':tj')
  let opt['cmd'] = cmd . ' ' . fnameescape(a:path)
  call VimSpecialBufferFixOpenCmds(opt)
endfunction

function! VimSpecialBufferFixTagsCmd2(path, ...)
  """ Wrapper Function, handles :ta command
  let opt = (a:0 >= 1 ? a:1 : {})
  let opt['cmd'] = ':ta'
  call VimSpecialBufferFixTagsCmd(a:path, opt)
endfunction

command! Enew call VimSpecialBufferFixOpenCmds()
command! Split call VimSpecialBufferFixOpenCmds({'cmd': ':sp'})
command! VSplit call VimSpecialBufferFixOpenCmds({'cmd': ':vsp'})
command! -nargs=1 -complete=file Edit call VimSpecialBufferFixEditCmd(<q-args>)
command! -nargs=1 -complete=tag Tjump call VimSpecialBufferFixTagsCmd(<q-args>)
command! -nargs=1 -complete=tag Tag call VimSpecialBufferFixTagsCmd2(<q-args>)

cnoremap <expr> enew
      \ (getcmdtype() == ':' && getcmdpos()<4 ? 'Enew' : 'enew')
cnoremap <expr> sp
      \ (getcmdtype() == ':' && getcmdpos()<2 ? 'Split' : 'sp')
cnoremap <expr> vsp
      \ (getcmdtype() == ':' && getcmdpos()<3 ? 'VSplit' : 'vsp')
cnoreabbrev <expr> e
      \ ((getcmdtype() == ':' && getcmdpos() <= 2) ? 'Edit' : 'e')
cnoremap <expr> tj
      \ (getcmdtype() == ':' && getcmdpos()<2 ? 'Tjump' : 'tj')
cnoremap <expr> ta<Space>
      \ (getcmdtype() == ':' && getcmdpos()<3 ? 'Tag ' : 'ta')
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
