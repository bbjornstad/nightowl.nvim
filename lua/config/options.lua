-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
----- The basic settings from init.vim
local CANDY_MOOD = os.getenv("CANDY_MOOD")

-- leader key specification
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.mouse = "a"
vim.opt.backspace = "indent,eol,start"
vim.opt.autoindent = true
vim.opt.startofline = false
vim.opt.confirm = true
vim.opt.visualbell = true

vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 200
vim.opt.timeoutlen = 500

vim.opt.wrap = true
vim.opt.whichwrap:append("<,>,h,l")

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

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 80

vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.spelllang = "en_us"
vim.opt.formatoptions = "tcroqb"
vim.opt.laststatus = 3
vim.opt.fillchars:append({
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
})

-- vim.opt.termguicolors = true
vim.opt.background = (CANDY_MOOD or "dark")

vim.cmd.hi("clear SignColumns")

-- vim.opt.do_filetype_lua = 1
vim.opt.completeopt = "menuone,menu,noinsert"

-- for nvim-ufo
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "0"
