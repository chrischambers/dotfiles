if globpath(&rtp, 'plugin/unite.vim') == ''
  finish
endif

" --------------------------------------------------------------------------
" Unite Buffer Mappings: {{{
" --------------------------------------------------------------------------
function! s:unite_settings()
  nmap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> jj    <Plug>(unite_insert_leave)
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  imap <buffer> qq    <Plug>(unite_exit)
endfunction
autocmd VimrcAutoCmd FileType unite call s:unite_settings()
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Sensible Defaults: {{{
" --------------------------------------------------------------------------
call unite#custom#profile('default', 'context', {
\     'direction': 'dynamictop',
\     'start_insert': 1,
\     'toggle': 1,
\     'split': 1,
\ })

call unite#filters#matcher_default#use(['matcher_fuzzy'])
" Gary Bernhardt's ranking algorithm from 'selecta':
call unite#filters#sorter_default#use(['sorter_selecta'])
" Permit unlimited candidates from following sources:
call unite#custom#source(
\     'buffer,file,file_rec,file_rec/async,file_mru,dir_mru',
\     'max_candidates', '0'
\ )

" By default, the mru ignore patterns include "/media/", but when directly
" accessing (or even following a symlink) to networked drives on a linux
" installation the file/directory paths will generally include "/media/", so
" let's change that default:
let g:unite_source_file_mru_ignore_pattern =
      \'\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$'.
      \'\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
      \'\|^\%(\\\\\|/mnt/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'.
      \'\|\%(^\%(fugitive\)://\)'.
      \'\|\%(^\%(term\)://\)'
let g:unite_source_directory_mru_ignore_pattern =
      \'\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
      \'\|^\%(\\\\\|/mnt/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
"  My Bindings: {{{
" --------------------------------------------------------------------------
let g:unite_source_history_yank_enable = 1

nnoremap <silent> <leader>y :<C-u>Unite
      \ history/yank
      \ <CR>
nnoremap <leader>p :<C-u>Unite -quick-match history/yank<CR>

" \ -auto-preview
nnoremap <silent> <leader>, :<C-u>Unite
      \ -no-split
      \ -no-resize
      \ -buffer-name=buffers
      \ buffer
      \ <CR>
" LustyJuggler style:
" nnoremap <leader>, :<C-u>Unite
"       \ -no-split
"       \ -buffer-name=buffers
"       \ -quick-match
"       \ -toggle
"       \ buffer<CR>

nnoremap <silent> <leader>r :<C-u>Unite
      \ -profile-name=mru
      \ file_mru
      \ <CR>

" --------------------------------------------------------------------------
" Note: from help page - g:unite_source_rec_async_command
" --------------------------------------------------------------------------
"
" ...
" " Using ag as recursive command.
" let g:unite_source_rec_async_command =
"         \ 'ag --follow --nocolor --nogroup --hidden -g ""'
" " Using ack-grep as recursive command.
" let g:unite_source_rec_async_command = 'ack -f --nofilter'
"

" The default value is "find -L" which follows symbolic links
" to have the same behaviour as file_rec, and the
" args(|g:unite_source_rec_find_args|).
" Because, "find" command is fastest.
" Note: In windows environment, you must install file list
" command and specify the variable.
" --------------------------------------------------------------------------

nnoremap <silent> <leader>f :<C-u>Unite
      \ -buffer-name=files
      \ file_rec/async
      \ <CR>
nnoremap <silent> <leader>F :<C-u>Unite
      \ -buffer-name=files
      \ file
      \ <CR>

 nnoremap <silent> <leader>o :<C-u>Unite
      \ -buffer-name=outline
      \ -no-start-insert
      \ -no-split
      \ -no-resize
      \ -auto-preview
      \ outline
      \ <CR>

" You seemingly cannot adjust sorters/converters/matchers via the
" custom#profile call atm, e.g.:
"
" call unite#custom#profile('mru', 'sorters', ['sorter_length'])
"
" The only way to set them to seems to be via #custom#source, e.g.:
"
" call unite#custom#source(
" \   'file_mru,dir_mru',
" \   'sorters', ['sorter_selecta']
" \ )
"
" call unite#custom#source(
" \    'file_mru,dir_mru',
" \    'converters', ['converter_relative_word']
" \ )
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------

" The rest of this file is inherited from vimrc-builder and being
" tweaked/tested:

" --------------------------------------------------------------------------
" Unite Prefix Mappings: {{{
" --------------------------------------------------------------------------
nnoremap [unite] <Nop>
nmap <Leader>g [unite]
" --------------------------------------------------------------------------

nmap [unite]t     <SID>(tab)

nmap [unite]/     <SID>(search)
nmap [unite]*     <SID>(star-search)

nmap [unite]g    <SID>(grep)

nmap [unite]o     <SID>(outline)
nmap [unite]m     <SID>(mark)
nmap [unite]r     <SID>(register)

nmap [unite]hc    <SID>(history-command)
nmap [unite]hs    <SID>(history-search)

nmap [unite]s     <SID>(show-unite-sources)

nmap [unite]nbin  <SID>(neobundle-install)
nmap [unite]Nbin  <SID>(neobundle-install-individually)
nmap [unite]nbin! <SID>(neobundle-install!)
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Unite Custom Commands For Mappings: {{{

nnoremap <silent> <SID>(search) :<C-u>Unite
      \ -buffer-name=search -
      \ prompt=search> -
      \ auto-preview -
      \ vertical -
      \ direction=topleft -
      \ no-quit
      \ line
      \ <CR>

nnoremap <silent> <SID>(star-search) :<C-u>
      \ UniteWithCursorWord
      \ -buffer-name=search
      \ -prompt=search>
      \ -auto-preview
      \ -vertical
      \ -direction=topleft
      \ -no-start-insert
      \ -no-quit
      \ line
      \ <CR>

nnoremap <silent> <expr> <SID>(grep)
    \ ':Unite -no-quit grep:' . expand('%:h') .
    \ "<CR>" . expand('<cword>') . "<CR>"

nnoremap <silent> <SID>(tab) :<C-u>Unite
      \ -buffer-name=tab
      \ -prompt=tab>
      \ -immediately
      \ -no-start-insert
      \ tab:no-current
      \ <CR>

nnoremap <silent> <SID>(outline)  :<C-u>Unite
      \ -vertical
      \ -direction=topleft
      \ -auto-preview
      \ outline
      \ <CR>

nnoremap <silent> <SID>(mark)     :<C-u>Unite mark<CR>
nnoremap <silent> <SID>(register) :<C-u>Unite register<CR>

nnoremap <silent> <SID>(history-command) :<C-u>Unite history/command<CR>
nnoremap <silent> <SID>(history-search)  :<C-u>Unite history/search<CR>

nnoremap <silent> <SID>(show-unite-sources) :<C-u>Unite source<CR>

nnoremap <silent> <SID>(neobundle-install) :<C-u>Unite
      \ neobundle/install
      \ <CR>
nnoremap <silent> <SID>(neobundle-install-individually) :<C-u>Unite
      \ neobundle/install:
nnoremap <silent> <SID>(neobundle-install!) :<C-u>Unite
      \ neobundle/install:!
      \ <CR>
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Select Best Grep Source For Unite: {{{
" --------------------------------------------------------------------------
if executable('ag')
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
  \ '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
  \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '-i --nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
  " http://beyondgrep.com/
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
  let g:unite_source_grep_recursive_opt = ''
else
  " Fall back to basic grep
  let g:unite_source_grep_default_opts = '-iRHn'
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
