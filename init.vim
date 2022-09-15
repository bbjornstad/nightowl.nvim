set nocompatible              " be iMproved, required

" plugins and things
call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'vim-syntastic/syntastic'
Plug 'christoomey/vim-tmux-navigator'
Plug 'bling/vim-airline'
Plug 'Raimondi/delimitmate'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-repeat'
Plug 'lervag/vimtex'
Plug 'stevearc/vim-arduino'
Plug 'cjrh/vim-conda'

" All of your Plugins must be added before the following line
call plug#end()

filetype plugin indent on    " required

" Some Basic Settings
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set colorcolumn=80
set t_Co=256
set textwidth=80
set softtabstop=4
set shiftwidth=4
set expandtab

syntax enable
set mouse=a

set background=dark
colorscheme nord

" for some plugins
hi clear SignColumn

set hidden
set wildmenu

set ignorecase
set smartcase

set autoindent
set nostartofline

set laststatus=2
set cmdheight=2

set confirm
set visualbell

set notimeout ttimeout ttimeoutlen=200

" -----Mappings-----
map Y y$
nnoremap <C-L> :nohl<CR><C-L>



" -----Airline Configuration-----
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='nord'
let g:airline_powerline_fonts=1

" -----VIM NERDTree Tabs Configuration-----
" Open/Close NERDTree with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
let g:nerdtree_tabs_open_on_console_startup=2

" -----Syntastic Configuration-----
let g:syntastic_error_symbol = ''
let g:syntastic_warning_symbol = ''
augroup mySyntastic
	autocmd!
	autocmd FileType tex,latex let b:syntastic_mode="passive"
augroup END

" -----VimTeX Configuration-----
" Set some options
let g:vimtex_echo_ignore_wait=1
let g:vimtex_mappings_enabled=0
let g:tex_flavor='latex'
let g:vimtex_compiler_latexmk = {
    \ 'backend' : 'nvim',
    \ 'background' : 1,
    \ 'build_dir' : '',
    \ 'callback' : 0,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
let g:vimtex_compiler_latexmk_engines = {
        \ '_'                : '-xelatex',
        \ 'pdflatex'         : '-pdf',
        \ 'dvipdfex'         : '-pdfdvi',
        \ 'lualatex'         : '-lualatex',
        \ 'xelatex'          : '-xelatex',
        \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
        \ 'context (luatex)' : '-pdf -pdflatex=context',
        \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
        \}

" Do some wrapping and mapping controls
augroup myVimTex
    autocmd!
    autocmd FileType tex,latex,plaintex nmap <silent> <leader>c <plug>(vimtex-compile)
    autocmd FileType tex,latex,plaintex nmap <silent> <leader>v <plug>(vimtex-view)
    autocmd FileType tex,latex,plaintex nmap <silent> <leader>e <plug>(vimtex-errors)
augroup END
