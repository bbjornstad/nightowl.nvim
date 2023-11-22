local env = require("environment.ui")
local default_colorizer = require("funsak.colors").identify_highlight
local bg_style = vim.env.NIGHTOWL_BACKGROUND_STYLE

if vim.fn.has("termguicolors") then
  vim.cmd([[set termguicolors]])
end

local defhl = require("funsak.colors").initialize_custom_highlights
-- defhl({ "Comment" }, { italic = true })

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      globalStatus = true,
      dimInactive = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = false },
      statementStyle = { bold = true },
      typeStyle = { italic = true },
      background = { dark = "wave", light = "lotus" },
      transparent = false,
      -- overrides some highlighting colors to get a more modern output for some
      -- views.
      overrides = function(colors)
        local theme = colors.theme
        return {
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = {
            bg = theme.ui.bg_dim,
            fg = theme.ui.bg_dim,
          },
          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },
          InclineNormal = { bg = colors.palette.waveBlue1 },
          InclineNormalNC = { bg = colors.palette.sumiInk1 },
          WinBar = { bg = colors.palette.sumiInk4 },
          WinBarNC = { bg = colors.palette.sumiInk4 },
          DropBarCurrentContext = { bg = "NONE" },
          DropBarMenuCurrentContext = { bg = "NONE" },
          DropBarIconCurrentContext = { bg = "NONE" },
          DropBarPreview = { bg = "NONE" },
          BiscuitColor = { link = "NightowlContextHints" },
          TreesitterContextBottom = { underline = true },
          NightowlContextHints = {
            italic = true,
            fg = colors.palette.springViolet2,
          },
          NightowlContextHintsBright = {
            italic = true,
            fg = colors.palette.dragonBlue,
          },
          NightowlStartupEntry = {
            bold = false,
            fg = colors.palette.springViolet2,
          },
          NightowlStartupHeader = {
            bold = true,
            fg = colors.palette.waveRed,
          },
          NightowlStartupConvenience = {
            bold = true,
            fg = colors.palette.waveBlue2,
          },
          IndentBlanklineWhitespace = { link = "@comment" },
          IndentBlanklineScope = { link = "@comment" },
          IndentBlanklineIndent = { link = "@comment" },
        }
      end,
    },
  },
  {
    "lewpoly/sherbet.nvim",
    config = function(_, opts)
      vim.g.sherbet_italic_keywords = opts.italic.keywords or false
      vim.g.sherbet_italic_functions = opts.italic.functions or true
      vim.g.sherbet_italic_comments = opts.italic.comments or true
      vim.g.sherbet_italic_loops = opts.italic.loops or true
      vim.g.sherbet_italic_conditionals = opts.italic.conditionals or true
    end,
    opts = {
      italic = {
        keywords = false,
        functions = true,
        comments = true,
        loops = true,
        conditionals = true,
      },
    },
    lazy = true,
    priority = 997,
  },
  {
    "cryptomilk/nightcity.nvim",
    version = false,
    opts = {
      style = "afterlife",
      terminal_colors = true,
      invert_colors = {
        cursor = true,
        diff = true,
        error = true,
        search = true,
        selection = true,
        signs = false,
        statusline = true,
        tabline = false,
      },
      font_style = {
        comments = {
          italic = true,
        },
        keywords = {
          italic = true,
        },
        functions = {
          bold = true,
        },
        search = {
          bold = true,
        },
      },
      plugins = { default = true },
      on_highlights = function(groups, colors) end,
    },
    config = function(_, opts)
      require("nightcity").setup(opts)
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = function(_, opts)
      local rppal = require("rose-pine.palette")
      opts.variant = "auto" or opts.variant
      opts.dark_variant = "main" or opts.dark_variant
      opts.highlight_groups = vim.tbl_deep_extend("force", {
        TelescopeTitle = { fg = rppal.text, bold = true },
        TelescopePromptNormal = { bg = rppal.surface },
        TelescopePromptBorder = { fg = rppal.base, bg = rppal.base },
        TelescopeResultsNormal = { fg = rppal.text, bg = rppal.nc },
        TelescopeResultsBorder = { fg = rppal.base, bg = rppal.base },
        TelescopePreviewNormal = { bg = rppal.nc },
        TelescopePreviewBorder = {
          bg = rppal.base,
          fg = rppal.base,
        },
        Pmenu = { fg = rppal.rose, bg = rppal.base },
        PmenuSel = { fg = "NONE", bg = rppal.surface },
        PmenuSbar = { bg = rppal.muted },
        PmenuThumb = { bg = rppal.overlay },
        InclineNormal = { bg = rppal.surface },
        InclineNormalNC = { bg = rppal.base },
        WinBar = { bg = rppal.surface },
        WinBarNC = { bg = rppal.base },
        BiscuitColor = { link = "@comment" },
        DropBarCurrentContext = { bg = "NONE" },
        DropBarMenuCurrentContext = { bg = "NONE" },
        DropBarIconCurrentContext = { bg = "NONE" },
        DropBarPreview = { bg = "NONE" },
        TreesitterContextBottom = { underline = true },
        NightowlContextHints = {
          italic = true,
          fg = default_colorizer("@punctuation"),
        },
        IndentBlanklineWhitespace = { link = "@comment" },
        IndentBlanklineScope = { link = "@comment" },
        IndentBlanklineIndent = { link = "@comment" },
      }, opts.highlight_groups or {})
    end,
    config = true,
    lazy = true,
    priority = 999,
  },
  {
    "yorik1984/newpaper.nvim",
    priority = 900,
    config = function(_, opts)
      require("newpaper").setup(opts)
    end,
    lazy = true,
    opts = {
      style = bg_style,
    },
  },
  {
    "Verf/deepwhite.nvim",
    lazy = true,
    priority = 890,
    config = function(_, opts)
      local dw_accent = "#E5E5E5"
      defhl({ "TreesitterContextBottom" }, { fg = dw_accent, underline = true })
      defhl({ "NightowlContextHints" }, { italic = true, fg = dw_accent })
      defhl({ "WinSeparator" }, { fg = dw_accent })
      require("deepwhite").setup(opts)
    end,
    opts = {
      low_blue_light = true,
    },
  },
  {
    "roobert/palette.nvim",
    config = function(_, opts)
      require("palette").setup(opts)
    end,
    opts = {
      palettes = {},
      custom_palettes = {
        main = {
          ["kanagawa-wave"] = {},
          ["kanagawa-lotus"] = {},
          ["deepwhite"] = {},
          ["nano"] = {},
          ["hagoromo"] = {},
        },
      },
      caching = true,
      cache_dir = {
        vim.fn.stdpath("cache") .. "/palette",
      },
    },
    event = "VeryLazy",
  },
  {
    "ronisbr/nano-theme.nvim",
    config = function(_, opts)
      vim.o.background = opts.background.override and opts.background.style
        or (vim.o.background or "light")
    end,
    opts = {
      background = {
        override = false,
        style = "light",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        local bg = bg_style or "dark"
        if bg == "light" then
          require(env.colorscheme.light).load()
        else
          require(env.colorscheme.dark).load()
        end
      end,
    },
  },
}
