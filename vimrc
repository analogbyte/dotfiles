"####################################################################
" .vimrc
"####################################################################

if has('vim_starting')
    set nocompatible
endif
scriptencoding utf-8

" filetype plugin and syntax
syntax on
set synmaxcol=512
filetype plugin indent on
runtime macros/matchit.vim

" system
set enc=utf-8
set spelllang=en
set backspace=indent,eol,start

" single settings
set hidden " change buffers without saving
set mousehide " no mouse
set wildmenu " menu when tab completing commands
set nostartofline " don't move the coursor to the beginning of the line
set foldmethod=marker
set scrolloff=16
set pastetoggle=<F12> " toggle paste
set showmatch " matching braces
set noshowmode " airline does this already
set noswapfile " 21. century, yay
set gdefault " substitution is global by default, specify g to reverse
set lazyredraw " don't redraw while executing a macro
set autoread " read changed files
set autochdir " pwd follows files
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
" set cindent
set smartindent

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
colorscheme industry

" line and column highlights
" set cul
" set cuc
" augroup cuc
"     au!
"     au WinLeave,InsertEnter * set nocuc
"     au WinEnter,InsertLeave * set cuc
" augroup END

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
"" }}}
