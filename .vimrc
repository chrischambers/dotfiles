" Variables To Customise:
" --------------------------------------------------------------------------

" <url:vimhelp:feature-list>
if has('win32')
    let g:vimfiles_path = '$HOME/vimfiles'
    let g:vimrc_path    = '$HOME/_vimrc'
else
    let g:vimfiles_path = '$HOME/.vim'
    let g:vimrc_path    = '$HOME/.vimrc'
endif

let g:user_name  = "Chris Chambers"
let g:user_email = "magma.chambers@gmail.com"
let s:dictionary_location="/usr/lib/openoffice/share/dict/ooo/en-GB.dic"
"let s:thesaurus_location=/usr/lib/openoffice/share/dict/ooo/th_en_US_v2.idx
let s:thesaurus_location="$HOME/moby_thesaurus_list-2002-05-01_etxt-3202.txt"
let s:django_location="$HOME/src/py/django/django-1.1"
let s:baseline_vim_path=""
let g:pythonpath_fixtures= [ g:vimfiles_path . '/python',
              \              g:vimfiles_path . '/after/ftplugin/python/' ]

" PythonPath Initialisation: {{{
" --------------------------------------------------------------------------
" Note: ropevim requires ropemode, ropevim and rope in the python path,
" pyflakes.vim requires .vim/after/ftplugin/python.
call map(g:pythonpath_fixtures, 'glob(v:val)')

function! UpdatePythonPathWithFixtures()
    """ Takes a list of absolute filenames, and appends them to the
    """ pythonpath.

python << EOF
import vim, sys, os
fixture_list = vim.eval('g:pythonpath_fixtures')
sys.path.extend(fixture_list)
EOF
endfunc
" --------------------------------------------------------------------------
" }}}

" Ref for file finding: {{{
" The "**" item can be used to search in a directory tree.
" For example, to find all "README.txt" files in the directories
" in 'runtimepath' and below: >
"     :echo globpath(&rtp, "**/README.txt")
" Upwards search and limiting the depth of "**" is not
" supported, thus using 'path' will not always work properly.


" py import vim; vim.command("let g:vimrc2 = '%s'" % (vim.eval('getreg("%")'),))
" STORES None
" let g:vimrc = getcwd() . getreg('%')
" STORED as home location
" echo g:vimrc
" }}}

" README: {{{
" --------------------------------------------------------------------------
" To make use of the virtualenv sys-path detection functionality, you should
" either:
" 1) Force easy_install not to use .egg files, especially for modules rather
" than packages (but probably for packages too), or...
" 2) Avoid using easy_install, and opt to use pip instead.

" The reason for this is that vim doesn't know how to look for, say, pytz in
" the following directory (assuming your environment's site-packages is part
" of vim's &path setting, which it should /always/ be using the SetupVirtualEnv
" functionality):

" [...]/lib/site-packages/pytz-2009j-py2.5.egg

" It /DOES/, however, know how to look in the following directory:

" [...]/lib/site-packages/pytz

" DEPENDENCIES:
" FuzzyFinderTextmate requires that your vim be compiled with ruby.
" ... a LOT of this stuff depends on your vim being compiled with python.
" --------------------------------------------------------------------------
" }}}

" Alpha Settings: {{{
" i.e. settings which should come first:
" --------------------------------------------------------------------------
set nocompatible                    " Force this at the start of the file
                                    " (changes subsequent options)
let mapleader = ','                 " Only affects subsequent <leader> commands
let g:loaded_AlignMapsPlugin = 1    " Don't load align mappings
call UpdatePythonPathWithFixtures() " initialise with required pythonpath
                                    " fixtures
" --------------------------------------------------------------------------
" }}}

" Backups: {{{
" --------------------------------------------------------------------------
" let s:backup_dir="~/.backup"
" set backupdir=s:backup_dir
" if ! len(glob(s:backup_dir))
"   echomsg "Backup directory ~/.backup doesn't exist!"
" endif
" set writebackup          " Make a backup of the original file when writing
" set backup               " and don't delete it after a succesful write.
" set backupskip=          " There are no files that shouldn't be backed up.
" set backupdir^=~/.backup " Backups are written to ~/.backup/ if possible.
" set directory^=~/.backup " Swap files are also written to ~/.backup, too.
" set updatetime=2000      " Write swap files after 2 seconds of inactivity.
" set backupext=~          " Backup for "file" is "file~"
" --------------------------------------------------------------------------
" }}}

" Basic Options: {{{
" --------------------------------------------------------------------------
" File-type highlighting and configuration.
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
" NOTE: These define autocmds, so they should come before any other autocmds.
" That way, a later autocmd can override the result of one defined here.
syntax on              " enable per-filetype syntax highlighting
filetype on            " enable filetype detection
filetype plugin on     " enable filetype specific plugins
filetype indent on     " enable filetype-specific indenting where available,

set background=dark
colorscheme ir_black   " slightly tweaked to fit, but totally awesome.
" alternatives include - eclipse, xoria256

set backspace=indent,eol,start " Intuitive backspacing in insert mode
set nu            " line numbering
set nocul         " disable cursor-line highlighting
set nowrap        " prevent lines from wrapping automatically

