" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin/cecscope.vim	[[[1
350
" cecscope.vim:
"  Author: Charles E. Campbell, Jr.
"  Date:   Nov 12, 2008
"  Version: 4
"  Usage:  :CS[!]  [cdefgist]
"          :CSL[!] [cdefgist]
"          :CSS[!] [cdefgist]
"          :CSH     (gives help)
"          :CSR
" =====================================================================
" Load Once: {{{1
if !has("cscope") || &cp || exists("g:loaded_cecscope")
 finish
endif
let g:loaded_cecscope= "v4"
if v:version < 702
 echohl WarningMsg
 echo "***warning*** this version of cecscope needs vim 7.2"
 echohl Normal
 finish
endif
"DechoTabOn

" =====================================================================
" Public Interface: {{{1
com!       -nargs=* CS  call s:Cscope(<bang>0,<f-args>) 
com!       -nargs=? CSH call s:CscopeHelp(<q-args>)
com! -bang -nargs=* CSL call s:Cscope(4+<bang>0,<f-args>) 
com! -bang -nargs=* CSS call s:Cscope(2+<bang>0,<f-args>) 
com!       -nargs=0 CSR call s:CscopeReset()

" =====================================================================
"  Options: {{{1
if !exists("g:cecscope_dboptions")
 let g:cecscope_dboptions=""
endif

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" Cscope: {{{2
"   Usage: :CS[ls][!]  [sgctefid]
" !: use vertical split
"
" -----
" style
" -----
"  s    (symbol)   find all references to the token under cursor
"  g    (global)   find global definition(s) of the token under cursor
"  c    (calls)    find all calls to the function name under cursor
"  t    (text)     find all instances of the text under cursor
"  e    (egrep)    egrep search for the word under cursor
"  f    (file)     open the filename under cursor
"  i    (includes) find files that include the filename under cursor
"  d    (called)   find functions that function under cursor calls
fun! s:Cscope(mode,...)
"  call Dfunc("Cscope(mode=".a:mode.") a:0=".a:0." cscopetag=".&cscopetag)
  if a:0 >= 1
   let style= a:1
"   call Decho("style=".style)
  else
   let style= "c"
  endif

  if !&cscopetag
   " use cscope and ctags for ctrl-], :ta, etc
   " check cscope for symbol definitions before using ctags
   " csto=0: cscope database searched first, then the <tags> file
"   call Decho("setting cscopetag, cscopetagorder (csto), csqf")
   set cscopetag csto=0
   if has("quickfix")
	let csqfkeep= &csqf
"    set csqf=c-,d-,e-,g-,i-,s-,t-
    set csqf=""
   endif

   if !executable("cscope")
	if has("quickfix")
	 let &csqf= csqfkeep
	endif
    echohl Error | echoerr "can't execute cscope!" | echohl None
"    call Dret("Cscope : can't execute cscope")
    return
   endif

   " add/build cscope database
   call s:CscopeAdd()

   " show message whenver any cscope database added
   set cscopeverbose
  endif

  " decide if cs/scs and vertical/horizontal
  if a:mode == 0         " CS  :  Cscope(0,...)
   let mode= "cs"       
  elseif a:mode == 1     " CS! :  Cscope(1,...)
   let mode= "vert cs"  
  elseif a:mode == 2     " CSS :  Cscope(2,...)
   let mode= "scs"
  elseif a:mode == 3     " CSS!:  Cscope(3,...)
   let mode= "vert scs"
  elseif a:mode == 4     " CSL :  Cscope(4,...)
   let mode= "silent cs"
"   call Decho("redir! > cscope.qf")
   redir! > cscope.qf
  elseif a:mode == 5     " CSL!:  Cscope(5,...)
   " restore previous efm
   if exists("b:cscope_efm")
    let &efm= b:cscope_efm
    unlet b:cscope_efm
   endif
   if has("quickfix")
    let &csqf= csqfkeep
   endif
