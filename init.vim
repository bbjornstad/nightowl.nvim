set nocompatible              " be iMproved, required

" Main Plugin Definitions and Installations
" - This section is 
call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'vim-syntastic/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'Raimondi/delimitmate'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'
Plug 'bluz71/vim-moonfly-colors'
Plug 'dikiaap/minimalist'
Plug 'tpope/vim-repeat'
Plug 'lervag/vimtex'
Plug 'stevearc/vim-arduino'
Plug 'cjrh/vim-conda'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'saltstack/salt-vim'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown' 

" All of your Plugins must be added before the following line
" - This already sets `filetype plugin indent on` and `syntax enable`
call plug#end()


" Basic Behavioral Settings
" - Mouse behavior
" - Selection Behavior
" - CMD input
"
"   - basic -
set mouse=a
set backspace=indent,eol,start
set autoindent
set nostartofline
set confirm
set visualbell
set notimeout ttimeout ttimeoutlen=200
set splitright

"   - cmd input -
set showcmd
set wildmenu
set laststatus=2
set cmdheight=2

"   - search input -
set ignorecase
set incsearch
set hlsearch
set hidden
set smartcase

" Page Settings, e.g. Tabbing, Lines/Width, etc.
" - color schemes go under the appropriate section below.
"
"   - tab behavior - 
set softtabstop=4
set shiftwidth=4
set expandtab
"   - page indicators -
set ruler
set number
set textwidth=80
set colorcolumn=80

set t_Co=256
if has('termguicolors')
    set termguicolors
endif
set background=dark
colorscheme jellybeans

" for some plugins
hi clear SignColumn

" -----Mappings-----
map Y y$
nnoremap <C-L> :nohl<CR><C-L>

" -----Airline Configuration-----
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='minimalist'
let g:airline_powerline_fonts=1

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
