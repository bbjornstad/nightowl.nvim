local key_preview = require("environment.keys").tool.preview

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", {
        typst_lsp = {},
      }, opts.servers or {})
    end,
  },
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
    keys = {
      {
        key_preview,
        "<CMD>TypstWatch<CR>",
        mode = "n",
        desc = "typst=> watch/view PDF",
      },
    },
  },
  {
    "MrPicklePinosaur/typst-conceal.vim",
    ft = { "typst" },
  },
  {
    "niuiic/typst-preview.nvim",
    dependencies = { "niuiic/core.nvim" },
    ft = { "typst" },
    config = function(_, opts)
      require("typst-preview").setup(opts)
    end,
    opts = {},
  },
}
