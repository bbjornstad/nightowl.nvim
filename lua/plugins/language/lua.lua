local lz = require("funsak.lazy")
local preq = require("funsak.masquerade").preq
local masonry = lz.masonry
local deflang = lz.lintformat

return {
  unpack(deflang("lua", "stylua", "selene")),
  masonry(
    { name = "lua_ls", lang = "lua" },
    "server",
    preq("lsp-zero").nvim_lua_ls() or {},
    { { "VonHeikemen/lsp-zero.nvim", optional = true } }
  ),
}
