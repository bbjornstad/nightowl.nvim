local env = {}
--------------------------------------------------------------------------------
-- UI: Borders
-- ===========
-- Spec is that the main border should be shadow. We want this to apply to all
-- borders that are not made by mason or lazy, the package management tools.
-- Those receive the alt border, which is the double.
env.borders = {}
env.borders.main = "shadow"
env.borders.alt = "solid"
env.borders.main_accent = "double"

env.ai = {}
env.ai.enabled = {
  copilot = os.getenv("NVIM_ENABLE_COPILOT"),
  cmp_ai = false,
  chatgpt = true,
  codegpt = true,
  neural = true,
  neoai = true,
  hfcc = true,
  tabnine = true,
  codeium = true,
}

env.telescope = {}
env.telescope.theme = "ivy"

env.navic = {}
env.navic.opts = {}

env.bufferline = {}
env.bufferline.tab_format = "slant"

env.enable_vim_strict = false

env.enable_lsp_signature = false
--------------------------------------------------------------------------------
-- UI: Colorscheme Options
-- ===========
--
env.colorscheme = {}
env.colorscheme.setup = {
  --function(_, opts)
  --  opts = vim.tbl_deep_extend("force", {
  globalStatus = true,
  dimInactive = true,
  commentStyle = { italic = false },
  keywordStyle = { italic = false },
  statementStyle = { bold = true },
  typeStyle = { italic = false },
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
      InclineNormal = { bg = colors.palette.lotusInk2 },
      InclineNormalNC = { bg = colors.palette.lotusViolet2 },
    }
  end,
}
--opts)
--end

return env
