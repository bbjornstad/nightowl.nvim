local lz = require("funsak.lazy")

return {
  lz.lspsrv("clojure_lsp", { server = {} }),
  lz.lsplnt("clj-kondo", "clojure"),
  lz.lspfmt("cljstyle", "clojure"),
  {
    "clojure-vim/acid.nvim",
    config = function() end,
    build = ":UpdateRemotePlugins",
    ft = { "clojure" },
  },
  {
    "clojure-vim/jazz.nvim",
    dependencies = {
      "clojure-vim/acid.nvim",
      "hkupty/impromptu.nvim",
    },
    ft = { "clojure" },
  },
  {
    "hkupty/impromptu.nvim",
    config = false,
    event = "VeryLazy",
  },
  {
    "Shopify/shadowenv.vim",
    config = function() end,
    ft = { "*shadowenv.d/*" },
  },
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "python" },
    dependencies = {
      {
        "PaterJason/cmp-conjure",
        dependencies = { "hrsh7th/nvim-cmp" },
        ft = { "clojure", "fennel", "python" },
      },
    },
    config = function(_, opts)
      require("conjure.main").main()
      require("conjure.mapping")["on-filetype"]()
    end,
    init = function()
      vim.g["conjure#debug"] = true
    end,
  },
  {
    "julienvincent/nvim-paredit",
    opts = {},
    config = function(_, opts)
      require("nvim-paredit").setup(opts)
    end,
    ft = { "clojure", "lisp" },
  },
}
