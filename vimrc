"####################################################################
" .vimrc
"####################################################################

set nocompatible " vi compatibility off
scriptencoding utf-8

"" filetype plugin and syntax
syntax on
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
set showmatch

"####################################################################
" visual style {{{
"####################################################################
"" colorscheme
"colorscheme wombat256mod " set after the bundles at the end of this file!
set background=dark
set t_Co=256 " force more colors

"" highlight the current line and column
set cul
set cuc

"" statusbar
set cmdheight=2
set laststatus=2
set showcmd

"" linenumbers
set number
set relativenumber
set ruler
"" }}}

"####################################################################
" general auto commands {{{
"####################################################################
" autoremove trailing whitespace
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" salt syntax highlighting
au BufRead,BufNewFile *.sls set filetype=sls

" arduino syntax highlightning
au BufRead,BufNewFile *.ino set filetype=c
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

" some easy ones
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :wq<CR>

" jump to visual lines
nnoremap j gj
nnoremap k gk

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

" toggle conversion of buffers to tabs
let notabs = 1
nnoremap <silent> <F8> :let notabs=!notabs<Bar>:if notabs<Bar>:tabo<Bar>:else<Bar>:tab ball<Bar>:tabn<Bar>:endif<CR>

" switch buffers
nnoremap <silent><Tab> :bn<Cr>
nnoremap <silent><S-Tab> :bp<Cr>

" save with sudo
cmap w!! w !sudo tee %

" never open first grep/ack hit
cmap ack Ack!
cmap grep grep!

"" }}}

"####################################################################
" autoinstall vundle and bundles {{{
" Credit to: https://github.com/erikzaadi
"####################################################################

" automatic installation of vundle on fresh deployments
let installed_vundle=0
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let installed_vundle=1
endif
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" begin bundles
Bundle 'gmarik/vundle'
Bundle 'myusuf3/numbers.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tomtom/tcomment_vim'
Bundle 'vim-scripts/taglist.vim'
Bundle 'saltstack/salt-vim'
Bundle 'vim-scripts/wombat256.vim'
Bundle 'bling/vim-airline'
Bundle 'goldfeld/vim-seek'
Bundle 'davidhalter/jedi-vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'ivyl/vim-bling'
Bundle 'mileszs/ack.vim'
Bundle 'sjl/gundo.vim'
Bundle 'terryma/vim-expand-region'
"Bundle 'Yggdroot/indentLine' " good with my urxvt config: let g:indentLine_color_term = 239

if installed_vundle == 1
    :BundleInstall
endif
"" }}}

"####################################################################
" bundle options {{{
"####################################################################

" NERDTree
nnoremap <silent><leader>f :NERDTreeToggle<Cr>
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1

" Taglist
noremap <silent><leader>t :TlistToggle<Cr>
let Tlist_Use_Right_Window=1
let Tlist_GainFocus_On_ToggleOpen = 1

" Colorscheme from bundle (needs to come after its Bundle line)
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

" GitGutter
let g:gitgutter_enabled = 0
noremap <silent><leader>g :GitGutterToggle<Cr>

" crtl-p
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_use_caching = 0

" Gundo
nnoremap <silent><leader>u :GundoToggle<Cr>

" expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"" }}}
