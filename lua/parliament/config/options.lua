-- options are the first things that are loaded, this is to allow the plugin
-- configurations to alter any options set here in case of conditional
-- inclusion, modular implementation details, etc.

-- leader configuration. These are mapped to <leader> and <localleader>
-- respectively. If using a `funsak` KeyModule, these have somewhat more
-- specific meanings depending on configuration.
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[\]]

-- Basic interface options that are not handled with specific plugin
-- configurations set in interface.lua
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"
vim.opt.backspace = "indent,eol,start"
vim.opt.autoindent = true
vim.opt.startofline = false
vim.opt.confirm = true
vim.opt.visualbell = true
vim.opt.mousemoveevent = true

-- timeout configuration for neovim mappings, affects WhichKey predominantly
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 10
vim.opt.timeoutlen = 60
vim.opt.updatetime = 10

-- set options for nvim completion menu behavior.
vim.opt.completeopt = "menuone,menu,noinsert"

-- turn on default hard word-wrapping and further extend the keys which can wrap
-- at the end of the line.
vim.opt.wrap = true
vim.opt.whichwrap:append("<,>,h,l")

-- the text that it is a part of
vim.opt.breakindent = true
vim.opt.breakindentopt:append("sbr")

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--  * 2023-12-20: this is the neovim default, kickstart also includes it but it is
--  now explicitly included in nightowl.
vim.opt.clipboard = "unnamedplus"

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

-- make ~ be an operator
vim.opt.tildeop = true

-- sign column and number column configuration
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- allow cursorline, this too is generally revamped with a plugin
vim.opt.cursorline = true

-- sets up the max column for syntax detection
-- see `:help synmaxcol`
vim.opt.synmaxcol = 3000

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
vim.opt.showtabline = 2

-- this is a relatively recent addition to neovim core, should probably be
-- enough to replace stickybuf?
if vim.fn.exists("&winfixfbuf") == 1 then
  vim.opt.winfixbuf = true
end

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
  eob = "⮽",
  stl = " ",
  stlnc = " ",
})

vim.cmd.hi("clear SignColumns")

vim.opt.encoding = "utf-8"

vim.opt.filetype = "on"

vim.opt.conceallevel = 3

vim.opt.virtualedit:append({ "block", "insert" })

-- change the shell invocation used within neovim to launch any system calls or
-- subprocess spawns. I normally use nushell, which breaks many bash-compatible
-- commands due to mismatched signature, etc. When already running in neovim, we
-- prefer the cross-compatibility because some plugins may break depending on
-- their implementation/functionality
-- vim.opt.shell = "bash"

-- disable netrw functionality
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
