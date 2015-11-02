call plug#begin('~/.config/nvim/plugged')

Plug 'w0ng/vim-hybrid'
Plug 'davidhalter/jedi-vim'
Plug 'scrooloose/syntastic'
Plug 'bling/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-fugitive'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jmcantrell/vim-virtualenv'

call plug#end()

"Colors and syntax
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set t_Co=256
let g:hybrid_use_Xresources = 1
set background=dark
colorscheme hybrid
syntax on
set number

"Tabs
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

set mouse=a
filetype indent plugin on
set visualbell
set ruler
set autoindent
set nowrap
"Colors on right
execute "set colorcolumn=" . join(range(100,335),',')

"Load indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size =2
"Air line
"TODO: Figure out how to get fonts for this working correctly
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
"let g:airline_powerline_fonts = 1
"if !exists('g:airline_symbols')
"    let g:airline_symbols = {}
"  endif
"let g:airline_symbols.space = "\ua0"
set laststatus=2
"Autoload flake8
"autocmd BufWritePost *.py call Flake8()

