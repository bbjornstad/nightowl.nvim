local masonry = require("funsak.lazy").masonry
local deflang = require("funsak.lazy").lintformat

return {
  masonry({ name = "jsonls", lang = "json" }, "server", {
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
    validate = { enable = true },
  }),
  unpack(deflang("json", "jq", "jsonlint")),
}
