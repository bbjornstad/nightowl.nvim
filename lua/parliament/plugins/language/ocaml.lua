local lsp = require("funsak.lsp")

return {
  {
    "tjdevries/ocaml.nvim",
    build = ":lua require('ocaml').update()",
    ft = { "ocaml" },
    opts = {},
    config = function(_, opts)
      require("ocaml").setup()
    end,
  },
  lsp.server("ocamllsp", {
    server = {
      get_language_id = function(_, ftype)
        return ftype
      end,
    },
  }),
  lsp.formatters({ ocaml = { "ocamlformat" } }),
}
