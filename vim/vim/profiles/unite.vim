" unite settings
if globpath(&rtp, 'plugin/unite.vim') == ''
  finish
endif

" let g:unite_split_rule = 'botright'
let g:unite_enable_start_insert = 1

" unite prefix key
nnoremap [unite] <Nop>
nmap <Leader><Leader> [unite]

" maps {{{
nmap [unite]u     <SID>(normally)
nmap [unite]c     <SID>(current-buffer-dir)
nmap [unite]b     <SID>(buffer)

nmap [unite]t     <SID>(tab)

nmap [unite]/     <SID>(search)
nmap [unite]*     <SID>(star-search)

nmap g*           <SID>(grep)

nmap [unite]o     <SID>(outline)
nmap [unite]m     <SID>(mark)
nmap [unite]r     <SID>(register)

nmap [unite]hc    <SID>(history-command)
nmap [unite]hs    <SID>(history-search)

nmap [unite]s     <SID>(source)

nmap [unite]nbin  <SID>(neobundle-install)
nmap [unite]Nbin  <SID>(neobundle-install-indivisually)
nmap [unite]nbin! <SID>(neobundle-install!)
"}}}

" on unite buffer setting
autocmd VimrcAutoCmd FileType unite call s:unite_settings()
function! s:unite_settings()"{{{
  nmap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> jj    <Plug>(unite_insert_leave)
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  imap <buffer> qq    <Plug>(unite_exit)
endfunction"}}}

" mapped commands {{{
" files {{{
nnoremap <silent> <SID>(normally)           :<C-u>Unite -buffer-name=files file file_rec buffer<CR>
nnoremap <silent> <SID>(current-buffer-dir) :<C-u>UniteWithBufferDir -buffer-name=files -prompt=buffer_dir> file buffer file_rec<CR>
nnoremap <silent> <SID>(buffer)             :<C-u>Unite -buffer-name=files -prompt=buffer> buffer<CR>
"}}}

" search {{{
nnoremap <silent> <SID>(search)      :<C-u>Unite -buffer-name=search -prompt=search> -auto-preview -vertical -direction=topleft -no-quit line<CR>
nnoremap <silent> <SID>(star-search) :<C-u>UniteWithCursorWord -buffer-name=search -prompt=search> -auto-preview -vertical -direction=topleft -no-start-insert -no-quit line<CR>
"}}}

nnoremap <silent> <SID>(tab) :<C-u>Unite -buffer-name=tab -prompt=tab> -immediately -no-start-insert tab:no-current<CR>

" grep {{{
let g:unite_source_grep_default_opts = '-iRHn'
nnoremap <silent> <expr> <SID>(grep)     ':Unite -no-quit grep:' . expand('%:h')     . "<CR>" . expand('<cword>') . "<CR>"
"}}}

nnoremap <silent> <SID>(outline)  :<C-u>Unite -vertical -direction=topleft -auto-preview outline<CR>
nnoremap <silent> <SID>(mark)     :<C-u>Unite mark<CR>
nnoremap <silent> <SID>(register) :<C-u>Unite register<CR>

" history {{{
nnoremap <silent> <SID>(history-command) :<C-u>Unite history/command<CR>
nnoremap <silent> <SID>(history-search)  :<C-u>Unite history/search<CR>
"}}}

nnoremap <silent> <SID>(source) :<C-u>Unite source<CR>

nnoremap <silent> <SID>(neobundle-install)              :<C-u>Unite neobundle/install<CR>
nnoremap <silent> <SID>(neobundle-install-indivisually) :<C-u>Unite neobundle/install:
nnoremap <silent> <SID>(neobundle-install!)             :<C-u>Unite neobundle/install:!<CR>
"}}}

if executable('ag')
  " Use ag in unite grep source.
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
  \ '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
  \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
  " let g:unite_source_rec_async_command =
  "     \ 'ag --follow --nocolor --nogroup --hidden -g ""'
elseif executable('pt')
  " Use pt in unite grep source.
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '-i --nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
  " Use ack in unite grep source.
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts =
  \ '-i --no-heading --no-color -k -H'
  let g:unite_source_grep_recursive_opt = ''
endif
" vim: expandtab softtabstop=2 shiftwidth=2
