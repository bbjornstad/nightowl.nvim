local deflang = require("funsak.lazy").lintformat

return {
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    -- branch = "1.x.x",
    ft = { "haskell", "hl" },
    config = function(_, opts) end,
  },
  unpack(deflang("haskell", {
    ormolu = {
      command = "ormolu",
    },
  }, { "hlint" })),
  {
    "mrcjkb/haskell-snippets.nvim",
    ft = { "haskell", "hl" },
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    config = function(_, opts)
      local ls = require("luasnip")
      local snips = require("haskell-snippets").all
      ls.add_snippets("haskell", snips, { key = "haskell" })
    end,
  },
}
