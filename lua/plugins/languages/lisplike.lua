local add_cmp_source = require("uutils.cmp").add_source

return {
  {
    "clojure-vim/acid.nvim",
    config = function() end,
    build = pcall(vim.cmd, "UpdateRemotePlugins"),
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
    ft = { "*shadowenv.d/*", "lisp" },
  },
  {
    "vlime/vlime",
    ft = { "lisp" },
    config = function(plugin)
      vim.opt.rtp:append((plugin.dir .. "vim/"))
    end,
    keys = {
      {
        "<leader>rv",
        "<CMD>!sbcl --load <CR>",
        mode = "n",
        desc = "lisp=> start vlime",
      },
    },
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
    config = true,
    ft = { "clojure", "lisp" },
  },
}
