" --------------------------------------------------------------------------
" Use Visual Range As Search Pattern: {{{
" --------------------------------------------------------------------------
" Select visual range, then use * or # to search on current selection(!)
" From an idea by Michael Naumann
" Source: <url:http://amix.dk/vim/vimrc.html>
" --------------------------------------------------------------------------
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Underline Current Line: {{{
" --------------------------------------------------------------------------
function! Underline(...)
  if a:0 == 1
    let l:underchar = a:1
  else
    let l:underchar = "-"
  endif
  let l:linenum = getline('.')
  let l:linelength = len(l:linenum)
  exec "normal o\<Esc>" . l:linelength . 'i' . l:underchar . "\<Esc>+"

endfunction

nnoremap <leader>u :call Underline()<CR>
nnoremap <leader><S-u> :call Underline("=")<CR>
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Highlight Overlength Lines: {{{
" --------------------------------------------------------------------------
" Provides subtle red-highlighting for lines with a length that exceeds 80
" characters.
" Source: <url:http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns>
" --------------------------------------------------------------------------
if has("autocmd")
  augroup highlight
  au!
  fun! Highlight_overlength()
    if !exists("b:no_highlight_overlength")
      highlight OverLength ctermbg=52 ctermfg=white guibg=#592929
      match OverLength /\%81v.*/
    endif
  endfun
  autocmd BufRead * call Highlight_overlength()
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
