" --------------------------------------------------------------------------
" Sunmap.vim - Clears naughty (and probably needless) select mode mappings:
" Source: <url: https://bugs.launchpad.net/ultisnips/+bug/427298>
" --------------------------------------------------------------------------
function! Sunmap(...)
    for k in a:000
        for b in ["", "<buffer> "]
            try
                exec "sunmap " . b . escape(k, '|')
            catch /^Vim(.*):E31:/
            endtry
        endfor
    endfor
endfunction

function! SmapShow()
    let oldA = @a
    redir @a
    silent smap
    redir END
    let result = @a
    let @a = oldA
    for line in split(result, "\n")
        let s = substitute(line, '^...\(\S\+\).*', '\1', '')
        if match(s, '^\c<plug>') == -1
            echo s
        endif
    endfor
endfunction

function! VmapShow()
    let oldA = @a
    redir @a
    silent verbose smap
    redir END
    let result = @a
    let @a = oldA
    let matched = 0
    for line in split(result, "\n")
        if matched
            let matched = 0
            echo line
        elseif match(line, '^v') != -1
            let s = substitute(line, '^...\(\S\+\).*', '\1', '')
            if match(s, '^\c<plug>') == -1
                echo s
                let matched = 1
            endif
        endif
    endfor
endfunction

function! SunmapAll()
    Sunmap %
    Sunmap ??
    Sunmap [%
    Sunmap \a(
    Sunmap \a,
    Sunmap \a<
    Sunmap \a=
    Sunmap \a?
    Sunmap \abox
    Sunmap \acom
    Sunmap \adcom
    Sunmap \adec
    Sunmap \adef
    Sunmap \aenum
    Sunmap \afnc
    Sunmap \anum
    Sunmap \aocom
    Sunmap \ascom
    Sunmap \aunum
    Sunmap \c
    Sunmap \Htd
    Sunmap \m=
    Sunmap \n
    Sunmap \p
    Sunmap \rh
    Sunmap \rv
    Sunmap \rwp
    Sunmap \swp
    Sunmap \T#
    Sunmap \t#
    Sunmap \T,
    Sunmap \t,
    Sunmap \T:
    Sunmap \t:
    Sunmap \T;
    Sunmap \t;
    Sunmap \T<
    Sunmap \t<
    Sunmap \T=
    Sunmap \t=
    Sunmap \T?
    Sunmap \t?
    Sunmap \T@
    Sunmap \t@
    Sunmap \Tab
    Sunmap \tab
    Sunmap \tml
    Sunmap \Ts,
    Sunmap \ts,
    Sunmap \ts:
    Sunmap \ts;
    Sunmap \ts<
    Sunmap \ts=
    Sunmap \Tsp
    Sunmap \tsp
    Sunmap \tsq
    Sunmap \tt
    Sunmap \T|
    Sunmap \t|
    Sunmap \T~
    Sunmap \t~
    Sunmap \w=
    Sunmap \x
    Sunmap ]%
    Sunmap a%
    Sunmap ai
    Sunmap g%
    Sunmap ii
    Sunmap ["
    Sunmap [[
    Sunmap []
    Sunmap ]"
    Sunmap ][
    Sunmap ]]
    " Modified - Chris Chambers, 1/11/2009
    Sunmap m
endfunction

command! -nargs=+ Sunmap call Sunmap(<f-args>)
command! -nargs=0 SmapShow call SmapShow()
command! -nargs=0 VmapShow call VmapShow()
command! -nargs=0 SunmapAll call SunmapAll()

SunmapAll
