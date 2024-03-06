local env = require("environment.ui")
local default_colorizer = require("funsak.colors").identify_highlight
local key_color = require("environment.keys").color

return {
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    opts = {
      { "*" },
      {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        names = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
      },
    },
    cmd = {
      "ColorizerAttachToBuffer",
      "ColorizerReloadAllBuffers",
      "ColorizerToggle",
    },
    config = function(_, opts)
      require("colorizer").setup(unpack(opts))
    end,
    keys = {
      {
        key_color.inline_hl.toggle,
        "<CMD>ColorizerToggle<CR>",
        mode = "n",
        desc = "color:| hl |=> toggle",
      },
      {
        key_color.inline_hl.detach,
        "<CMD>ColorizerDetachFromBuffer<CR>",
        mode = "n",
        desc = "color:| hl |=> detach",
      },
      {
        key_color.inline_hl.attach,
        "<CMD>ColorizerAttachToBuffer<CR>",
        mode = "n",
        desc = "color:| hl |=> attach",
      },
      {
        key_color.inline_hl.reload,
        "<CMD>ColorizerReloadAllBuffers<CR>",
        mode = "n",
        desc = "color:| hl |=> reload",
      },
    },
  },
  {
    "echasnovski/mini.colors",
    event = "VeryLazy",
    version = false,
    keys = {
      {
        key_color.convert.hex,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "hex")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> hex",
      },
      {
        key_color.convert.rgb,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "rgb")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> rgb",
      },
      {
        key_color.convert.eightbit,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "8-bit")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> 8-bit",
      },
      {
        key_color.convert.oklab,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "oklab")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> oklab",
      },
      {
        key_color.convert.oklch,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "oklch")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> oklch",
      },
      {
        key_color.convert.okhsl,
        function()
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local present = vim.api.nvim_buf_get_lines(0, row, column, false)
          local col = vim.fn.expand("<cword>")
          local conv = require("mini.colors").convert(col, "okhsl")
          present = vim.tbl_map(function(t)
            return t:gsub(col, conv)
          end, present)
        end,
        mode = "n",
        desc = "color:| convert |=> okhsl",
      },
      {
        key_color.convert.select,
        function()
          local col = vim.fn.expand("<cword>")
          vim.ui.select(
            { "8-bit", "hex", "rgb", "oklab", "oklch", "okhsl" },
            { prompt = "colorspace: " },
            function(sel)
              local conv = require("mini.colors").convert(col, sel)
              local row, column = unpack(vim.api.nvim_win_get_cursor(0))
              vim.api.nvim_buf_set_text(
                0,
                row,
                column,
                row,
                column,
                vim.tbl_flatten({ conv })
              )
            end
          )
        end,
        mode = "n",
        desc = "color:| convert |=> select",
      },
      {
        key_color.interactive,
        function()
          require("mini.colors").interactive()
        end,
        mode = "n",
        desc = "color:| play |=> interactive",
      },
    },
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
        key_color.pick,
        "<CMD>Colortils picker<CR>",
        mode = "n",
        desc = "color:| select |=> pick",
      },
      {
        key_color.lighten,
        "<CMD>Colortils lighten<CR>",
        mode = "n",
        desc = "color:| mod |=> lighten",
      },
      {
        key_color.darken,
        "<CMD>Colortils darken<CR>",
        mode = "n",
        desc = "color:| mod |=> darken",
      },
      {
        key_color.greyscale,
        "<CMD>Colortils greyscale<CR>",
        mode = "n",
        desc = "color:| mod |=> greyscale",
      },
      {
        key_color.list,
        "<CMD>Colortils css list<CR>",
        mode = "n",
        desc = "color:| list |=> css",
      },
    },
  },
}
