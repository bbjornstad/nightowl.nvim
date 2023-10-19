local add_cmp_source = require("uutils.cmp").add_source
local deflang = require('funsak.lazy').language

return {
  unpack(deflang("clojure", "cljstyle", "clj-kondo")),
  {
    "clojure-vim/acid.nvim",
    config = function()
    end,
    build = ":UpdateRemotePlugins",
    ft = { "clojure" },
  },
  {
    "clojure-vim/jazz.nvim",
    dependencies = {
      "clojure-vim/acid.nvim",
      "Vigemus/impromptu.nvim",
    },
    ft = { "clojure" },
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
        config = function(_, opts)
          add_cmp_source("conjure", opts or {})
          add_cmp_source("buffer", opts or {}, {
            sources = {
              { name = "conjure" },
            },
          })
        end,
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
