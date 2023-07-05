local env = require("environment.ui")

local function ursa_highlights(colors) end
local linemapper = {
  tundra = "tundra",
  kanagawa = "kanagawa",
  default = "auto",
}

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      --function(_, opts)
      --  opts = vim.tbl_deep_extend("force", {
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
          WinBarNC = { bg = colors.palette.sumiInk1 },
          -- Nvim-Navic
          -- NavicIconsFile = { fg = theme.syn.punct },
          -- NavicIconsModule = { fg = theme.syn.operator },
          -- NavicIconsNamespace = { fg = theme.syn.punct },
          -- NavicIconsPackage = { fg = theme.ui.special },
          -- NavicIconsClass = { fg = theme.syn.constant },
          -- NavicIconsMethod = { fg = theme.syn.fun },
          -- NavicIconsProperty = { fg = theme.syn.type },
          -- NavicIconsField = { fg = theme.diag.hint },
          -- NavicIconsConstructor = { fg = theme.syn.constant },
          -- NavicIconsEnum = { fg = theme.syn.regex },
          -- NavicIconsInterface = { fg = theme.syn.identifier },
          -- NavicIconsFunction = { fg = theme.syn.fun },
          -- NavicIconsVariable = { fg = theme.syn.statement },
          -- NavicIconsConstant = { fg = theme.syn.statement },
          -- NavicIconsString = { fg = theme.syn.string },
          -- NavicIconsNumber = { fg = theme.syn.number },
          -- NavicIconsBoolean = { fg = theme.syn.constant },
          -- NavicIconsArray = { fg = theme.syn.type },
          -- NavicIconsObject = { fg = theme.syn.constant },
          -- NavicIconsKey = { fg = theme.syn.statement },
          -- NavicIconsNull = { fg = theme.syn.identifier },
          -- NavicIconsEnumMember = { fg = theme.syn.identifier },
          -- NavicIconsStruct = { fg = theme.syn.constant },
          -- NavicIconsEvent = { fg = theme.syn.constant },
          -- NavicIconsOperator = { fg = theme.syn.punct },
          -- NavicIconsTypeParameter = { fg = theme.syn.special1 },
          -- NavicText = { fg = theme.ui.fg },
          -- NavicSeparator = { fg = theme.ui.fg },
        }
      end,
    },
  },
  {
    "sam4llis/nvim-tundra",
    lazy = true,
    priority = 993,
    config = function(_, opts)
      opts.transparent_background = false
      opts.dim_inactive_windows = vim.tbl_extend("force", {
        enabled = false,
        color = nil,
      }, opts.dim_inactive_windows or {})
      opts.sidebars = vim.tbl_extend("force", {
        enabled = true,
        color = nil,
      }, opts.sidebars or {})
      opts.diagnostics = vim.tbl_extend("force", {
        errors = {},
        warnings = {},
        information = {},
        hints = {},
      }, opts.diagnostics or {})
      opts.syntax = vim.tbl_extend("force", {
        booleans = { bold = true, italic = false },
        comments = { bold = false, italic = true },
        operators = { bold = true },
        types = { italic = true },
      })
      opts.plugins = vim.tbl_extend("force", {
        lsp = true,
        treesitter = true,
        telescope = true,
        cmp = true,
        context = true,
        gitsigns = true,
        neogit = true,
      }, opts.plugins or {})
      opts.overwrite = vim.tbl_extend("force", {
        colors = {},
        highlights = {},
      })
    end,
  },
  { "dasupradyumna/midnight.nvim", lazy = true, priority = 994 },
  {
    "projekt0n/github-nvim-theme",
    -- Dance would do me dirty every day like that so color me impressed.
    config = function()
      require("github-theme").setup({})
    end,
    lazy = true,
    priority = 999,
  },
  {
    "navarasu/onedark.nvim",
    config = function()
      -- require("onedark").load()
    end,
    lazy = true,
    priority = 997,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({})
    end,
    lazy = true,
    priority = 996,
  },
  {
    "NLKNguyen/papercolor-theme",
    priority = 998,
    lazy = true,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = true,
    priority = 995,
    config = function()
      -- require("nordic").load()
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = env.default_colorscheme } },
}
