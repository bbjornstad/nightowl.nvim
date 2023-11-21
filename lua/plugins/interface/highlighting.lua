local env = require("environment.ui")
local kenv = require("environment.keys").ui
local key_easyread = kenv.easyread
local key_block = kenv.block

return {
  {
    "winston0410/range-highlight.nvim",
    event = "BufWinEnter",
    config = function() end,
  },
  {
    "m-demare/hlargs.nvim",
    opts = {
      highlight = {
        link = "@float",
      },
      excluded_filetypes = env.ft_ignore_list,
      extras = { named_parameters = true },
    },
    config = function(_, opts)
      require("hlargs").setup(opts)
    end,
    event = "VeryLazy",
  },
  {
    "tzachar/highlight-undo.nvim",
    config = true,
    enabled = true,
    opts = {
      keymaps = {
        { "n", "u", "undo", {} },
        { "n", "<C-r>", "redo", {} },
      },
    },
    event = "VeryLazy",
  },
  {
    "tzachar/local-highlight.nvim",
    opts = {
      disable_file_types = { "markdown" },
    },
    config = true,
    event = "VeryLazy",
  },
  {
    "HampusHauffman/bionic.nvim",
    cmd = { "Bionic", "BionicOn", "BionicOff" },
    keys = {
      {
        key_easyread,
        "<CMD>Bionic<CR>",
        mode = { "n" },
        desc = "bionic=> toggle flow-state bionic reading",
      },
    },
  },
  {
    "HampusHauffman/block.nvim",
    opts = {
      percent = 1.1,
      depth = 8,
      automatic = true,
    },
    config = true,
    cmd = { "Block", "BlockOn", "BlockOff" },
    keys = {
      {
        key_block,
        "<CMD>Block<CR>",
        mode = "n",
        desc = "block=> toggle block highlighting",
      },
    },
  },
}
