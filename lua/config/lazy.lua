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
      import = "lazyflex.hook",
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
          -- "alpha",
          "bufferline",
          "neo-tree",
          "illuminate",
          "dashboard",
        },
      },
    },
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        icons = {
          diagnostics = uienv.icons.diagnostic,
        },
      },
    },
    -- Extra LazyVim bundled plugin specifications
    -- We want basically everything that we can stuff into this specification,
    -- so we are enabling almost all of the extra options.
    --  Note that as of more recent versions of LazyVim (nightowl.nvim should be
    --  kept as up to date as possible ideally), the `LazyExtras` command in
    --  neovim provides a popup menu a-la lazy.nvim for (un)installation of any
    --  of the extras. Neat...

    -- ~~ lsp tooling ~~
    { import = "lazyvim.plugins.extras.lsp.none-ls" },

    -- language specification
    -- >>> update 11/13/2023 removed the language options from this list, now to
    -- be managed with the lazyextras builtin. But the rest of this we want to
    -- keep here in config.

    -- - ~~ ui tooling ~~
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.ui.edgy" },
    -- { import = "lazyvim.plugins.extras.ui.mini-starter" },

    -- ~~ formatting and linting ~~
    { import = "lazyvim.plugins.extras.formatting.black" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.linting.eslint" },

    -- - debugging, adapters, and testing
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },

    -- - ~~ utility tooling ~~
    { import = "lazyvim.plugins.extras.util.project" },
    { import = "lazyvim.plugins.extras.util.dot" },
    -- { import = "lazyvim.plugins.extras.editor.aerial" },
    { import = "lazyvim.plugins.extras.editor.symbols-outline" },

    -- ~~ ai tooling ~~
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.coding.codeium" },
    { import = "lazyvim.plugins.extras.coding.tabnine" },

    -- user-level plugin configuration
    -- * exists namely to allow for modularziation of the specification
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
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = {
      "kanagawa",
      "deepwhite",
      "nano",
      "nightcity",
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
    loader = true,
    require = true,
  },
}

require("lazy").setup(lazyconf)
