if has("gui_running")
    set guioptions-=T " disables Toolbar
    set guioptions-=L " disables left-hand vertical scrollbar when vsplit
    set guioptions-=c " use console dialogues instead of popup ones
    " set guioptions-=r " disable right-hand scrollbar
    set columns=95 lines=57
    " set columns=105 lines=60
    if g:is_mac
      set guifont=Source\ Code\ Pro:h11,Andale\ Mono:h12,Consolas\ 9,Liberation\ Mono\ 8
    elseif g:is_linux
      set guifont=Droid\ Sans\ Mono\ 10
    elseif g:is_win
      set guifont=Consolas:h11:cANSI,Dina:h8:cANSI
      set columns=95 lines=48
    endif
endif
