local lz = require("funsak.lazy")
local preq = require("funsak.masquerade").preq

return {
  lz.lspsrv("lua_ls", {
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
  lz.lsplnt({ "selene" }, "lua"),
  lz.lspfmt({ "stylua" }, "lua"),
}
