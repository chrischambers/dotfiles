" --------------------------------------------------------------------------
" Aliases for Identifying Platform (windows, *nix, osx, etc.) {{{
" --------------------------------------------------------------------------
let g:is_win    = has("win16") || has("win32") || has("win64")
let g:is_mac    = has("mac") || has("macunix")
let g:is_linux  = has("unix") && !has("mac")
let g:is_cygwin = has("win32unix")
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Core: {{{
" --------------------------------------------------------------------------
set nocompatible                    " Force this at the start of the file
                                    " (changes subsequent options)
let mapleader = ','                 " Only affects subsequent <leader> commands
" --------------------------------------------------------------------------
"  }}}
" --------------------------------------------------------------------------
" Initiate vim with a single NERDTree only: {{{
" --------------------------------------------------------------------------
if exists('*NERDTreeVisible') && NERDTreeVisible()
  " This file has already been sourced once and NERDTree is still open -
  " deactivate it!
  call NERDToggle()
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Initialize VimrcAutoCmd Auto-Command Group: {{{
" --------------------------------------------------------------------------

" Whenever you create autocommands, you should place them within this group.
" Vim will combine subsequent groups with the same name (they aren't
" overwritten). As this file will always be run first, and the first
" instruction is to clear the previous commands in this group (autocmd!),
" re-sourcing this file will make each autocommand active ONCE, as you would
" expect.
augroup VimrcAutoCmd
  autocmd!
augroup END
" }}}

" --------------------------------------------------------------------------
" Bootstrap: {{{
let s:local_mods_file = '~/.vimrc.local'
" Example script_location- "~/dotfiles/mine/vim" (note lack of terminal slash):
let s:script_location = fnamemodify(resolve(expand('<sfile>')), ':h')
let s:config_files = filter(split(
\    glob(printf('%s/config/**', s:script_location))),
\    'v:val !~ "/config/after"'
\ )
let s:post_config_files = filter(split(
\    glob(printf('%s/config/**', s:script_location))),
\    'v:val =~ "/after/"'
\ )

function! s:Source_bundles()
  execute printf('source %s/%s', s:script_location, 'bundles.vim')
endfunction

function! s:Source_configs(list)
  for l:path in a:list
    if filereadable(l:path)
      execute printf('source %s', l:path)
    endif
  endfor
endfunction

function! s:Source_local_modifications(local_mods_file)
  let l:file = expand(a:local_mods_file)
  if filereadable(l:file)
    execute printf('source %s', l:file)
  endif
endfunction

function! s:Bootstrap()
  call s:Source_bundles()
  call s:Source_configs(s:config_files)
  call s:Source_configs(s:post_config_files)
  call s:Source_local_modifications(s:local_mods_file)
endfunction
" }}}

if !exists('s:loaded_my_vimrc')
  call s:Bootstrap()
  let s:loaded_my_vimrc = 1
endif

" --------------------------------------------------------------------------
" File-type highlighting and configuration. {{{
" --------------------------------------------------------------------------
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
syntax on             " enable per-filetype syntax highlighting
filetype on           " enable filetype detection
filetype plugin on    " enable filetype specific plugins
filetype indent on    " enable filetype-specific indenting where available,
" }}}
" --------------------------------------------------------------------------

" vim: foldmethod=marker
