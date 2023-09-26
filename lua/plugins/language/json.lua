local masonry = require("uutils.lazy").masonry

return {
  masonry({ name = "jsonls", lang = "json" }, {
    schemas = require('schemastore').json.schemas({
      extra = {
        {
          description = "Lua Language Server Configuration JSON Schema",
          fileMatch = ".luarc.json",
          name = ".luarc.json",
          url =
          "https://github.com/LuaLS/vscode-lua/raw/master/setting/schema.json",
        },
      }
    }),
    validate = { enable = true },
  }),
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   dependencies = { "neovim/nvim-lspconfig", "b0o/SchemaStore.nvim" },
  --   opts = function(_, opts)
  --     opts = vim.tbl_deep_extend("force", opts, {
  --       handlers = {
  --         jsonls = function()
  --           require("lspconfig").jsonls.setup({
  --             settings = {
  --               json = {
  --                 schemas = require("schemastore").json.schemas({
  --                   extra = {
  --                     {
  --                       description = "Lua Language Server Configuration JSON Schema",
  --                       fileMatch = ".luarc.json",
  --                       name = ".luarc.json",
  --                       url = "https://github.com/LuaLS/vscode-lua/raw/master/setting/schema.json",
  --                     },
  --                   },
  --                 }),
  --                 validate = { enable = true },
  --               },
  --             },
  --           })
  --         end,
  --       },
  --     })
  --   end,
  -- },
}
