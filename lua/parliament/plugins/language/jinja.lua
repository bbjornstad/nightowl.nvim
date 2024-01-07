local lsp = require("funsak.lsp")

return {
  {
    "Glench/Vim-Jinja2-Syntax",
    ft = { "jinja", "jinja2" },
  },
  {
    "HiPhish/jinja.vim",
    config = function(_, opts) end,
    ft = { "jinja", "jinja2" },
  },
  lsp.linters(lsp.per_ft("curlylint", { "liquid" })),
  lsp.linters(lsp.per_ft({ "djlint", "curlylint" }, { "jinja", "jinja2" })),
  lsp.formatters(lsp.per_ft("djlint", { "jinja", "jinja2" })),
}
