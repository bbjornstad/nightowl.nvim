local deflang = require("funsak.lazy").lintformat
local srv = require("funsak.lazy").lspsrv

local ret = {
  srv("html", { server = {}, dependencies = {} }),
  unpack(deflang({ "html" }, { "prettier" }, { "eslint_d" })),
  srv("cssls", { server = {}, dependencies = {} }),
}

return ret
