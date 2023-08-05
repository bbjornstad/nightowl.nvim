local env = require("environment.ui")

return {
  {
    "bennypowers/nvim-regexplainer",
    config = true,
    opts = {
      popup = {
        border = {
          style = env.borders.main,
          padding = { 1, 2 },
        },
      },
    },
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "tomiis4/hypersonic.nvim",
    config = true,
    opts = {
      border = env.borders.main,
      winblend = 15,
      add_padding = true,
      hl_group = "Keyword",
      wrapping = '"',
      enable_cmdline = true,
    },
    event = "VeryLazy",
  },
}
