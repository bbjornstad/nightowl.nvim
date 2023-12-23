local lz = require('funsak.lazy')
local key_preview = require("environment.keys").tool.preview

return {
  lz.lspsrv("typst_lsp", { server = {} }),
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
