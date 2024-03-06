local lsp = require("funsak.lsp")

return {
  {
    "pest-parser/pest.vim",
    ft = { "pest" },
  },
  lsp.server("pest_ls", {
    setup = {
      handler = function()
        require("pest-vim").setup({})
      end,
    },
    dependencies = { "pest-parser/pest.vim" },
  }),
}
