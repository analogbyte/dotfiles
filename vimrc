"####################################################################
" .vimrc
"####################################################################

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
scriptencoding utf-8

" filetype plugin and syntax
syntax on
set synmaxcol=512
filetype plugin indent on
runtime macros/matchit.vim

" system
set enc=utf-8
let shell = system("which zsh")
let &shell=shell[0:len(shell)-2]
set spelllang=de
set backspace=indent,eol,start

" single settings
set hidden " change buffers without saving
set mousehide " no mouse
set wildmenu " menu when tab completing commands
set nostartofline " don't move the coursor to the beginning of the line
set foldmethod=marker
let my_scrolloff_value=16
let &scrolloff=my_scrolloff_value " minimum lines to the screens end
set pastetoggle=<F12> " toggle paste
set showmatch " matching braces
set noshowmode " airline does this already
set noswapfile " 21. century, yay
set gdefault " substitution is global by default, specify g to reverse
set lazyredraw " don't redraw while executing a macro
set autoread " read changed files
set autochdir " pwd follows files
set clipboard^=unnamed " use system clipboard

" open splits in nicer locations
set splitbelow
set splitright

" persistent undo and backup
set history=1000
set undofile
set undodir=~/.backup/
set backup
set backupdir=~/.backup/

" tabs and stuff
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set smarttab
set cindent

" width
set textwidth=0
set wrapmargin=0

" search
set ignorecase
set smartcase
set hlsearch
set incsearch

" snappy timeouts
set notimeout
set ttimeout
set ttimeoutlen=0


"####################################################################
" visual style {{{
"####################################################################
" colorscheme
set background=dark

" line and column highlights
set cul
set cuc
augroup cuc
    au!
    au WinLeave,InsertEnter * set nocuc
    au WinEnter,InsertLeave * set cuc
augroup END

" statusbar
set cmdheight=2
set laststatus=2
set showcmd

" linenumbers
set number
set relativenumber
set ruler

" highlight git merge markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
"" }}}

"####################################################################
" general auto commands {{{
"####################################################################

" no cindent for tex
au FileType tex set nocindent

" replace man with :help when editing vimrc
au FileType vim set keywordprg=":help"

" autoremove trailing whitespace
au BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" arduino syntax highlightning
au BufRead,BufNewFile *.ino set filetype=c

" grow and shrink splits with the window
au VimResized * :wincmd =

"" }}}

"####################################################################
" keymaps {{{
"####################################################################

let mapleader = "\<Space>"

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" quickfix usage
nnoremap <leader>qp :cprev<cr>
nnoremap <leader>qn :cnext<cr>

" jump to visual lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" start and end of line
noremap H ^
noremap L $

" stay in visual after indent
vnoremap < <gv
vnoremap > >gv

" highlight last inserted text
nnoremap gV `[v`]

" change Y from yy to y$
map Y y$

" alternative esc
inoremap jk <esc>

" remove search hl
nnoremap <silent><C-C> :nohl<cr>

" switch buffers
nnoremap <silent><Tab> :bn<cr>
nnoremap <silent><S-Tab> :bp<cr>

" save with sudo
cmap w!! w !sudo tee %

" splits
nnoremap <silent> <C-k> :wincmd k<cr>
nnoremap <silent> <C-j> :wincmd j<cr>
nnoremap <silent> <C-h> :wincmd h<cr>
nnoremap <silent> <C-l> :wincmd l<cr>
nnoremap <silent> <leader><Right> :vertical resize -5<cr>
nnoremap <silent> <leader><Down> :resize +5<cr>
nnoremap <silent> <leader><Up> :resize -5<cr>
nnoremap <silent> <leader><Left> :vertical resize +5<cr>

" jump to buffer
"nnoremap <leader><leader> <C-^>
nnoremap <leader>1 :1b<cr>
nnoremap <leader>2 :2b<cr>
nnoremap <leader>3 :3b<cr>
nnoremap <leader>4 :4b<cr>
nnoremap <leader>5 :5b<cr>
nnoremap <leader>6 :6b<cr>
nnoremap <leader>7 :7b<cr>
nnoremap <leader>8 :8b<cr>
nnoremap <leader>9 :9b<cr>
nnoremap <leader>0 :10b<cr>

" move char to the end of the line, useful for closing stuff
nnoremap <leader>z :let @z=@"<cr>x$p:let @"=@z<cr>
nnoremap <leader>m :cd %:p:h<cr>

" sorting of lines (python imports)
nnoremap <leader>s vip:!sort<cr>
vnoremap <leader>s :!sort<cr>

" align selection in columns
vnoremap <leader>c :!column -t<cr>

" show file in continuous mode
"" open all folds
"" disable dynamic numbers plugin
"" disable wrap in the first window, because this kills the sync
"" disable relative numbers
"" ensure enabled numbers
"" temorary scrolloff=0
"" open the current buffer in a vertical split
"" move our view and set scrollbind in the new split
"" move back to the old split
"" set scrollbind in this split, too
"" reset scrolloff to whatever it was
nnoremap <silent> <leader>cm zR:<C-u>NumbersDisable<cr>:setl nowrap<cr>:set nornu<cr>:set nu<cr>:let &scrolloff=0<cr>:bo vs<cr>Ljzt:setl scrollbind<cr><C-w>p:setl scrollbind<cr>:let &scrolloff=my_scrolloff_value<cr>

