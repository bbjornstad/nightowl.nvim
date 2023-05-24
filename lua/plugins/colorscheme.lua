local env = require("environment.ui")

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = env.colorscheme.setup,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "kanagawa" } },
}