"   call Dret("Cscope")
   return
  else
   if has("quickfix")
    let &csqf= csqfkeep
   endif
   echohl Error | echoerr "(Cscope) mode=".a:mode." not supported" | echohl None
"   call Dret("Cscope")
   return
  endif

  if a:0 == 2
   let word= a:2
  elseif style =~ '[fi]'
   let word= expand("<cfile>")
  else
   let word= fnameescape(expand("<cword>"))
  endif
"  call Decho("a:mode=".a:mode." yields mode<".mode.">  word<".word.">  style=".style)

  if style == 'f'
"   call Decho("exe ".mode." find f ".fnameescape(word))
   exe mode." find f ".word
  elseif style == 'i'
"   call Decho("exe ".mode." find i ^".fnameescape(word)."$")
   exe mode." find i ^".fnameescape(word)."$"
  else
"   call Decho("exe ".mode." find ".style." ".fnameescape(word))
   try
   	redraw!
	exe mode." find ".style." ".fnameescape(word)
   catch /^Vim\%((\a\+)\)\=:E/
	echohl WarningMsg | echomsg "***warning**** unable to find <".fnameescape(word).">" | echohl None
   endtry
  endif

  if a:mode == 4	" CSL :  Cscope(4,...)
   redir END
"   call Decho("redir END")
   if !exists("b:cscope_efm")
"	call Decho("setting up efm")
    let b:cscope_efm= &efm
    setlocal efm=%C\ \ \ \ \ \ \ \ \ \ \ \ \ %m
    setlocal efm+=%I\ %#%\\d%\\+\ %#%l\ %#%f\ %m
    setlocal efm+=%-GChoice\ number\ %.%#
    setlocal efm+=%-G%.%#line\ \ filename\ /\ context\ /\ line
    setlocal efm+=%-G%.%#Cscope\ tag:\ %.%#
    setlocal efm+=%-G
   endif
"   call Decho("case a:mode=".a:mode.": lg cscope.qf")
   lg cscope.qf
   silent! lope 5
   if has("menu") && has("gui_running") && &go =~ 'm'
"	call Decho("set up menu: restore error format :CSL!")
    exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Restore\ Error\ Format'
    exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Restore\ Error\ Format	:CSL!'."<cr>"
   endif
  endif

  if has("quickfix")
   let &csqf= csqfkeep
  endif
  if has("folding")
   silent! norm! zMzxz.
  else
   norm! z.
  endif

"  call Dret("Cscope")
endfun

" ---------------------------------------------------------------------
" s:CscopeAdd: {{{2
fun! s:CscopeAdd()
"  call Dfunc("s:CscopeAdd()")
  let s:cscopedatabase="undefined"

  " specify cscope database in current directory
  " or use whatever the CSCOPE_DB environment variable says to
  if filereadable("cscope.out")
"   call Decho("adding <cscope.out>")
   let s:cscopedatabase= "cscope.out"
   cs add cscope.out
  elseif $CSCOPE_DB != "" && filereadable($CSCOPE_DB)
"   call Decho("adding $CSCOPE_DB<".expand("$CSCOPE_DB").">")
   let s:cscopedatabase= expand("$CSCOPE_DB")
   cs add $CSCOPE_DB
  else
   let cscopeout_list= findfile('cscope.out',getcwd().';'.expand("$HOME"),-1)
   for cscopeout in cscopeout_list
"	call Decho("cs add ".cscopeout)
	exe "cs add ".cscopeout
   endfor
   if empty(cscopeout_list) && executable("cscope")
"    call Decho("using cscope ".expand("%"))
    let s:cscopedatabase= expand("%")
    call system("cscope -b ".g:cecscope_dboptions." ".s:cscopedatabase)
    cs add cscope.out
    if !filereadable("cscope.out")
     echohl WarningMsg | echoerr "(Cscope) can't find cscope database" | echohl None
    endif
   endif
  endif
"  call Dret("s:CscopeAdd : added <".s:cscopedatabase.">")
endfun

