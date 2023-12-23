local recurser = require("funsak.wrap").recurser

local M = {}

---@alias NightowlHighlightSpec table

M.__highlights__ = {
  TelescopeTitle = {},
  TelescopePromptNormal = {},
  TelescopePromptBorder = {},
  TelescopeResultsNormal = {},
  TelescopeResultsBorder = {},
  TelescopePreviewNormal = {},
  TelescopePreviewBorder = {},
  Pmenu = {},
  PmenuSel = {},
  PmenuSbar = {},
  PmenuThumb = {},
  InclineNormal = {},
  InclineNormalNC = {},
  WinBar = {},
  WinBarNC = {},
  DropBarCurrentContext = {},
  DropBarMenuCurrentContext = {},
  DropBarIconCurrentContext = {},
  DropBarPreview = {},
  BiscuitColor = {},
  TreesitterContextBottom = {},
  NightowlContextHints = {},
  NightowlContextHintsBright = {},
  NightowlStartupEntry = {},
  NightowlStartupHeader = {},
  NightowlStartupConvenience = {},
  IndentBlanklineWhitespace = {},
  IndentBlanklineScope = {},
  IndentBlanklineIndent = {},
}
M.__highlights__.__index = M.__highlights__

M.__schemes__ = {
  kanagawa = {},
  deepwhite = {},
  ["nano-theme"] = {},
  ["rose-pine"] = {},
  sherbet = {},
  palettee = {},
}

function M.__highlights__:new(opts)
  M.__schemes__ = M.__schemes__
end

--- internal helper to register a new highlight definition amongst the rest
---@param cls table highlight definitions by scheme mapping.
---@param scheme string name of the colorscheme to register this highlight to
---@param hl string name of the highlight group
---@param definition NightowlHighlightSpec highlight group definition mapping
function M.__highlights__.register_highlight(cls, scheme, hl, definition)
  local prev = cls[hl] or {}
  M.__highlights__[hl] =
    vim.tbl_deep_extend("force", prev, { [scheme] = definition })
end

--- registers a new highlight target to the internal highlights by scheme
--- mapping. Registered highlights are indexed by the target or current
--- colorscheme to determine the final set of highlights applied.
---@param hl string name of the target highlights
---@param schemes string | string[] name of the colorscheme or schemes for which
---this highlight is registered.
---@param definition NightowlHighlightSpec highlight group definition mapping
function M.__highlights__:register(hl, schemes, definition)
  local fn = recurser(M.__highlights__.register_highlight, true)
  fn(self, schemes, hl, definition)
end

function M.get_colors(options)
  local colors = {
    base0 = "#1A1918", -- hsv(30, 8%, 10%)
    base1 = "#595855", -- hsv(45, 4%, 35%)
    base2 = "#807E79", -- hsv(43, 5%, 50%)
    base3 = "#999791", -- hsv(45, 5%, 60%)
    base4 = "#B3B1AD", -- hsv(40, 3%, 70%)
    base5 = "#CCCBC6", -- hsv(50, 3%, 80%)
    base6 = "#E6E4DF", -- hsv(43, 3%, 90%)
    base7 = "#FAF2EB", -- hsv(24, 4%, 98%)

    light_orange = "#FAE1C8", -- hsv(30, 20%, 98%)
    light_yellow = "#FAFAC8", -- hsv(60, 20%, 98%)
    light_cyan = "#C8FAFA", -- hsv(180, 20%, 98%)
    light_green = "#D4FAD4", -- hsv(120, 15%, 98%)
    light_blue = "#D4D4FA", -- hsv(240, 15%, 98%)
    light_purple = "#EDD4FA", -- hsv(280, 15%, 98%)
    light_pink = "#FAD4ED", -- hsv(320, 15%, 98%)
    light_red = "#FAD4D4", -- hsv(360, 15%, 98%)

    orange = "#F27900", -- hsv(30, 100%, 95%)
    yellow = "#F2F200", -- hsv(60, 100%, 95%)
    cyan = "#00F2F2", -- hsv(180, 100%, 95%)
    green = "#00F200", -- hsv(120, 100%, 95%)
    blue = "#0000A6", -- hsv(240, 100%, 65%)
    purple = "#6F00A6", -- hsv(280, 100%, 65%)
    pink = "#A6006F", -- hsv(320, 100%, 65%)
    red = "#A60000", -- hsv(360, 100%, 65%)
  }
  if options.low_blue_light then
    colors.base7 = "#FAFAFA" -- hsv(60, 0%, 98%)
  end
  return colors
end

local HLMatcher = require("funsak.colors").HLMatcher

local function highlights(colors)
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
    NightowlContextHintsBright = { link = "DiagnosticHint" },
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
end
