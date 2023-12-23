local lz = require('funsak.lazy')

return {
  lz.lspsrv("hls", { handler = lz.noop }),
  lz.lspfmt({ "ormolu" }, { "haskell", "lhaskell", "cabal", "cabalproject" }),
  lz.lsplnt({ "hlint" }, { "haskell", "lhaskell", "cabal", "cabalproject" }),
  {
    "mrcjkb/haskell-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    -- branch = "1.x.x",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function(_, opts) end,
  },
  {
    "mrcjkb/haskell-snippets.nvim",
    ft = { "haskell", "hl" },
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    config = function(_, opts)
      local ls = require("luasnip")
      local snips = require("haskell-snippets").all
      ls.add_snippets("haskell", snips, { key = "haskell" })
    end,
  },
  {
    "Vigemus/iron.nvim",
    opts = function(_, opts)
      opts.config = vim.tbl_deep_extend("force", {
        repl_definition = {
          haskell = {
            command = function(meta)
              local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
              return require("haskell-tools").repl.mk_repl_cmd(file)
            end,
          },
        },
      }, opts.config or {})
    end,
    optional = true,
    dependencies = {
      "mrcjkb/haskell-tools.nvim",
    },
  },
}
