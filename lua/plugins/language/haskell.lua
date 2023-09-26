local def = require('uutils.lazy').lang

return {
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    branch = "1.x.x",
    ft = { "haskell", "hl" },
    config = function(_, opts)
      def({"haskell", "hl"}, "stylish_haskell", "hlint")
    end
  },
}
