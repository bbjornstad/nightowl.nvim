local def = require('uutils.lazy').lang

return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap"
    },
    ft = { "scala", "scl"},
    config = function(_, opts)

    end
  },
  {
    "softinio/scaladex.nvim",
    ft = { "scala", "scl" },
  },
}
