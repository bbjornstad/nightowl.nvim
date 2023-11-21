local env = require("environment.ui")
local signs = env.icons.cursorsigns

local cb = require("funsak.wrap").cb
local hlcomp = require("funsak.colors").component

return {
  {
    "declancm/cinnamon.nvim",
    config = function(_, opts)
      require("cinnamon").setup(opts)
    end,
    opts = {
      default_keymaps = true,
      extra_keymaps = true,
      extended_keymaps = true,
      always_scroll = true,
      centered = false,
      disabled = false,
      default_delay = 3,
      hide_cursor = false,
      horizontal_scroll = true,
    },
    event = "VeryLazy",
  },
  {
    "gen740/SmoothCursor.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("smoothcursor").setup(opts)
      local autocmd = vim.api.nvim_create_autocmd

      autocmd({ "ModeChanged" }, {
        callback = function()
          local current_mode = vim.fn.mode()
          if current_mode == "n" then
            vim.api.nvim_set_hl(
              0,
              "SmoothCursor",
              hlcomp("lualine_b_normal", "fg")
            )
          elseif current_mode == "v" then
            vim.api.nvim_set_hl(
              0,
              "SmoothCursor",
              hlcomp("lualine_b_visual", "fg")
              -- hlcomp("ModesVisual", "bg", { bg = "fg" })
            )
          elseif current_mode == "V" then
            vim.api.nvim_set_hl(
              0,
              "SmoothCursor",
              hlcomp("lualine_b_visual", "fg")
              -- hlcomp("ModesVisual", "bg", { bg = "fg" })
            )
          elseif current_mode == "�" then
            vim.api.nvim_set_hl(
              0,
              "SmoothCursor",
              hlcomp("lualine_b_visual", "fg")
              -- hlcomp("ModesVisual", "bg", { bg = "fg" })
            )
          elseif current_mode == "i" then
            vim.api.nvim_set_hl(
              0,
              "SmoothCursor",
              hlcomp("lualine_b_insert", "fg")
              -- hlcomp("ModesInsert", "bg", { bg = "fg" })
            )
          end
        end,
      })
    end,
    opts = {
      type = "matrix",
      autostart = true,
      text_hl = "SmoothCursor",
      line_hl = "CursorLine",
      speed = 64,
      threshold = 3,
      matrix = {
        head = {
          cursor = vim.is_callable(signs.head) and cb(signs.head) or signs.head,
          text_hl = "SmoothCursor",
        },
        body = {
          cursor = vim.is_callable(signs.body) and cb(signs.body) or signs.body,
          length = 6,
          text_hl = "SmoothCursor",
        },
        tail = {
          cursor = vim.is_callable(signs.tail) and cb(signs.tail) or signs.tail,
          text_hl = "SmoothCursor",
        },
      },
      fancy = {
        enable = false,
        head = { cursor = "󰵵" },
        body = {},
      },
    },
  },
}
