local env = require("environment.alpha")
local function startdash2(header)
  local opt_header = env.fallback_headers[header]
  local opt_linelen = #opt_header[1]
  if vim.api.nvim_win_get_width(0) < opt_linelen then
    --header = env.fallback_headers[width_fallback]
    return opt_header
  else
    return opt_header or env.fallback_headers["slant_relief_alt_dotted"]
  end
end

local function startdash(layout, header, width_fallback)
  layout = layout or "alpha.themes.dashboard"
  local opt_header = env.fallback_headers[header]
  local opt_linelen = #opt_header[1]
  print(opt_linelen)
  if vim.api.nvim_win_get_width(0) < opt_linelen then
    --header = env.fallback_headers[width_fallback]
    header = env.fallback_headers[header]
  else
    header = env.fallback_headers[header]
      or env.fallback_headers["slant_relief_alt_dotted"]
  end
  local this_dash = require(layout)
  this_dash.section.header.val = header -- divalpha(header)
  return this_dash
end

return {
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        shortcut_type = "letter",
        hide = { statusline = true, tabline = true, winbar = true },
        preview = {
          file_path = true,
          file_height = true,
          file_width = true,
        },

        config = {
          footer = "...Invisible Things are the Only Realities...",
          -- header = startdash2("nightowl"),
          week_header = {
            enable = true,
          },
        },
      })
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function(_, opts)
      local thisheader = startdash2(env.preferred_alpha_header)
      -- vim.go.dashboard_custom_header = thisheader
      vim.keymap.set(
        { "n", "v" },
        "<Home>",
        "<CMD>Alpha<CR>",
        { desc = "א.α => return to alpha state" }
      )
    end,
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  -- {
  --   "goolord/alpha-nvim",
  --   opts = function(_, opts)
  --     opts = vim.tbl_deep_extend(
  --       "force",
  --       startdash(
  --         env.preferred_alpha_layout or "",
  --         env.preferred_alpha_header or nil,
  --         env.preferred_fallback_header or nil
  --       ),
  --       opts
  --     )
  --   end,
  --   enabled = not env.disable_alpha or true,
  --   -- keys = require("environment.keys").alpha,
  --   init = function(_, opts)
  --     vim.keymap.set(
  --       { "n", "v" },
  --       "<Home>",
  --       "<CMD>Alpha<CR>",
  --       { desc = "א.α => return to alpha state" }
  --     )
  --   end,
  -- },
}
