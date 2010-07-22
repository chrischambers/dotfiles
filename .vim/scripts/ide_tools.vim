" list of patterns
let s:default_excludes = [ '^-MiniBufExplorer-$', '^NERD_tree_\d*$' ]

function! VimIDEFixEqualizeWindows(...)
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
nnoremap <silent> <C-W>= :call VimIDEFixEqualizeWindows()<CR>

function! BufferNameMatchesPatterns(buffername, pattern_list)
  for pattern in a:pattern_list
    if a:buffername =~# pattern
      return 1
    endif
  endfor
endfunction

function! VimIDEFixOpenCmds(...)
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

function! VimIDEFixEditCmd(path, ...)
  """ The current implementation could get stuck in an infinite loop if all
  """ the buffers match the exclude patterns.
  let opt = (a:0 >= 1 ? a:1 : {})
  let opt['cmd'] = ':e ' . fnameescape(a:path)
  call VimIDEFixOpenCmds(opt)
endfunction
command! -nargs=1 -complete=file Edit call VimIDEFixEditCmd(<q-args>)
cnoreabbrev <expr> e
      \ ((getcmdtype() == ':' && getcmdpos() <= 2) ? 'Edit' : 'e')

command! Enew call VimIDEFixOpenCmds()
cnoremap <expr> enew
      \ (getcmdtype() == ':' && getcmdpos()<4 ? 'Enew' : 'enew')
command! Split call VimIDEFixOpenCmds({'cmd': ':sp'})
cnoremap <expr> sp
      \ (getcmdtype() == ':' && getcmdpos()<2 ? 'Split' : 'sp')
command! VSplit call VimIDEFixOpenCmds({'cmd': ':vsp'})
cnoremap <expr> vsp
      \ (getcmdtype() == ':' && getcmdpos()<3 ? 'VSplit' : 'vsp')

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
    call feedkeys("\<C-W>c", "n")
  endif
endfunction

function! VimIDEFixCloseWindow(...)
  let window_is_nerdtree = getbufvar('%', '&ft') == "nerdtree"
  if !window_is_nerdtree
    call PreventClosingLastWindow()
  else
    call NERDToggle()
  endif
endfunction
nnoremap <C-W>c :call VimIDEFixCloseWindow()<CR>

