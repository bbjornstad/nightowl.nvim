-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- The basic settings from init.vim
local NIGHTOWL_BACKGROUND = vim.env.NIGHTOWL_BACKGROUND_STYLE

-- leader configuration. These are mapped to <leader> and <localleader>
-- respectively. If using a `funsak` KeyModule, these have somewhat more
-- specific meanings depending on configuration.
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[']]

-- Basic interface options that are not handled with specific plugin
-- configurations set in interface.lua
vim.opt.mouse = "a"
vim.opt.backspace = "indent,eol,start"
vim.opt.autoindent = true
vim.opt.startofline = false
vim.opt.confirm = true
vim.opt.visualbell = true
vim.opt.mousemoveevent = true

-- timeout configuration for neovim mappings, affects WhichKey predominantly
vim.opt.completeopt = "menuone,menu,noinsert"
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 75
vim.opt.timeoutlen = 300

-- turn on default hard word-wrapping and further extend the keys which can wrap
-- at the end of the line.
vim.opt.wrap = true
vim.opt.whichwrap:append("<,>,h,l")

vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.cmdheight = 0

vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.scrolloff = 10

vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.synmaxcol = 50

vim.opt.swapfile = false
vim.opt.spelllang = "en_us"
vim.opt_global.formatoptions:append("t")
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

if not NIGHTOWL_BACKGROUND then
  vim.notify(
    [[This configuration is missing a background specification in the environment.
    You can set the background using the NIGHTOWL_BACKGROUND_STYLE environment variable,
    which accepts two possible values: "light" or "dark". Without setting this variable,
    defaults to "dark"]]
  )
end
vim.opt.background = (NIGHTOWL_BACKGROUND or "dark")

vim.cmd.hi("clear SignColumns")
vim.opt.signcolumn = "auto"

vim.opt.encoding = "utf-8"

vim.g.loaded_perl_provider = 0

-- set up the most important of the highlights for all schemes, generally these
-- should be overwritten somewhere in the scheme definition itself but this
-- provides a fallback such that certain plugins won't fail.
vim.api.nvim_set_hl(0, "IndentBlanklineWhitespace", { link = "@comment" })
vim.api.nvim_set_hl(0, "IndentBlanklineScope", { link = "@comment" })
vim.api.nvim_set_hl(0, "IndentBlanklineIndent", { link = "@comment" })
