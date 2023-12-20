local srv = require("funsak.lazy").lspsrv

return {
  {
    "wfxr/protobuf.vim",
    ft = { "proto" },
    init = function() end,
  },
  srv("bufls", { server = {} }),
}
