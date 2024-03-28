return {
  {
    "vhyrro/luarocks.nvim",
    config = function(_, opts)
      require("luarocks").setup(opts)
    end,
    priority = 1002,
    dependencies = {
      "rcarriga/nvim-notify",
    },
  },
  {
    "folke/lazy.nvim",
    opts = function(_, opts)
      local fixer = require("funsak.autocmdr").buffixcmdr("LazyBufFix", true)
      fixer({ "FileType" }, { pattern = "lazy" })
    end,
  },
}
