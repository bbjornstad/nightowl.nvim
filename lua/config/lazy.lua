local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
          "bufferline",
          -- "neo-tree",
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

    -- ui tooling
    { import = "lazyvim.plugins.extras.ui.edgy" },

    -- formatting and linting
    { import = "lazyvim.plugins.extras.formatting.black" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.linting.eslint" },

    -- debugging, adapters, and testing
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },

    -- utility tooling
    { import = "lazyvim.plugins.extras.util.project" },
    { import = "lazyvim.plugins.extras.util.dot" },
    { import = "lazyvim.plugins.extras.editor.symbols-outline" },

    --  ai tooling
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.coding.codeium" },
    { import = "lazyvim.plugins.extras.coding.tabnine" },

    -- user-level plugin configuration
    { import = "plugins" },
    { import = "plugins.lsp" },
    { import = "plugins.language" },
    { import = "plugins.cmp" },
    { import = "plugins.interface" },
  },
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
      "nightcity",
      "newpaper",
      "rose-pine",
      "sherbet",
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
}

require("lazy").setup(lazyconf)