" ---------------------------------------------------------------------
" CscopeHelp: {{{2
fun! s:CscopeHelp(...)
"  call Dfunc("CscopeHelp() a:0=".a:0)
  if a:0 == 0 || a:1 == ""
   echo "CS     [cdefgist]   : cscope"
   echo "CSL[!] [cdefgist]   : locallist style (! restores efm)"
   echo "CSS[!] [cdefgist]   : split window and use cscope (!=vertical split)"
   echo "CSR                 : reset/rebuild cscope database"
   let styles="!cdefgist"
   while styles != ""
"   	call Decho("styles<".styles.">")
   	call s:CscopeHelp(strpart(styles,0,1))
	let styles= strpart(styles,1)
   endwhile
"   call Dret("CscopeHelp : all")
   return
  elseif a:1 == '!' | echo "!            split vertically"
  elseif a:1 == 'c' | echo "c (calls)    find functions    calling  function under cursor"
  elseif a:1 == 'd' | echo "d (called)   find function(s) called by function under cursor"
  elseif a:1 == 'e' | echo "e (egrep)    egrep search for the word under cursor"
  elseif a:1 == 'f' | echo "f (file)     open the file named under cursor"
  elseif a:1 == 'g' | echo "g (global)   find global definition(s) of word under cursor"
  elseif a:1 == 'i' | echo "i (includes) find files that #include file named under cursor"
  elseif a:1 == 's' | echo "s (symbol)   find all references to the word under cursor"
  elseif a:1 == 't' | echo "t (text)     find all instances  of the word under cursor"
  else              | echo a:1." not supported"
  endif

"  call Dret("CscopeHelp : on <".a:1.">")
endfun

" ---------------------------------------------------------------------
" CscopeMenu: {{{2
fun! CscopeMenu(type)
"  call Dfunc("CscopeMenu(type=".a:type.")")
  if !exists("g:DrChipTopLvlMenu")
   let g:DrChipTopLvlMenu= "DrChip."
  endif
  if !exists("s:installed_menus")
   exe "menu ".g:DrChipTopLvlMenu."Cscope.Help	:CSH\<cr>"
  endif
  if exists("s:installed_menus")
"   silent! unmenu DrChipCscope
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Use\ Messages\ Display'
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Use\ Horiz\ Split\ Display'
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Use\ Vert\ Split\ Display'
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Use\ Quickfix\ Display'
  endif
  if a:type == 1
   let cmd= "CS"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Quickfix\ Display	:call CscopeMenu(2)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Horiz\ Split\ Display 	:call CscopeMenu(3)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Vert\ Split\ Display	:call CscopeMenu(4)'."<cr>"
  elseif a:type == 2
   let cmd= 'CSL'
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Messages\ Display	:call CscopeMenu(1)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Horiz\ Split\ Display	:call CscopeMenu(3)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Vert\ Split\ Display	:call CscopeMenu(4)'."<cr>"
  elseif a:type == 3
   let cmd= 'CSS'
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Messages\ Display	:call CscopeMenu(1)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Quickfix\ Display	:call CscopeMenu(2)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Vert\ Split\ Display	:call CscopeMenu(4)'."<cr>"
  elseif a:type == 4
   let cmd= 'CSS!'
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Messages\ Display	:call CscopeMenu(1)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Quickfix\ Display	:call CscopeMenu(2)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Horiz\ Split\ Display	:call CscopeMenu(3)'."<cr>"
  endif

  if exists("s:installed_menus")
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ functions\ which\ call\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ functions\ called\ by\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Egrep\ search\ for\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Open\ file\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ globally\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ files\ that\ include\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ all\ references\ to\ symbol\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ all\ instances\ of\ text\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Reset'
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Restore\ Error\ Format'
  endif

  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ functions\ which\ call\ word\ under\ cursor<tab>:'.cmd.'\ c	:'.cmd.'\ c'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ functions\ called\ by\ word\ under\ cursor<tab>:'.cmd.'\ d	:'.cmd.'\ d'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Egrep\ search\ for\ word\ under\ cursor<tab>:'.cmd.'\ e	:'.cmd.'\ e'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Open\ file\ under\ cursor<tab>:'.cmd.'\ f	:'.cmd.'\ f'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ globally\ word\ under\ cursor<tab>:'.cmd.'\ g	:'.cmd.'\ g'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ files\ that\ include\ word\ under\ cursor<tab>:'.cmd.'\ i	:'.cmd.'\ i'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ all\ references\ to\ symbol\ under\ cursor<tab>:'.cmd.'\ s	:'.cmd.'\ s'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ all\ instances\ of\ text\ under\ cursor<tab>:'.cmd.'\ t	:'.cmd.'\ t'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Reset<tab>:CSr	:CSr'."<cr>"
  if exists("b:cscope_efm")
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Restore\ Error\ Format	:CSL!'."<cr>"
  endif

  let s:installed_menus= 1
