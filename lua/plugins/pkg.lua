local env = require("environment.ui")
local mapx = vim.keymap.set

return {
  {
    "williamboman/mason.nvim",
    opts = { ui = { border = env.borders.main } },
  },
  -- {
  --   "tamton-aquib/nvim-market",
  --   import = "nvim-market.plugins",
  --   config = function(_, opts)
  --     require("nvim-market").setup(opts)
  --     mapx("n", "<leader>L")
  --   end,
  --   opts = {},
  --   cmd = { "Lazy" },
  -- },
}
