"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Configuration File
" Author: Amila Perera
" File Name: .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vundle setup {{{
filetype off
call pathogen#infect()
call pathogen#helptags()

set rtp+=!/.vim/bundle/vundle
call vundle#rc()

" let Vundle manage Vundle {{{2
Bundle 'gmarik/vundle'
" }}}2

" let Vundle manage pathogen {{{2
" For a brand new vim installation download vim-pathogen to bundle directory
" and create a link to $HOME/.vim/bundle/vim-pathogen/autoload in $HOME/.vim
Bundle 'tpope/vim-pathogen'
" }}}2

" General enhancements {{{2
Bundle 'vim-scripts/AutoComplPop'
Bundle 'vim-scripts/DrawIt'
Bundle 'vim-scripts/EasyGrep'
Bundle 'vim-scripts/FuzzyFinder'
Bundle 'vim-scripts/VisIncr'
Bundle 'vim-scripts/ZoomWin'
Bundle 'vim-scripts/highlight.vim'
Bundle 'vim-scripts/mru.vim'
Bundle 'vim-scripts/taglist.vim'
Bundle 'vim-scripts/vcscommand.vim'
Bundle 'vim-scripts/L9'
Bundle 'vim-scripts/txt.vim'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-eunuch'
Bundle 'jlanzarotta/bufexplorer'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'ervandew/supertab'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'nelstrom/vim-visual-star-search'
Bundle 'godlygeek/tabular'
Bundle 'Raimondi/delimitMate'
Bundle 'maxbrunsfeld/vim-yankstack'
Bundle 'mileszs/ack.vim'
Bundle 'jimsei/winresizer'
" }}}2

" Using the updated version of bufkill plugin {{{2
" since the original vim-script repository is not yet
" updated, get the fork it and updated it
Bundle 'amilaperera/bufkill.vim'
" }}}2

" General development related {{{2
Bundle 'vim-scripts/DoxygenToolkit.vim'
" }}}2

" Vim tmux integration {{{2
Bundle 'tpope/vim-tbone'
" }}}2

" Vim custom text objects {{{2
Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-entire'
Bundle 'kana/vim-textobj-indent'
Bundle 'kana/vim-textobj-syntax'
Bundle 'kana/vim-textobj-line'
Bundle 'nelstrom/vim-textobj-rubyblock'
" }}}2

" HTML editing {{{2
Bundle 'mattn/emmet-vim'
Bundle 'othree/html5.vim'
" }}}2

" C/C++ enhancements {{{2
Bundle 'vim-scripts/a.vim'
Bundle 'jabbourb/omnicpp'
" }}}2

" Colorschemes {{{2
" Using my own colorschemes
" This is a fork from https://github.com/flazz/vim-colorschemes
Bundle 'amilaperera/vim-colorschemes'
" }}}2

" Ruby enhancements {{{2
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-rake'
Bundle 'vim-ruby/vim-ruby'
" }}}2

" Snipmate plugin, related dependencies & snippets {{{2
Bundle 'garbas/vim-snipmate'
Bundle 'tomtom/tlib_vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
" Using my own snippets
" This is a fork from https://github.com/honza/vim-snippets
Bundle 'amilaperera/vim-snippets'
" }}}2
" }}}

" General settings {{{
set nocompatible               " gets out of vi compatible mode
set noexrc                     " don't use a local version of .(g)vimrc
set hidden                     " hide unsaved buffers
set autochdir                  " changes to the directory containing the file which was opened or selected
set autowriteall               " writes the contents of the file when moving to another file
set autoread                   " read automatically when a file is changed
set backspace=indent,eol,start " backspace more flexible
set noerrorbells               " no error bells
set novisualbell               " no visual bells
set visualbell t_vb=           " no beep, no flash NOTE: for some reason this has tobe set in .gvimrc too
set noswapfile                 " no swap files
set helpheight=35              " height of the help window
set mouse=nvi                  " use mouse in normal, visual & insert modes
set mousemodel=popup           " right mosue button pops up a menu
" }}}

" Changing map leader {{{
let mapleader = "," " set mapleader to ','
" }}}

" Miscellaneous {{{
filetype on               " filetype detection on
filetype plugin on        " filetype plugin on
filetype indent on        " filetype indent on
syntax on                 " always syntax on

runtime macros/matchit.vim " autoload the matchit plugin on startup

set autoindent            " auto-indent on
set foldenable            " enable fold functionality
set foldmethod=syntax     " foldmethod to syntax
set foldtext=NeatFoldText()

" Wildmenu settings {{{2
set wildmenu              " command line completion wildmenu
set wildmode=full         " completes till longest common string
" }}}2

" Timeout settings {{{2
set timeoutlen=1200 " more time for macros
set ttimeoutlen=50  " makes Esc to work faster
" }}}2

