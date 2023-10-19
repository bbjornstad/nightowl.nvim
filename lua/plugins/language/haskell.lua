local deflang = require('funsak.lazy').language

return {
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    branch = "1.x.x",
    ft = { "haskell", "hl" },
    config = function(_, opts) end
  },
  unpack(deflang("haskell", {
    ormolu = {
      command = "ormolu"
    }
  }, { "hlint" }))
}
