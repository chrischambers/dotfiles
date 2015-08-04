let s:is_win    = has("win16") || has("win32") || has("win64")
let s:is_mac    = has("mac") || has("macunix")
let s:is_linux  = has("unix") && !has("mac")
let s:is_cygwin = has("win32unix")

" --------------------------------------------------------------------------
set nocompatible                    " Force this at the start of the file
                                    " (changes subsequent options)
let mapleader = ','                 " Only affects subsequent <leader> commands
" --------------------------------------------------------------------------

" add local .vim directory to runtimepath
let s:script_location = resolve(expand('<sfile>'))
let s:local_dot_vim_dir_path = fnamemodify(s:script_location, ':h:h') . '/vim/config'
execute 'set runtimepath+=' . s:local_dot_vim_dir_path

" setup sample settings{{{
" local settings
let s:profiles_dir_path = fnamemodify(s:script_location, ':h:h') . '/vim/profiles/'
let s:profile_names = ['core', 'functions', 'unite', 'plugins', 'filetypes'] " 'default'

" local functions {{{
function! s:source_profile(name)"{{{
  let l:path = printf('%s%s.vim', s:profiles_dir_path, a:name)
  if filereadable(l:path)
    execute printf('source %s', l:path)
  endif
endfunction"}}}

function! s:source_profiles(names)"{{{
  for l:name in a:names
    call s:source_profile(l:name)
  endfor
endfunction"}}}

function! s:call_source_profiles(args)"{{{
  call s:source_profiles(split(a:args, '[, :]'))
endfunction"}}}
command! -nargs=+ ResourceProfile call s:call_source_profiles(<q-args>)
"}}}

" initialize VimrcAutoCmd augroup
augroup VimrcAutoCmd
  autocmd!
augroup END

" source bundles at first
call s:source_profile('bundles')
" source profiles
call s:source_profiles(s:profile_names)

" source local settings last
let g:path_to_vimrc_profile = '~/.vimrc_profile'
if filereadable(expand(g:path_to_vimrc_profile))
  execute printf('source %s', expand(g:path_to_vimrc_profile))
endif
"}}}

let g:vimshell_editor_command = "mvim -v"

let g:unite_source_history_yank_enable = 1
let g:unite_enable_short_source_names = 1
let g:unite_matcher_fuzzy_max_input_length = 200
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('buffer,file,file_rec,file_rec/async',
      \'sorters', 'sorter_rank')
call unite#custom#source('buffer,file,file_rec,file_rec/async',
      \'max_candidates', '0')
call unite#custom#profile('mru', 'context.ignorecase', 1)
call unite#custom#profile('mru', 'filters', 'sorter_rank')

nnoremap <leader>f :<C-u>Unite
      \ -no-split
      \ -buffer-name=files
      \ -start-insert
      \ -toggle
      \ file_rec/async<CR>
nnoremap <leader>r :<C-u>Unite
      \ -no-split
      \ -profile-name=mru
      \ -start-insert
      \ -toggle
      \ file_mru<CR>
nnoremap <leader>, :<C-u>Unite
      \ -no-split
      \ -buffer-name=buffers
      \ -start-insert
      \ -toggle
      \ buffer<CR>
" LustyJuggler style:
" nnoremap <leader>, :<C-u>Unite
"       \ -no-split
"       \ -buffer-name=buffers
"       \ -quick-match
"       \ -toggle
"       \ buffer<CR>
nnoremap <leader>F :<C-u>Unite -no-split -buffer-name=files -toggle file<CR>

nnoremap <leader>o :<C-u>Unite
      \ -no-split
      \ -buffer-name=outline
      \ -no-start-insert
      \ -toggle
      \ outline<CR>
nnoremap <leader>p :<C-u>Unite -quick-match history/yank<CR>
nnoremap <leader><C-r> :source ~/dotfiles/vimrc-builder/dotfiles/dot.vimrc<C-m>

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-S-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-S-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-S-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-S-l> :TmuxNavigateRight<cr>
nnoremap <silent> <C-S-/> :TmuxNavigatePrevious<cr>

let g:jedi#rename_command = "<leader>pr"
let g:jedi#goto_definitions_command = "gd"
let g:jedi#use_tabs_not_buffers = 0

" Note: when using NERDTree, you want to ensure you force the minibufexpl
" window to be active at all times:
let g:miniBufExplBuffersNeeded = 0

if has("gui_running")
    set guioptions-=T " disables Toolbar
    set guioptions-=L " disables left-hand vertical scrollbar when vsplit
    set columns=95
    set lines=57
    " set columns=105 lines=60
    if s:is_mac
      set guifont=Source\ Code\ Pro:h11,Andale\ Mono:h12,Consolas\ 9,Liberation\ Mono\ 8
    elseif s:is_linux
      set guifont=Droid\ Sans\ Mono\ 10
    elseif s:is_win
      set guifont=Dina:h8:cANSI,Consolas:h9:cANSI
    endif
endif

hi clear SpellBad
hi clear SpellLocal
hi clear SpellRare
hi clear SpellCap
hi SpellBad ctermbg=52 gui=undercurl guisp=#FF5522
hi SpellCap ctermbg=53 gui=undercurl guisp=SlateBlue
hi SpellRare ctermbg=55 gui=undercurl guisp=purple

let s:viml_functions = "~/.vim/UltiSnips/viml_functions.vim"
if filereadable(s:viml_functions)
  execute 'source ' . s:viml_functions
endif
let g:localvimrc_sandbox = 0
let g:localvimrc_whitelist = '/Users/ajax/src/py/django/_mine/[^/]*/'

" Set Grep Program to Ag or Ack: {{{
" --------------------------------------------------------------------------
" Modified heavily from original source:
" <url:http://weblog.jamisbuck.org/2008/11/17/vim-follow-up>
if executable('ag')
  set grepprg=ag\ --column
  set grepformat=%f:%l:%c:%m
elseif executable('ack') || executable('ack-grep')
  set grepprg=ack
  set grepformat=%f:%l:%m
endif
" --------------------------------------------------------------------------
" }}}

" By default, these mru ignore patterns include "/media/", but when directly
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

if s:is_linux
  let g:netrw_browsex_viewer="firefox"
endif

" vim: foldmethod=marker