" Moving cursor to prev/next lines {{{2
set whichwrap=b,s         " <BS>, <Space>
set whichwrap+=<,>        " <Left, Right> Normal & Visual
set whichwrap+=~          " ~
set whichwrap+=[,]        " <Left, Right> Insert & Replace
" }}}2

" Ignore below when file name completion {{{2
set wildignore=*.o
set wildignore+=*.obj
set wildignore+=*.a
set wildignore+=*.so
set wildignore+=*.jpg
set wildignore+=*.png
set wildignore+=*.gif
set wildignore+=*.dll
set wildignore+=*.exe
set wildignore+=*.dpkg
set wildignore+=*.rpm
set wildignore+=*.pdf
set wildignore+=*.chm
" }}}2

" History settings {{{2
set history=1000
" }}}2

" Set possible locations for the tags file {{{2
set tags=./tags
set tags+=../tags
set tags+=../../tags
set tags+=../../../tags
set tags+=../../../../tags
" }}}2

" Allow '/' in directory paths in Windows {{{2
if has('win32') || has('win64')
  set shellslash
endif
" }}}2
" }}}

" UI Settings {{{
set list                      " strings to be used in list mode
set listchars=tab:\|.,trail:- " strings to be used in list mode

set tabstop=4                 " number of spaces that a tab counts for
set shiftwidth=4              " number of spaces to be used in each step of indent
set softtabstop=4             " number of spaces that a tab counts for while editing
set expandtab                 " use spaces to insert a tab

set cino=:0
set cino=l1

set nocursorline              " display nocursorline - window redraw is slow
set nocursorcolumn            " display nocursorcolumn - window redraw is slow

set nonumber                  " show line numbers
set numberwidth=6             " safe upto 999999

set hlsearch                  " highlight searched phrases
set incsearch                 " highlight as you type your search phrase
set ignorecase                " if caps are included in search string go case sensitive
set magic                     " keeps the magic option to its default value for maximum portability

set scrolloff=2               " keeps 5 lines for scope when scrolling
set matchtime=10              " tenth of milliseconds to show the matching paren
set lazyredraw                " don't redraw screen while typing macros
set nostartofline             " leave my cursor where it was
set showcmd                   " show the command being typed
set cmdheight=2               " set command height to 2
set report=0                  " always report the number of lines changed
set ruler                     " always shows the current position bottom the screen

set textwidth=100             " maximum width of the text that is being inserted

set title                     " display title
set display=lastline          " show as much as possible of the last line

" ColorScheme {{{2
let s:myFavourite256ColorScheme  = "wombat256"
let s:myFavouriteTermColorScheme = "default"

" set the colorscheme only for terminal vim
" for gui vim use the colorscheme in the .gvimrc
if ! has('gui_running')
  set background=dark
  if (&term == "xterm-256color" || &term == "screen-256color")
    execute "colorscheme " . s:myFavourite256ColorScheme
  else
    execute "colorscheme " . s:myFavouriteTermColorScheme
  endif
endif
" }}}2
" }}}

" StatusLine Settings {{{
set laststatus=2 " set status line visible even in single window mode