"  call Dret("CscopeMenu")
endfun

" ---------------------------------------------------------------------
" CscopeReset: {{{2
fun! s:CscopeReset()
"  call Dfunc("CscopeReset()")
  if has("win32") || has("win95") || has("win64") || has("win16")
   if &shell =~ '\%(\<bash\>\|\<zsh\>\)\%(\.exe\)\=$'
	" cygwin or similar shell being used under windows
	call system("cscope -b ".g:cecscope_dboptions." *.[ch]")
   else
	call system("cscope -b ".g:cecscope_dboptions." *.c *.h")
   endif
  else
   " linux/unix/macos/...
   call system("cscope -b ".g:cecscope_dboptions." *.[ch]")
  endif
  cscope reset
"  call Dret("CscopeReset")
endfun

" =====================================================================
"  Install Menus: {{{1
if !exists("s:installed_menus") && has("menu") && has("gui_running") && &go =~ 'm'
 call CscopeMenu(1)
endif

" =====================================================================
" Modelines: {{{1
" vim: fdm=marker
doc/cecscope.txt	[[[1
167
*cecscope.txt*	Charles E Campblell's Cscope Plugin		Nov 12, 2008

Author:  Charles E. Campbell, Jr.  <NdrOchip@ScampbellPfamily.AbizM>
	 (remove NOSPAM from Campbell's email first)
Copyright: (c) 2004-2008 by Charles E. Campbell, Jr.	*cecscope-copyright*
           The VIM LICENSE applies to cecscope.vim and cecscope.txt
           (see |copyright|) except use "cecscope" instead of "Vim".
	   No warranty, express or implied.  Use At-Your-Own-Risk.
Note:    Required:
         * your :version of vim must have +cscope
         * vim 7.0aa snapshot#188 or later for the "quickfix" display

==============================================================================
1. Contents						*cecscope-contents*

  1. Contents............................: |cecscope-contents|
  2. Installing cecscope.................: |cecscope-install|
  3. Cescope Manual......................: |cecscope-manual|
  3. Cescope Tutorial....................: |cecscope-tutorial|
  5. Cescope History.....................: |cecscope-history|
   	

==============================================================================
2. Installing cecscope					*cecscope-install*

    1. vim cecscope.vba.gz
    2. :so %
    3. :q

    Cecscope now requires vim 7.2 or later; it uses the fnameescape() function
    to avoid certain security problems.  It is possible to use "carefully
    crafted filenames" to cause vim to execute arbitrary commands otherwise.
    Admittedly, most such filenames are obviously bad apples.

    Using vim 7.2 also means that your vimball plugin is reasonably
    up-to-date, which is used by the install process.

==============================================================================
3. Cescope Manual				*cecscope-manual*
						*:CS* *:CSL* *:CSS* *:CSH*
    :CS     [cdefgist]   : cscope command handler
    :CSL[!] [cdefgist]   : locallist style (! restores efm)
    :CSS[!] [cdefgist]   : split window and use cscope
    :CSH                 : give quick help
    :CSR                 : cscope reset

    !            split vertically
    c (calls)    find functions calling function under cursor
    d (called)   find functions called by function under cursor
    e (egrep)    egrep search for the word under cursor
    f (file)     open the file named under cursor
    g (global)   find global definition(s) of word under cursor
    i (includes) find files that #include file named under cursor
    s (symbol)   find all references to the word under cursor
    t (text)     find all instances of the word under cursor

    A simple >
        :CS
<   will initialize cscope, building its database if necessary.  What
    :CS will do: >

        if cscope.out exists in the current directory, cs add it.
        if $CSCOPE_DB (an environment variable) exists and the
           file it references exists, cs add it.
        if cscope.out exists in any directory from the current
           directory or in any parent directory up to but not
           including the $HOME directory, cs add it.
        if cscope is executable, apply cscope -b to the current file.
<
    Thus :CS will search for and attempt to use a cscope database,
    building one if necessary.

    In addition, when using gvim, there is a menu interface under the
    "DrChip" label with all of the above options mentioned.  The first
    four items are taken from:

        Help
        Use Messages Display
        Use Horiz Split Display
        Use Vert Split Display
        Use Quickfix Display

    The "Use" method that's currently active will not be present (initially,
    that's the "Use Messages Display").

    *g:cecscope_dboptions*
    For special options to be passed to cscope for database building, set
    g:cecscope_dboptions to the desired string.  For example, to use all
    source files in a so-called namefile: >
        let g:cecscope_dboptions= "-inamefile"
<   One must explicitly list *.cpp, *.c++, and *.C files, for example, in
    such a file.


==============================================================================
4. Cescope Tutorial					*cecscope-tutorial*

   GETTING STARTED
    To use this plugin you'll need to have vim 7.0aa, snapshot#188 or later,
    and your version should have +cscope.  To check that latter condition,
    either look for +cscope through the output of >
        :version
<   or type >
        :echo has("cscope")
<   You'll need to recompile your vim if you don't have +cscope.

    BUILDING CSCOPE DATABASE
    Once you have your cscope-enabled vim, then change directory to wherever
    you have some C code.  Type >
        cscope -b *.[ch]
<   and the cscope database will be generated (<cscope.out>).  If you don't
    have a cscope database, the file specified by the environment variable
    named >
        $CSCOPE_DB
<   will be used.  Sadly, otherwise cecscope.vim will issue a warning message.

    SELECTING A DISPLAY MODE

    Assuming you're using gvim: Select >
        DrChip:Cscope:Use Quickfix Display
<   This will make the information from cscope show up in a local quickfix
    window (see |:lopen|).  The other modes allow one to see cscope messages
    as regular messages (which will shortly disappear) or in another window.

    USING THE QUICKFIX DISPLAY
    Place your cursor atop some function that you've written: >
        DrChip:Cscope:Find function which calls word under cursor
<   and you'll see a locallist window open up which tells you something like >
        xgrep.c|410 info| <<sprt>> Edbg(("xgrep(%s)",sprt(filename)));
<   To jump to that entry, type >
        :ll
<   To jump to the next entry, type >
        :lne
<   To jump to the previous entry, type >
        :lp
<   You can also switch windows (ex. <ctrl-w>j, see |window-move-cursor|)
    to the locallist window, move the cursor about normally, then hit the
    <cr> to jump to the selection.

    USING THE COMMAND LINE
    You could've done the above using the command line!  Again, just
    place your cursor atop some function that you've written, then type: >
        :CSL c
<   You may use the :ll, :lne, and :lp commands as before.

    HELP
    Just type >
        :CSH
<   for a quick help display.  Of course, you can always type : >
        :help CS
<   too.


==============================================================================
5. Cescope History					*cecscope-history*

   v4 Nov 12, 2008 * csqf kept if has("quickfix") is true
                   * vim 7.2 required, and warning message is issued if
                     vim isn't 7.2 (or later)
                   * fnameescape() used for security purposes (thus vim 7.2)
                   * help menu fixed
   v3 Oct 12, 2006 : removed "silent" from cscope calls; it prevented the
                     selector from appearing.
   v1 Jan 30, 2006 : initial release

=====================================================================
vim:tw=78:ts=8:ft=help:sts=4:et:ai
