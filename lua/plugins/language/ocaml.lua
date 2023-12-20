local lz = require("funsak.lazy")

return {
  {
    "tjdevries/ocaml.nvim",
    build = ":lua require('ocaml').update()",
    ft = { "ocaml" },
    opts = {},
    config = function(_, opts)
      require("ocaml").setup(opts)
    end,
  },
  lz.lspsrv("ocamllsp", {
    server = {
      get_language_id = function(_, ftype)
        return ftype
      end,
    },
  }),
}
