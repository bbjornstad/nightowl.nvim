local env = require("environment.ui")
local kenv = require("environment.keys").ui
local key_easyread = kenv.easyread
local key_block = kenv.block
local key_hlslens = kenv.hlslens

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
        desc = "hl:| bionic |=> toggle flow-state reading",
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
        desc = "hl:| block |=> toggle",
      },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    opts = {
      auto_enable = true,
      enable_incsearch = true,
      calm_down = true,
      nearest_only = false,
      nearest_float_when = "auto",
      float_shadow_bend = 30,
      virt_priority = 40,
    },
    config = function(_, opts)
      require("hlslens").setup(opts)
    end,
    event = "VeryLazy",
    keys = {
      {
        key_hlslens,
        "<CMD>HlSearchLensToggle<CR>",
        mode = "n",
        desc = "ui:| lens |=> toggle",
      },
    },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = "UIEnter",
    config = function(_, opts)
      local chunk_ft = require("hlchunk.utils.filetype")
      opts.chunk.support_filetypes = vim.list_extend(
        opts.chunk.support_filetypes,
        chunk_ft.support_filetypes
      )
      opts.chunk.exclude_filetypes = vim.list_extend(
        opts.chunk.exclude_filetypes,
        chunk_ft.exclude_filetypes
      )
      require("hlchunk").setup(opts)

      local acmdr =
        require("funsak.autocmd").autocmdr("SpaceportBackgroundFix", true)
      acmdr({ "BufReadPost" }, {
        callback = function(ev)
          vim.cmd([[DisableHL]])
        end,
        -- buffer = true,
        desc = "Disable Spaceport Background HLChunk",
        pattern = "*spaceport*",
      })
    end,
    opts = {
      indent = {
        enable = true,
        chars = { "┆", "┊" },
        style = { fg = require("funsak.colors").dvalue("@comment", "fg") },
      },
      line_num = {
        enable = true,
        use_treesitter = true,
        style = { fg = require("funsak.colors").dvalue("@comment", "fg") },
      },
      blank = {
        enable = true,
        chars = {
          "·",
        },
      },
      chunk = {
        enable = true,
        notify = true,
        use_treesitter = true,
        support_filetypes = {},
        exclude_filetypes = {
          "spaceport",
          "alpha",
          "dashboard",
          "outline",
          "starter",
        },
        chars = {
          horizontal_line = "╌",
          vertical_line = "╎",
          left_top = "┌",
          left_bottom = "└",
          right_arrow = "┤",
        },
        style = {
          { fg = require("funsak.colors").dvalue("DiagnosticInfo", "fg") },
          { fg = require("funsak.colors").dvalue("DiagnosticError", "fg") },
        },
      },
    },
  },
}
