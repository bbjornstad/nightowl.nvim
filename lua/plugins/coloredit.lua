local env = require("environment.ui")
local key_ccc = require("environment.keys").stems.ccc

local function default_colorizer(hlgroup)
  local labeled_hl = vim.api.nvim_get_hl_by_name(hlgroup, true)
  return labeled_hl.fg
end

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
      default_color = default_colorizer("@comment"),
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
        function()
          vim.cmd([[CccPick]])
        end,
        desc = "ccc=> pick color interface",
      },
      {
        key_ccc .. "h",
        function()
          vim.cmd([[CccHighlighterToggle]])
        end,
        desc = "ccc=> toggle inline color highlighting",
      },
      {
        key_ccc .. "v",
        function()
          vim.cmd([[CccConvert]])
        end,
        desc = "ccc=> convert color to another format",
      },
      {
        key_ccc .. "f",
        function()
          vim.cmd([[CccHighlighterDisable]])
        end,
        desc = "ccc=> turn off inline color highlighting",
      },
      {
        key_ccc .. "o",
        function()
          vim.cmd([[CccHighlighterEnable]])
        end,
        desc = "ccc=> turn on inline color highlighting",
      },
    },
  },
}
