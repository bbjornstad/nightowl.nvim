local lsp = require("funsak.lsp")

return {
  lsp.server("zls", { setup = { handler = lsp.noop } }),
  lsp.formatters({ zig = { "zigfmt" } }),
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