set softtabstop=4 " no. spaces that <Tab> counts for
set shiftwidth=4  " no. spaces used for auto-indent, <<, >>, etc.
set shiftround    " Rounds indent to multiple of shiftwidth
set expandtab     " replaces \t characters with spaces
set autoindent    " copy indent from current line when starting new line
                  " also try set smartindent

    " Note: why no smart-indent? {{{
    " smartindent messes python comments up, because it’s meant for C-like
    " languages and assumes ‘#’ is the beginning of a preprocesser
    " instruction. smartindent is really only meant to be used if you don’t
    " have a smart indentation file around, and with indent/python.vim you do!
    "
    " It really isn’t adding anything you need either, it just does some
    " not-quite pythonic indentation around ‘{’ and ‘}’, and indentation after
    " C keywords like ’switch’ or ‘do’, all of which is getting overridden by
    " the python indent file.
    "
    " So just don’t use smartindent on python files. Change the last line of
    " python_pep8.vim to be “setlocal nosmartindent” and your indentation
    " should still be just as automatic and pretty much exactly the same, just
    " without messed up comment indentation.
    "
    " source: <url:http://www.cmdln.org/2008/10/18/vim-customization-for-python/>
    " }}}

set showcmd       " Show (partial) command in status line.
set showmatch     " Show matching brackets...
set matchtime=2   " for only .2 seconds.
set autowrite     " Automatically save before commands like :next and :make
set hidden        " Allows you to switch to different buffers without
                  " having to save changes.
                  " * The current buffer can be put to the background without
                  "   writing to disk;
                  " * When a background buffer becomes current again, marks
                  "   and undo-history are remembered.
set history=200   " Command history length.
set laststatus=2  " always include status line, even if only one window

" from godlygeek:
set virtualedit=block " Let cursor move past the last char in <C-v> mode
set showfulltag       " Show more information while completing tags.
set previewheight=7   " Max height for preview window

" Basic Mappings: {{{
" Edit .vimrc easily!
nnoremap <Home> :e $MYVIMRC<CR>

" Y behaves like D rather than like dd
nnoremap Y y$

" <C-l> redraws the screen and removes any search highlighting.
" guifont is a bugfix to make an invisible cursor reappear.
nnoremap <silent> <leader><C-l> :let &guifont=&guifont<CR> :nohl<CR><C-l>
" }}}

" Use tag-jump menu rather than guessing most likely tag:
" cabbr ta tj
"
" Source: <url:http://github.com/sjbach/env/blob/master/dotfiles/vimrc>
" Vi-style editing in the command-line
" nnoremap : q:a
" nnoremap / q/a
" nnoremap ? q?a

" --------------------------------------------------------------------------
" Search:
" --------------------------------------------------------------------------
set hlsearch      " Highlight searches by default.
set incsearch     " Incrementally search while typing a /regex
set ignorecase    " Default to using case insensitive searches...
set smartcase     " unless uppercase letters are used in the regex.
" These two options, when set together, will make /-style searches
" case-sensitive only if there is a capital letter in the search expression.

" The following command sets the regex mode for searching to 'very magic',
" which acts like Extended Regular Expressions (TRIAL):
nnoremap / /\v
" Note that you still have to use the *v*ery magic slash before substitution
" patterns - e.g:
" :%s/\v(These parentheses now capture)|Unescaped bar alternates{2,3}/Foo/g
" --------------------------------------------------------------------------
" }}}

" GUI Specific Options: {{{
" --------------------------------------------------------------------------
" To see current size of gvim gui:
" echo &columns &lines
if has("gui_running")
    set guioptions-=T " disables Toolbar
    set guioptions-=L " disables left-hand vertical scrollbar when vsplit
    set columns=95
    set lines=57
    " set columns=105 lines=60
    if has('unix') || has('macunix')
      set guifont=Andale\ Mono:h12,Consolas\ 9,Liberation\ Mono\ 8
    elseif has('win32')
      set guifont=Dina:h8:cANSI,Consolas:h9:cANSI
    endif
endif
" --------------------------------------------------------------------------
" }}}

" British English Spelling: {{{
" --------------------------------------------------------------------------
set spell
setlocal spell spelllang=en_gb
nnoremap <silent> <leader>sp :exe (&spell ? ":set nospell" : ":set spell")<CR>
" --------------------------------------------------------------------------
" }}}

" Bash Like Filename Completion: {{{
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
set wildignore+=*.pyc,*.zip,*.gz,*.bz,*.tar,*.jpg,*.png,*.gif,*.avi,*.wmv,*.ogg,*.mp3,*.mov

" set complete=.,w,b,u,t,i
set completeopt=menu,preview,longest
" preview:         displays python help files when using omni-completion:
"                  (awesome, but induces a performance hit).
" longest:         only tab-completes up to the common elements, if any:
"                  allows you to hit tab, type to reduce options, hit tab to
"                  complete.
" }}}

" Folding: {{{
" --------------------------------------------------------------------------
" Example - python:
" # name for the folded text {{{
" to begin marker and
" # }}}
" to end it.
" --------------------------------------------------------------------------
" set foldmethod=syntax " By default, use syntax to determine folds
" set foldlevelstart=99 " All folds open by default
set foldmethod=marker
" --------------------------------------------------------------------------
" }}}

" Completion: Dictionary And Thesaurus: {{{
" --------------------------------------------------------------------------
exec 'set dictionary=' . s:dictionary_location
exec 'set thesaurus=' . s:thesaurus_location
" --------------------------------------------------------------------------
" }}}

