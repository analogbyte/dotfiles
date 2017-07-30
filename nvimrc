"####################################################################
" .vimrc
"####################################################################

"####################################################################
" install plugins {{{
"####################################################################

" automatic installation of plug on fresh deployments
if !filereadable(expand('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()
" views
Plug 'simnalamburt/vim-mundo', { 'on':  'MundoToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'majutsushi/tagbar', { 'on':  'TagbarToggle' }
Plug 'justinmk/vim-dirvish'

" visuals
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter', { 'on':  'GitGutterToggle' }
Plug 'yonchu/accelerated-smooth-scroll'
Plug 'vim-airline/vim-airline'
Plug 'ivyl/vim-bling'
Plug 'machakann/vim-highlightedyank'

" editing
Plug 'tomtom/tcomment_vim' "toggle comments according to ft (mapping: gc)
Plug 'tpope/vim-unimpaired' " mappings for dual ops
Plug 'tpope/vim-surround'
" Cheatsheet for surround:
"  cs + $old_surrounding + $new_surrounding = changes old to new, new waits for
"      xml tags, to use xml tags as $old, use 't'
"  ys adds/wraps
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

" linter
Plug 'w0rp/ale'

" language support
Plug 'ap/vim-css-color', {'for': 'css'}
Plug 'rust-lang/rust.vim'
Plug 'pearofducks/ansible-vim'
Plug 'fatih/vim-go'
Plug 'google/yapf', {'for': 'python'} " auto format
Plug 'davidhalter/jedi-vim', {'for': 'python'} " auto completion

call plug#end()

"" }}}

"####################################################################
" general settings{{{
"####################################################################
" filetype plugin and syntax
syntax on
set synmaxcol=512
filetype plugin indent on

" system
set enc=utf-8
let shell = system("which fish")
set backspace=indent,eol,start

" single settings
set hidden " change buffers without saving
set mousehide " no mouse
set wildmenu " menu when tab completing commands
set nostartofline " don't move the coursor to the beginning of the line
set foldmethod=marker " use manual folding
set scrolloff=16 " minimum lines to the screens end
set showmatch " matching braces
set noshowmode " airline does this already
set noswapfile " 21. century, yay
set gdefault " substitution is global by default, specify g to reverse
set autoread " read changed files
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

set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·
" set list
" augroup list
"     au!
"     au WinLeave,InsertEnter * set nolist
"     au WinEnter,InsertLeave * set list
" augroup END

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

" set file types
au BufNewFile,BufRead *.go setlocal filetype=go noet ts=8 sw=8 sts=8
au BufRead,BufNewFile *.ino set filetype=c

" set ft specific
au FileType ansible set sw=2
au FileType tex set nocindent
au FileType tex set textwidth=100
au FileType vim set keywordprg=":help"

" autoremove trailing whitespace
au BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" grow and shrink splits with the window
au VimResized * :wincmd =
"" }}}

"####################################################################
" keymaps {{{
"####################################################################

let mapleader = "\<Space>"

" smarter go to beginning of line
function! ToggleMovement(firstOp, thenOp)
  let pos = getpos('.')
  execute "normal! " . a:firstOp
  if pos == getpos('.')
    execute "normal! " . a:thenOp
  endif
endfunction

" start and end of line
nnoremap <silent> H :call ToggleMovement('^', '0')<CR>
nnoremap L $


" jump to visual lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

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

" sorting of lines
nnoremap <leader>s vip:!sort<cr>
vnoremap <leader>s :!sort<cr>

" align selection in columns
vnoremap <leader>c :!column -t<cr>

" new line from normal mode
nnoremap <NL> i<CR><ESC>
"" }}}

"####################################################################
" bundle options and mappings {{{
"####################################################################

" Tagbar
let g:tagbar_left = 1
let g:tagbar_width = 30
let g:tagbar_autofocus = 1
let g:tagbar_zoomwidth = 0
nnoremap <silent><leader>t :Tagbar<Cr>

" fzf
nnoremap <silent><leader>p :exe "FZF ".expand("%:p:h")<CR>
nnoremap <silent><C-p> :exe "FZF ".expand("%:p:h")<CR>

" Colorscheme from bundle
" let g:gruvbox_italic=1
set background=dark
" toggle light/dark (needs unimpaired.vim)
nmap <leader>c cob
set termguicolors
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" toggle list
nmap <leader>w col

" bling
let g:bling_color = 'darkred'

" Airline
let g:airline_extensions = ["tabline"]
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline_exclude_preview = 1
let g:airline_theme = 'gruvbox'
let g:airline_left_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_sep=''
let g:airline_right_alt_sep=''
let g:airline_symbols={}
let g:airline_symbols.space=' '
let g:airline_symbols.linenr='☰'
let g:airline_symbols.maxlinenr=''
let g:airline_symbols.branch='⎇'
let g:airline_symbols.whitespace='☲'

" Seek
let g:seek_subst_disable = 1
let g:seek_enable_jumps = 1
let g:seek_enable_jumps_in_diff = 1

" GitGutter
let g:gitgutter_enabled = 0
highlight clear SignColumn
highlight GitGutterAdd guibg=background guifg=darkyellow
highlight GitGutterChange guibg=background guifg=grey
highlight GitGutterDelete guibg=background guifg=red
highlight GitGutterChangeDelete guibg=background guifg=red
nnoremap <silent><leader>g :GitGutterToggle<Cr>

" change jedi mapping as leader g is git gutter
let g:jedi#goto_assignments_command = "<leader>a"

" Mundo
nnoremap <silent><leader>u :MundoToggle<Cr>

" autoformat python
autocmd FileType python nnoremap <LocalLeader>= :0,$!yapf<CR>

" (needs to come after its Bundle line) accelerated_smoothscroll
let g:ac_smooth_scroll_enable_accelerating = 0

" mypy defaults
let g:ale_fixers = ['autopep8']
let g:ale_python_autopep8_options = '--max-line-length 100'
let g:ale_python_mypy_options = '--ignore-missing-imports'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'
nnoremap <leader>= :ALEFix<CR>
nnoremap <leader>l :ALEToggle<CR>
nnoremap gn :ALENextWrap<CR>
"" }}}
