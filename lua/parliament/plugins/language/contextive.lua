local lsp = require("funsak.lsp")

-- local owlang = vim.tbl_map(lsp.util.get_efmls_target, {
--   lua = { "linters.selene", "formatters.stylua" },
--   rust = { "formatters.rustfmt" },
--   css = { "linters.stylelint", "formatters.prettier" },
--   scss = { "linters.stylelint", "formatters.prettier" },
--   less = { "linters.stylelint", "formatters.prettier" },
--   sass = { "linters.stylelint", "formatters.prettier" },
-- })
--
-- local function efmconfig(opts)
--   local languages = require("efmls-configs.defaults").languages()
--   languages["Blade"] = {}
--   languages["blade"] = {}
--   local efmls_config = vim.tbl_deep_extend("force", {
--     filetypes = vim.tbl_keys(owlang),
--     settings = {
--       rootMarkers = {
--         ".neoconf.json",
--         ".git/",
--         ".contextive/",
--         "/prj/*",
--         "/prsc/*",
--       },
--       languages = owlang,
--     },
--     init_options = {
--       documentFormatting = true,
--       documentRangeFormatting = true,
--       hover = true,
--       documentSymbol = true,
--       codeAction = true,
--       completion = true,
--     },
--   }, opts or {})
--   return efmls_config
-- end
--
local function contextiveconfig(opts)
  local cfg = vim.tbl_deep_extend("force", {
    settings = {
      contextive = {
        path = ".contextive/definitions.yml",
      },
    },
  }, opts or {})
  return cfg
end

return {
  -- lsp.server("efm", {
  --   server = function(_, opts)
  --     return efmconfig(opts)
  --   end,
  --   dependencies = {
  --     "creativenull/efmls-configs-nvim",
  --   },
  -- }),
  lsp.server("contextive", {
    server = function(_, opts)
      return contextiveconfig(opts)
    end,
  }),
  -- {
  --   "creativenull/efmls-configs-nvim",
  --   dependencies = { "neovim/nvim-lspconfig" },
  --   event = "LspAttach",
  -- },
}
