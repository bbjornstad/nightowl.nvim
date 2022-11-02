" -----------------------------------------------------------------------------
" NeoVIM Configuration. Could be symlinked to .vimrc
" -----------------------------------------------------------------------------
set nocompatible              " be iMproved, required

" -----------------------------------------------------------------------------
" NeoVIM Configuration. Could be symlinked to .vimrc
" -----------------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/site/plugged')
" Plug 'sheerun/vim-polyglot'
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
Plug 'NLKNguyen/papercolor-theme'

Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'neovim/nvim-lspconfig'

Plug 'mfussenegger/nvim-dap'
Plug 'simrat39/rust-tools.nvim'

Plug 'lervag/vimtex'
Plug 'cjrh/vim-conda'
Plug 'saltstack/salt-vim'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'kkoomen/vim-doge'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
" Plug 'amrbashir/nvim-docs-view', { 'on': 'DocsViewToggle'}

" ------------------------------------------------------------------------------
" ddc - Deoplete Replacement
" ------------------------------------------------------------------------------
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'

Plug 'Shougo/pum.vim'
Plug 'Shougo/ddc-ui-pum'
Plug 'Shougo/ddc-source-around'
Plug 'Shougo/ddc-source-nvim-lsp'
Plug 'Shougo/ddc-source-line'
Plug 'matsui54/denops-popup-preview.vim'
Plug 'matsui54/denops-signature_help'
Plug 'delphinus/ddc-treesitter'

Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'


" ------------------------------------------------------------------------------
" orgmode plugins
" ------------------------------------------------------------------------------
Plug 'nvim-orgmode/orgmode'
Plug 'akinsho/org-bullets.nvim'

Plug 'nvim-neorg/neorg'
Plug 'esquires/neorg-gtd-project-tags'
Plug 'max397574/neorg-contexts'
Plug 'max397574/neorg-kanban'


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

" -----------------------------------------------------------------------------
" Colors and Themes
" -----------------------------------------------------------------------------
set t_Co=256
if has('termguicolors')
    set termguicolors
endif

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
set background=light
colorscheme PaperColor

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
    let l:breaklen=(&l:colorcolumn - l:commentcharlen)
    execute printf(":normal! %sa-\<ESC>\<CR>", l:breaklen)
endfunction
nnoremap <M-i><M-l> :call CommentBreak()<CR>
inoremap <M-i><M-l> <C-O>:call CommentBreak()<CR>

command SuperPlug PlugClean|PlugUpgrade|PlugInstall|PlugUpdate

noremap <leader><[> <ESC>:bprevious<CR>
noremap <F5> <ESC>:bprevious<CR>
noremap <leader><]> <ESC>:bnext<CR>
noremap <F6> <ESC>:bnext<CR>

noremap <leader><q> <C-O>:bdelete<CR>

noremap <leader><F3> <ESC> :vsplit<CR>
noremap <leader><F4> <ESC> :split<CR>

" -----------------------------------------------------------------------------
" Language Configuration Sections
" -----------------------------------------------------------------------------
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
        \}

autocmd FileType tex,latex,plaintex nmap <silent> <leader>b call deoplete#auto_complete
augroup END


" Customize global settings

" You must set the default ui.
" Note: native ui
" https://github.com/Shougo/ddc-ui-native
call ddc#custom#patch_global('ui', 'pum')

" Use around source.
" https://github.com/Shougo/ddc-source-around
call ddc#custom#patch_global('sources', ['around', 'nvim-lsp', 'treesitter', 'line'])

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })

" Change source options
call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'a'},
      \ 'nvim-lsp': {'mark': 'l', 'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ 'treesitter': {'mark': 't'},
      \ 'line': {'mark': '-.-'}
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ 'nvim-lsp': {'maxSize': 500},
      \ 'line': {'maxSize': 500},
      \ })

" Mappings
inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : pum#map#insert_relative(+1)

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : pum#map#insert_relative(-1)

" Use ddc.
call signature_help#enable()
call popup_preview#enable()
call ddc#enable()

lua require('treesitter_rs')
lua require('null-ls_rs')
lua require('lspconfig_rs')
lua require('indentblankline_rs')

lua require('orgmode_rs')
lua require('neorg_rs')

augroup orgmodeconf
    autocmd!
    autocmd FileType org imap <C><CR> <ESC><leader><CR>
augroup END

