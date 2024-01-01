local env = require("environment.ui")
local default_colorizer = require("funsak.colors").identify_highlight
local comp = require("funsak.colors").component
local bg_style = vim.env.NIGHTOWL_BACKGROUND_STYLE

if vim.fn.has("termguicolors") then
  vim.cmd([[set termguicolors]])
end

local defhl = require("funsak.colors").initialize_custom_highlights

local REQUIRED_HLS = {
  telescope = {
    "TelescopeTitle",
    "TelescopePromptNormal",
    "TelescopePromptBorder",
    "TelescopeResultsNormal",
    "TelescopeResultsBorder",
    "TelescopePreviewNormal",
    "TelescopePreviewBorder",
  },
  incline = {
    "InclineNormal",
    "InclineNormalNC",
  },
  dropbar = {
    "WinBar",
    "WinBarNC",
    "DropBarCurrentContext",
    "DropBarMenuCurrentContext",
    "DropBarIconCurrentContext",
    "DropBarPreview,",
  },
  context_hint = {
    "BiscuitColor",
    "TreesitterContextBottom",
    "NightowlContextHints",
    "NightowlContextHintsBright",
    "NightowlStartupHeader",
    "NightowlStartupEntry",
    "NightowlStartupConvenience",
  },
  indent_blankline = {
    "IndentBlanklineWhitespace",
    "IndentBlanklineIndent",
    "IndentBlanklineScope",
  },
}

local function hl_scheme_segments(scheme)
  return function(colors)
    colors = type(colors) == "function" and colors() or colors
  end
end

local function initialize_required_hl_defaults(skip)
  skip = skip or {}
end

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
        local pcol = colors.palette
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
          InclineNormal = { bg = theme.ui.bg_p2 },
          InclineNormalNC = { bg = theme.ui.bg_dim },
          WinBar = { bg = pcol.sumiInk4 },
          WinBarNC = { bg = pcol.sumiInk4 },
          DropBarCurrentContext = { bg = "NONE" },
          DropBarMenuCurrentContext = { bg = "NONE" },
          DropBarIconCurrentContext = { bg = "NONE" },
          DropBarPreview = { bg = "NONE" },
          BiscuitColor = { link = "NightowlContextHints" },
          TreesitterContextBottom = { underline = true },
          NightowlContextHints = {
            italic = true,
            fg = pcol.winterGreen,
          },
          NightowlContextHintsBright = {
            italic = true,
            fg = pcol.winterYellow,
          },
          NightowlStartupEntry = {
            bold = true,
            fg = pcol.springViolet2,
          },
          NightowlStartupHeader = {
            bold = true,
            fg = pcol.springViolet1,
          },
          NightowlStartupConvenience = {
            bold = false,
            fg = pcol.waveBlue2,
          },
          IndentBlanklineWhitespace = { link = "@comment" },
          IndentBlanklineScope = { link = "@comment" },
          IndentBlanklineIndent = { link = "@comment" },
        }
      end,
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      require('kanagawa').load("wave")
    end
  },
  {
    "cryptomilk/nightcity.nvim",
    priority = 950,
    enabled = true,
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
      on_highlights = function(groups, colors)
        groups.IndentBlanklineWhitespace = comp("Conceal", { "fg" })
        groups.IndentBlanklineScope = comp("Conceal", { "fg" })
        groups.IndentBlanklineIndent = comp("Conceal", { "fg" })

        groups.NightowlContextHints = comp("SignColumn", { "bg", "fg" })
        groups.NightowlContextHintsBright = comp("@repeat", { "bg", "fg" })
        groups.NightowlStartupEntry = comp("LspInlayHint", { "bg", "fg" })
        groups.NightowlStartupHeader = comp("@number", { "bg", "fg" })
        groups.NightowlStartupConvenience =
            comp("DashboardShortCut", { "bg", "fg" })
      end,
    },
    config = function(_, opts)
      require("nightcity").setup(opts)
    end,
  },
  {
    "rose-pine/neovim",
    enabled = true,
    name = "rose-pine",
    opts = function(_, opts)
      local rppal = require("rose-pine.palette")
      opts.variant = "auto" or opts.variant
      opts.dark_variant = "moon" or opts.dark_variant
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
    priority = 960,
  },
  {
    "Verf/deepwhite.nvim",
    priority = 990,
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
    priority = 980,
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
          -- TODO: Add an implementation for the "hagoromo" colorscheme.
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
    priority = 970,
    config = function(_, opts) end,
    opts = {
      background = {
        override = false,
        style = "light",
      },
    },
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = true,
    priority = 950,
    config = function(_, opts)
      require("everforest").setup(opts)
    end,
    opts = {
      background = "soft",
      sign_column_background = "grey",
      ui_contrast = "low",
      float_style = "dim",
      on_highlights = function(hl, palette) end,
    },
  },
  {
    "bbjornstad/hagoromo.nvim",
    dev = true,
    enabled = false,
    priority = 1001,
    opts = {},
    config = function(_, opts)
      require("hagoromo").setup(opts)
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    config = function(_, opts)
      require("nightfox").setup(opts)
    end,
    opts = {
      styles = {
        comments = "italic",
        functions = "bold",
        constants = "bold",
        keywords = "bold",
      },
      module_default = true,
    },
    priority = 800,
    lazy = true,
  },
  {
    "yorik1984/newpaper.nvim",
    config = function(_, opts)
      require("newpaper").setup(opts)
    end,
    priority = 790,
    opts = {
      style = bg_style ~= nil and bg_style or "dark",
      editor_better_view = true,
      keywords = "bold",
      doc_keywords = "bold,italic",
      error_highlight = "undercurl",
      saturation = -0.2,
      italic_strings = false,
      italic_comments = true,
      italic_doc_comments = true,
      italic_functions = true,
      italic_variables = false,
      borders = true,
    },
    lazy = true,
  },
  {
    "katawful/kat.nvim",
    tag = "3.1",
    config = false,
  }
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = function()
  --       local bg = bg_style or "dark"
  --       if bg == "light" then
  --         local has, pkg = pcall(require, env.colorscheme.light)
  --         local ok, res
  --         if has then
  --           ok, res = pcall(pkg.load)
  --         else
  --           ok, res = false, nil
  --         end
  --         if not ok then
  --           vim.cmd.colorscheme(env.colorscheme.light)
  --         end
  --       else
  --         local has, pkg = pcall(require, env.colorscheme.dark)
  --         local ok, res
  --         if has then
  --           ok, res = pcall(pkg.load)
  --         else
  --           ok, res = pcall(require(env.colorscheme.dark).load)
  --         end
  --         if not ok then
  --           vim.cmd.colorscheme(env.colorscheme.dark)
  --         end
  --       end
  --     end,
  --   },
  -- },
}
