local kenv = require("environment.keys")
local key_debug = kenv.debug

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      --- fancy UI for the debugger
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "mfussenegger/nvim-dap",
          {
            "folke/neodev.nvim",
            opts = function(_, opts)
              opts.library = require("funsak.table").mopts({
                plugins = {
                  { "nvim-dap-ui" },
                  types = true,
                },
              }, opts.library or {})
            end,
          },
        },
      },
      -- virtual text for the debugger
      { "theHamsta/nvim-dap-virtual-text", optional = true },

      -- which key integration
      {
        "folke/which-key.nvim",
        opts = {
          defaults = {
            [key_debug:leader()] = { name = "::debug::" },
            [key_debug.adapters] = { name = "::debug.dap=> adapters::" },
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
        dependencies = {
          "williamboman/mason.nvim",
        },
      },
      {
        "LiadOz/nvim-dap-repl-highlights",
        optional = true,
      },
      {
        "niuiic/dap-utils.nvim",
        optional = true,
      },
      {
        "daic0r/dap-helper.nvim",
        optional = true,
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
    event = "VeryLazy",
    config = function(_, opts)
      require("printer").setup(opts)
    end,
    opts = {
      keymap = key_debug.printer,
      behavior = "insert_below",
    },
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
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup(opts)
    end,
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_new_as_changed = true,
      commented = false,
      all_references = false,
    },
  },
  {
    "ofirgall/goto-breakpoints.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function(_, opts) end,
    opts = {},
    keys = {
      {
        kenv.shortcut.diagnostics.breakpoint.next,
        function()
          require("goto-breakpoints").next()
        end,
        mode = "n",
        desc = "dap=> next breakpoint",
      },
      {
        kenv.shortcut.diagnostics.breakpoint.previous,
        function()
          require("goto-breakpoints").prev()
        end,
        mode = "n",
        desc = "dap=> next breakpoint",
      },
      {
        kenv.shortcut.diagnostics.breakpoint.stopped,
        function()
          require("goto-breakpoints").stopped()
        end,
        mode = "n",
        desc = "dap=> next breakpoint",
      },
    },
  },
}
