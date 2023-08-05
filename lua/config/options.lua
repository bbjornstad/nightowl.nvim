-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
----- The basic settings from init.vim
local NIGHTOWL_BACKGROUND = os.getenv("NIGHTOWL_BACKGROUND_STYLE")

-- leader key specification
-- <leader> = <Space> for easy access
-- Also, <localleader> = <Backslash> for easy access, though somewhat less so.
--
-- The <localleader> is used for buffer-specific text-generation and editing
-- commands, namely line breaks and boxes drawn with specific ASCII
-- configurations.
-- The <leader> key is the backbone of interaction and provides shortcut access
-- to most of what could be needed at a moment's notice when editing, and then
-- some.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

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
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 200
vim.opt.timeoutlen = 500

-- turn on default hard word-wrapping and further extend the keys which can wrap
-- at the end of the line.
vim.opt.wrap = true
vim.opt.whichwrap:append("<,>,h,l")

vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.cmdheight = 2

vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- >>> these are overwritten by our .editorconfig file in this directory.
--vim.opt.tabstop = 4
--vim.opt.shiftwidth = 4
--vim.opt.textwidth = 80
-- >>>

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

vim.opt.encoding = "utf-8"

vim.g.loaded_perl_provider = 0
