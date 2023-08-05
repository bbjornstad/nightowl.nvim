return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "onsails/lspkind.nvim" },
    opts = function(_, opts)
      local cmp = require("cmp")
      --------------------------------------------------------------------------
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
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          preset = "codicons",
          maxwidth = 60,
          ellipsis_char = "",
        }),
      }, opts.formatting or {})
    end,
  },
}
