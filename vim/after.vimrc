filetype off

let mapleader = '\'

set t_Co=256                          " Tell Vim the terminal supports 256 colors.
set laststatus=2

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
let g:NERDSpaceDelims = 1             " Put a space after NERDComments.
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn\|review$',
  \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$',
  \ 'link': 'blaze-bin\|blaze-genfiles\|blaze-google3\|blaze-out\|blaze-testlogs\|READONLY$',
  \ }                                 " Make CtrlP fuzzy-search faster.
  " Auto-open and -close NERDTree when no other files are open.
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nmap <leader>b :BufExplorer<CR>
nmap <leader>ls :NERDTreeToggle<CR>
nmap <leader>t :TagbarToggle<CR>
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:easytags_file = '~/.vim/tmp/tags'
let g:easytags_auto_highlight = 0
let g:easytags_updatetime_warn = 0
let g:pymode = 0
let g:pymode_indent = 0
let g:syntastic_mode_map = {'mode': 'passive'}


set backspace=indent,eol,start

" Swap, backup, and undo directories
" Double trailing slash makes vim use full path/to/file
set directory=~/.vim/tmp/swap//
set backup
set backupdir=~/.vim/tmp/backup//
set undofile
set undodir=~/.vim/tmp/undo//

" History
set history=50          " keep 50 lines of command line history
set showcmd             " display incomplete commands
set incsearch           " do incremental searching

" Gui stuff
set ruler               " show the cursor position all the time
let &guicursor = &guicursor . ",a:blinkon0"
set number              "show line numbers
set relativenumber
set list listchars=tab:»·,trail:␣
set mouse=a             "enable mouse
set wildmenu            "enable fun tab-complete prettyness
set wildmode=list:longest,full
set clipboard+=unnamed  "yanking automatically uses system clipboard
set splitbelow
set splitright

" Tabs
set autoindent          " always set autoindenting on
set et ts=2 sts=2 sw=2  "set tab defaults

" Coloring
colorscheme hybrid
set background=light
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
" highlight Search ctermbg=LightBlue
" highlight ErrorMsg ctermfg=Red ctermbg=White
" highlight ColorColumn ctermbg=DarkMagenta
" highlight SpecialKey ctermfg=DarkMagenta
highlight clear SignColumn
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=darkgrey ctermfg=darkgrey
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=black ctermfg=black

" since # searches for current word, \# clears searches
nmap <leader># :let @/ = ""<CR>

" Other simple settings
set hidden              "allow switching buffers without saving
set textwidth=80
set colorcolumn=+1
set encoding=utf-8
set nojoinspaces

" Folding stuff
augroup AutoFold
  " automatcially create folds
  au BufReadPre * setlocal foldmethod=indent
  " but don't close them
  set foldlevelstart=99
  " and let me do other folding manually
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
  " with some sweet mappings for space
  nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
  vnoremap <Space> zf
augroup END

" Reopen file at last used point
:au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
