local stems = require("environment.keys").stems
local mapn = require("environment.keys").map("n")
local key_repl = stems.base.repl
local key_iron = key_repl .. "r"
local key_sniprun = key_repl .. "s"
local key_magma = key_repl .. "m"

return {
  {
    "vlime/vlime",
    ft = { "lisp" },
    config = function(plugin)
      vim.opt.rtp:append((plugin.dir .. "vim/"))
    end,
    keys = {
      {
        key_repl .. "v",
        "<CMD>!sbcl --load <CR>",
        mode = "n",
        desc = "lisp=> start vlime",
      },
    },
  },
  {
    "michaelb/sniprun",
    build = "sh ./install.sh",
    config = true,
    -- opts = {},
    -- event = "VeryLazy",
    keys = {
      {
        key_sniprun .. "O",
        "<Plug>SnipRun",
        mode = { "n" },
        silent = true,
        desc = "repl.snip=> line sniprun",
      },
      {
        key_sniprun .. "o",
        "<Plug>SnipRunOperator",
        mode = { "n" },
        silent = true,
        desc = "repl.snip=> operator sniprun",
      },
      {
        key_sniprun .. "s",
        "<Plug>SnipRun",
        mode = { "v" },
        silent = true,
        desc = "repl.snip=> sniprun",
      },
      {
        key_sniprun .. "i",
        "<Plug>SnipInfo",
        mode = { "n" },
        silent = true,
        desc = "repl.snip=> sniprun info",
      },
      {
        key_sniprun .. "q",
        "<Plug>SnipClose",
        mode = { "n" },
        desc = "repl.snip=> close sniprun",
      },
      {
        key_sniprun .. "l",
        "<Plug>SnipLive",
        mode = { "n" },
        silent = true,
        desc = "repl.snip=> sniprun live mode",
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
      {
        "jmbuhr/otter.nvim",
        dependencies = {
          "hrsh7th/nvim-cmp",
          "neovim/nvim-lspconfig",
          "nvim-treesitter/nvim-treesitter",
        },
      },
      "hrsh7th/nvim-cmp",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "qmd" },
    config = function(_, opts)
      local otter = require("otter")
      mapn(
        "gd",
        otter.ask_definition,
        { desc = "otter=> ask for item definition", silent = true }
      )
      mapn(
        "gK",
        otter.ask_hover,
        { desc = "otter=> ask for item hover", silent = true }
      )
      otter.activate({
        "r",
        "python",
        "lua",
        "julia",
        "rust",
      }, true)
    end,
  },
  {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins",
    cmd = {
      "MagmaEvaluateOperator",
      "MagmaEvaluateLine",
      "MagmaEvaluateVisual",
      "MagmaReevaluateCell",
      "MagmaDelete",
      "MagmaShowOutput",
    },
    init = function()
      vim.g.magma_automatically_open_output = false
      vim.g.magma_image_provider = "kitty"
      vim.g.magma_output_window_borders = false
    end,
    keys = {
      {
        key_magma .. "e",
        "<CMD>MagmaEvaluateOperator<CR>",
        mode = "n",
        desc = "magma=> evaluate",
      },
      {
        key_magma .. "l",
        "<CMD>MagmaEvaluateLine<CR>",
        mode = "n",
        desc = "magma=> evaluate line",
      },
      {
        key_magma .. "e",
        "<CMD>MagmaEvaluateVisual<CR>",
        mode = "x",
        desc = "magma=> evaluate",
      },
      {
        key_magma .. "r",
        "<CMD>MagmaReevaluateCell<CR>",
        mode = "n",
        desc = "magma=> evaluate cell",
      },
      {
        key_magma .. "d",
        "<CMD>MagmaDelete<CR>",
        mode = "n",
        desc = "magma=> delete",
      },
      {
        key_magma .. "s",
        "<CMD>MagmaShowOutput<CR>",
        mode = "n",
        desc = "magma=> show output",
      },
    },
  },
}
