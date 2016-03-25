"####################################################################
" .vimrc
"####################################################################

"####################################################################
" install plugins {{{
"####################################################################

" automatic installation of neobundle on fresh deployments
if !filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()
" basics
Plug 'Shougo/unite.vim'
Plug 'tpope/vim-fugitive'

" additional views
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'majutsushi/tagbar', { 'on':  'Tagbar' } " TODO: add rust later, see github
Plug 'sjl/gundo.vim', { 'on':  'GundoToggle' }
Plug 'airblade/vim-gitgutter', { 'on':  'GitGutterToggle' }

" minor tweaks
Plug 'tomtom/tcomment_vim' "toggle comments according to ft (mapping: gc)
Plug 'yonchu/accelerated-smooth-scroll'

" movements and stuff
Plug 'tpope/vim-surround'
" Cheatsheet for surround:
"  cs + $old_surrounding + $new_surrounding = changes old to new, new waits for
"  xml tags, to use xml tags as $old, use 't'
Plug 'goldfeld/vim-seek'
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

" visual stuff
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'myusuf3/numbers.vim'
Plug 'ivyl/vim-bling'

" colorschemes
" Plug 'nanotech/jellybeans.vim'
" Plug 'zeis/vim-kolor'
" Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'

" syntax stuf
" python specific (TODO: check if lazy loading hurts)
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'}

" completion
Plug 'davidhalter/jedi-vim', {'for': 'python'}
autocmd FileType python setlocal omnifunc=jedi#completions
" let g:jedi#completions_enabled = 0
" let g:jedi#auto_vim_configuration = 0
" let g:jedi#smart_auto_mappings = 0
" let g:jedi#show_call_signatures = 0

" Cheatsheet for jedi
"  <C-Space> = completion
"  <leader>a  = goto assignments
"  <leader>d  = goto definitions
"  K = show pydoc
"  <leader>r = renaming
"  <leader>n = usages
"  :Pyimport os = opens the os module

" css specific
Plug 'ap/vim-css-color', {'for': 'css'}

" use salt-vim
au BufRead,BufNewFile *.sls set filetype=sls
Plug 'saltstack/salt-vim', {'for': 'sls'}

" use rust.vim
au BufRead,BufNewFile *.rs set filetype=rs
Plug 'rust-lang/rust.vim', {'for': 'rs'}

" use ansible-vim
Plug 'pearofducks/ansible-vim'

" use vim-fis
Plug 'dag/vim-fish'
autocmd FileType fish compiler fish
call plug#end()

"" }}}

"####################################################################
" general settings{{{
"####################################################################
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
" set autochdir " pwd follows files
set clipboard^=unnamedplus " use system clipboard

" open splits in nicer locations
set splitbelow
set splitright

" persistent undo and backup
set history=1000
set undofile
set undodir=~/.undo/
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
call matchadd('ErrorMsg', '\%102v', -1) " highlight char 101 of a long line


" search
set ignorecase
set smartcase
set hlsearch
set incsearch

" snappy timeouts
set notimeout
set ttimeout
set ttimeoutlen=0

"" }}}

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

" do not backup pass files
autocmd BufRead,BufNewFile /dev/shm* set nobackup
autocmd BufRead,BufNewFile /dev/shm* set noundofile
autocmd BufRead,BufNewFile /dev/shm* set noswapfile

" only indet by 2 with ansible yml
au FileType ansible set sw=2

" no cindent for tex
au FileType tex set nocindent
au FileType tex set textwidth=100
" no underscore highlights
let g:tex_flavor = 'context'

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
" bundle options and mappings {{{
"####################################################################

" Unite.vim
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10
" replace ctrl-p
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <leader>o :<C-u>Unite -start-insert file_rec/neovim:/home/danieln/Code<cr>
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
let g:tagbar_type_rust = {
\ 'ctagstype' : 'rust',
\ 'kinds' : [
    \'T:types,type definitions',
    \'f:functions,function definitions',
    \'g:enum,enumeration names',
    \'s:structure names',
    \'m:modules,module names',
    \'c:consts,static constants',
    \'t:traits,traits',
    \'i:impls,trait implementations',
\]
\}

" Colorscheme from bundle (needs to come after its Bundle line)
" PlugSource vim-kolor
" colorscheme kolor
" PlugSource jellybeans.vim
" colorscheme jellybeans
" PlugSource base16-vim
" let base16colorspace=256
" colorscheme base16-flat
let g:gruvbox_contrast_dark='hard'
let g:terminal_color_0  = '#1d2021'
let g:terminal_color_1  = '#cc241d'
let g:terminal_color_2  = '#98971a'
let g:terminal_color_3  = '#d79921'
let g:terminal_color_4  = '#458588'
let g:terminal_color_5  = '#b16286'
let g:terminal_color_6  = '#689d6a'
let g:terminal_color_7  = '#a89984'
let g:terminal_color_8  = '#928374'
let g:terminal_color_9  = '#fb4934'
let g:terminal_color_10 = '#b8bb26'
let g:terminal_color_11 = '#fabd2f'
let g:terminal_color_12 = '#83a598'
let g:terminal_color_13 = '#d3869b'
let g:terminal_color_14 = '#8ec07c'
let g:terminal_color_15 = '#ebdbb2'
colorscheme gruvbox

" bling
let g:bling_color = 'darkred'

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline_exclude_preview = 1
let g:airline_theme = 'hybridline'

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
