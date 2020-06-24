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
