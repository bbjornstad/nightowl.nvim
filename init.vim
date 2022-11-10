" -----------------------------------------------------------------------------
" NeoVIM Configuration. Could be symlinked to .vimrc
" -----------------------------------------------------------------------------
" -- The following is deprecated for nvim
" set nocompatible              " be iMproved, required


" -----------------------------------------------------------------------------
" Plugin Configuration
" -----------------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/site/plugged')
" --- Base Plugins
"  - Color Schemes
"  - Component Pieces (airline, tagbar, bufferline)
Plug 'bling/vim-airline'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'Raimondi/delimitmate'
Plug 'majutsushi/tagbar'
Plug 'folke/which-key.nvim'
Plug 'vim-airline/vim-airline-themes'
" Plug 'morhetz/gruvbox'
" Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'
" Plug 'dikiaap/minimalist'
Plug 'NLKNguyen/papercolor-theme'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'lewis6991/gitsigns.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'lotabout/skim.vim'
Plug 'yamatsum/nvim-cursorline'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'folke/trouble.nvim'
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'

" --- Language Server Setup 
"  - LSP Config
"  - Mason
"  - DAP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-dap'
Plug 'simrat39/rust-tools.nvim'
Plug 'folke/lsp-colors.nvim'

"  --- nvim-cmp temporarily testing
"" - nvim-cmp specific stuff
"Plug 'hrsh7th/cmp-nvim-lsp'
"Plug 'hrsh7th/cmp-buffer'
"Plug 'hrsh7th/cmp-path'
"Plug 'hrsh7th/cmp-cmdline'
"Plug 'hrsh7th/nvim-cmp'

" For snippy users.
" Plug 'dcampos/nvim-snippy'
" Plug 'dcampos/cmp-snippy'

" --- ddc - Deoplete Replacement
"  - DDC Specific Stuff
"  - See github.com/Shougo/ddc.vim
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
Plug 'Shougo/deoppet.nvim', { 'do': ':UpdateRemotePlugins' }

"  - UI Settings
Plug 'Shougo/pum.vim'
Plug 'Shougo/ddc-ui-pum'

"  - Sources for DDC
Plug 'Shougo/ddc-source-around'
Plug 'Shougo/ddc-source-nvim-lsp'
Plug 'Shougo/ddc-source-line'
Plug 'LumaKernel/ddc-tabnine'
Plug 'delphinus/ddc-treesitter'
Plug 'delphinus/ddc-ctags'

"  - Usability Upgrades
Plug 'matsui54/denops-popup-preview.vim'
Plug 'matsui54/denops-signature_help'

"  - Filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'

" --- Language Specific Plugins for Certain Functionality
Plug 'lervag/vimtex'
Plug 'cjrh/vim-conda'
Plug 'jmcantrell/vim-virtualenv'
Plug 'saltstack/salt-vim'
Plug 'preservim/vim-markdown'
Plug 'danymat/neogen'

" --- orgmode plugins
"  - nvim-orgmode
"  - neorg
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
" set notimeout
set ttimeout ttimeoutlen=200
set timeoutlen=500

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
set relativenumber
set cursorline

set spelllang=en_us

" -----------------------------------------------------------------------------
" Colors and Themes
" -----------------------------------------------------------------------------
set t_Co=256
if has('termguicolors')
    set termguicolors
endif

" let g:gruvbox_italic=1
" let g:gruvbox_contrast_dark='hard'
set background=light
" colorscheme hybrid
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

nnoremap <leader>[ <ESC>:bprevious<CR>
noremap <F5> <ESC>:bprevious<CR>
nnoremap <leader>] <ESC>:bnext<CR>
noremap <F6> <ESC>:bnext<CR>

nnoremap <leader>q <C-O>:bdelete<CR>

nnoremap <leader><F3> <ESC> :vsplit<CR>
nnoremap <leader><F4> <ESC> :split<CR>

nnoremap <leader>so <CMD>set spell!<CR>

nnoremap <leader>tt <CMD>Telescope<CR>

nnoremap <leader>nt <CMD>NvimTreeToggle<CR>

" -----------------------------------------------------------------------------
" Language Configuration Sections
" -----------------------------------------------------------------------------
" -----Rust Configuration-----
let g:rust_recommended_style=1

" -----------------------------------------------------------------------------
" Plugin Configuration Sections
" -----------------------------------------------------------------------------
" -----Tagbar Configuration-----
let g:tagbar_position='topleft vertical'
let g:tagbar_width=0
"
" -----Airline Configuration-----
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='papercolor'
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

" ------------------------------------------------------------------------------
" --- deoppet snippets
" ------------------------------------------------------------------------------
call deoppet#initialize()
call deoppet#custom#option('snippets',
\ map(globpath(&runtimepath, 'neosnippets', 1, 1),
\     { _, val -> { 'path': val } }))

imap <C-k>  <Plug>(deoppet_expand)
imap <C-f>  <Plug>(deoppet_jump_forward)
imap <C-b>  <Plug>(deoppet_jump_backward)
smap <C-f>  <Plug>(deoppet_jump_forward)
smap <C-b>  <Plug>(deoppet_jump_backward)

" Customize global settings

" You must set the default ui.
" Note: native ui
" https://github.com/Shougo/ddc-ui-native
call ddc#custom#patch_global('ui', 'pum')

" Use around source.
" https://github.com/Shougo/ddc-source-around
call ddc#custom#patch_global('sources', ['nvim-lsp', 'deoppet', 'around', 'treesitter', 'tabnine', 'ctags', 'line'])

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
      \ 'around': {'mark': 'a', 'maxItems': 10},
      \ 'nvim-lsp': {'mark': 'l', 'forceCompletionPattern': '\.\w*|:\w*|->\w*', 'maxItems': 20},
      \ 'deoppet': {'mark': 's', 'maxItems': 20},
      \ 'treesitter': {'mark': 't', 'maxItems': 10},
      \ 'line': {'mark': '-', 'maxItems': 10},
      \ 'ctags': {'mark': 'c', 'maxItems': 10},
      \ 'tabnine': {'mark': '9', 'maxItems': 10},
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ 'nvim-lsp': {'maxSize': 500},
      \ 'line': {'maxSize': 500},
      \ 'tabnine': {'maxSize': 500},
      \ })

" Mappings
inoremap <C-n>   <CMD>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <CMD>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <CMD>call pum#map#confirm()<CR>
inoremap <C-e>   <CMD>call pum#map#cancel()<CR>
inoremap <PageDown> <CMD>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <CMD>call pum#map#insert_relative_page(-1)<CR>

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

lua require('which-key_rs')
lua require('nvim-cursorline_rs')
lua require('gitsigns_rs')
lua require('nvim-tree_rs')
lua require('treesitter_rs')
lua require('null-ls_rs')
lua require('lspconfig_rs')
lua require('trouble_rs')
lua require('indentblankline_rs')
lua require('neogen_rs')
lua require('noice').setup()

lua require('orgmode_rs')
lua require('neorg_rs')

