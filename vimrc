"####################################################################
" .vimrc
"####################################################################

if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
scriptencoding utf-8

"" filetype plugin and syntax
syntax on
set synmaxcol=512
filetype indent plugin on

"" system
set enc=utf-8
set shell=/bin/zsh
set spelllang=de
set backspace=indent,eol,start

"" single settings
set hidden " change buffers without saving
set mousehide " no mouse
set wildmenu " menu when tab completing commands
set nostartofline " don't move the coursor to the beginning of the line
set foldmethod=marker " fold by marker
set scrolloff=11 " minimum lines to the screens end
set autochdir " always be in the right directory
set pastetoggle=<F12> " toggle paste
set showmatch " matching braces
set noshowmode " airline does this already
set noswapfile " 21. century, yay

"" persistent undo and backup
set history=1000
set undofile
set undodir=~/.backup/
set backup
set backupdir=~/.backup/

"" tabs and stuff
set nosmartindent
set shiftwidth=4
set softtabstop=4
set expandtab " use spaces
set textwidth=0
set wrapmargin=0

"" search
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
set t_Co=256 " force more colors

" highlight the current line and column
set cul
set cuc

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
" autoremove trailing whitespace
au BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" arduino syntax highlightning
au BufRead,BufNewFile *.ino set filetype=c

" column hl only in active window and in non-insert modes
augroup cuc
    au!
    au WinLeave,InsertEnter * set nocuc
    au WinEnter,InsertLeave * set cuc
augroup END

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
nnoremap [q :cprev<cr>
nnoremap ]q :cnext<cr>
nnoremap {q :cpfile<cr>
nnoremap }q :cnfile<cr>

" jump to visual lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" stay in visual after indent
vnoremap < <gv
vnoremap > >gv

" replace dollar and acute
nnoremap B ^
nnoremap E $

" highlight last inserted text
nnoremap gV `[v`]

" change Y from yy to y$
map Y y$

" alternative esc
inoremap jk <esc>

" remove search hl
nnoremap <silent><C-C> :nohl<CR>

" switch buffers
nnoremap <silent><Tab> :bn<Cr>
nnoremap <silent><S-Tab> :bp<Cr>

" save with sudo
cmap w!! w !sudo tee %

" splits
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" move char to the end of the line, useful for closing stuff
nnoremap zl :let @z=@"<cr>x$p:let @"=@z<cr>

" sorting of lines (python imports)
nnoremap <leader>s vip:!sort<cr>
vnoremap <leader>s :!sort<cr>

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
NeoBundle 'vimwiki/vimwiki'
NeoBundle 'airblade/vim-gitgutter'

" minor tweaks
NeoBundle 'Valloric/ListToggle' "toggle quickfix list
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
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'ivyl/vim-bling'

" colorschemes
NeoBundleLazy 'nanotech/jellybeans.vim'
NeoBundleLazy 'vim-scripts/wombat256.vim'

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
call unite#custom#profile('default', 'ignorecase', 1)
call unite#custom#profile('default', 'context', {
\   'winheight': 10,
\   'direction': 'botright',
\ })
" replace ctrl-p
nnoremap <C-p> :Unite -start-insert file_rec/async<cr>
" ack stuff, does not quite replace ack.vim
let g:unite_source_grep_command = 'ack'
let g:unite_source_grep_default_opts = '-i --nogroup --nocolor -H'
nnoremap <leader>/ :Unite grep:.<cr>
nnoremap <silent><leader><leader> :<C-u>UniteResume<CR>
" yankring
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :Unite history/yank<cr>
" buffer switching, very good when many buffers are open
nnoremap <leader>s :Unite -quick-match buffer<cr>

" NERDTree
nnoremap <silent><leader>f :NERDTreeToggle<Cr>
let NERDTreeShowBookmarks=1
let NERDTreeHijackNetrw=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1

" Tagbar
noremap <silent><leader>t :Tagbar<Cr>

" Colorscheme from bundle (needs to come after its Bundle line)
"NeoBundleSource jellybeans.vim
"colorscheme jellybeans
NeoBundleSource wombat256.vim
colorscheme wombat256mod

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline_exclude_preview=1

" Seek
let g:seek_subst_disable = 1
let g:seek_enable_jumps = 1
let g:seek_enable_jumps_in_diff = 1

" Jedi
let g:jedi#goto_assignments_command = ""
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>a"

" GitGutter
let g:gitgutter_enabled = 0
highlight clear SignColumn
highlight GitGutterAdd ctermbg=232 ctermfg=green
highlight GitGutterChange ctermbg=232 ctermfg=yellow
highlight GitGutterDelete ctermbg=232 ctermfg=red
highlight GitGutterChangeDelete ctermbg=232 ctermfg=red
noremap <silent><leader>g :GitGutterToggle<Cr>

" crtl-p
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_use_caching = 0
nnoremap <silent><Leader>o :CtrlP<cr>

" Gundo
nnoremap <silent><leader>u :GundoToggle<Cr>

" indentLine
let g:indentLine_color_term = 239

" vimwiki
nmap <Leader>wn <Plug>VimwikiNextLink
nmap <Leader>wp <Plug>VimwikiPrevLink

"" }}}

if filereadable('.vimrc.local')
    source .vimrc.local
endif
