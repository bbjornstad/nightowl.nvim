local kenv = require("environment.keys").debug

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      --- fancy UI for the debugger
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
      },
      {
        "niuiic/dap-utils.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
      },
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
      },
      {
        "daic0r/dap-helper.nvim",
        dependencies = {
          "rcarriga/nvim-dap-ui",
          "mfussenegger/nvim-dap",
        },
        config = function(_, opts)
          require("dap-helper").setup()
        end,
      },

      -- which key integration
      {
        "folke/which-key.nvim",
        opts = {
          defaults = {
            [kenv:leader()] = { name = "+debug" },
            [kenv.adapters] = { name = "dap=> +adapters" },
          },
        },
      }, -- mason.nvim integration
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_setup = true,
          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},
          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
      },
      {
        "LiadOz/nvim-dap-repl-highlights",
      },
    },
  },
  {
    "niuiic/dap-utils.nvim",
    config = true,
    dependencies = {
      "niuiic/core.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "LiadOz/nvim-dap-repl-highlights",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    build = ":TSInstall dap_repl",
  },
  {
    "andrewferrier/debugprint.nvim",
    event = "VeryLazy",
    opts = {
      create_keymaps = true,
      move_to_debugline = true,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "andythigpen/nvim-coverage",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  {
    "rareitems/printer.nvim",
    config = function(_, opts)
      require("printer").setup(opts)
    end,
    opts = {
      keymap = kenv.printer .. "p",
      behavior = "insert_below",
    },
  },
}
