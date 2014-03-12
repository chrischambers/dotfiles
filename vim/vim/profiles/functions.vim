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
" Trim Trailing WhiteSpace: {{{
" --------------------------------------------------------------------------
" autocmd BufWritePre * normal m`:%s/\s\+$//e`
" autocmd BufWritePre *.py normal m`:%s/\s\+$//e`

function! TrimWhiteSpace() range
""" Removes trailing spaces
  let start = a:firstline == a:lastline ? 1 : a:firstline
  let end   = a:firstline == a:lastline ? line('$') : a:lastline
  exe start . "," . end . 's/\s*$//'
endfunction
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Prettify Python Files on Save: {{{
" --------------------------------------------------------------------------
function! RegulateClassDefSpacing()
  """ For algorithm, see comments below.
  """
  """ Possible improvement: factor out common regex components, and use some
  """ kind of string interpolation. Note that we're using the "very magic"
  """ option to keep the regexes a little cleaner.
  """
  """ Function/class definition:        ((\s*def |\s*class )[^\(]+\([^\)]+\):)
  """ Class definition:                 ((\s*class )[^\(]+\([^\)]+\):)
  """ Blank line (ending):              (\s*\n)

  try
    " First, squeeze all concurrent blank lines at EOF down to 1:
    %s/\v(^\s*\n)*%$//
    " ...and append an empty line to the end of the file, if required.
    " if !empty(getline('$'))
    "    %s/\%$//g
    " endif
    " trim all class/function definitions so that they have only a single
    " preceding blank line:
    %s/\v^(\s*\n){2,}((.+\n)*)((\s*def |\s*class )[^\(]+\([^\)]+\):)/\2\4/g
    "%s/\v^(\s*\n){2,}((.+\n)*)(\s*def|\s*class)/\2\4/g
    " if a class/function definition line is immediately followed by blank
    " lines, remove them:
    %s/\v((\s*def |\s*class )[^\(]+\([^\)]+\):)(\s*\n)+/\1/g
    " ensure all classes definitions now have 2 preceding blank lines:
    %s/\v^(\s*\n)+((.+\n)*)((\s*class )[^\(]+\([^\)]+\):)/\2\4/g
  catch /^Vim\%((\a\+)\)\=:E486/   " regex didn't match
  endtry
endfunction

function! PrettifyPythonWhitespace()
  let cursor_position = getpos('.')
  silent call TrimWhiteSpace()
  silent call RegulateClassDefSpacing()
  call setpos('.', cursor_position)
endfunction

" set list listchars=trail:.,extends:>
" Deactivated temporarily.

" if has("autocmd")
"   augroup python_prettify
"     au!
"     au FileWritePre *.py :silent call PrettifyPythonWhitespace()
"     au FileAppendPre *.py :silent call PrettifyPythonWhitespace()
"     au FilterWritePre *.py :silent call PrettifyPythonWhitespace()
"     au BufWritePre *.py :silent call PrettifyPythonWhitespace()
"   augroup END
" endif

noremap <leader>pp :call PrettifyPythonWhitespace()<CR>
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