" Completion: Omni-Completion: {{{
" --------------------------------------------------------------------------
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType python set omnifunc=pythoncomplete#Complete

if has("python")
function! FixVimPythonSysModule()
  """ Certain modules which rely on sys.real_prefix to exist will raise
  """ AttributeErrors on import, and subsequently fail to be imported
  """ correctly. Likewise, pythoncomplete won't work correctly when
  """ it fails to import a module for whatever reason. This function
  """ monkey-patches the sys module to make sure it has a useful 
  """ 'real_prefix' attribute.
python << EOL
import os, sys
from distutils.sysconfig import get_python_lib
if not hasattr(sys, 'real_prefix'):
    sys.real_prefix = os.path.dirname(get_python_lib())
EOL
endfunction
  call FixVimPythonSysModule()
endif
" --------------------------------------------------------------------------
" }}}

" Command Line Mode: {{{
" --------------------------------------------------------------------------
    set cmdheight=2 " Sets command-line height
" --------------------------------------------------------------------------
    " Emacs Mappings At Command Line: {{{
    " For Emacs-style editing on the command-line: <url:vimhelp:emacs-keys>
        " start of line
        :cnoremap <C-A>        <Home>
        " back one character
        :cnoremap <C-B>        <Left>
        " delete character under cursor
        :cnoremap <C-D>        <Del>
        " end of line
        :cnoremap <C-E>        <End>
        " forward one character
        :cnoremap <C-F>        <Right>
        " recall newer command-line
        :cnoremap <C-N>        <Down>
        " recall previous (older) command-line
        :cnoremap <C-P>        <Up>
        " back one word
        :cnoremap <Esc><C-B>    <S-Left>
        " forward one word
        :cnoremap <Esc><C-F>    <S-Right>
        " kill line
        :cnoremap <C-K>    <C-U>
    " }}}
" --------------------------------------------------------------------------
" }}}

" Setting Useful Status Line: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.linux.com/archive/feature/120126>
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L] 
set statusline=%<[%02n]\ %F%(\ %m%h%w%y%r%)\ %a%=\ %8l,%c%V/%L\ (%P)
" --------------------------------------------------------------------------
" }}}

" Set Grep Program To Ack: {{{
" --------------------------------------------------------------------------
" Note: ack will need to be on your path, and on certain systems (e.g. *Buntu,
" perhaps other Linux distros) you'll need to alias ack-grep to ack.
" Source: <url:http://weblog.jamisbuck.org/2008/11/17/vim-follow-up>
" --------------------------------------------------------------------------
set grepprg=ack
set grepformat=%f:%l:%m
" --------------------------------------------------------------------------
" }}}

" Show Filetypes In Syntax Menu: {{{
" --------------------------------------------------------------------------
" See: <url:vimhelp:menu.vim>
if has("gui_running")
  let do_syntax_sel_menu=1
  runtime! synmenu.vim
  aunmenu &Syntax.&Show\ filetypes\ in\ menu
endif
" --------------------------------------------------------------------------
" }}}

