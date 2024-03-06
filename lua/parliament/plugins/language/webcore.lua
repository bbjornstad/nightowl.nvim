local lsp = require("funsak.lsp")

local ret = {
  lsp.server("html", { server = {} }),
  lsp.linters(
    lsp.per_ft("htmlhint", { "html" }),
    { mason_nvim_lint = { enable = false } }
  ),
  lsp.formatters(lsp.per_ft("prettier", { "html", "css", "scss", "sass" })),

  lsp.server("cssls", { server = {} }),
  lsp.server("tailwindcss", { server = {} }),
}

return ret
