" -----------------------------------------------------------------------------
" NeoVIM Configuration. Could be symlinked to .vimrc
" -----------------------------------------------------------------------------
set nocompatible              " be iMproved, required

" -----------------------------------------------------------------------------
" NeoVIM Configuration. Could be symlinked to .vimrc
" -----------------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'bling/vim-airline'
Plug 'chriskempson/base16-vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'Raimondi/delimitmate'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'
Plug 'dikiaap/minimalist'
Plug 'lervag/vimtex'
Plug 'cjrh/vim-conda'
Plug 'saltstack/salt-vim'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'kkoomen/vim-doge'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'

" deoplete only
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" Load ALE
Plug 'dense-analysis/ale'


" All of your Plugins must be added before the following line
" 
" - This already sets `filetype plugin indent on` and `syntax enable`
" 
call plug#end()

" -----------------------------------------------------------------------------
" Basic Behavioral Settings
" -----------------------------------------------------------------------------
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

" -----------------------------------------------------------------------------
" Basic Behavioral Settings
" -----------------------------------------------------------------------------
"   - Page Settings, e.g. Tabbing, Lines/Width, etc.
"       - color schemes go under the appropriate section below.
"
"   - tab behavior - 
set softtabstop=4
set shiftwidth=4
set expandtab
"   - page indicators -
set ruler
set number
set textwidth=79
set colorcolumn=80
set rnu
" set nofoldenable -> probably should go in a different place

" -----------------------------------------------------------------------------
" Colors and Themes
" -----------------------------------------------------------------------------
set t_Co=256
if has('termguicolors')
    set termguicolors
endif

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
set background=dark
colorscheme gruvbox

" for some plugins
hi clear SignColumn

" -----------------------------------------------------------------------------
" Complex Behavior Overrides
" -----------------------------------------------------------------------------
" -----Vertical Split Default----
augroup default_vertical_split
    autocmd WinNew * wincmd L
    autocmd BufWinEnter <buffer> wincmd L
augroup END



" -----------------------------------------------------------------------------
" Custom Mappings
" -----------------------------------------------------------------------------
" -----User Mappings-----
map Y y$
nnoremap <C-L> :nohl<CR><C-L>

function CommentBreak()
    let l:commentcharlen=strlen(split(&commentstring, '%s')[0])
    let l:breaklen=(&l:colorcolumn - l:commentcharlen - col('.'))
    execute printf(":normal! %sa-\<ESC>\<CR>", l:breaklen)
endfunction
nnoremap <M-i><M-l> :call CommentBreak()<CR>
inoremap <M-i><M-l> <C-O>:call CommentBreak()<CR>

" -----------------------------------------------------------------------------
" Language Configuration Sections
" -----------------------------------------------------------------------------
" -----ALE and deoplete-----
let g:ale_linters = {'rust': ['analyzer', 'rls']}
let g:auto_refresh_delay=20

inoremap <leader><c> call deoplete#auto_complete()

" -----Rust Configuration-----
let g:rust_recommended_style=0


" -----------------------------------------------------------------------------
" Plugin Configuration Sections
" -----------------------------------------------------------------------------
" -----Tagbar Configuration-----
let g:tagbar_position='topleft vertical'
let g:tagbar_width=0
"
" -----Airline Configuration-----
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1

" -----Vim-Doge Configuration-----
" nmap <silent> <leader>h call doge#generate

" -----Vim-Markdown Configuration-----
let g:vim_markdown_folding_disabled=1

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
    autocmd FileType tex,latex,plaintex nmap <silent> <leader>b call deoplete#auto_complete
augroup END
