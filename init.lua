-- ----------------------------------------------------------------------------
-- The Rising Sines Project - Neovim Configuration in lua
--
-- This is the standard way of doing things in the neovim framework, so we might
-- as well make the transition.
-- ----------------------------------------------------------------------------
-- ----- Installation of lazy.nvim package manager -----

-- We are required to do this here to hopefully have access to lazy commands on
-- the flipside.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
	"git",
      	"clone",
      	"--filter=blob:none",
      	"https://github.com/folke/lazy.nvim.git",
      	"--branch=stable", -- latest stable release
	lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Main requirements for vim setup below
require('pkgsetup')
require('vimsettings')

-- plugin specific stuff
require('_treesitter')
require('_lspconfig')
require('_telescope')
require('_indentblankline')
require('_nvim-cursorline')
require('_gitsigns')
require('_neogen')
require('_neorg')
require('_orgmode')
require('_trouble')
require('_which-key')
