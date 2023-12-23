local lz = require("funsak.lazy")

return {
  lz.lsplnt("jsonlint", "json"),
  lz.lspfmt("jq", "json"),
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
                  url = "https://github.com/LuaLS/vscode-lua/raw/master/setting/schema.json",
                }
              }
            }),
          }
        }
      })
    end
  },
  -- lz.lspsrv("jsonls", {
  --   server = {
  --     settings = {
  --       json = {
  --         format = { enable = true },
  --       },
  --       validate = { enable = true },
  --       schemas = require("schemastore").json.schemas({
  --         extra = {
  --           {
  --             description = "Lua Language Server Configuration JSON Schema",
  --             fileMatch = ".luarc.json",
  --             name = ".luarc.json",
  --             url = "https://github.com/LuaLS/vscode-lua/raw/master/setting/schema.json",
  --           },
  --         },
  --       }),
  --     },
  --     validate = { enable = true },
  --   },
  --   dependencies = { { "b0o/SchemaStore.nvim" } },
  -- }),
}
