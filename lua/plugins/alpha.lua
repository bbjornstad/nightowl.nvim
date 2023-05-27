local env = require("environment.alpha")
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
    "goolord/alpha-nvim",
    opts = function(_, opts)
      opts = vim.tbl_deep_extend(
        "force",
        startdash(
          env.preferred_alpha_layout or "",
          env.preferred_alpha_header or nil,
          env.preferred_fallback_header or nil
        ),
        opts
      )
    end,
    enabled = not env.disable_alpha or true,
    -- keys = require("environment.keys").alpha,
    init = function()
      vim.keymap.set(
        { "n", "v" },
        "<Home>",
        "<CMD>Alpha<CR>",
        { desc = "א.α:>> return to alpha state" }
      )
    end,
  },
}
