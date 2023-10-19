local env = require("environment.ui")
local stems = require("environment.keys")
local mapn = require("funsak.keys").kmap("n")
local key_repl = stems.repl:leader()
local key_iron = stems.repl.iron
local key_sniprun = stems.repl.sniprun
local key_molten = stems.repl.molten

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
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    cmd = {
      "MoltenInit",
      "MoltenDeinit",
      "MoltenEvaluateOperator",
      "MoltenEvaluateLine",
      "MoltenEvaluateVisual",
      "MoltenReevaluateCell",
      "MoltenDelete",
      "MoltenShowOutput",
      "MoltenHideOutput",
      "MoltenInterrupt",
      "MoltenRestart",
      "MoltenSave",
      "MoltenInterrupt",
    },
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_copy_output = false
      vim.g.molten_image_provider = "image_nvim"
      vim.g.molten_output_crop_border = true
      vim.g.molten_output_show_more = true
      vim.g.molten_output_virt_lines = true
      vim.g.molten_output_win_border = env.borders.main
      vim.g.molten_output_win_cover_gutter = true
      vim.g.molten_use_border_highlights = true
      vim.g.molten_wrap_output = true
    end,
    keys = {
      {
        key_molten .. "l",
        "<CMD>MoltenEvaluateLine<CR>",
        mode = "n",
        desc = "molten=> evaluate line",
      },
      {
        key_molten .. "e",
        "<CMD>MoltenEvaluateVisual<CR>",
        mode = "x",
        desc = "molten=> evaluate",
      },
      {
        key_molten .. "r",
        "<CMD>MoltenReevaluateCell<CR>",
        mode = "n",
        desc = "molten=> evaluate cell",
      },
      {
        key_molten .. "d",
        "<CMD>MoltenDelete<CR>",
        mode = "n",
        desc = "molten=> delete",
      },
      {
        key_molten .. "s",
        "<CMD>MoltenShowOutput<CR>",
        mode = "n",
        desc = "molten=> show output",
      },
    },
  },
}
