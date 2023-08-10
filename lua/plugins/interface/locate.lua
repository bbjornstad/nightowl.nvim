local kcolors = require("environment.ui").kanacolors
local function decelerator() end

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
      cursorline = { enable = true, timeout = 500, number = false },
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
    event = "VeryLazy",
    opts = {
      blend = 20,
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
  {
    "nacro90/numb.nvim",
    config = true,
    event = "VeryLazy",
    opts = {
      show_numbers = true,
      show_cursorline = true,
      hide_relativenumbers = true,
      number_only = false,
      centered_peeking = true,
    },
  },
  {
    "sitiom/nvim-numbertoggle",
    event = "VeryLazy",
  },
  {
    "rainbowhxch/accelerated-jk.nvim",
    event = "VeryLazy",
    opts = {
      mode = "time_driven",
      enable_deceleration = false,
      acceleration_motions = { "j", "k", "e", "w", "b" },
      acceleration_limit = 120,
      acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
      -- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
      deceleration_table = { { 150, 9999 } },
    },
    config = true,
  },
}
