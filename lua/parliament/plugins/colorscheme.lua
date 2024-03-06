-- SPDX-FileCopyrightText: 2025 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "parliament.plugins.colorscheme" colorscheme setup for parliamentary
---neovim configurations
---@author Bailey Bjornstad | ursa-major
---@license MIT

local env = require("environment.ui")
local default_colorizer = require("funsak.colors").identify_highlight
local comp = require("funsak.colors").component
local hlval = require("funsak.colors").dvalue
local conv = require("funsak.convert")
local lz = require("funsak.lazy")
local bg_style = os.getenv("NIGHTOWL_BACKGROUND")
local scheme_sel = os.getenv("NIGHTOWL_COLORSCHEME")
local key_ui = require("environment.keys").ui
local key_scope = require("environment.keys").scope

local function importcs()
  local res = require("schemes.pineapple")
  vim.notify(vim.inspect(res))
  return type(res) == "table" and res or {}
end

if conv.bool_from_env("NIGHTOWL_DEBUG") then
  local cmdr = require("funsak.autocmd").autocmdr("Nightowl_ColorschemeInfo")
  cmdr({ "UIEnter" }, {
    callback = function(ev)
      lz.info("Selected Background: " .. bg_style)
      lz.info("Selected Colorscheme: " .. scheme_sel)
    end,
  })
end

-- warn if there is not a background designation set in the corresponding
-- environment variable.
if not bg_style then
  lz.info([[This configuration is missing a background specification in the
    environment. You can set the background using the NIGHTOWL_BACKGROUND
    environment variable, which accepts two possible values: "light" or "dark".
    Without setting this variable, defaults to "dark"]])
end

local defhl = require("funsak.colors").set_hls

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

-- set up an autocommand to make sure that on change of colorscheme, we actually
-- go forward and apply the highlights that are necessary for functioning
-- without erroring all over the map.

local function autocmdr(group_name, group_opts)
  group_opts = group_opts or {}
  local augroup_opts = group_opts.augroup or {}
  augroup_opts = vim.tbl_deep_extend("force", { clear = true }, augroup_opts)
  return function(events, handler, specopts)
    specopts = specopts or {}
    vim.api.nvim_create_autocmd(
      events,
      vim.tbl_deep_extend("force", vim.is_callable(handler) and {
        group = vim.api.nvim_create_augroup(group_name, augroup_opts),
        callback = handler,
      } or {
        group = vim.api.nvim_create_augroup(group_name, augroup_opts),
        command = handler,
      }, specopts)
    )
  end
end

local cs_autocmdr =
  require("funsak.autocmd").autocmdr("RequiredHighlight", true)

