local env = require("environment.ui")

return {
  {
    "williamboman/mason.nvim",
    -- build = function()
    --  pcall(vim.cmd, "MasonUpdate")
    -- end,
    opts = { ui = { border = env.borders.main_accent } },
  },
}
