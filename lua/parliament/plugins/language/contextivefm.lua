local lsp = require("funsak.lsp")

local function efmconfig(opts)
  local languages = require("efmls-configs.defaults").languages()
  local efmls_config = vim.tbl_deep_extend("force", {
    filetypes = vim.tbl_keys(languages),
    settings = {
      rootMarkers = {
        ".neoconf.json",
        ".git/",
        ".contextive/",
        "/prj/*",
        "/prsc/*",
      },
      languages = languages,
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
      hover = true,
      documentSymbol = true,
      codeAction = true,
      completion = true,
    },
  }, opts or {})
  return efmls_config
end

local function contextiveconfig(opts)
  local cfg = vim.tbl_deep_extend("force", {
    settings = {
      contextive = {
        path = ".contextive/definitions.yaml",
      },
    },
  }, opts or {})
  return cfg
end

return {
  lsp.server("efm", {
    server = function(_, opts)
      return efmconfig(opts)
    end,
    dependencies = {
      "creativenull/efmls-configs-nvim",
    },
  }),
  lsp.server("contextive", {
    server = function(_, opts)
      return contextiveconfig(opts)
    end,
  }),
  {
    "creativenull/efmls-configs-nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "LspAttach",
  },
}