local brush = require("funsak.paint")
cs_autocmdr({ "ColorScheme" }, {
  callback = function(ev)
    local owhl = vim.api.nvim_create_namespace("NightowlNvim")
    vim.api.nvim_set_hl(0, "manBold", { bold = true, underline = true })
    vim.api.nvim_set_hl(0, "Headline", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "IndentBlanklineIndent", { link = "@conceal" })
    vim.api.nvim_set_hl(0, "IndentBlanklineWhitespace", { link = "@conceal" })
    vim.api.nvim_set_hl(0, "IndentBlanklineScope", { link = "@conceal" })
    vim.api.nvim_set_hl(0, "NightowlInlayHints", {
      fg = brush.find("DiagnosticVirtualTextInfo").bg,
      bg = brush.find("WinSeparator").fg,
      italic = true,
    })
    vim.api.nvim_set_hl(0, "NightowlMelonSigns", { link = "@label" })
    vim.api.nvim_set_hl(
      0,
      "NightowlContextHints",
      { fg = brush.find("@markup.raw").fg, italic = true }
    )
    vim.api.nvim_set_hl(
      0,
      "NightowlContextHintsBright",
      { fg = brush.find("@tag").fg, italic = true }
    )
    vim.api.nvim_set_hl(0, "NightowlStartupHeader", { link = "@function" })
    vim.api.nvim_set_hl(0, "NightowlStartupEntry", { link = "NvimIdentifier" })
    vim.api.nvim_set_hl(
      0,
      "NightowlStartupConvenience",
      { link = "@conditional" }
    )
    vim.api.nvim_set_hl(
      0,
      "SpaceportRecentsTitle",
      { link = "NightowlStartupHeader" }
    )
    vim.api.nvim_set_hl(
      0,
      "SpaceportRecentsProject",
      { link = "@lsp.type.property" }
    )
    vim.api.nvim_set_hl(
      0,
      "SpaceportRemapDescription",
      { link = "NightowlStartupConvenience" }
    )
    vim.api.nvim_set_hl(
      0,
      "SpaceportRemapKey",
      { link = "NightowlStartupEntry" }
    )
    vim.api.nvim_set_hl(
      0,
      "SpaceportRecentsCount",
      { link = "NightowlStartupEntry" }
    )
    vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true, underline = true })
    vim.api.nvim_set_hl(0, "EyelinerSecondary", { underline = true })
    vim.api.nvim_set_hl(0, "BiscuitColor", { link = "NightowlContextHints" })
    vim.api.nvim_set_hl(0, "LspInlayHint", { link = "NightowlInlayHints" })
  end,
})

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      globalStatus = true,
      dimInactive = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = false, bold = true },
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
          LspInlayHint = { link = "NightowlInlayHints" },
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
          NightowlInlayHints = {
            fg = brush.find("DiagnosticVirtualTextInfo").bg,
            bg = brush.find("WinSeparator").fg,
            italic = true,
          },
          IndentBlanklineWhitespace = { link = "@comment" },
          IndentBlanklineScope = { link = "@comment" },
          IndentBlanklineIndent = { link = "@comment" },
          Headline = {
            fg = pcol.sumiInk0,
            bg = pcol.sumiInk0,
          },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      -- require("kanagawa").load("wave")
    end,
  },
  {
    "cryptomilk/nightcity.nvim",
    priority = 920,
    enabled = true,
    version = false,
    lazy = false,
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
        TelescopeBorder = { fg = "overlay", bg = "overlay" },
        TelescopeNormal = { fg = "subtle", bg = "overlay" },
        TelescopeSelection = { fg = "text", bg = "highlight_med" },
        TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
        TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },

        TelescopeTitle = { fg = "base", bg = "love" },
        TelescopePromptTitle = { fg = "base", bg = "pine" },
        TelescopePreviewTitle = { fg = "base", bg = "iris" },

        TelescopePromptNormal = { fg = "text", bg = "surface" },
        TelescopePromptBorder = { fg = "surface", bg = "surface" },
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

        Headline = { fg = rppal.base },
      }, opts.highlight_groups or {})
    end,
    config = true,
    lazy = false,
    priority = 960,
  },
  {
    "Verf/deepwhite.nvim",
    priority = 980,
    config = function(_, opts)
      local dw_accent = "#E5E5E5"
      -- defhl({ "TelescopeBorder" }, { fg = "overlay", bg = "overlay" })
      -- defhl({ "TelescopeNormal" }, { fg = "subtle", bg = "overlay" })
      -- defhl({ "TelescopeSelection" }, { fg = "text", bg = "highlight_med" })
      -- defhl(
      --   { "TelescopeSelectionCaret" },
      --   { fg = "love", bg = "highlight_med" }
      -- )
      -- defhl(
      --   { "TelescopeMultiSelection" },
      --   { fg = "text", bg = "highlight_high" }
      -- )
      --
      -- defhl({ "TelescopeTitle" }, { fg = "base", bg = "love" })
      -- defhl({ "TelescopePromptTitle" }, { fg = "base", bg = "pine" })
      -- defhl({ "TelescopePreviewTitle" }, { fg = "base", bg = "iris" })
      --
      -- defhl({ "TelescopePromptNormal" }, { fg = "text", bg = "surface" })
      -- defhl({ "TelescopePromptBorder" }, { fg = "surface", bg = "surface" })

      defhl({ "TreesitterContextBottom" }, { fg = dw_accent, underline = true })
      defhl({ "NightowlContextHints" }, { italic = true, fg = dw_accent })
      defhl({ "WinSeparator" }, { fg = dw_accent })
      defhl({ "Headline" }, { fg = dw_accent, bg = dw_accent })
      require("deepwhite").setup(opts)
    end,
    opts = {
      low_blue_light = true,
    },
    lazy = false,
  },
  {
    "ronisbr/nano-theme.nvim",
    priority = 930,
    config = function(_, opts) end,
    opts = {
      background = {
        override = false,
        style = "light",
      },
    },
    lazy = false,
  },
  {
    "EdenEast/nightfox.nvim",
    config = function(_, opts)
      require("nightfox").setup(opts)
    end,
    opts = {
      options = {
        styles = {
          comments = "italic",
          functions = "bold",
          constants = "bold",
          keywords = "bold",
        },
        module_default = true,
        groups = {
          NightowlContextHints = { link = "@markup.raw" },
          NightowlContextHintsBright = { link = "@tag" },
        },
      },
    },
    priority = 970,
    lazy = false,
  },
  {
    "CWood-sdf/pineapple",
    lazy = false,
    dependencies = vim.list_extend(
      { "nvim-telescope/telescope.nvim" },
      importcs()
    ),
    opts = {
      installedRegistry = "schemes.pineapple",
      colorschemeFile = "after/plugin/theme.lua",
    },
    cmd = "Pineapple",
    config = function(_, opts)
      require("pineapple").setup(opts)
      require("telescope").load_extension("pineapple")
    end,
    keys = {
      {
        key_ui.color.pineapple,
        function()
          vim.cmd([[Pineapple]])
        end,
        mode = "n",
        desc = "ui:| scheme |=> pineapple",
      },
      {
        key_scope.pineapple,
        function()
          require("telescope").extensions.pineapple.colorschemes()
        end,
        mode = "n",
        desc = "scope:| ext |=> colorschemes",
      },
    },
  },
}
