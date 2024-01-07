local lsp = require("funsak.lsp")
return {
  {
    "imsnif/kdl.vim",
    ft = "kdl",
    init = function() end,
  },
  lsp.server("efm", {
    server = function(_)
      local codespell = require("efmls-configs.linters.codespell")
      local vale = require("efmls-configs.linters.vale")
      local function kdl(_)
        return {
          filetypes = { "kdl" },
          settings = {
            languages = {
              kdl = {
                lsp.util.efmls({ "linters.codespell", "linters.vale" }),
              },
            },
          },
        }
      end
    end,
  }),
}
