local HLMatcher = require("funsak.colors").HLMatcher

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
  NightowlContextHintsBright = {
    italic = true,
    fg = require("kanagawa.colors").setup({ theme = "wave" }).palette.dragonBlue,
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
  IndentBlanklineWhitespace = { link = "@comment" },
  IndentBlanklineScope = { link = "@comment" },
  IndentBlanklineIndent = { link = "@comment" },
}
