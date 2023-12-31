local lsp = require("funsak.lsp")

return {
  {
    "wfxr/protobuf.vim",
    ft = { "proto" },
    init = function() end,
  },
  lsp.server("bufls", { server = {} }),
  lsp.formatters({ buf = { "buf" } }),
}
