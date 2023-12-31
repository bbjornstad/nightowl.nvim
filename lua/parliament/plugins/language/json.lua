local lz = require("funsak.lazy")
local lsp = require("funsak.lsp")


return {
  lsp.linters(lsp.per_ft("jsonlint", { "json"})),
  lsp.formatters(lsp.per_ft("jq", { "json" })),
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        jsonls = {
          settings = {
            json = {
              format = { enable = true },
            },
            validate = { enable = true },
            schemas = require("schemastore").json.schemas({
              extra = {
                {
                  description = "Lua Language Server Configuration JSON Schema",
                  fileMatch = ".luarc.json",
                  name = ".luarc.json",
                  url =
                  "https://github.com/LuaLS/vscode-lua/raw/master/setting/schema.json",
                }
              }
            }),
          }
        }
      })
    end
  },
}
