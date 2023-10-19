local env = require("environment.ui")
local opt = require("environment.optional")
local kenv = require("environment.keys")
local kcolors = require("funsak.colors").kanacolors

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
    },
    event = "VeryLazy",
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
        priority = 1024,
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
    "edluffy/specs.nvim",
    enabled = opt.specs.enable,
    config = true,
    opts = function()
      local opts = {
        show_jumps = true,
        min_jump = 30,
        popup = {
          delay_ms = 0,
          inc_ms = 30,
          blend = 10,
          width = 30,
          winhl = "CmpCompletionSel",
          fader = require("specs").linear_fader,
          resizer = require("specs").shrink_resizer,
        },
        ignore_filetypes = env.ft_ignore_list,
        ignore_buftypes = {
          nofile = true,
        },
      }
      return opts
    end,
    keys = {
      {
        "gC",
        function()
          require("specs").show_specs()
        end,
        mode = "n",
        desc = "specs=> show location flare",
      },
      {
        "gCs",
        function()
          require("specs").show_specs()
        end,
        mode = "n",
        desc = "specs=> show location flare",
      },
      {
        "gCt",
        function()
          require("specs").toggle()
        end,
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
    "gorbit99/codewindow.nvim",
    event = "LspAttach",
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
      minimap_width = 16,
      window_border = env.borders.main,
    },
  },
}
