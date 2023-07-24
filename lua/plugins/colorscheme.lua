local env = require("environment.ui")

if vim.fn.has("termguicolors") then
  vim.cmd([[set termguicolors]])
end

local function hlursa(overrides)
  -- each item of overrides is a key-value pair where the keyname is the
  -- highlight group and the value is a table with assignments in string name
  -- form, along with an optional colordef_section key which is removed and is
  -- used to pick the section of the "colors" table we need to parse out.
  local function inner_hl(opts)
    -- in this case that would be the opts table passed into this function
    local hlink = opts.link_highlight or nil
    -- this is either "theme" or "palette", and identifies the subsection of the
    -- colorscheme that should be removed. When more colorschemes are accepted,
    -- this is then going to be the union of all possible subdesignations.
    local colordef_section = opts.colordef_section or "theme"
    -- we need to toss these elements because of the fact that they are not
    -- well-defined inputs for the final format, but we needed them to infer
    -- behavior. moreover, there is impetus to do it this way to play nicely
    -- with the vim.tbl_map function.
    opts.link_highlight = nil
    opts.colordef_section = nil

    if hlink ~= nil then
      return { link = hlink }
    end
  end

  local function genfunc(colors, overrides)
    return function(colors)
      return vim.tbl_map(inner_hl, overrides)
    end
  end

  return vim.tbl_map(inner_hl, overrides)
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
  DropBarCurrentContext = { link = "TreesitterContext" },
  DropBarMenuCurrentContext = { link = "TreesitterContext" },
  DropBarIconCurrentContext = { link = "TreesitterContext" },
  DropBarPreview = { link = "TreesitterContext" },
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
          DropBarCurrentContext = { link = "TreesitterContext" },
          DropBarMenuCurrentContext = { link = "TreesitterContext" },
          DropBarIconCurrentContext = { link = "TreesitterContext" },
          DropBarPreview = { link = "TreesitterContext" },
          CustomContextVT = { fg = colors.palette.lightBlue, italic = true },
          BiscuitColor = { fg = colors.palette.lightBlue, italic = true },
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
      }, opts.syntax or {})
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
      }, opts.overwrite or {})
    end,
  },
  { "dasupradyumna/midnight.nvim", lazy = true, priority = 994 },
  {
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup({})
    end,
    lazy = true,
    priority = 999,
  },
  {
    "olimorris/onedarkpro.nvim",
    config = function()
      -- require("onedark").load()
    end,
    lazy = true,
    priority = 990,
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
      }, opts.highlight_groups or {})
    end,
    config = true,
    lazy = true,
    priority = 996,
  },
  {
    "sainnhe/everforest",
    lazy = true,
    priority = 992,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 1
      vim.cmd([[colorscheme everforest]])
    end,
  },
  {
    "yorik1984/newpaper.nvim",
    config = true,
    opts = {
      style = "light",
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = env.default_colorscheme } },
}
