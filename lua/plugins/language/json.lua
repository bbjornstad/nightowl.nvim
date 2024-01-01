local deflang = require("funsak.lazy").lintformat
local lz = require("funsak.lazy")

return {
  unpack(deflang("json", "jq", "jsonlint")),
  lz.lsplnt("jsonlint", "json"),
  lz.lspfmt("jq", "json"),
  lz.lspsrv("jsonls", {
    server = {
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
      validate = { enable = true },
    },
    dependencies = { { "b0o/SchemaStore.nvim" } },
  }),
}
