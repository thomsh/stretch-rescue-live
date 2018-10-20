scriptencoding utf-8
set nocompatible
set t_Co=256
syntax enable
set bg=dark
set wildmenu
set showmatch
set showcmd
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

" general tabstop & expand tab:
set tabstop=2
set expandtab
" file specific ts
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
" python pep8 + 119 char config
autocmd BufNewFile,BufRead *.py setlocal ts=4 sw=4 sts=4 expandtab autoindent fileformat=unix

if has("autocmd")
  filetype plugin indent on
endif

" no mouse
set mouse-=a

set laststatus=2
" let g:airline#extensions#tabline#enabled = 1


" basic status line :
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P

" extra white space in red
highlight ExtraWhitespace ctermbg=red guibg=red
let a = matchadd('ExtraWhitespace', '\s\+$')

" Undo level
set ul=100

set noswapfile
