local lz = require("funsak.lazy")

local function efmconfig(opts)
  local languages = require("efmls-configs.defaults").languages()
  local efmls_config = vim.tbl_deep_extend("force", {
    filetypes = vim.tbl_keys(languages),
    settings = {
      rootMarkers = { ".git/" },
      languages = vim.tbl_extend("force", languages, {
        lua = {
          require("efmls-configs.linters.selene"),
        },
      }),
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
    },
  }, opts or {})
  return efmls_config
end

local function contextiveconfig(opts)
  local cfg = vim.tbl_deep_extend("force", {
    path = ".contextive/definitions.yml",
  }, opts or {})
  return cfg
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", {
        efm = efmconfig(),
      }, opts.servers or {})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", {
        contextive = contextiveconfig(),
      }, opts.servers or {})
    end,
  },
  {
    "creativenull/efmls-configs-nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "VeryLazy",
    version = "v1.x.x",
  },
}
