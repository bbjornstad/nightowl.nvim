local stems = require("environment.keys").stems
local key_repl = stems.repl
local key_iron = key_repl .. "r"
local key_sniprun = key_repl .. "s"

return {
  {
    "michaelb/sniprun",
    build = "sh ./install.sh",
    config = true,
    opts = {},
    event = "VeryLazy",
    keys = {
      {
        key_sniprun .. "O",
        "<Plug>SnipRun",
        mode = { "n" },
        silent = true,
        desc = "run=> line sniprun",
      },
      {
        key_sniprun .. "o",
        "<Plug>SnipRunOperator",
        mode = { "n" },
        silent = true,
        desc = "run=> operator sniprun",
      },
      {
        key_sniprun .. "s",
        "<Plug>SnipRun",
        mode = { "v" },
        silent = true,
        desc = "run=> sniprun",
      },
      {
        key_sniprun .. "i",
        "<Plug>SnipInfo",
        mode = { "n" },
        silent = true,
        desc = "run=> sniprun info",
      },
      {
        key_sniprun .. "q",
        "<Plug>SnipClose",
        mode = { "n" },
        desc = "run=> close sniprun",
      },
      {
        key_sniprun .. "l",
        "<Plug>SnipLive",
        mode = { "n" },
        silent = true,
        desc = "run=> sniprun live mode",
      },
    },
  },
  {
    "Vigemus/iron.nvim",
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
    keys = {
      {
        key_iron .. "s",
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.repl_here(ft)
        end,
        mode = "n",
        desc = "repl.iron=> open ft repl",
      },
      {
        key_iron .. "r",
        function()
          local core = require("iron.core")
          core.repl_restart()
        end,
        mode = "n",
        desc = "repl.iron=> restart repl",
      },
      {
        key_iron .. "f",
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.focus_on(ft)
        end,
        mode = "n",
        desc = "repl.iron=> focus on repl",
      },
      {
        key_iron .. "q",
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.close_repl(ft)
        end,
        mode = "n",
        desc = "repl.iron=> hide repl",
      },
    },
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
}
