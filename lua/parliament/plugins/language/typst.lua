local lsp = require("funsak.lsp")
local key_preview = require("environment.keys").tool.preview

return {
  lsp.server("typst_lsp", { server = {} }),
  lsp.server("efm", {
    server = function(_)
      local function cfg(_)
        local langs = require("efmls-configs.defaults").languages()
        return {
          settings = {
            languages = vim.tbl_extend("force", langs, {
              typst = require("efmls-configs.formatters.prettypst"),
            }),
          },
        }
      end
      return cfg(_)
    end,
    dependencies = { "creativenull/efmls-configs-nvim" },
  }),
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
