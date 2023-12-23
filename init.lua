---@module "parliament.nvim" kickstart version of nightowl.nvim neovim
---configuration setup. The goal is to make neovim capable of doing anything.
---@author Bailey Bjornstad | ursa-major
---@license not settled yet.

-- we have to be very careful what we include here using a require call. This is
-- an easy place to accidentally create a circular dependency.
local uienv = require('environment.ui')

-- [[ Install `lazy.nvim` plugin manager ]]
-- ========================================
-- https://github.com/folke/lazy.nvim
--`:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Setting options ]]
-- =====================
-- See `:help vim.o`
--
-- NOTE: The default kickstart.nvim sets all of its options in this init.lua
-- file, I prefer to have them separated in file structure, so as to keep a
-- simple modular approach and style across the entire configuration structure.
require('parliament.config.options')

-- [[ Configure plugins ]]
-- =======================
-- NOTE: Here is where you install your plugins. You can configure plugins using
-- the `config` key. You can also configure plugins after the setup call, as
-- they will be available in your neovim runtime.
require('lazy').setup({
  -- these are a couple of extra plugin specifications that are included with
  -- kickstart.nvim, might as well use them since they do replace some of the
  -- functionality previously preconfigured with lazyvim.
  require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- this imports all additional plugins that are not covered by the four core
  -- components below. It is necessary to load these first, as they contain the
  -- colorscheme plugins which must be loaded first according to lazy.nvim
  -- specifications for usage.
  { import = 'parliament.plugins' },

  -- the following sets up the core components that are a part of the
  -- nightowl.nvim configuration. These are the most important to have correct
  { import = 'parliament.plugins.interface' },
  { import = 'parliament.plugins.lsp' },
  { import = 'parliament.plugins.cmp' },
  { import = 'parliament.plugins.language' },

  -- these

  -- the below is unlikely to be used all that much but it does exist if
  -- desired, so technically we could put additional plugins in here. This seems
  -- highly superfluous though, given that we overhauled with our own custom
  -- directory. It probably just makes the most sense to remove this line in the
  -- long run
  { import = 'custom.plugins' },
}, {
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins
    -- will load during startup. If you know what you're doing, you can set this
    -- to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    version = false,
  },
  install = {
    colorscheme = {
      "kanagawa",
      "deepwhite",
      "nano",
      "newpaper",
      "rose-pine",
    },
  },
  checker = { enabled = true },
  performance = {
    rtp = {
      paths = { "/home/ursa-major/.opam/default/share/ocp-indent/vim" },
      disabled_plugins = {
        -- these are disabled based on the fact that we are including other,
        -- plugins which are more powerful matchparen implementations and are
        -- written in lua (these might be written in lua too, idk the internals
        -- of neovim well enough).
        "matchit",
        "matchparen",

        -- these are always disabled.
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = uienv.borders.alt,
    title = " ::lazy: package manager",
    title_pos = "left",
    icons = vim.tbl_deep_extend("force", {
      cmd = " ",
      config = " ",
      event = " ",
      ft = " ",
      new = "󱍕 ",
      import = "󱀯 ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "● ",
      not_loaded = "○ ",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = "✔ ",
      list = {
        "⋄",
        "⇀",
        "⟐",
        "‒",
      },
    }, uienv.icons.kinds),
  },
  diff = "diffview.nvim",
  dev = {
    path = vim.fn.expand("~/prj/nvim-dev"),
    patterns = {},
    fallback = true,
  },
  profiling = {
    loader = false,
    require = false,
  },
})

-- [[ Basic Keymaps ]]
-- ===================
require('parliament.config.keymaps')

-- [[ Basic Autocommands ]]
-- ========================
require('parliament.config.autocmds')

-- vim: ts=2 sts=2 sw=2 et
