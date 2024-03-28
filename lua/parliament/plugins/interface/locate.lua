local env = require("environment.ui")
local kcolors = require("funsak.colors").kanacolors
local key_ui = require("environment.keys").ui

local default_class_separator_style = {
  fgColor = "#7AA89F",
  char = "⬩",
  width = tonumber(vim.o.colorcolumn) or 80,
  name = "ClassSeparator",
}
local default_func_separator_style = {
  fgColor = "#7E9CD8",
  char = "⌁",
  width = tonumber(vim.o.colorcolumn) or 80,
  name = "FuncSeparator",
}

return {
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
      line_opacity = 0.10,
    },
    event = "VeryLazy",
  },
  {
    "mawkler/modicator.nvim",
    dependencies = {
      "rebelot/kanagawa.nvim",
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("modicator").setup(opts)
    end,
    init = function()
      -- these are required options for this plugin. They are also set in the
      -- main options file, but this is helpful for modularity.
      vim.o.cursorline = true
      vim.o.number = true
      -- vim.o.termguicolors = true
    end,
    opts = {
      show_warnings = true,
      highlights = {
        defaults = {
          bold = true,
        },
      },
      integration = {
        lualine = {
          enabled = true,
          highlight = "bg",
        },
      },
    },
  },
  {
    "yamatsum/nvim-cursorline",
    event = "VeryLazy",
    opts = {
      cursorline = { enable = true, timeout = 300, number = false },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
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
    "gorbit99/codewindow.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      local cw = require("codewindow")
      cw.setup(opts)
      cw.apply_default_keybinds()
      vim.api.nvim_set_hl(0, "CodewindowBackground", { blend = 50 })
    end,
    opts = {
      auto_enable = true,
      exclude_file_types = vim.list_extend(
        env.ft_ignore_list,
        { "mail", "himalaya-email-listing" }
      ),
      minimap_width = 8,
      screen_bounds = "background",
      window_border = env.borders.alt,
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("virt-column").setup(opts)
    end,
    opts = {
      enabled = true,
      char = "╵",
      virtcolumn = table.concat(env.column_rulers or { "+1" }, ","),
      exclude = {
        filetypes = env.ft_ignore_list,
      },
    },
  },
  {
    "CWood-sdf/melon.nvim",
    opts = {
      ignore = function(_)
        return false
      end,
      signOpts = {
        texthl = "NightowlMelonSigns",
      },
    },
    config = function(_, opts)
      require("melon").setup(opts)
    end,
    event = "VeryLazy",
  },
}
