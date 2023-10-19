-- vim: set ft=lua: -0-
local env = require("environment.ui")
local stems = require("environment.keys")

return {
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        marks = false,
        registers = true,
      },
      window = {
        border = env.borders.main,
        position = "top",
        winblend = 25,
        zindex = 80,
      },
      triggers_nowait = {
        "g",
        "gc",
        "gz",
        "g`",
        "g'", -- registers '"',
        "<c-r>",
        -- spelling
        -- "z=",
        "z",
        "Z",
      },
      documentation = {
        view = "hover",
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
      icons = {
        breadcrumb = "󰶻",
        separator = "",
        group = " ",
      },
      defaults = {
        [stems:leader()] = { name = "+nvim core fxns" },
        [stems.editor:leader()] = { name = "+metadata/special editor cmds" },
        [stems.time:leader()] = { name = "+task/time management" },
        [stems.ai:leader()] = { name = "+ai and language models" },
        [stems.repl:leader()] = { name = "+repl-style" },
        [stems.fuzzy:leader()] = { name = "+fuzzy find with fzf" },
        [stems.buffer:leader()] = { name = "+quitbuf utilities" },
        [stems.scope:leader()] = { name = "+fuzzy find with telescope" },
        [stems.ui:leader()] = { name = "+user interface" },
        [stems.code:leader()] = { name = "+act on code" },
        [stems.fuzzy:leader()] = { name = "+fuzzy find with fzf" },
        [stems.fm:leader()] = { name = "+file managers" },
      },
    },
    keys = {
      {
        "<C-g>h",
        "<CMD>WhichKey '' i<CR>",
        mode = "i",
        desc = "which=> key help",
      },
    },
  },
  {
    "jokajak/keyseer.nvim",
    opts = {},
    config = function(_, opts)
      require("keyseer").setup(opts)
    end,
    version = false,
    keys = {
      {
        stems.metakey.keyseer,
        "<CMD>KeySeer<CR>",
        mode = "n",
        desc = "seer=> keys mapped",
      },
    },
    cmd = "KeySeer",
  },
}
