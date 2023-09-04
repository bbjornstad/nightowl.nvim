local env = require("environment.ui")
local default_colorizer = env.identify_highlight
local bg_style = os.getenv("NIGHTOWL_BACKGROUND_STYLE")

if vim.fn.has("termguicolors") then
  vim.cmd([[set termguicolors]])
end

local hl_overrides = {
  TelescopeTitle = { fg = "ui.special", bold = true },
  TelescopePromptNormal = { bg = "ui.bg_p1" },

  TelescopePromptBorder = { fg = "ui.bg_p1", bg = "ui.bg_p1" },
  TelescopeResultsNormal = { fg = "ui.fg_dim", bg = "ui.bg_m1" },
  TelescopeResultsBorder = { fg = "ui.bg_m1", bg = "ui.bg_m1" },
  TelescopePreviewNormal = { bg = "ui.bg_dim" },
  TelescopePreviewBorder = {
    bg = "ui.bg_dim",
    fg = "ui.bg_dim",
  },
  Pmenu = { fg = "ui.shade0", bg = "ui.bg_p1" },
  PmenuSel = { fg = "NONE", bg = "ui.bg_p2" },
  PmenuSbar = { bg = "ui.bg_m1" },
  PmenuThumb = { bg = "ui.bg_p2" },
  InclineNormal = { bg = "ui.bg_p1" },
  InclineNormalNC = { bg = "ui.bg_m2" },
  WinBar = { bg = "ui.bg_p1" },
  WinBarNC = { bg = "ui.bg_p1" },
  DropBarCurrentContext = { bg = "NONE" },
  DropBarMenuCurrentContext = { bg = "NONE" },
  DropBarIconCurrentContext = { bg = "NONE" },
  DropBarPreview = { bg = "NONE" },
  TreeSitterContext = {},
}

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
          InclineNormal = { bg = colors.palette.sumiInk4 },
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
            fg = require("kanagawa.colors").setup({ theme = "wave" }).palette.springViolet2,
          },
          NightowlStartupEntry = {
            bold = false,
            fg = require("kanagawa.colors").setup({ theme = "wave" }).palette.springViolet2,
          },
          NightowlStartupHeader = {
            bold = true,
            fg = require("kanagawa.colors").setup({ theme = "wave" }).palette.waveRed,
          },
          NightowlStartupConvenience = {
            bold = true,
            fg = require("kanagawa.colors").setup({ theme = "wave" }).palette.waveBlue2,
          },
        }
      end,
    },
  },
  {
    "projekt0n/github-nvim-theme",
    config = function(_, opts)
      require("github-theme").setup(opts)
    end,
    lazy = true,
    priority = 901,
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
      }, opts.highlight_groups or {})
    end,
    config = true,
    lazy = true,
    priority = 999,
  },
  {
    "yorik1984/newpaper.nvim",
    priority = 900,
    config = true,
    lazy = true,
    opts = {
      style = bg_style,
    },
  },
  {
    "antonk52/lake.nvim",
    priority = 995,
    lazy = true,
  },
  {
    "Verf/deepwhite.nvim",
    lazy = true,
    priority = 890,
    config = function(_, opts)
      require("deepwhite").setup(opts)
    end,
    opts = {
      low_blue_light = true,
    },
  },
  {
    "wuelnerdotexe/vim-enfocado",
    lazy = true,
    priority = 997,
    config = function()
      vim.g.enfocado_style = "nature"
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
    priority = 996,
    config = function() end,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    priority = 992,
    opts = {},
    config = function(_, opts)
      require("onedarkpro").setup(opts)
    end,
  },

  { "LazyVim/LazyVim", opts = { colorscheme = env.default_colorscheme } },
}
