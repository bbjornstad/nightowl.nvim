local sound_dir = vim.fn.expand("config") .. "/interface_sounds"
local opt = require("environment.optional")

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
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#8aa872" })
            vim.fn.sign_define("smoothcursor", { text = "" })
          elseif current_mode == "v" then
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
            vim.fn.sign_define("smoothcursor", { text = "" })
          elseif current_mode == "V" then
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
            vim.fn.sign_define("smoothcursor", { text = "" })
          elseif current_mode == "�" then
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#bf616a" })
            vim.fn.sign_define("smoothcursor", { text = "" })
          elseif current_mode == "i" then
            vim.api.nvim_set_hl(0, "SmoothCursor", { fg = "#668aab" })
            vim.fn.sign_define("smoothcursor", { text = "" })
          end
        end,
      })
    end,
    opts = {
      autostart = true,
      line_hl = "CursorLine",
      speed = 36,
      threshold = 3,
      fancy = {
        enable = true,
        head = { cursor = "󰵵" },
        body = {},
      },
    },
  },
}