" Plugin Configuration:
""" Used:
" Pyflakes Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://vim.sourceforge.net/scripts/script.php?script_id=2441>
" --------------------------------------------------------------------------
if has("gui_running")
  highlight SpellBad term=underline gui=undercurl guisp=Orange
  " highlight SpellBad term=reverse ctermbg=12 gui=undercurl guisp=Orange
endif
" --------------------------------------------------------------------------
" }}}

" NERDTree Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=1658>
" --------------------------------------------------------------------------
" Toggle the following off with 'f'!
let NERDTreeIgnore=['\.pyc$', '\~$', '^#.*#$', '\.swp']
let NERDTreeChDirMode=2 " Tree root ALWAYS equal to CWD
let NERDChristmasTree=1 " Extra-colourful Tree
let NERDTreeMouseMode=2 " If you do use the mouse, this is probably what you want.

function! NERDToggle()
  if !exists('s:gui_active')
    let s:gui_active = has('gui_running')
  endif
  if !s:gui_active
    NERDTreeToggle
    return
  endif

  let l:visible_buffers = map(tabpagebuflist(), 'bufname(v:val)')
  call filter(l:visible_buffers, 'v:val =~# "NERD_tree"')
  if !empty(l:visible_buffers)
  " if count(l:visible_buffers, 'NERD_tree_1')
    NERDTreeToggle
    exec 'set columns-=' . g:NERDTreeWinSize
  else
    NERDTreeToggle
    exec 'set columns+=' . g:NERDTreeWinSize
  endif
endfunction
" nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>d :call NERDToggle()<CR>
" Note the trailing space after each of the following commands:
map <leader><S-d> :NERDTreeFromBookmark 
"
" --------------------------------------------------------------------------
" Python Project Specific:
" We're really not interested in these binary files for the most part:
let NERDTreeIgnore=['\.py\(c\|o\)$', '\.swp', '\~$', '^#.*#$', '\.gif', '\.jpg','\.png','\.jpeg','\.ico', '\.psd', '\.flv', '\.swf', '\.pdf', '\.doc']
" python files will take precedence over .csv, .log, .txt, etc.
let NERDTreeSortOrder=['\/$', '\.py', '*', '\.swp$',  '\.bak$', '\~$']
" --------------------------------------------------------------------------
" }}}

" Ultisnips Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=2715>
" --------------------------------------------------------------------------
set runtimepath+=~/src/vim/ultisnips
" Mnemonic - "source snippets"
nnoremap <leader>ss :py UltiSnips_Manager.reset()<CR>
autocmd BufRead *.snippets setl ft=conf
" --------------------------------------------------------------------------
" }}}

" Trac Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=2147>
" --------------------------------------------------------------------------
let s:TRAC_FILE = '~/.vimrc_trac'
if filereadable(s:TRAC_FILE)
    source s:TRAC_FILE
endif
" --------------------------------------------------------------------------
" }}}

" ShowMarks Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=152>
" --------------------------------------------------------------------------
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let g:showmarks_enable = 1
" For marks a-z
highlight ShowMarksHLl gui=bold guibg=LightBlue guifg=Blue
" For marks A-Z
highlight ShowMarksHLu gui=bold guibg=LightRed guifg=DarkRed
" For all other marks
highlight ShowMarksHLo gui=bold guibg=LightYellow guifg=DarkYellow
" For multiple marks on the same line.
highlight ShowMarksHLm gui=bold guibg=LightGreen guifg=DarkGreen

" Ultisnips Fix: {{{
" --------------------------------------------------------------------------
" Showmarks assigns a select mapping to the 'm' key, which causes
" over-typing selected text to raise an "E481: No range allowed" error.
" This is easily averted (when you know the cause!) via sunmap:
" Source: <url:https://bugs.launchpad.net/ultisnips/+bug/427298>
" Fixed via the 'sunmap m' /after/plugin/sunmap.vim
" --------------------------------------------------------------------------
" }}}
" --------------------------------------------------------------------------
" }}}

" SuperTab Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=182>
" --------------------------------------------------------------------------
" let g:SuperTabDefaultCompletionType='context'
" let g:SuperTabLongestHighlight = 1
" let g:SuperTabMidWordCompletion=0
let g:SuperTabDefaultCompletionType="context"
"if you specify a certain type of completion, e.g. <c-x><c-l>, it will persist
" only for that completion, and not until you toggle out of insert mode.
let g:SuperTabRetainCompletionDuration="completion"
" May have to choose alternative (miniBufExplr conflict):
" let g:SuperTabMappingTabLiteral = '<c-tab>'
let g:SuperTabLongestHighlight = 1
"pre-highlights first match in completion menu.
" --------------------------------------------------------------------------
" }}}

" UTL Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=293>
" To configure, visit: <url:config:#r=map_http>.
" --------------------------------------------------------------------------
" let g:utl_cfg_hdl_scm_http_system = "!firefox '%u#%f' &"
" FIXME: UTL currently either ignores fragments, or fails when urls with no
" fragment are used:
if has("mac")
    " This version play nicely with url fragments, but borks on urls without
    " specified fragments:
    " let g:utl_cfg_hdl_scm_http_system = "silent !open -a Firefox '%u#%f'"
    " This version completely disregards url fragments:
    let g:utl_cfg_hdl_scm_http_system = "silent !open -a Firefox '%u'"
endif
" This version doesn't work at all:
" let g:utl_cfg_hdl_scm_http_system = "silent !firefox -remote 'ping()' && firefox -remote 'openURL( %u )' || firefox '%u#%f' &"
" --------------------------------------------------------------------------
" }}}

" UTL Mappings: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=293>
" --------------------------------------------------------------------------
" NOTE: this clobbers `go-to-<count>-byte` command
nnoremap <leader>go :Utl<CR>
" --------------------------------------------------------------------------
" }}}

" GetLatestVimScripts Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=642>
" Requires wget:
" Debian: sudo apt-get install wget (though it's likely installed)
" Mac: sudo port install wget
" --------------------------------------------------------------------------
let g:GetLatestVimScripts_allowautoinstall=1
" --------------------------------------------------------------------------
" }}}

" BufOnly Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=1071>
" --------------------------------------------------------------------------
nmap <silent> <leader>bo :BufOnly<CR>
" --------------------------------------------------------------------------
" }}}

" MiniBufExpl Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=159>
" --------------------------------------------------------------------------
" minibufexpl.vim - Extracted all useful settings, 24-10-2009
" C-j,k,l,m do as you would expect:
let g:miniBufExplMapWindowNavVim = 1
" Ctrl and arrow keys also do as you would expect:
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
" For mousing (not that we ever do, truth be told):
let g:miniBufExplUseSingleClick = 1
" Try and avoid placing buffer contents into non-modifiable buffers, like
" NERDTree!
let g:miniBufExplModSelTarget = 1
" Maximum MBE window size:
" let g:miniBufExplMaxSize = 1
" Causes the MBE window to be only be loaded if 2 buffers are open:
" (0 for always active, other numbers correspond to amount of buffers required
" before minibufexpl is displayed)
let g:miniBufExplorerMoreThanOne=2
" Attempts to override bug where syntax highlighting is disabled:
" let g:miniBufExplForceSyntaxEnable = 1
" Note: screws up MBE and NERDtree highlighting!
" --------------------------------------------------------------------------
" }}}

" Align Mappings: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=294>
" --------------------------------------------------------------------------
" There are three families of commands for defining mappings related to visual
" and select modes:
"
" :smap select mode only
" :xmap visual mode only
" :vmap both visual and select modes
"
" It's unfortunate that :vmap doesn't mean visual-only. I believe this
" naming imprecision is the root cause for plugins that define select-mode
" mappings.
" Source: <url:https://bugs.launchpad.net/ultisnips/+bug/427298/comments/2>

xmap <leader>a{ :Align'[^']\+':<CR>
" --------------------------------------------------------------------------
" }}}

" FuzzyFinder Mappings: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=1984>
" --------------------------------------------------------------------------
nnoremap <leader>, :FuzzyFinderBuffer<CR>
"nmap <leader>f :FuzzyFinderFile<CR>
nnoremap <leader><S-f> :FuzzyFinderTextMate<CR>
nnoremap <leader>f :FuzzyFinderTaggedFile<CR>
nnoremap <leader>ta :FuzzyFinderTag<CR>

" Remap :ta[g] to use fuzzytagfinding. Leave :tj alone though, as that will
" complete faster if you know the exact tag name / for large tag files:
cnoremap <expr> ta<space> (getcmdtype() == ':' ? 'FuzzyFinderTag<CR>' : 'tj')
" --------------------------------------------------------------------------
" }}}

" FuzzyFinder Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=1984>
" --------------------------------------------------------------------------
let g:fuzzy_ignore="*.pyc,*.pyo,*~,#*#,*.gif,*.jpg,*.JPG,*.png,*.PNG,*.jpeg,*.JPEG,*.ico,*.psd,*.flv,*.swf,*.pdf,*.doc,*.db,*.jar"
" --------------------------------------------------------------------------
" }}}

" AutoTag Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=1343>
" --------------------------------------------------------------------------
" let g:autotagCtagsCmd="ctags --links=no --exclude='rosetta/' --python-kinds=-i --regex-Python='/\s*([_A-Z][A-Z_1-9]+)\s*=/\1/' -R"
" let g:autotagCtagsCmd="ctags --regex-Python='/\s*([_A-Z][A-Z_1-9]+)\s*=/\1/'"
let g:autotagCtagsCmd="ctags -a --sort=foldcase --links=no --exclude='rosetta/' --python-kinds=-i --regex-Python='/\s*([_A-Z][A-Z_1-9]+)\s*=/\1/' -R"
" --------------------------------------------------------------------------
" }}}

" Pydoc Autocommands: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=1112>
" --------------------------------------------------------------------------
autocmd FileType python nnoremap <silent> <buffer> K :call <SID>:KeyPydocLoad(expand("<cWORD>"))<Cr>
" --------------------------------------------------------------------------
" }}}

" TVO Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=517>
" --------------------------------------------------------------------------
let otl_bold_headers=0
let maplocalleader = ","
" au BufWinLeave *.otl mkview
" au BufWinEnter *.otl silent loadview

augroup otl_setup
""" Do not display hidden characters (like tabs)
au!
autocmd FileType otl setl nolist
augroup END