set statusline=\ [%n]\ %<%f   " buffer number and file name
set statusline+=\ %m\ %r%h%w  " modified flag, readonly flag, help buffer flag, preview window flag
set statusline+=\ %{'['.&ff.':'.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']'} " file type:file encoding
set statusline+=\ [%Y]                           " file type
set statusline+=\ %{fugitive#statusline()}       " fugitive prompt

set statusline+=%= " right align

if has('iconv')
  set statusline+=\ (0x%{FencB()}) " value under cursor
else
  set statusline+=\ (0x%B)         " value under cursor
endif
set statusline+=\ (%v,\ %l/%L) " virtual column number, line/total number of lines
set statusline+=\ --%3P--\     " percentage

function! FencB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return s:Byte2hex(s:Str2byte(c))
endfunction

function! s:Str2byte(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function! s:Byte2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
endfunction
" }}}

" Japanese encoding settings {{{
" Set encoding & fileformat settings
if has('win32') || has('win64')
  source $HOME\vimfiles\charencode_plugin\encode.vim " source the encoding file
  set encoding=japan
else
  set encoding=utf-8
  set fileencoding=utf-8
  set fileformats=unix,dos,mac
  set fileencodings=ucs-bom,utf-8,euc-jp,cp932,iso-2022-jp,ucs-2le,ucs-2
endif

" Display ZenkakuSpace, tabs and trailing spaces
if has('syntax')
  syntax on
  syn sync fromstart
  function! ActivateInvisibleIndicator()
    highlight InvisibleJISX0208Space term=NONE ctermbg=Blue guibg=darkgray gui=NONE
    syntax match InvisibleJISX0208Space "　" display containedin=ALL
  endfunction
  augroup invisible
    autocmd! invisible
    autocmd FileType * call ActivateInvisibleIndicator()
  augroup END
endif
" }}}

" Diff Settings {{{
set diffopt=filler
set diffopt+=vertical
set diffopt+=context:3
" }}}

" Dictionary & Spell Checking {{{
set spelllang=en                      " set spell language to English
set nospell                           " no spell checking by default
set dictionary+=/usr/share/dict/words " set the dictionary file
" }}}

" Settings related to external plugins {{{
" TagList Settings {{{2
map <silent> <right> :Tlist<CR>
let Tlist_Auto_Open            = 0       " let the tag list open automatically
let Tlist_Compact_Format       = 1       " show small menu
let Tlist_Ctags_Cmd            = 'ctags' " location of ctags
let Tlist_Enable_Fold_Column   = 0       " do not show column folding
let Tlist_Exist_OnlyWindow     = 1       " if you are the last, kill yourself
let Tlist_File_Fold_Auto_Close = 0       " fold closed other trees
let Tlist_Sort_Type            = "name"  " order by name
let Tlist_Use_Right_Window     = 1       " split to the right side of the screen
let Tlist_WinWidth             = 40      " Taglist window 40 columns wide
" }}}2

" BufferExplorer mappings {{{2
nnoremap <silent> <F12> :BufExplorer<CR>
" }}}2

" NerdCommenter Settings {{{2
let g:NERDSpaceDelims       = 1
let g:NERDRemoveExtraSpaces = 1
imap <C-c> <plug>NERDCommenterInsert
" }}}2

" Nerdtree settings {{{2
map <silent> <left> :NERDTreeToggle<CR>
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeIgnore        = ['\.o$', '\.a$', '\.so$', '\.so.*$', '\.dpkg$', '\.rpm$', '\.obj$', '\.exe$', '\.d$','\.swp$', '\.git$', '\~$']
" }}}2

" MRU {{{2
let MRU_Window_Height = 8
nnoremap <silent> mr   :MRU<CR>
" }}}2

" AutoCompletionPopup {{{2
let g:acp_enableAtStartup = 0 " disable acp at startup
nnoremap <silent> <Leader>ae      :AcpEnable<CR>
nnoremap <silent> <Leader>ad      :AcpDisable<CR>
" }}}2

" FuzzyFinder Settings {{{2
let g:fuf_file_exclude      = '\v\~$|\.(o|exe|dll|obj|d|swp)$|/test/data\.|(^|[/\\])\.(svn|hg|git|bzr)($|[/\\])'
let g:fuf_splitPathMatching = 0
let g:fuf_maxMenuWidth      = 120
let g:fuf_timeFormat        = ''
nmap <silent> <Leader>f  :FufFile<CR>
nmap <silent> <Leader>fv :FufFile ~/.vim/**/<CR>
nmap <silent> <Leader>fb :FufBuffer<CR>
nmap <silent> <Leader>fd :FufDir<CR>
" }}}2

" EasyGrep Settings {{{2
let g:EasyGrepWindowPosition = "botright"
" }}}2

" SuperTab Settings {{{2
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabNoCompleteBefore      = []
let g:SuperTabNoCompleteAfter       = ['^', ',', ';', ':', '{', '}', '(', ')', '[', ']', '<', '>', '\s']
" }}}2

" OmniCppComplete {{{2
let OmniCpp_NamespaceSearch     = 1
let OmniCpp_GlobalScopeSearch   = 1
let OmniCpp_ShowAccess          = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot      = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow    = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope    = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces   = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
" }}}2

" Tabularize {{{2
nmap <silent> <Leader>a= :Tabularize /=<CR>
vmap <silent> <Leader>a= :Tabularize /=<CR>
nmap <silent> <Leader>a: :Tabularize /:\zs<CR>
vmap <silent> <Leader>a: :Tabularize /:\zs<CR>
" }}}2

" yankstack {{{2
" load the yankstack plugin immediately
" otherwise the vS mapping of the vim-surround gets clobbered
call yankstack#setup()
nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste
" }}}2

" bufkill {{{2
nmap <silent> <Leader>bd :BD<CR>
" }}}2

" winresizer {{{2
let g:winresizer_vert_resize = 2
let g:winresizer_horiz_resize = 1
" }}}2
" }}}

" Functions {{{
" Custom fold text {{{2
" taken from http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
" }}}2

" QuickFix window toggling function {{{2
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
  else
    execute "botright cwindow " . g:jah_Quickfix_Win_Height
  endif
endfunction

" used to track the quickfix window
augroup QFixToggle
  autocmd!
  autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
  autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

let g:jah_Quickfix_Win_Height = 10 " setting qfix window height
" }}}2

" tabs to spaces & spaces to tabs conversion {{{2
" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction
command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)
" }}}2

" Show syntax highlighting groups for word under cursor {{{2
" This is helpful when creating colorschemes
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nmap <Leader>sgr :call <SID>SynStack()<CR>
" }}}2
" }}}

" file type specific settings {{{
augroup FTCheck
  autocmd!
  autocmd BufNewFile,BufRead *.text,*.notes,*.memo setl ft=txt
augroup END

augroup FTOptions
  autocmd!
  autocmd Filetype sh,zsh,csh,tcsh setl ts=4 noet fdm=marker
  autocmd Filetype ruby,eruby      setl ts=2 sw=2 sts=2 fdm=indent
  autocmd Filetype html,css        setl ts=2 sw=2 sts=2 fdm=indent
  autocmd Filetype vim             setl ts=2 sw=2 sts=2 fdm=marker
  autocmd Filetype txt,mail        setl ts=2 sw=2 sts=2 fdm=indent
  autocmd Filetype gitcommit       setl spell

  autocmd BufNewFile,BufRead *.c,*.cpp,*.c++,*.cxx,*.h,*hpp setl ts=4 sw=4 sts=4 noet
  autocmd BufNewFile,BufRead *.pro setl ft=QT_PROJECT_FILE syn=make
augroup END
" }}}2
" }}}

" Personal Mappings {{{
" When .vimrc/.gvimrc is edited, reload it {{{2
autocmd! BufWritePost .vimrc source $HOME/.vimrc
autocmd! BufWritePost .gvimrc source $HOME/.gvimrc
" }}}2
" Fast editing of the vim, tmux configuration files {{{2
map <Leader>v :e! $HOME/.vimrc<CR>
map <Leader>vg :e! $HOME/.gvimrc<CR>
" }}}2
" nohlsearch, after a search {{{2
nnoremap <silent> <C-L> :nohlsearch<CR>
" }}}2
" retain visual selection after indentation {{{2
vnoremap > >gv
vnoremap < <gv
" }}}2
" vimgrep {{{2
" Displays a vimgrep command template
map <Leader>g :vimgrep // ../**/*.<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" Search the current file for the word under the cursor and display matches
nmap <silent> <Leader>gw :vimgrep /<C-r><C-w>/ %<CR>:cclose<CR>:cwindow<CR><C-W>J:nohlsearch<CR>
" }}}2
" force encoding conversion {{{2
map <silent> <Leader>e :e! ++enc=euc-jp<CR>
map <silent> <Leader>u :e! ++enc=utf-8<CR>
" }}}2
" changes directory to the directory of the current buffer {{{2
nmap <silent> <Leader>cd :lcd %:h<CR>:pwd<CR>
" }}}2
" get the full path of the file in the buffer {{{2
nmap <Leader> <Space> :echo expand('%:p')<CR>
" }}}2
" Heading {{{2
noremap <silent> <Leader>h1 yyp^v$r=
noremap <silent> <Leader>h2 yyp^v$r-
noremap <silent> <Leader>he <ESC>070i=<ESC>
noremap <silent> <Leader>hh <ESC>070i-<ESC>
noremap <silent> <Leader>hs <ESC>070i*<ESC>
" }}}2
" Window closing commands {{{2
" Close this window
noremap <silent> <Leader>clw :close<CR>
" Close the other window
noremap <silent> <Leader>clj :wincmd j<CR>:close<CR>
noremap <silent> <Leader>clk :wincmd k<CR>:close<CR>
noremap <silent> <Leader>clh :wincmd h<CR>:close<CR>
noremap <silent> <Leader>cll :wincmd l<CR>:close<CR>
" }}}2
" Useful Digraphs {{{2
" diamond(◆)
inoremap <silent> <C-l><C-d> <C-k>Db
" triangle(▲)
inoremap <silent> <C-l><C-t> <C-k>UT
" circle(●)
inoremap <silent> <C-l><C-r> <C-k>0M
" alpha(α)
inoremap <silent> <C-l><C-a> <C-k>a*
" beta(β)
inoremap <silent> <C-l><C-b> <C-k>b*
" }}}2

" merge consecutive empty lines and clean up trailing spaces(from tpope's .vimrc file) {{{2
map <Leader>fm :g/^\s*$/,/\S/-j<Bar>%s/\s\+$//<CR>
" }}}2

" Mappings for functions {{{2
" QuickFixWindow Toggle
nmap <silent> <Leader>q <ESC>:QFix<CR>
" Space-Tab conversion
nmap <silent> <Leader>ta <ESC>:Space2Tab<CR>
nmap <silent> <Leader>sp <ESC>:Tab2Space<CR>
" }}}2
" }}}
