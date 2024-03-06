local env = require("environment.ui")
local key_regex = require("environment.keys").tool.regex

return {
  {
    "tomiis4/hypersonic.nvim",
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
    -- event = "CmdlineEnter",
    cmd = "Hypersonic",
    opts = {
      border = env.borders.main,
      winblend = 15,
      add_padding = true,
      hl_group = "Keyword",
      wrapping = "\"",
      enable_cmdline = true,
    },
    keys = {
      {
        key_regex.hypersonic,
        "<CMD>Hypersonic<CR>",
        mode = { "n", "v" },
        desc = "regex=> hypersonic",
      },
    },
  },
}