" Highlighting overrides
hi otlTab0 gui=bold, guifg=#E18964
hi otlTab1 gui=bold, guifg=#96CBFE
hi otlTab2 gui=bold, guifg=#A8FF60
hi otlTab3 gui=bold, guifg=#FFFFB6
hi otlTab4 gui=bold, guifg=#FFD2A7
hi otlTextLeader guifg=gray20
" --------------------------------------------------------------------------
" }}}

""" Disabled:
" ScrollColors Mappings: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=1488>
" --------------------------------------------------------------------------
" map <silent><leader>n :NEXTCOLOR<cr>
" map <silent><leader>p :PREVCOLOR<cr> 
" --------------------------------------------------------------------------
" }}}

" CSApprox Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=2390>
" --------------------------------------------------------------------------
" Note: Definitely do not set this - causes flashing in terminals that do not
" actually support 256 colours!
" set t_Co=256        " Sets terminal colors to 256
" --------------------------------------------------------------------------
" }}}

""" Unused:
" Pylint Options: {{{
" --------------------------------------------------------------------------
" Source: <url:http://vim.sourceforge.net/scripts/script.php?script_id=891>
" --------------------------------------------------------------------------
" set path+=$HOME/.virtualenvs/langlab/bin - this doesn't do anything
" autocmd FileType python compiler pylint
" --------------------------------------------------------------------------
"}}}

" Useful Functions:

" Function: Highlight Overlength Lines: {{{
" --------------------------------------------------------------------------
" Provides subtle red-highlighting for lines with a length that exceeds 80
" characters.
" Source: <url:http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns>
" --------------------------------------------------------------------------
if has("autocmd")
  augroup highlight
  au!
  fun! Highlight_overlength()
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%81v.*/
  endfun
  autocmd BufRead * call Highlight_overlength()
  augroup END
endif
" --------------------------------------------------------------------------
" }}}

" Function: Automatically Trim Trailing Spaces: {{{
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

" Function: Pretty Print XML: {{{
" --------------------------------------------------------------------------
function! DoPrettyXML()
  1,$!xmllint --format --recover -
endfunction
command! PrettyXML call DoPrettyXML()
" --------------------------------------------------------------------------
" }}}

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

