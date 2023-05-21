local env = require("environment.ui")

return {
  {
    "rebelot/kanagawa.nvim",
    opts = function(_, opts)
      table.insert(opts, env.colorscheme.setup)
    end,
  },
  { "navarasu/onedark.nvim", opts = { style = "warmer" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "kanagawa" } },
}
