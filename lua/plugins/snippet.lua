return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "honza/vim-snippets",
      "rafamadriz/friendly-snippets",
    },
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
}
