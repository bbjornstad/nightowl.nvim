local kenv = require("environment.keys")
local key_debug = kenv.debug

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      --- fancy UI for the debugger
      { "rcarriga/nvim-dap-ui", optional = true }, -- virtual text for the debugger
      { "theHamsta/nvim-dap-virtual-text", optional = true },
      { "LiadOz/nvim-dap-repl-highlights", optional = true },
      { "niuiic/dap-utils.nvim", optional = true },
      { "jay-babu/mason-nvim-dap.nvim", optional = true },
    },
    keys = {
      {
        key_debug.dap.continue,
        function()
          require("dap").continue()
        end,
        mode = "n",
        desc = "debug:| dap |=> continue",
      },
      {
        key_debug.dap.step_over,
        function()
          require("dap").step_over()
        end,
        mode = "n",
        desc = "debug:| dap |=> step over",
      },
      {
        key_debug.dap.step_into,
        function()
          require("dap").step_into()
        end,
        mode = "n",
        desc = "debug:| dap |=> step into",
      },
      {
        key_debug.dap.step_out,
        function()
          require("dap").step_out()
        end,
        mode = "n",
        desc = "debug:| dap |=> step out",
      },
      {
        key_debug.dap.breakpoint.toggle,
        function()
          require("dap").toggle_breakpoint()
        end,
        mode = "n",
        desc = "debug:| dap |=> toggle breakpoint",
      },
      {
        key_debug.dap.breakpoint.set,
        function()
          require("dap").set_breakpoint()
        end,
        mode = "n",
        desc = "debug:| dap |=> set breakpoint",
      },
      {
        key_debug.dap.breakpoint.log,
        function()
          require("dap").set_breakpoint(
            nil,
            nil,
            vim.fn.input("log point message: ")
          )
        end,
        mode = "n",
        desc = "debug:| dap |=> log breakpoint",
      },
      {
        key_debug.dap.repl_open,
        function()
          require("dap").repl.open()
        end,
        mode = "n",
        desc = "debug:| dap |=> open repl",
      },
      {
        key_debug.dap.run_last,
        function()
          require("dap").run_last()
        end,
        mode = "n",
        desc = "debug:| dap |=> run last",
      },
      {
        key_debug.dap.hover,
        function()
          require("dap.ui.widgets").hover()
        end,
        mode = "n",
        desc = "debug:| dap |=> hover",
      },
      {
        key_debug.dap.preview,
        function()
          require("dap.ui.widgets").preview()
        end,
        mode = "n",
        desc = "debug:| dap |=> preview",
      },
      {
        key_debug.dap.frames,
        function()
          require("dap.ui.widgets").centered_float(
            require("dap.ui.widgets").frames
          )
        end,
        mode = "n",
        desc = "debug:| dap |=> frames",
      },
      {
        key_debug.dap.scopes,
        function()
          require("dap.ui.widgets").centered_float(
            require("dap.ui.widgets").scopes
          )
        end,
        mode = "n",
        desc = "debug:| dap |=> scopes",
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
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "folke/neodev.nvim",
        opts = function(_, opts)
          opts.library = require("funsak.table").mopts({
            plugins = { { "nvim-dap-ui" }, types = true },
          }, opts.library or {})
        end,
      },
    },
  },
  -- which key integration
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        [key_debug:leader()] = { name = "::debug::" },
        [key_debug.adapters] = {
          name = "debug:| dap |=> adapters",
        },
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
        -- Update this to ensure that you have the debuggers for the langs
        -- you want
      },
    },
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "andrewferrier/debugprint.nvim",
    event = "VeryLazy",
    opts = { create_keymaps = true, move_to_debugline = true },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "andythigpen/nvim-coverage",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      require("coverage").setup(opts)
    end,
    opts = function(_, opts)
      opts.highlights = vim.tbl_deep_extend("force", {
        covered = { link = "DiagnosticVirtualTextHint" },
        uncovered = { link = "DiagnosticVirtualTextError" },
        partial = { link = "DiagnosticVirtualTextInfo" },
      }, opts.highlights or {})
    end,
  },
  {
    "rareitems/printer.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("printer").setup(opts)
    end,
    opts = { keymap = key_debug.printer, behavior = "insert_below" },
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
  {
    "chrisgrieser/nvim-chainsaw",
    opts = {
      marker = "󰹈",
    },
    config = function(_, opts)
      require("chainsaw").setup(opts)
    end,
    keys = {
      {
        key_debug.chainsaw.message,
        function()
          require("chainsaw").messageLog()
        end,
        mode = "n",
        desc = "log:| message |=> create",
      },
      {
        key_debug.chainsaw.variable,
        function()
          require("chainsaw").variableLog()
        end,
        mode = "n",
        desc = "log:| variable |=> create",
      },
      {
        key_debug.chainsaw.object,
        function()
          require("chainsaw").objectLog()
        end,
        mode = "n",
        desc = "log:| object |=> create",
      },
      {
        key_debug.chainsaw.assertion,
        function()
          require("chainsaw").assertLog()
        end,
        mode = "n",
        desc = "log:| assert |=> create",
      },
      {
        key_debug.chainsaw.beep,
        function()
          require("chainsaw").beepLog()
        end,
        mode = "n",
        desc = "log:| beep |=> create",
      },
      {
        key_debug.chainsaw.time,
        function()
          require("chainsaw").timeLog()
        end,
        mode = "n",
        desc = "log:| time |=> create",
      },
      {
        key_debug.chainsaw.debug,
        function()
          require("chainsaw").debugLog()
        end,
        mode = "n",
        desc = "log:| debug |=> create",
      },
      {
        key_debug.chainsaw.remove,
        function()
          require("chainsaw").removeLogs()
        end,
        mode = "n",
        desc = "log:| all |=> remove",
      },
    },
  },
  {
    "smartpde/debuglog",
    event = "VeryLazy",
    cmd = {
      "DebugLogInstallShim",
      "DebugLogEnable",
      "DebugLogEnableFileLogging",
      "DebugLogOpenFileLog",
    },
    opts = {
      log_to_console = true,
      log_to_file = true,
    },
    config = function(_, opts)
      require("debuglog").setup(opts)
    end,
  },
}
