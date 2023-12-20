---@diagnostic disable: param-type-mismatch
local env = require("environment.ui")
local key_mc = require("environment.keys").multicursor
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
      default_delay = 1,
      hide_cursor = false,
      horizontal_scroll = true,
    },
    event = "BufWinEnter",
  },
  {
    "gen740/SmoothCursor.nvim",
    lazy = false,
    config = function(_, opts)
      require("smoothcursor").setup(opts)
      local autocmd = vim.api.nvim_create_autocmd
      autocmd({ "ModeChanged" }, {
        group = vim.api.nvim_create_augroup(
          "smoothcursor_clear",
          { clear = true }
        ),
        callback = function()
          local current_mode = vim.fn.mode()
          local mode_map = {
            n = "Normal",
            i = "Insert",
            v = "Visual",
            V = "Visual",
            ["�"] = "Visual",
            c = "Command",
            t = "Terminal",
          }
          local full_mode = mode_map[current_mode] or false
          full_mode = full_mode and full_mode .. "Mode" or nil

          local hlres = full_mode and hlcomp(full_mode, { "fg" })
          vim.api.nvim_set_hl(0, "SmoothCursor", { link = full_mode })
          -- vim.fn.sign_define(
          --   "smoothcursor",
          --   { text = "󰮶", texthl = "SmoothCursor" }
          -- )
        end,
      })
    end,
    opts = {
      type = "matrix",
      autostart = true,
      -- texthl = "SmoothCursor",
      speed = 42,
      threshold = 3,
      intervals = 10,
      priority = 50,
      -- flyin_effect = "bottom",
      matrix = {
        head = {
          cursor = signs.head,
          texthl = "SmoothCursor",
        },
        body = {
          cursor = signs.body,
          length = 8,
          texthl = "SmoothCursor",
        },
        tail = {
          cursor = signs.tail,
          texthl = "SmoothCursor",
        },
        unstop = false,
      },
    },
  },
}