"" }}}

"####################################################################
" autoinstall vundle and bundles {{{
" Credit to: https://github.com/erikzaadi
"####################################################################

" automatic installation of neobundle on fresh deployments
if !filereadable(expand('~/.vim/bundle/neobundle.vim/README.md'))
    silent !git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
    quit
endif

call neobundle#begin(expand('~/.vim/bundle/'))
" basics
NeoBundle 'Shougo/vimproc.vim',
\ {
    \ 'build' : {
        \ 'unix' : 'make -f make_unix.mak',
        \ 'cygwin' : 'make -f make_cygwin.mak',
        \ 'windows' : has('win64') ? 'tools\\update-dll-mingw 64' : 'tools\\update-dll-mingw 32',
        \ 'mac' : 'make -f make_mac.mak'
    \ }
\ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tpope/vim-fugitive'

" additional views
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'airblade/vim-gitgutter'

" minor tweaks
NeoBundle 'milkypostman/vim-togglelist' "toggle quickfix list
NeoBundle 'tomtom/tcomment_vim' "toggle comments according to ft (mapping: gc)

" movements and stuff
NeoBundle 'tpope/vim-surround'
" Cheatsheet for surround:
"  cs + $old_surrounding + $new_surrounding = changes old to new, new waits for
"  xml tags, to use xml tags as $old, use 't'
NeoBundle 'goldfeld/vim-seek'
" Cheatsheet for seek:
"  s + two chars = jump to the first of those chars
"  action = {d,c,y}
"  $action + s + two chars = target from here to the middle of those two chars
"  $action + x + two chars = target from here to those two chars
"  $action + r + two chars = target the inner word with the chars and jump back
"  $action + u + two chars = target the outer word with the chars and jump back
"  $action + p + two chars = target the inner word with the chars and stay
"  $action + o + two chars = target the outer word with the chars and stay
"  All those work backwards with their capital counterparts.

" python specific (no lazy loading here, it causes trouble with jedi somehow)
NeoBundle 'jmcantrell/vim-virtualenv'
NeoBundle 'davidhalter/jedi-vim'
" Cheatsheet for jedi
"  <C-Space> = completion
"  <leader>a  = goto assignments
"  <leader>d  = goto definitions
"  K = show pydoc
"  <leader>r = renaming
"  <leader>n = usages
"  :Pyimport os = opens the os module

" visual stuff
NeoBundle 'bling/vim-airline'
NeoBundle 'myusuf3/numbers.vim'

" colorschemes
NeoBundleLazy 'nanotech/jellybeans.vim'
NeoBundleLazy 'zeis/vim-kolor'

NeoBundle 'yonchu/accelerated-smooth-scroll'
NeoBundle 'thinca/vim-localrc'

" syntax
au BufRead,BufNewFile *.sls set filetype=sls
NeoBundleLazy 'saltstack/salt-vim'
au FileType sls NeoBundleSource salt-vim

call neobundle#end()
NeoBundleCheck

"" }}}

"####################################################################
" bundle options and mappings {{{
"####################################################################

" Unite.vim
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10
" replace ctrl-p
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>o :<C-u>Unite -start-insert file_rec/async<cr>
" ag
if executable('ag')
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --nogroup -S'
    let g:unite_source_grep_recursive_opt=''
endif
nnoremap <leader>/ :<C-u>Unite grep:.<cr>
command T Unite grep:.::TODO\:\|FIXME\:\|NOTE\:<cr>
" yankring
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :<C-u>Unite history/yank<cr>
" buffer switching, very good when many buffers are open
nnoremap <leader>s :<C-u>Unite -quick-match buffer<cr>
" reopen unite
nnoremap <silent><leader><leader> :<C-u>UniteResume<cr>

" NERDTree
nnoremap <silent><leader>f :NERDTreeToggle<Cr>
let NERDTreeShowBookmarks=1
let NERDTreeHijackNetrw=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.o']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1

" Tagbar
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_autofocus = 1
let g:tagbar_zoomwidth = 0
noremap <silent><leader>t :Tagbar<Cr>

" Colorscheme from bundle (needs to come after its Bundle line)
" NeoBundleSource vim-kolor
" colorscheme kolor
NeoBundleSource jellybeans.vim
colorscheme jellybeans

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline_exclude_preview = 1

" Seek
let g:seek_subst_disable = 1
let g:seek_enable_jumps = 1
let g:seek_enable_jumps_in_diff = 1

" Jedi
let g:jedi#goto_assignments_command = ""
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>a"
let g:jedi#show_call_signatures = 2

" GitGutter
let g:gitgutter_enabled = 0
highlight clear SignColumn
" use 233 as termbg for jellybeans, 234 for kolor
highlight GitGutterAdd ctermbg=233 ctermfg=green
highlight GitGutterChange ctermbg=233 ctermfg=yellow
highlight GitGutterDelete ctermbg=233 ctermfg=red
highlight GitGutterChangeDelete ctermbg=233 ctermfg=red
noremap <silent><leader>g :GitGutterToggle<Cr>

" Gundo
nnoremap <silent><leader>u :GundoToggle<Cr>

" accelerated_smoothscroll
let g:ac_smooth_scroll_enable_accelerating = 0
"" }}}
