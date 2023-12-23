local env = require("environment.ui")
local default_colorizer = require("funsak.colors").identify_highlight
local key_color = require("environment.keys").color

return {
  {
    "uga-rosa/ccc.nvim",
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterEnable",
      "CccHighlighterToggle",
    },
    event = "VeryLazy",
    opts = function()
      local ccc = require("ccc")
      return {
        inputs = {
          ccc.input.rgb,
          ccc.input.hsl,
          ccc.input.cmyk,
          ccc.input.hwb,
          ccc.input.lab,
          ccc.input.lch,
          ccc.input.oklab,
          ccc.input.oklch,
          ccc.input.hsluv,
          ccc.input.okhsl,
          ccc.input.hsv,
          ccc.input.okhsv,
          ccc.input.xyz,
        },
        win_opts = {
          style = "minimal",
          relative = "cursor",
          border = env.borders.main,
        },
        auto_close = true,
        preserve = true,
        -- default_color = default_colorizer("Delimiter"),
        recognize = {
          input = true,
          output = true,
        },
        highlighter = {
          auto_enable = true,
          update_insert = true,
        },
        bar_len = 60,
        save_on_quit = true,
      }
    end,
    keys = {
      {
        key_color.pick.ccc,
        "<CMD>CccPick<CR>",
        mode = "n",
        desc = "col.ccc=> pick color interface",
      },
      {
        key_color.inline_hl.toggle,
        "<CMD>CccHighlighterToggle<CR>",
        mode = "n",
        desc = "col.ccc=> toggle inline highlighting",
      },
      {
        key_color.convert,
        "<CMD>CccConvert<CR>",
        mode = "n",
        desc = "col.ccc=> convert color",
      },
      {
        key_color.inline_hl.disable,
        "<CMD>CccHighlighterDisable<CR>",
        mode = "n",
        desc = "col.ccc=> disable inline highlighting",
      },
      {
        key_color.inline_hl.enable,
        "<CMD>CccHighlighterEnable<CR>",
        mode = "n",
        desc = "col.ccc=> enable inline highlighting",
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
        key_color.pick.tils,
        "<CMD>Colortils picker<CR>",
        mode = "n",
        desc = "col.tils=> pick color",
      },
      {
        key_color.lighten,
        "<CMD>Colortils lighten<CR>",
        mode = "n",
        desc = "col.tils=> lighten",
      },
      {
        key_color.darken,
        "<CMD>Colortils darken<CR>",
        mode = "n",
        desc = "col.tils=> darken",
      },
      {
        key_color.greyscale,
        "<CMD>Colortils greyscale<CR>",
        mode = "n",
        desc = "col.tils=> greyscale",
      },
      {
        key_color.list,
        "<CMD>Colortils css list<CR>",
        mode = "n",
        desc = "col.tils=> css list",
      },
    },
  },
}
