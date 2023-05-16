local env = require("environment.ui")

return {
  { "rebelot/kanagawa.nvim", opts = env.colorscheme.setup },
  { "navarasu/onedark.nvim", opts = { style = "warmer" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "kanagawa" } },
}
