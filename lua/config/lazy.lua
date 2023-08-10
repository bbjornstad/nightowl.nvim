local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local uienv = require("environment.ui")

local lazyconf = {
  spec = {
    -- add LazyVim and import its plugins
    -- edit: 2023-08-09 added personal fork to remove neo-tree
    -- incompatibilities.
    -- { "bbjornstad/nvimparliament", dev = false, import = "lazyvim.plugins" },
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.elixir" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.util.project" },
    { import = "lazyvim.plugins.extras.ui.edgy" },
    -- import/override with your plugins
    { import = "plugins" },
    { import = "plugins.languages" },
    { import = "plugins.interface" },
    { import = "plugins.cmp" },
    { import = "plugins.lsp" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    version = false,
  },
  install = {
    colorscheme = { "kanagawa", "rose-pine", "github-theme", "newpaper" },
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = { border = uienv.borders.main_accent },
  diff = "diffview.nvim",
  debug = false,
}

local function genspec(conf)
  local aienv = require("environment.ai")
  if aienv.enabled.copilot then
    table.insert(
      conf.spec,
      { { import = "lazyvim.plugins.extras.coding.copilot" } }
    )
  end
end

genspec(lazyconf)

require("lazy").setup(lazyconf)
