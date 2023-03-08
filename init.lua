-- ----------------------------------------------------------------------------
-- The Rising Sines Project - Neovim Configuration in lua

-- This is the standard way of doing things in the neovim framework, so we
-- might as well make the transition.
-- -----------------------------------------------------------------------

-- the following file contains the definitions of some server-level materials
-- related to neovim package/update/plugin distribution. It will install
-- Lazy.nvim if it does not already exist, and will update otherwise assuming
-- that option is correctly set (which I think is true by default)
--require('_catppuccin')

-- Main requirements for vim setup below
require('pkgsetup')
require('vimsettings')
require('_nvim-dap')

-- plugin specific stuff
require('_treesitter')
require('_lspconfig')
require('_nvim-tree')
require('_telescope')
require('_trouble')
require('_noice')
require('_indentblankline')
require('_nvim-cursorline')
require('_vista')
require('_mini')
require('_gitsigns')
require('_neorg')
require('_orgmode')
require('_neogen')
require('_ufo')
require('_nvim-lualine')
require('_ccc')
require('autocmd')
require('keymappings')
require('modelineset')

