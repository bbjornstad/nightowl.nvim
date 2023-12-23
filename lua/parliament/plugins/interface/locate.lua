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
      vim.o.termguicolors = true
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
        }
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      local defhl = require("funsak.colors").initialize_custom_highlights
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
      enabled = true,
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
    end,
    opts = {
      auto_enable = true,
      exclude_file_types = vim.list_extend(
        env.ft_ignore_list,
        { "mail", "himalaya-email-listing" }
      ),
      minimap_width = 8,
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
    },
  },
  {
    "monkoose/matchparen.nvim",
    cmd = "MatchParenEnable",
    opts = {
      on_startup = true,
      hl_group = "MatchParen",
      augroup_name = "matchparen",
      debounce_time = 100,
    },
    config = function(_, opts)
      require("matchparen").setup(opts)
    end,
    event = "VeryLazy",
    init = function()
      vim.g.loaded_matchparen = 1
    end,
    keys = {
      {
        key_ui.matchparen.enable,
        "<CMD>MatchParenEnable<CR>",
        mode = "n",
        desc = "matchparen=> enable",
      },
      {
        key_ui.matchparen.disable,
        "<CMD>MatchParenDisable<CR>",
        mode = "n",
        desc = "matchparen=> disable",
      },
    },
  },
}
