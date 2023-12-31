local env = require("environment.ui")
local lsp = require('funsak.lsp')

return {
  lsp.server("rust_analyzer", { handler = lsp.noop }),
  lsp.formatters(lsp.per_ft("rustfmt", { "rust", "rs" })),
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    init = function()
      vim.g.rust_recommended_style = 1
    end,
    opts = {
      tools = {
        inlay_hints = {
          auto = true,
          max_len_align = true,
        },
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
    version = "^3",
    ft = { "rust", "rs" },
  },
}
