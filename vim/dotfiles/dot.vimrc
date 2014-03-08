let mapleader = ','
let g:tmux_navigator_no_mappings = 1
" Ultisnips Options: {{{
" --------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger="<Enter>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"
nnoremap <leader>ue :UltiSnipsEdit<CR>
" --------------------------------------------------------------------------
" }}}

" add local .vim directory to runtimepath
let s:local_dot_vim_dir_path = expand('<sfile>:h:h') . '/vim/config'
execute 'set runtimepath+=' . s:local_dot_vim_dir_path

" setup sample settings{{{
" local settings
let s:profiles_dir_path = expand('<sfile>:h:h') . '/vim/profiles/'
let s:profile_names = [ 'bundles', 'core', 'functions', 'unite', 'plugins' ] " 'default'

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
" source sample profiles
call s:source_profiles(s:profile_names)

" source local settings at last
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
call unite#custom#profile('mru', 'ignorecase', 1)
call unite#custom#profile('mru', 'filters', 'sorter_rank')

nnoremap <leader>f :<C-u>Unite
      \ -no-split
      \ -buffer-name=files
      \ -start-insert
      \ -toggle
      \ file_rec<CR>
nnoremap <leader>r :<C-u>Unite
      \ -no-split
      \ -profile-name=mru
      \ -start-insert
      \ -toggle
      \ file_mru<CR>
nnoremap <leader>, :<C-u>Unite
      \ -no-split
      \ -buffer-name=buffers
      \ -quick-match
      \ -toggle
      \ buffer<CR>
nnoremap <leader>F :<C-u>Unite -no-split -buffer-name=files -toggle file<CR>
nnoremap <leader>o :<C-u>Unite
      \ -no-split
      \ -buffer-name=outline
      \ -no-start-insert
      \ -toggle
      \ outline<CR>
nnoremap <leader>y :<C-u>Unite history/yank<CR>
nnoremap <leader><C-r> :source ~/dotfiles/vimrc-builder/dotfiles/dot.vimrc<C-m>


nnoremap <silent> <c-s-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-s-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-s-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-s-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-s-/> :TmuxNavigatePrevious<cr>

let g:jedi#rename_command = "<leader>pr"
let g:jedi#goto_definitions_command = "<leader>pd"

" Note: when using NERDTree, you want to ensure your force the minibufexpl
" window to be active at all times:
let g:miniBufExplBuffersNeeded = 0

" vim: foldmethod=marker
