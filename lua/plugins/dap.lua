return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      --- fancy UI for the debugger
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {},
      },
      {
        "niuiic/dap-utils.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {},
      },
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
        dependencies = { "mfussenegger/nvim-dap" },
      },

      -- which key integration
      {
        "folke/which-key.nvim",
        opts = {
          defaults = {
            ["<leader>d"] = { name = "+debug" },
            ["<leader>da"] = { name = "dap=> +adapters" },
            -- TODO Add a few more of these baseline name mappings
            -- directly onto the which-key configuration here.
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
    opts = {},
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
    opts = {},
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "andrewferrier/debugprint.nvim",
    event = "LspAttach",
    opts = {
      create_keymaps = false,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    opts = {},
    event = "VeryLazy",
  },
}
