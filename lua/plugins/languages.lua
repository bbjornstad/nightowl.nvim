local key_neogen = require("environment.keys").stems.neogen

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
    keys = {
      {
        key_neogen .. "d",
        function()
          return require("neogen").generate({ type = "func" })
        end,
        { desc = "generate docstring for function" },
      },
      {
        key_neogen .. "c",
        function()
          return require("neogen").generate({ type = "class" })
        end,
        { desc = "generate docstring for class" },
      },
      {
        key_neogen .. "t",
        function()
          return require("neogen").generate({ type = "type" })
        end,
        { desc = "generate docstring for type" },
      },
      {
        key_neogen .. "f",
        function()
          return require("neogen").generate({ type = "func" })
        end,
        { desc = "generate docstring for function" },
      },
    },
  },
  { "Fymyte/rasi.vim", ft = { "rasi" } },
  {
    "hkupty/iron.nvim",
    tag = "v3.0",
    module = "iron.core",
    opts = {
      config = {
        repl_open_cmd = ":lua require('iron.view').split.vertical.botright(50)",
        scratch_repl = true,
        repl_definition = { sh = { command = { "zsh" } } },
      },
      keymaps = {},
    },
    -- config = true,
  },
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
