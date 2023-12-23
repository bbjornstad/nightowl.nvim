local lz = require("funsak.lazy")

local ret = {
  lz.lspsrv("html", {server = {}}),
  lz.lspsrv("cssls", {server = {}}),
  lz.lspsrv("tailwindcss", { server = {} }),
  lz.lsplnt({"htmlhint"}, {"html"}),
  lz.lspfmt({ "prettier" }, { "html", "css", "scss", "sass" }),
}

return ret
