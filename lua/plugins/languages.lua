local key_neogen = require("environment.keys").stems.neogen
local key_iron = require("environment.keys").stems.iron
local mapn = require("environment.keys").map("n")

return {
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = {
      tools = {
        inlay_hints = {
          auto = false,
        },
      },
    },
  },
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
    init = function()
      mapn(key_neogen .. "d", function()
        return require("neogen").generate({ type = "func" })
      end, { desc = "generate docstring for function" })
      mapn(key_neogen .. "c", function()
        return require("neogen").generate({ type = "class" })
      end, { desc = "generate docstring for class" })
      mapn(key_neogen .. "t", function()
        return require("neogen").generate({ type = "type" })
      end, { desc = "generate docstring for type" })
      mapn(key_neogen .. "f", function()
        return require("neogen").generate({ type = "func" })
      end, { desc = "generate docstring for function" })
    end,
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
    init = function()
      mapn(key_iron .. "s", function()
        local core = require("iron.core")
        local ft = vim.bo.filetype
        core.repl_here(ft)
      end, { desc = "iron=> open repl" })
      mapn(key_iron .. "r", function()
        local core = require("iron.core")
        core.repl_restart()
      end, { desc = "iron=> restart repl" })
      mapn(key_iron .. "f", function()
        local core = require("iron.core")
        local ft = vim.bo.filetype
        core.focus_on(ft)
      end, { desc = "iron=> focus" })
      mapn(key_iron .. "h", function()
        local core = require("iron.core")
        local ft = vim.bo.filetype
        core.close_repl(ft)
      end, { desc = "iron=> hide" })
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "hrsh7th/nvim-cmp",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "qmd" },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      if vim.fn.has("otter") then
        local cmp = require("cmp")
        opts.sources = vim.list_extend({
          { name = "otter", max_item_count = 8 },
        }, opts.sources or {})
      end
    end,
  },
}
