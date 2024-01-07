local env = require("environment.ui")
local lsp = require("funsak.lsp")

return {
  lsp.server("rust_analyzer", { handler = lsp.noop }),
  lsp.formatters(lsp.per_ft("rustfmt", { "rust", "rs" })),
  {
    "Saecki/crates.nvim",
    event = { "BufReadPre *Cargo.toml*", "BufReadPre *cargo.toml*" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      require("crates").setup(opts)
    end,
    opts = {
      smart_insert = true,
      insert_closing_quote = true,
      autoload = true,
      autoupdate = true,
      autoupdate_throttle = 500,
      thousands_separator = ",",
      text = {
        loading = "   Loading",
        version = "   %s",
        prerelease = "  󰐩 %s",
        yanked = "   %s",
        nomatch = "   No match",
        upgrade = "  󰚰 %s",
        error = "  󰅝 Error fetching crate",
      },
      popup = {
        border = env.borders.main,
        padding = 2,
      },
      null_ls = {
        enabled = false,
      },
      src = {
        cmp = {
          kind_text = {
            version = "ver",
            feature = "feat",
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = vim.list_extend(opts.sources or {}, {
        { name = "crates", group_index = 1 },
      })
    end,
  },
  {
    "vxpm/ferris.nvim",
    opts = {
      create_commands = true,
      url_handler = "xdg-open",
    },
    ft = { "rust", "rs" },
  },
  {
    "mrcjkb/rustaceanvim",
    -- version = "^3",
    ft = { "rust", "rs" },
    config = function(_, opts)
      vim.g.rust_recommended_style = 1
      vim.g.rustaceanvim = opts
    end,
    opts = {
      tools = {
        hover_actions = {
          border = env.borders.main,
          auto_focus = true,
        },
        executor = {
          function(...)
            require("rust-tools.executors").toggleterm(...)
          end,
        },
      },
    },
  },
}
