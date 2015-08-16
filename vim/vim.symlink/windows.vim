" --------------------------------------------------------------------------
" Modify Runtimepath: {{{
" --------------------------------------------------------------------------
set runtimepath+=$VIMRUNTIME
" call pathogen#surround($VIM  . pathogen#slash() . 'vimfiles')
" call pathogen#surround(g:vimfiles)
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Avoid Opening NERDTree In System32 Folder On Windows: {{{
" --------------------------------------------------------------------------
if getcwd() =~ '\\Windows\\system32'
  cd $HOME
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Configure Grep For Windows: {{{
" --------------------------------------------------------------------------
" set grepprg=findstr\ /n\ /s"
" Depends on fs.bat: https://github.com/jeyoung/fs.bat
set grepprg=C:\Windows\fs.bat
" }}}
