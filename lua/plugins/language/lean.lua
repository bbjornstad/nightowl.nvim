return {
  {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
    ft = { "lean" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      lsp = {
        -- these should already be set correctly because my lsp settings are
        -- setup.
        on_attach = function() end,
      },
    },
  },
}
