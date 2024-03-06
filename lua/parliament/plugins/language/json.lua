local env = require("environment.ui")
local lsp = require("funsak.lsp")
local lz = require("funsak.lazy")

return {
  lsp.server("jsonls", {
    server = function()
      return {
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
                url = "https://github.com/LuaLS/vscode-lua/raw/master/setting/schema.json",
              },
            },
          }),
        },
      }
    end,
    dependencies = { "b0o/SchemaStore.nvim" },
  }),
  lsp.linters(lsp.per_ft("jsonlint", { "json" })),
  lsp.formatters(lsp.per_ft("jq", { "json" })),
}
