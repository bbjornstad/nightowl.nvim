local lz = require("funsak.lazy")

return {
  {
    "wfxr/protobuf.vim",
    ft = { "proto" },
    init = function() end,
  },
  lz.lspsrv("bufls", { server = {} }),
}
