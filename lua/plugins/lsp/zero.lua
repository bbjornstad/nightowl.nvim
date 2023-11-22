local env = require("environment.ui")

return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
      vim.g.lsp_zero_ui_float_border = env.borders.main
      vim.g.lsp_zero_ui_signcolumn = 1
    end,
    config = function(_, opts)
      local zero = require("lsp-zero")
      zero.set_sign_icons(env.icons.diagnostic)
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
  },
}
