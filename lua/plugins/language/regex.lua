local env = require("environment.ui")
local key_regex = require("environment.keys").tool.regex

return {
  {
    "bennypowers/nvim-regexplainer",
    config = true,
    ft = {
      "html",
      "js",
      "cjs",
      "mjs",
      "ts",
      "jsx",
      "tsx",
      "cjsx",
      "mjsx",
    },
    cmd = {
      "Regexplainer",
      "RegexplainerShowSplit",
      "RegexplainerShowPopup",
      "RegexplainerToggle",
    },
    opts = {
      mode = "narrative",
      display = "popup",
      auto = true,
      filetypes = {
        "html",
        "js",
        "cjs",
        "mjs",
        "ts",
        "jsx",
        "tsx",
        "cjsx",
        "mjsx",
      },
      popup = {
        border = {
          style = env.borders.main,
          padding = { 1, 2 },
        },
      },
    },
    keys = {
      {
        key_regex .. "r",
        "<CMD>RegexplainerToggle<CR>",
        mode = "n",
        desc = "regex=> explain",
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "tomiis4/hypersonic.nvim",
    config = true,
    event = "CmdlineEnter",
    cmd = "Hypersonic",
    opts = {
      border = env.borders.main,
      winblend = 15,
      add_padding = true,
      hl_group = "Keyword",
      wrapping = '"',
      enable_cmdline = true,
    },
    keys = {
      {
        key_regex .. "h",
        "<CMD>Hypersonic<CR>",
        mode = { "n", "v" },
        desc = "regex=> hypersonic",
      },
    },
  },
}
