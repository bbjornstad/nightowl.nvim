local lsp = require("funsak.lsp")
return {
  {
    "imsnif/kdl.vim",
    ft = "kdl",
    init = function() end,
  },
  -- lsp.server("efm", {
  --   server = function(_, opts)
  --     local function kdl(o)
  --       return vim.tbl_deep_extend("force", {
  --         filetypes = { "kdl" },
  --         settings = {
  --           languages = {
  --             kdl = {
  --               lsp.util.get_efmls_target({
  --                 "linters.codespell",
  --                 "linters.vale",
  --               }),
  --             },
  --           },
  --         },
  --       }, o or {})
  --     end
  --     return kdl(opts)
  --   end,
  -- }),
}
