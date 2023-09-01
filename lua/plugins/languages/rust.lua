local env = require("environment.ui")

return {
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
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
          require("rust-tools.executors").toggleterm,
        },
      },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function(_, opts)
  --     opts.servers = vim.tbl_deep_extend("force", {
  --       rust_analyzer = {},
  --     }, opts.servers or {})
  --   end,
  -- },
}
