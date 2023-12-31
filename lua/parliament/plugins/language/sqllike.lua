local lsp = require("funsak.lsp")
local lz = require("funsak.lazy")

return {
  lsp.server("sqlls", { server = {} }),
  lsp.formatters(lsp.per_ft({ "sql-formatter", "sqlfmt" }, { "sql" })),
  lsp.linters(lsp.per_ft("sqlfluff", { "sql" })),
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function(_, opts)
      require("dbee").setup(opts)
    end,
    opts = {
      lazy = true,
      page_size = 100,
      drawer = {
        -- manually refresh drawer
        refresh = { key = "r", mode = "n" },
        -- actions perform different stuff depending on the node:
        -- action_1 opens a scratchpad or executes a helper
        action_1 = { key = "<CR>", mode = "n" },
        -- action_2 renames a scratchpad or sets the connection as active manually
        action_2 = { key = "cw", mode = "n" },
        -- action_3 deletes a scratchpad or connection (removes connection from the file if you configured it like so)
        action_3 = { key = "dd", mode = "n" },
        -- these are self-explanatory:
        -- collapse = { key = "c", mode = "n" },
        -- expand = { key = "e", mode = "n" },
        toggle = { key = "o", mode = "n" },
      },
    },
    ft = { "sql" },
  },
}
