-- options are the first things that are loaded, this is to allow the plugin
-- configurations to alter any options set here in case of conditional
-- inclusion, modular implementation details, etc.

-- get the background style from the corresponding environment variable.
local NIGHTOWL_BACKGROUND = vim.env.NIGHTOWL_BACKGROUND_STYLE

-- leader configuration. These are mapped to <leader> and <localleader>
-- respectively. If using a `funsak` KeyModule, these have somewhat more
-- specific meanings depending on configuration.
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[\]]

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
vim.opt.ttimeoutlen = 75
vim.opt.timeoutlen = 300

-- set options for nvim completion menu behavior.
vim.opt.completeopt = "menuone,menu,noinsert"

-- turn on default hard word-wrapping and further extend the keys which can wrap
-- at the end of the line.
vim.opt.wrap = true
vim.opt.whichwrap:append("<,>,h,l")

-- turn on breakindent, which shows wrapped lines along the same alignment as
-- the text that it is a part of
vim.opt.breakindent = true
vim.opt.breakindentopt:append("sbr")

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--  * 2023-12-20: this is the neovim default, kickstart also includes it but it is
--  now explicitly included in nightowl.
vim.o.clipboard = "unnamedplus"

-- cmdline behavior.
-- * NOTE: This is generally going to be completely overhauled with noice.nvim
-- in the default implementation of nightowl.nvim
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.cmdheight = 0

-- prevent superfluous mode messages with the other ui elements
vim.opt.showmode = false

-- Search Behavior:
-- * Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- better interactivity with search input
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- see `:help hidden`
vim.opt.hidden = true

-- allows search cycling
vim.opt.wrapscan = true

-- scrolling behavior.
vim.opt.scrolloff = 10

-- sign column and number column configuration
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:2"

-- allow cursorline, this too is generally revamped with a plugin
vim.opt.cursorline = true

-- sets up the max column for syntax detection
-- see `:help synmaxcol`
vim.opt.synmaxcol = 300

-- don't use swapfiles, this really only makes sense since we have a plugin
-- which is responsible for autosaving. Set to true to reenable the default
-- behavior of using a swapfile.
-- NOTE: We could put this in a guard, e.g. a check for the existence of the
-- autosave plugin, and then if not set this to true.
vim.opt.swapfile = false

-- save undo history.
-- NOTE: In the default configuration, this behavior is enhanced with plugins.
vim.o.undofile = true

-- spelling detection language
vim.opt.spelllang = "en_us"

-- add an option to formatoptions
vim.opt.formatoptions:append("t")

-- use a global statusline instead of a statusline per-window.
-- * this helps to reduce clutter in the default implementation, especially
-- seeing as there is supposed to also be a winbar included per window like a
-- per-window statusline, implemented with incline.nvim
vim.opt.laststatus = 3

-- specify character set for the fill characters for ui divisions that are
-- filled using line-type elements.
-- see `:help fillchars`
vim.opt.fillchars:append({
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
})

vim.cmd.hi("clear SignColumns")

vim.opt.encoding = "utf-8"

-- turn on fancy colors, requires terminal emulator support
-- vim.opt.termguicolors = true

vim.opt.filetype = "on"

vim.opt.conceallevel = 3

-- disable the perl provider for neovim, I just generally don't use it at all.
-- vim.g.loaded_perl_provider = 0
