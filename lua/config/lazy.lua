local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

local uienv = require("environment.ui")

local lazyconf = {
  spec = {
    -- <Log:2023-10-15> use lazyflex for componentized lazyvim implementation
    -- and provide more configuration.
    {
      "abeldekat/lazyflex.nvim",
      version = "*",
      import = "lazyflex.entry.lazyvim",
      lazy = false,
      cond = true,
      opts = {
        enable_match = false,
        lazyvim = {
          presets = {
            {
              "coding",
              "editor",
              -- if desired, I could theoretically remove the lsp component
              -- here. It would be replaced with lsp-zero
              "lsp",
              "extras",
              "formatting",
              "linting",
              "treesitter",
              "ui",
              "xtras",
            },
          },
        },
        kw = {
          "tokyonight",
          "catppuccin",
          "alpha",
          "bufferline",
          "neo-tree",
          "illuminate",
        },
      },
    },
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        defaults = {
          keymaps = "parliament.config.keymaps",
        },
        icons = {
          diagnostics = uienv.icons.diagnostic,
        },
      },
    },
    -- Extra LazyVim bundled plugin specifications
    -- - language definitions and tooling
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.python-semshi" },
    { import = "lazyvim.plugins.extras.lang.tex" },

    -- lsp tooling
    { import = "lazyvim.plugins.extras.lsp.none-ls" },

    -- - debugging, adapters, and testing
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },
    { import = "lazyvim.plugins.extras.ui.edgy" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.ui.mini-starter" },

    -- - utility tooling
    { import = "lazyvim.plugins.extras.util.project" },
    { import = "lazyvim.plugins.extras.util.dot" },
    { import = "lazyvim.plugins.extras.editor.aerial" },
    { import = "lazyvim.plugins.extras.editor.symbols-outline" },

    -- - ui tooling
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.ui.edgy" },
    { import = "lazyvim.plugins.extras.ui.mini-starter" },

    -- ai tooling
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.coding.codeium" },

    -- user-level plugin configuration
    -- - exists namely to allow for modularziation of the specification
    --   configuration. Ideally, we will offload most of the spec to lazyflex
    --   loaded presets. When that has been achieved, the following will be
    --   uncommented.
    -- { import = "flexspec" },
    { import = "plugins" },
    { import = "plugins.lsp" },
    { import = "plugins.language" },
    { import = "plugins.cmp" },
    { import = "plugins.interface" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    version = false,
  },
  install = {
    colorscheme = {
      "kanagawa",
      "deepwhite",
      "newpaper",
      "rose-pine",
      "sherbet",
    },
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        -- TODO: conditionalize these dynamically based on what specification is
        -- created for the plugins. This may not be possible.
        --
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
    border = uienv.borders.main_accent,
    title_pos = "left",
  },
  diff = "diffview.nvim",
  dev = {
    path = vim.fn.expand("~/prj/nvim-dev"),
    patterns = {},
    fallback = true,
  },
}

require("lazy").setup(lazyconf)
