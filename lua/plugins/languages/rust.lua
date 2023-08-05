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
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", {
        rust_analyzer = {
          keys = {
            {
              "K",
              function()
                require("rust-tools").hover_actions.hover_actions()
              end,
              desc = "lsp=> hover (rust edition)",
            },
            {
              "ga",
              function()
                require("rust-tools").code_action_group.code_action_group()
              end,
              desc = "lsp=> code actions (rust edition)",
            },
            {
              "<leader>ca",
              function()
                require("rust-tools").code_action_group.code_action_group()
              end,
              desc = "lsp=> code actions (rust edition)",
            },
          },
        },
      }, opts.servers or {})
    end,
  },
}
