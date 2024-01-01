local deflang = require("funsak.lazy").lintformat
local lz = require("funsak.lazy")

return {
  {
    "Glench/Vim-Jinja2-Syntax",
    ft = { "jinja", "jinja2" },
  },
  {
    "HiPhish/jinja.vim",
    config = function(_, opts)
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.html",
        command = "jinja#AdjustFiletype()",
      })
    end,
    ft = { "jinja", "jinja2" },
  },
  lz.lsplnt({ "djlint", "curlylint" }, { "jinja", "jinja2" }),
  lz.lsplnt({ "curlylint" }, { "liquid" }),
  lz.lspfmt("djlint", { "jinja", "jinja2" }),
}
