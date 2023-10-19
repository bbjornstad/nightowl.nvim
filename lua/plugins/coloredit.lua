local env = require("environment.ui")
local default_colorizer = require("funsak.colors").identify_highlight
local key_ccc = require("environment.keys").ui.color

return {
  {
    "uga-rosa/ccc.nvim",
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterEnable",
      "CccHighlighterToggle",
    },
    opts = {
      win_opts = {
        style = "minimal",
        relative = "cursor",
        border = env.borders.main,
      },
      auto_close = true,
      preserve = true,
      default_color = default_colorizer("Delimiter"),
      recognize = {
        input = true,
        output = true,
      },
      highlighter = {
        auto_enable = true,
      },
      bar_len = 50,
    },
    keys = {
      {
        key_ccc .. "c",
        "<CMD>CccPick<CR>",
        mode = "n",
        desc = "ccc=> pick color interface",
      },
      {
        key_ccc .. "h",
        "<CMD>CccHighlighterToggle<CR>",
        mode = "n",
        desc = "ccc=> toggle inline highlighting",
      },
      {
        key_ccc .. "v",
        "<CMD>CccConvert<CR>",
        mode = "n",
        desc = "ccc=> convert color",
      },
      {
        key_ccc .. "f",
        "<CMD>CccHighlighterDisable<CR>",
        mode = "n",
        desc = "ccc=> disable inline highlighting",
      },
      {
        key_ccc .. "o",
        "<CMD>CccHighlighterEnable<CR>",
        mode = "n",
        desc = "ccc=> enable inline highlighting",
      },
    },
  },
  {
    "echasnovski/mini.colors",
    event = "VeryLazy",
    version = false,
  },
  {
    "nvim-colortils/colortils.nvim",
    config = function(_, opts)
      require("colortils").setup(opts)
    end,
    opts = {
      border = env.borders.main,
    },
    cmd = "Colortils",
    keys = {
      {
        key_ccc .. "t",
        "<CMD>Colortils picker<CR>",
        mode = "n",
        desc = "'tils=> pick color",
      },
      {
        key_ccc .. "l",
        "<CMD>Colortils lighten<CR>",
        mode = "n",
        desc = "'tils=> lighten",
      },
      {
        key_ccc .. "d",
        "<CMD>Colortils darken<CR>",
        mode = "n",
        desc = "'tils=> darken",
      },
      {
        key_ccc .. "g",
        "<CMD>Colortils greyscale<CR>",
        mode = "n",
        desc = "'tils=> greyscale",
      },
      {
        key_ccc .. "L",
        "<CMD>Colortils greyscale<CR>",
        mode = "n",
        desc = "'tils=> css list",
      },
    },
  },
}
