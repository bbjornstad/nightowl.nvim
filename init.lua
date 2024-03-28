-- SPDX-FileCopyrightText: 2023 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2023 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "parliament.nvim" kickstart version of nightowl.nvim neovim
---configuration setup. The goal is to make neovim capable of doing anything.
---@author Bailey Bjornstad | ursa-major
---@license MIT

-- parliament.nvim: A neovim configuration of the highest order, in fact, the
-- prestige here is so great that

-- we have to be very careful what we include here using a require call. This is
-- an easy place to accidentally create a circular dependency.
local uienv = require("environment.ui")

-- Install `lazy.nvim` plugin manager
-- ==================================
-- https://github.com/folke/lazy.nvim
--`:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    -- latest stable release
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- setting options
-- ===============
-- See `:help vim.o`
-- NOTE: The default kickstart.nvim sets all of its options in this init.lua
-- file, I prefer to have them separated in file structure, so as to keep a
-- simple modular approach and style across the entire configuration structure.
require("parliament.config.options")

-- Configure Plugins
-- =================
-- NOTE: Here is where you install your plugins. You can configure plugins using
-- the `config` key. You can also configure plugins after the setup call, as
-- they will be available in your neovim runtime.
require("lazy").setup({
  {
    "abeldekat/lazyflex.nvim",
    version = "*",
    cond = true,
    import = "lazyflex.hook",
    opts = {},
  },
  -- this imports all additional plugins that are not covered by the four core
  -- components below. It is necessary to load these first, as they contain the
  -- colorscheme plugins which must be loaded first according to lazy.nvim
  -- specifications for usage.
  { import = "parliament.plugins" },

  -- the following sets up the core components that are a part of the
  -- nightowl.nvim configuration. These are the most important to have correct
  { import = "parliament.plugins.interface" },
  { import = "parliament.plugins.lsp" },
  { import = "parliament.plugins.cmp" },
  { import = "parliament.plugins.language" },
}, {
  defaults = {
    -- LazyVim and lazy.nvim by default do not lazy load user-specified
    -- plugins. Because of the sheer volume contained here, we really benefit
    -- from having this set to true instead
    lazy = true,
    -- allow for the most up-to-date versions for git plugins
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
  -- TODO: the below RTP plugin manipulations are somewhat problematic from the
  -- modularity perspective. As far as I can tell, they are required to be put
  -- into this specification instead of a self-contained one or better,
  -- modularly spread out according to language definitions.
  performance = {
    rtp = {
      paths = {
        -- ocaml
        "/home/ursa-major/.opam/default/share/ocp-indent/vim",
        vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazyflex.nvim"),
        vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "fzf"),
      },
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
      task = "",
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

-- ─[ Basic Keymaps ]────────────────────────────────────────────────────
--  =================
require("parliament.config.keymaps")

-- ─[ Basic Autocommands ]───────────────────────────────────────────────
--  ======================
require("parliament.config.autocmds")

-- ─[ Setup Colorscheme ]────────────────────────────────────────────────
--  =====================
local loader = uienv.load_scheme
local bg = os.getenv("NIGHTOWL_BACKGROUND") or "dark"
vim.opt.background = bg
loader(uienv.colorscheme[bg], { suppress_warning = false })
