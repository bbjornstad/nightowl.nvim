local lz = require("funsak.lazy")

return {
  lz.lspfmt("zigfmt", { "zig" }),
  {
    "neovim/nvim-lspconfig",
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
    opts = function(_, opts)
      opts.setup = vim.tbl_deep_extend("force", {
        zls = require("lsp-zero").noop,
      }, opts.setup or {})
    end,
  },
  {
    "NTBBloodbath/zig-tools.nvim",
    ft = "zig",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      require("zig-tools").setup(opts)
    end,
    opts = {
      integrations = {
        zls = {
          hints = true,
          management = {
            enable = true,
          },
        },
      },
    },
  },
}
