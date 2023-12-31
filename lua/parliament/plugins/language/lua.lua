local lsp = require("funsak.lsp")
local preq = require("funsak.masquerade").preq

return {
  lsp.server("lua_ls", {
    server = preq("lsp-zero").nvim_lua_ls({
      settings = {
        Lua = {
          codeLens = {
            enable = true,
          },
        },
      },
    }),
  }),
  lsp.linters({ lua = { "selene" } }),
  lsp.formatters({ lua = { "stylua" } }),
  {
    "folke/neoconf.nvim",
    opts = {
      plugins = {
        lua_ls = {
          enabled_for_neovim_config = true,
          enabled = true,
        },
      },
    },
  },
}
