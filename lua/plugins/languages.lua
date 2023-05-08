return {
  { "simrat39/rust-tools.nvim", ft = { "rust" } },
  { "lervag/vimtex", ft = { "tex" } },
  { "jmcantrell/vim-virtualenv", ft = { "python" } },
  {
    "lepture/vim-jinja",
    ft = { "jinja", "j2", "jinja2", "tfy" },
    dependencies = {
      "Glench/Vim-Jinja2-Syntax",
      ft = { "jinja", "j2", "jinja2", "tfy" },
    },
  },
  {
    "saltstack/salt-vim",
    ft = { "Saltfile", "sls", "top" },
    dependencies = { "Glench/Vim-Jinja2-Syntax", "lepture/vim-jinja" },
  },
  { "preservim/vim-markdown", ft = { "markdown", "md", "rmd" } },
  {
    "danymat/neogen",
    event = { "VeryLazy" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { snippet_engine = "luasnip" },
  }, -- Orgmode Specific
  { "Fymyte/rasi.vim", ft = { "rasi" } }, -- {
  --  "hkupty/iron.nvim",
  --  module = "iron.core",
  --  opts = {
  --    config = {
  --      repl_open_cmd = require("iron.view").split.vertical.botright(50),
  --      scratch_repl = true,
  --      repl_definition = { sh = { command = { "zsh" } } },
  --    },
  --  },
  -- },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "hrsh7th/nvim-cmp",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", ".qmd" },
  },
}
