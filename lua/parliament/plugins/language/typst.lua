local lsp = require("funsak.lsp")
local key_preview = require("environment.keys").tool.preview

return {
  lsp.server("typst_lsp", { server = {} }),
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
    keys = {
      {
        key_preview,
        "<CMD>TypstWatch<CR>",
        mode = "n",
        desc = "typst:| view |=> PDF",
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
