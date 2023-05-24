local env = require("environment.alpha")
local function startdash(layout, header)
  layout = layout or "alpha.themes.dashboard"
  header = env.fallback_headers[header]
    or env.fallback_headers["slant_relief_alt_dotted"]
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
        opts,
        startdash(
          env.preferred_alpha_layout or "",
          env.preferred_alpha_header or nil
        )
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
