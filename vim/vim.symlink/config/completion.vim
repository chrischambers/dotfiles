" Shell Like Filename Completion: {{{
" --------------------------------------------------------------------------
" By default, pressing <TAB> in command mode will choose the first possible
" completion with no indication of how many others there might be. The
" following configuration lets you see what your other options are:
set wildmenu
" To have the completion behave similarly to a shell, i.e. complete only up to
" the point of ambiguity (while still showing you what your options are), also
" add the following:
set wildmode=list:longest,full
" list:longest    - When > 1 match, list all matches and
"                   complete till longest common string.
" full            - enables you to tab through the remaining completions
set wildignore+=*.pyc,*.zip,*.gz,*.bz,*.tar,*.jpg,*.png,*.gif,*.avi,*.wmv,*.ogg,*.mp3,*.mov,*.chm

" set complete=.,w,b,u,t,i
" set completeopt=menu,longest
" preview:         displays python help files when using omni-completion:
"                  (awesome, but results in a performance hit).
" longest:         only tab-completes up to the common elements, if any:
"                  allows you to hit tab, type to reduce options, hit tab to
"                  complete.
" --------------------------------------------------------------------------
" }}}
