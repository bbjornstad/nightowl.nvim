local lsp = require("funsak.lsp")

return {
  lsp.server("clojure_lsp", { server = {} }),
  -- lsp.linters(lsp.per_ft({ "clj-kondo", "joker" }, { "clojure" })),
  lsp.formatters(
    lsp.per_ft({ "zprint", "joker" }, { "clojure", "clojurescript" })
  ),
  {
    "clojure-vim/acid.nvim",
    config = function() end,
    build = ":UpdateRemotePlugins",
    ft = { "clojure", "clojurescript" },
  },
  {
    "clojure-vim/jazz.nvim",
    dependencies = {
      "clojure-vim/acid.nvim",
      "hkupty/impromptu.nvim",
    },
    ft = { "clojure", "clojurescript" },
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
    ft = {
      "clojurescript",
      "clojure",
      "fennel",
      "python",
      "racket",
      "scheme",
      "guile",
      "julia",
      "lisp",
    },
    dependencies = {
      {
        "PaterJason/cmp-conjure",
        dependencies = { "hrsh7th/nvim-cmp" },
        ft = {
          "clojure",
          "fennel",
          "python",
          "clojurescript",
          "python",
          "racket",
          "scheme",
          "guile",
          "julia",
          "lisp",
        },
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
    dependencies = {
      {
        "julienvincent/nvim-paredit-fennel",
        optional = true,
      },
      {
        "ekaitz-zarraga/nvim-paredit-scheme",
        optional = true,
      },
    },
    ft = {
      "clojurescript",
      "clojure",
      "lisp",
      "scheme",
      "guile",
      "fennel",
      "racket",
    },
  },
  {
    "julienvincent/nvim-paredit-fennel",
    ft = { "fennel" },
  },
  {
    "ekaitz-zarraga/nvim-paredit-scheme",
    ft = { "scheme", "racket" },
  },
  {
    "gpanders/nvim-parinfer",
    opts = {},
    config = function(_, opts)
      require("parinfer").setup(opts)
    end,
    ft = {
      "clojurescript",
      "clojure",
      "lisp",
      "scheme",
      "guile",
      "fennel",
      "racket",
    },
  },
  {
    "dundalek/parpar.nvim",
    dependencies = { "gpanders/nvim-parinfer", "julienvincent/nvim-paredit" },
    ft = {
      "clojurescript",
      "clojure",
      "lisp",
      "scheme",
      "guile",
      "fennel",
      "racket",
    },
    opts = {},
  },
}
