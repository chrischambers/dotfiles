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
