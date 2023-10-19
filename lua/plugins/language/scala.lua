local deflang = require('funsak.lazy').language

return {
  unpack(deflang({ "scala", "scl" }, { "scalafmt" }, {})),
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap"
    },
    ft = { "scala", "scl" },
    config = function(_, opts) end
  },
  {
    "softinio/scaladex.nvim",
    ft = { "scala", "scl" },
  },
}
