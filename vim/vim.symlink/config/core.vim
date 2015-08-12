set backspace=indent,eol,start " Intuitive backspacing in insert mode

set nu                " line numbering
set nocul             " disable cursor-line highlighting
set nowrap            " prevent lines from wrapping automatically

set showcmd           " Show (partial) command in status line.
set showmatch         " Show matching brackets...
set matchtime=2       " for only .2 seconds.

"set autoread         " Watch for file changes and update accordingly. Note:
                      " "the above change updates the file without prompting
                      " the user. This could potentially overwrite work.
set autowrite         " Automatically save before commands like :next and :make
set hidden            " Allows you to switch to different buffers without
                      " having to save changes:
                      "
                      " * The current buffer can be put to the background
                      "   without writing to disk
                      " * When a background buffer becomes current again, marks
                      "   and undo-history are remembered.
set history=200       " Command history length.
set tags=tags;/       " Look for tags file up through dirs until one is found.

set scrolloff=2       " Keep 2 lines above/below cursor when scrolling up/down
set sidescrolloff=2   " Keep 2 lines left/right of cursor when scrolling
                      " left/right
                      "
set encoding=utf-8    " applies to text in the buffers, registers, Strings in
                      " expressions, text stored in the viminfo file, etc.
" --------------------------------------------------------------------------
" Show Invisible Characters: {{{
" --------------------------------------------------------------------------
" from godlygeek:
if &enc =~ '^u\(tf\|cs\)' " When running in a Unicode environment,
  set list " visually represent certain invisible characters:
  let s:arr = nr2char(9655) " using U+25B7 (▷) for an arrow, and
  let s:dot = nr2char(8901) " using U+22C5 (⋅) for a very light dot,
  " display tabs as an arrow followed by some dots (▷⋅⋅⋅⋅⋅⋅⋅),
  exe "set listchars=tab:" . s:arr . s:dot
  " and display trailing and non-breaking spaces as U+22C5 (⋅).
  exe "set listchars+=trail:" . s:dot
  exe "set listchars+=nbsp:" . s:dot
  " Also show an arrow+space (↪ ) at the beginning of any wrapped long lines?
  " I don't like this, but I probably would if I didn't use line numbers.
  let &sbr=nr2char(8618).' '
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Resume Last Editing Spot When Reading File: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  " Try to jump to the last spot the cursor was at in a file when reading it.
  augroup resume_last_editing_spot
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" |
        \ endif
  augroup END
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" Initiate Vim With A Single NERDTree Only: {{{
" --------------------------------------------------------------------------
if exists('*NERDTreeVisible') && NERDTreeVisible()
  " This file has already been sourced once and NERDTree is still open -
  " deactivate it!
  call NERDToggle()
endif
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
