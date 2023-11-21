local env = require("environment.ui")

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "VonHeikemen/lsp-zero.nvim", optional = true },
      "onsails/lspkind.nvim",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local has = require("lazyvim.util").has
      local cmp_format = require("lspkind").cmp_format({
        mode = "symbol_text",
        preset = "codicons",
        maxwidth = 60,
        ellipsis_char = " ",
        menu = {},
      })
      -- The following changes the appearance of the menu. Noted changes:
      -- - different row field order
      -- - vscode codicons
      -- - vscode-styled colors
      opts.formatting = vim.tbl_deep_extend("force", {
        fields = {
          cmp.ItemField.Kind,
          cmp.ItemField.Abbr,
          cmp.ItemField.Menu,
        },
        format = cmp_format,
      }, opts.formatting or {})
      -- set up window parameters and other main display settings. I don't know
      -- why the documentation is not following the same pattern. Padding does
      -- not seem to be applied.
      opts.window = vim.tbl_deep_extend("force", {
        completion = cmp.config.window.bordered({
          border = env.borders.main,
          side_padding = 2,
        }),
        documentation = cmp.config.window.bordered({
          border = env.borders.main,
          side_padding = 2,
        }),
      }, opts.window or {})
    end,
  },
}
