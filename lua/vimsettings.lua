-- ----- The basic settings from init.vim

HOME = os.getenv('HOME')

-- leader key specification
vim.g.mapleader = '\\'
vim.g.maplocalleader = ','

vim.opt.mouse = 'a'
vim.opt.backspace = 'indent,eol,start'
vim.opt.autoindent = true
vim.opt.startofline = false
vim.opt.confirm = true
vim.opt.visualbell = true

vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 200
vim.opt.timeoutlen = 500

vim.opt.wrap = true
vim.opt.whichwrap:append('<,>,h,l')

vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 2

vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 80

vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.spelllang = 'en_us'
vim.opt.formatoptions = 'tcroqb'

if vim.fn.has('termguicolors') == 1 then
    vim.opt.termguicolors = true
end
vim.opt.background = 'light'

vim.cmd.hi('clear SignColumns')

