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
local key_colors = require("environment.keys").color

local function import_pineapple()
  local res = require("schemes.pineapple")
  return type(res) == "table" and res or {}
end

if conv.bool_from_env("NIGHTOWL_DEBUG") then
  local cmdr = require("funsak.autocmd").autocmdr("Nightowl_ColorschemeInfo")
  cmdr({ "UIEnter" }, {
    callback = function(ev)
      vim.schedule(function()
        lz.info("Selected Background: " .. bg_style)
      end)
      vim.schedule(function()
        lz.info("Selected Colorscheme: " .. scheme_sel)
      end)
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
      link = "DiagnosticSignInfo",
    })
    vim.api.nvim_set_hl(0, "NightowlMelonSigns", { link = "@label" })
    vim.api.nvim_set_hl(0, "NightowlContextHints", {
      bg = brush.find("Normal").bg,
      fg = brush.find("@markup.raw").fg,
      italic = true,
    })
    vim.api.nvim_set_hl(0, "NightowlContextHintsBright", {
      bg = brush.find("Normal").bg,
      fg = brush.find("@tag").fg,
      italic = true,
    })
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
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      -- require("kanagawa").load("wave")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    opts = function(_, opts)
      opts.overrides = opts.overrides
        or function(colors)
          local theme = colors.theme
          local pcol = colors.palette
          return {
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = {
              fg = theme.ui.fg_dim,
              bg = theme.ui.bg_m1,
            },
            TelescopeResultsBorder = {
              fg = theme.ui.bg_m1,
              bg = theme.ui.bg_m1,
            },
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
              bg = brush.find("Normal").bg,
              fg = brush.find("Folded@function.call").fg,
              italic = true,
            },
            NightowlContextHintsBright = {
              bg = brush.find("Normal").bg,
              fg = brush.find("@tag").fg,
              italic = true,
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
              link = "DiagnosticSignInfo",
            },
            IndentBlanklineWhitespace = { link = "@comment" },
            IndentBlanklineScope = { link = "@comment" },
            IndentBlanklineIndent = { link = "@comment" },
            Headline = {
              fg = pcol.sumiInk0,
              bg = pcol.sumiInk0,
            },
          }
        end
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
    "Verf/deepwhite.nvim",
    priority = 980,
    config = function(_, opts)
      local dw_accent = "#E5E5E5"
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
    "olivercederborg/poimandres.nvim",
    config = function(_, opts)
      require("poimandres").setup(opts)
    end,
    opts = {},
    lazy = false,
    priority = 850,
  },
  {
    "kepano/flexoki-neovim",
    opts = {},
    name = "flexoki",
    config = function(_, opts)
      -- require("flexoki").setup(opts)
    end,
    lazy = false,
    priority = 840,
  },
  {
    "CWood-sdf/pineapple",
    lazy = false,
    dependencies = vim.list_extend(
      { "nvim-telescope/telescope.nvim" },
      import_pineapple()
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
        key_colors.pineapple,
        function()
          vim.cmd([[Pineapple]])
        end,
        mode = "n",
        desc = "color:| scheme |=> pineapple",
      },
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
