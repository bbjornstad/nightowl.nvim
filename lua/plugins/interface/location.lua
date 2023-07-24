local kcolors = require("environment.ui").kanacolors

return {
  {
    "winston0410/range-highlight.nvim",
    config = function() end,
    event = "VeryLazy",
  },
  {
    "mvllow/modes.nvim",
    tag = "v0.2.0",
    config = true,
    opts = {
      colors = kcolors({
        copy = "boatYellow2",
        delete = "peachRed",
        insert = "springBlue",
        visual = "springViolet1",
      }),
    },
    event = "VeryLazy",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      vim.opt.list = true
      vim.opt.listchars:append("space:⋅")
      vim.opt.listchars:append("eol:↴")
    end,
    opts = {
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = true,
    },
  },
  {
    "yamatsum/nvim-cursorline",
    event = "VeryLazy",
    opts = {
      cursorline = { enable = true, timeout = 1000, number = false },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
    },
  },
  {
    "edluffy/specs.nvim",
    config = true,
    opts = {
      blend = 60,
      width = 8,
      winhl = "PMenu",
    },
    keys = {
      {
        "<leader>uS",
        "<CMD>lua require('specs').toggle()<CR>",
        mode = "n",
        desc = "specs=> toggle location flare",
      },
    },
  },
}
