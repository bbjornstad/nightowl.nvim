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
      "nvim-lualine/lualine.nvim",
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
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      local defhl = require("funsak.colors").set_hl_multi
      defhl({
        "IndentBlanklineWhitespace",
        "IndentBlanklineScope",
        "IndentBlanklineIndent",
      }, { link = "@comment" })
      require("ibl").setup(opts)
    end,
    init = function()
      vim.opt.list = true
      vim.opt.listchars:append("space:·")
      vim.opt.listchars:append("eol:↴")
      vim.opt.listchars:append("tab:  ⏗")
      vim.opt.showbreak = "⊧ "
    end,
    opts = {
      enabled = false,
      debounce = 400,
      indent = {
        char = "┆",
        highlight = "IndentBlanklineIndent",
      },
      whitespace = {
        highlight = "IndentBlanklineWhitespace",
      },
      scope = {
        enabled = true,
        char = "",
        show_end = true,
        show_start = true,
        injected_languages = true,
        priority = 100,
        highlight = "IndentBlanklineScope",
      },
      exclude = {
        filetypes = env.ft_ignore_list,
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
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      pairs = {
        { "(", ")" },
        { "{", "}" },
        { "[", "]" },
        { "<", ">" },
      },
      delay = 50,
      limit = 60,
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
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
    end,
    opts = {
      indent = {
        enable = true,
        chars = { "┆", "┊" },
        style = require("funsak.colors").dvalue("@comment", "fg"),
      },
      line_num = {
        enable = true,
        use_treesitter = true,
        style = require("funsak.colors").dvalue("@text.environment", "fg"),
      },
      blank = {
        enable = false,
        chars = {
          "․",
        },
      },
      chunk = {
        enable = true,
        notify = true,
        use_treesitter = true,
        support_filetypes = {},
        exclude_filetypes = {},
        chars = {
          horizontal_line = "-",
          vertical_line = "|",
          left_top = "-",
          left_bottom = "-",
          right_arrow = ">",
        },
        style = {
          { fg = require("funsak.colors").dvalue("DiagnosticInfo", "fg") },
          { fg = require("funsak.colors").dvalue("DiagnosticError", "fg") },
        },
      },
    },
  },
}
