local env = require("environment.ui")
local keystems = require("environment.keys").stems.base

return {
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        marks = true,
        registers = true,
      },
      window = {
        border = env.borders.alt,
        position = "top",
        winblend = 25,
        zindex = 80,
      },
      triggers_nowait = {
        "g`",
        "g'",
        -- registers
        '"',
        "<c-r>",
        -- spelling
        "z=",
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
      defaults = {
        [keystems.core] = { name = "+nvim core fxns" },
        [keystems.editor] = { name = "+metadata/special editor cmds" },
        [keystems.tasks] = { name = "+task/time management" },
        [keystems.ai] = { name = "+ai and language models" },
        [keystems.repl] = { name = "+repl-style" }, -- TODO Add a few more of these baseline name mappings -- directly onto the which-key configuration here.
        [keystems.fuzzy] = { name = "+fuzzy find with fzf" },
        [keystems.buffers] = { name = "+quitbuf utilities" },
        [keystems.telescope] = { name = "+fuzzy find with telescope" },
        [keystems.ui] = { name = "+user interface" },
        [keystems.code] = { name = "+act on code" },
      },
    },
  },
}
