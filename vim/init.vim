""" PLUGINS """
call plug#begin('~/.local/share/nvim/site/plugged/')

Plug 'Raimondi/delimitMate'
Plug 'Valloric/YouCompleteMe', {'do': './install.py --go-completer'}
Plug 'aarongable/vim-python-indent'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ehamberg/vim-cute-python'
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'
Plug 'google/vim-syncopate'
Plug 'gregsexton/gitv'
Plug 'jlanzarotta/bufexplorer'
Plug 'junegunn/fzf', {'dir': '~/.local/share/fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'michaeljsmith/vim-indent-object'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'w0ng/vim-hybrid'
Plug 'zaiste/tmux.vim'

" I want to use these, but don't currently:
" Plug 'tpope/vim-endwise'
" Plug 'Lokaltog/vim-easymotion'

" Automatically does:
" filetype plugin indent on
" syntax enable
call plug#end()

call glaive#Install()
Glaive syncopate plugin[mappings]

""" BASICS """
let mapleader = " "

set directory=~/.cache/nvim/swap//
set backup
set backupdir=~/.cache/nvim/backup//
set undofile
set undodir=~/.cache/nvim/undo//
set showcmd
set number
set relativenumber
set mouse=a
set wildmode=list:longest,full
set clipboard^=unnamed
set splitbelow
set splitright
set nobinary
set autoindent
set et ts=2 sts=2 sw=2
set hidden
set textwidth=80
set colorcolumn=+1
set nojoinspaces

noremap <left> <nop>
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
map Y y$
vnoremap <leader>yo "*y
nnoremap <leader>po "*p
noremap <leader>bp :bprevious<cr>
noremap <leader>bn :bnext<cr>
vnoremap < <gv
vnoremap > >gv

highlight clear SignColumn

autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell

" since # searches for current word, \# clears searches
nmap <leader># :let @/ = ""<CR>

" Reopen file at last used point
:au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

""" PLUGIN CONFIGURATION """
colorscheme hybrid
set background=dark

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols = {}
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#tabline#enabled = 1

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1

let g:NERDSpaceDelims = 1             " Put a space after NERDComments.
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nmap <leader>b :BufExplorer<CR>
nmap <leader>ls :NERDTreeToggle<CR>
nmap <leader>t :TagbarToggle<CR>