" Resume Last Editing Spot When Reading File: {{{
" --------------------------------------------------------------------------
if has("autocmd")
  " Try to jump to the last spot the cursor was at in a file when reading it.
  au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal g`\"" |
      \ endif
endif
" --------------------------------------------------------------------------
" }}}

" Function: Use Visual Range As Search Pattern: {{{
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

" Function: Pipe Output of Command Into New Tab: {{{
" --------------------------------------------------------------------------
" Function that pipes the output of a command into a new tab (Vim 7.0):
" Example Usage:
" :call PipeToTab('py import sys; from pprint import pprint; pprint(sys.path)')
" (Note that the argument must be a string - recommended single quotes, for
" better escaping.)
" --------------------------------------------------------------------------
function! PipeToTab(cmd)
 redir => message
 silent execute a:cmd
 redir END
 tabnew
 silent put=message
 set nomodified
endfunction
command! -nargs=+ -complete=command PipeToTab call PipeToTab(<q-args>)
" --------------------------------------------------------------------------
" }}}

" Close Buffers Without Closing Windows: VimTip165: {{{
" --------------------------------------------------------------------------
" Depends on $VIM/plugin/bclose.vim, Vim Tip 165
" Source: <url:http://vim.wikia.com/wiki/VimTip165>
" Mapping taken from Gary Bernhardt's .vimrc -
" Source: <url:http://bitbucket.org/garybernhardt/dotfiles/src/>
" GRB: use fancy buffer closing that doesn't close the split
cnoremap <expr> bd (getcmdtype() == ':' ? 'Bclose' : 'bd')
" --------------------------------------------------------------------------
" }}}

" Superuser Write To File: (Unix/OSX only): {{{
" :W writes to files which require superuser access to modify.
if has('unix') " includes OSX
  command! W w !sudo tee % > /dev/null
endif
" }}}

" Underline Current Line: {{{
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
" }}}

" Vim Specific:

" Autocommand: Prepare Vim File Defaults: {{{
augroup vim_setup
au!
autocmd FileType vim setl shiftwidth=2
augroup END
" }}}

" Text And ReST Specific:

" Autocommand: Prepare Text / ReST File Defaults: {{{
" --------------------------------------------------------------------------
augroup txt_setup
au!
fun! Txt_wrap()
  setl textwidth=78
endfun
autocmd FileType txt call Txt_wrap()
autocmd FileType rst call Txt_wrap()
augroup END
" --------------------------------------------------------------------------
" }}}

" HTML Specific:

" Autocommand: Prepare HTML File Defaults: {{{
" --------------------------------------------------------------------------
augroup html_setup
au!
fun! Html_fold()
  setl autoindent
  setl foldmethod=indent
  setl foldnestmax=10
  setl nofoldenable
  setl foldlevel=1
  " setl foldopen=all foldclose=all
  setl foldtext=substitute(getline(v:foldstart),'\\t','\ \ \ \ ','g')
  setl fillchars=vert:\|,fold:\
  setl expandtab softtabstop=2 shiftwidth=2 nowrap
endfun
autocmd FileType html call Html_fold()
autocmd FileType htmldjango call Html_fold()
augroup END
" --------------------------------------------------------------------------
" }}}

" Python Specific:
"
" --------------------------------------------------------------------------
" Useful Commmands:
" --------------------------------------------------------------------------
" Outputting external python process into buffer/line-range/visual range:
" :<range>!python -c "command"    ==> Redirect stdout of cmd into buffer
"                                     (visual?) range
"
" Outputting internal python process into buffer/line-range:
" :py[thon] import vim; cb = vim.current.buffer; cb[start:end] = [useful_output]

" -- Note: this latter approach doesn't require you to direct the useful
"  output to stdout, via print statements or whatever. Moreover, write strings
"  to single indexes, and lists to to slices- e.g.
" ... cb[1] = 'a string'
" ... cb[1:5] = ['a string']
" --------------------------------------------------------------------------

" Source useful python utility functions: {{{
exec "source " . g:.vimfiles_path . '/scripts/python.vim'
" }}}
"
" Autocommand: Prepare Python File Defaults: {{{
" --------------------------------------------------------------------------
augroup python_setup
au!
fun! Python_fold()
  execute 'syntax clear pythonStatement'
  execute 'syntax keyword pythonStatement break continue del'
  execute 'syntax keyword pythonStatement except exec finally'
  execute 'syntax keyword pythonStatement pass print raise'
  execute 'syntax keyword pythonStatement return try'
  execute 'syntax keyword pythonStatement global assert'
  execute 'syntax keyword pythonStatement lambda yield'
  execute 'syntax match pythonStatement /\<def\>/ nextgroup=pythonFunction skipwhite'
  execute 'syntax match pythonStatement /\<class\>/ nextgroup=pythonFunction skipwhite'
  execute 'syntax region pythonFold start="^\z(\s*\)\%(class\|def\)" end="^\%(\n*\z1\s\)\@!" transparent fold'
  execute 'syntax sync minlines=2000 maxlines=4000'
  setl foldmethod=syntax
  " setl foldopen=all foldclose=all
  " setl foldtext=substitute(getline(v:foldstart),'\\t','\ \ \ \ ','g')
  setl fillchars=vert:\|,fold:\
  setl softtabstop=4 shiftwidth=4 nowrap nosmartindent

  " EXPERIMENT: Try to Use '_' as word seperator: {{{
  " let &isk = substitute(&isk, '_,', '', '')
  " removes the underscore from python 'words'
  " PROBLEMS:
  " * affects syntax highlighting (e.g. 'type' will be highlighted as keyword
  " for variable 'sub_type'
  " * affects supertab word completion
  " }}}

endfun
autocmd FileType python call Python_fold()
" Adds keyword-dictionary as complete option. For the most part, I found this
" /not/ to be useful:
" autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(
" from <url:vimhelp:'complete'>:
" k{dict}  scan the file {dict}.  Several "k" flags can be given,
"          patterns are valid too.  For example:
"          :set cpt=k/usr/dict/*,k~/spanish
augroup END
" --------------------------------------------------------------------------
" }}}

" Autocommand: Prettify Python Files on Save: {{{
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
augroup python_prettify
  au!
  autocmd FileWritePre *.py :silent call PrettifyPythonWhitespace()
  autocmd FileAppendPre *.py :silent call PrettifyPythonWhitespace()
  autocmd FilterWritePre *.py :silent call PrettifyPythonWhitespace()
  autocmd BufWritePre *.py :silent call PrettifyPythonWhitespace()
augroup END

map! <F2> :call TrimWhiteSpace()<CR>
" --------------------------------------------------------------------------
" }}}

" Pythonpath File Jumping: {{{
" --------------------------------------------------------------------------
" Freely jump between code and Python libraries
" Use 'gf' on your import statements to jump directly to that file.
" Also useful for quickfix w/vimgrep or grep.
" Source: <url:http://www.sontek.net/post/Python-with-a-modular-IDE-(Vim).aspx>
" --------------------------------------------------------------------------

" Performance Note: {{{ 
" --------------------------------------------------------------------------
" Make sure your complete option does NOT include i, as this will
" result in a very laborious search through every file in your python path for
" completion options!
" --------------------------------------------------------------------------
" }}}

" set complete=.,w,b,u
set complete-=t,i "tags deactivated, includes deactivated
function! SetVimPathFromPyPath()
""" Reset path to baseline_vim_path, then update with vim's internal 
""" PYTHONPATH

exec "set path=" . s:baseline_vim_path

python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
    #  else:
    #      print p
EOF
endfunction
" set path=$HOME/src/py/django/django-1.1 " Don't need /usr/include - not working with C.
" set path+=/Library/Frameworks/Python.framework/Versions/2.5/lib/python2.5
" --------------------------------------------------------------------------
" }}}

" Python File Syntax Checking: {{{
" --------------------------------------------------------------------------
" Check for missing colons at the end of command statements:
syn match pythonError "^\s*def\s\+\w\+(.*)\s*$" display
syn match pythonError "^\s*class\s\+\w\+(.*)\s*$" display
syn match pythonError "^\s*for\s.*[^:]$" display
syn match pythonError "^\s*except\s*$" display
syn match pythonError "^\s*finally\s*$" display
syn match pythonError "^\s*try\s*$" display
syn match pythonError "^\s*else\s*$" display
syn match pythonError "^\s*else\s*[^:].*" display
syn match pythonError "^\s*if\s.*[^\:]$" display
syn match pythonError "^\s*except\s.*[^\:]$" display
syn match pythonError "[;]$" display
syn keyword pythonError         do 

" type :make and get a list of syntax errors
" type :cn and :cp to move around the error list. 
" type :clist to see all the errors
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" --------------------------------------------------------------------------
" }}}

" Print Range Evaluated Via Python Interpreter: {{{
python << EOL
import vim
def EvaluateCurrentRange():
    eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL
map <leader>h :py EvaluateCurrentRange()<CR>
" --------------------------------------------------------------------------
" }}}

" Run Current File Through Python Interpreter: {{{
" --------------------------------------------------------------------------
" Made obsolete by Bexec plugin (<leader>bx)
" Source: <url:http://ed.cranford.googlepages.com/vimrc>
" --------------------------------------------------------------------------
" :nnoremap <f5> :up<CR>!python %<CR>
" --------------------------------------------------------------------------
" }}}

" Evaluate Python Range And Replace With Output: {{{
" --------------------------------------------------------------------------
" Source: <url:http://ed.cranford.googlepages.com/vimrc>
" in visual mode, highlight one or more lines
" and hit f5 and the block will be replaced with
" its python output.
" --------------------------------------------------------------------------
:vnoremap <f5> :!python<CR>
" --------------------------------------------------------------------------
" }}}

" Python Syntax Highlighting Improved: {{{
" --------------------------------------------------------------------------
" Source: <url:http://www.vim.org/scripts/script.php?script_id=790>
let python_highlight_all=1
" --------------------------------------------------------------------------
" }}}

" Python Indentation Improved: {{{
" --------------------------------------------------------------------------
" Install indent/python.vim from <url:http://www.vim.org/scripts/script.php?script_id=974>
" Modify setlocal indentkeys (see <url:.vim/indent/python.vim#line=17>)
" setlocal indentkeys=!^F,o,O,<:>,0),0],0},=elif,=except,0#
" Source: <url:http://henry.precheur.org/2008/4/18/Indenting_Python_with_VIM.html>
" --------------------------------------------------------------------------
" }}}

" My Hackish Additions To The Vim Arsenal:

" TODO:
" * Incorporate virtualenvwrapper hooks:
"   <url:http://www.doughellmann.com/docs/virtualenvwrapper/scripts.html>

""" VirtualEnv Configuration: {{{
function! StoreVirtualEnvSysPath(virtualenv)
  """ Stores virtualenv's sys.path in a global vim variable,
  """ g:virtualenv_sys_path

python << EOF
virtualenv = vim.eval('a:virtualenv')
virtualenv_dir = os.environ.get("WORKON_HOME")
if virtualenv_dir:
  python_exe = os.path.join(virtualenv_dir, virtualenv, 'bin', 'python')
  if os.path.exists(python_exe):
    import subprocess
    cmd = python_exe + ' -c "import sys; print sys.path"'
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    virtualenv_sys_path = eval(proc.communicate()[0])
    pythonpath_fixtures = vim.eval('g:pythonpath_fixtures')
    cwd = [os.getcwd()]
    new_sys_path = cwd + pythonpath_fixtures + virtualenv_sys_path
    vim.command('let g:virtualenv_sys_path = %s' % new_sys_path)
  else:
    print 'virtualenv "%s" not found!' % (virtualenv,)
else:
  print "$WORKON_HOME environment variable not found!"
EOF
endfunc

function! SetupVirtualEnv(name)
  """ Update vim's path and its internal-python sys.path to agree with
  """ the virtualenv's sys.path

  " First, set g:virtualenv_sys_path to the virtualenv's sys path:
  call StoreVirtualEnvSysPath(a:name)

  " Then, monkey patch vim's internal python so that its sys.path is now the
  " virtualenv's sys.path!
  if exists('g:virtualenv_sys_path') && !empty(g:virtualenv_sys_path)
    py import sys, vim; sys.path = vim.eval('g:virtualenv_sys_path')
  endif

  " Finally, update vim's path to agree with pythonpath:
  call SetVimPathFromPyPath()
endfunc
" }}}

" MY PROJECT SPECIFIC SETTINGS: {{{

" --------------------------------------------------------------------------
" Prepare Django Environment:

call SetupVirtualEnv('languagelab')
python << EOF
os.environ['DJANGO_SETTINGS_MODULE'] = 'llcom.settings'
sys.path.append(os.path.join(
    os.path.expanduser('~'),
    'src', 'py', 'django', '_mine', 'languagelab', 'llab-trunk'
))
EOF
set tags+=$HOME/src/py/django/_mine/languagelab/llab-trunk/llcom/tags
" FIXME: Not finding django via django.pth file when run at startup - may be
" due to subprocess module not being found.
" FIXME: PythonPath as WELL as Vim path!
set path+=$HOME/src/py/django/_mine/languagelab/llab-trunk
set path+=$HOME/src/py/django/_mine/languagelab/llab-trunk/llcom
set path+=$HOME/src/py/django/_mine/languagelab/llab-trunk/external_apps
" !source /Users/Chris/.virtualenvwrapper && workon languagelab && python
" $HOME/src/py/django/_mine/languagelab/llab-trunk/llcom/manage.py validate
" --------------------------------------------------------------------------
" Necessary run-time command to activate Django atm:
" (see http://blog.fluther.com/blog/2008/10/17/django-vim/)
" DJANGO_SETTINGS_MODULE='llcom.settings' PYTHONPATH='/home/nestor/documents/code/llab' vim -g
" set tags+=$HOME/.vim/tags/python.ctags
" set tags+=/usr/lib/python2.5/site-packages/Django-1.0.2_final-py2.5.egg/django/tags
" temporary mapping - sets tag-open to smart tag open

" Add Django tags.
" !sed '/    v/d'
" set tags+=$HOME/src/py/django/django-1.1/django/tags
" Slows down omnicompletion too much, sadly!
" --------------------------------------------------------------------------
" }}}

" Fixes and Todos: {{{
" --------------------------------------------------------------------------
" FIXME: FuzzyfinderTaggedFile- CWD seems to need to be the same as the tags
" file atm.
" SOLUTION: Fixed upon rollback to fuzzyfinder 2.22.3
" FIXME: NERD_Tree is being quite greedy in how much space it opens sometimes.
" Also, occasionally, opens file underneath the tree rather than to the right
" of it.
" WORKAROUND: Setting minibufexpl to permanent position, and using Bclose
" function.
" FIXME: SpellBad is broken dotted line, rather than 'undercurl'
" Note: this seems to be an OSX/MacVim thing, and was probably always the case.
" FIXME: SetupVirtualEnv changes:
" * you need a way of adding extra packages that won't necessarily be in
"   sys.path by default. For example, the languagelab project contains
"   external_apps, which should be added to the system path.
" FIXME:
" Re-sourcing .vimrc causes 2 anomalies:
" * <url:.#line=130> becomes remapped to <C-l> from <C-S-l>
" not properly mapped anyway: <C-S-l> not cls
" SOLUTION: Remapped to <leader><C-l>. Not sure <C-S-l> is possible.
" * NERDTree loses highlighting
" FIXME: temporarily add parent dir of current file to pythonpath?
" --------------------------------------------------------------------------
" }}}

" Omega Settings: {{{
" --------------------------------------------------------------------------
" i.e. settings which should come last:
" py UltiSnips_Manager.reset() - fails on load, not defined yet!
" Reload snippets
let s:LOCAL_VIMRC = '~/.vimrc_local'
if filereadable(s:LOCAL_VIMRC)
    source s:LOCAL_VIMRC
endif

" --------------------------------------------------------------------------
" }}}


