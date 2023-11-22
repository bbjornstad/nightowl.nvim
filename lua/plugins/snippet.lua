local key_scope = require("environment.keys").scope

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      { "honza/vim-snippets", optional = true },
      { "rafamadriz/friendly-snippets", optional = true },
    },
    event = "VeryLazy",
    opts = {
      vscode = true,
      snipmate = true,
    },
    config = function(_, opts)
      opts = opts or {}
      if opts.vscode then
        require("luasnip.loaders.from_vscode").lazy_load()
      end
      if opts.snipmate then
        require("luasnip.loaders.from_snipmate").lazy_load()
      end
    end,
  },
  { "honza/vim-snippets", config = false, event = "VeryLazy" },
  { "rafamadriz/friendly-snippets", config = false, event = "VeryLazy" },
  {
    "benfowler/telescope-luasnip.nvim",
    module = "telescope._extensions.luasnip",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("telescope").load_extension("luasnip")
    end,
    keys = {
      {
        key_scope.luasnip,
        function()
          require("telescope").extensions.luasnip.luasnip()
        end,
        mode = "n",
        desc = "scope.ext=> snippets",
      },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    event = "VeryLazy",
  },
}
