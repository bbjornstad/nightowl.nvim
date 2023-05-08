local env = require("environment.ui")

return {
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require(env.colorscheme.name).setup(env.colorscheme.setup)
    end,
  },
  { "navarasu/onedark.nvim", opts = { style = "warmer" } },
  {
    "cocopon/iceberg.vim",
    config = function()
      vim.cmd("colorscheme iceberg")
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = env.colorscheme.name } },
}
