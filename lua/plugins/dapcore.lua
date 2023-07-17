return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      --- fancy UI for the debugger
      { "rcarriga/nvim-dap-ui", opts = {} },
      -- virtual text for the debugger
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      -- which key integration
      {
        "folke/which-key.nvim",
        opts = function(_, opts)
          opts.defaults = vim.tbl_extend("force", opts.defaults or {}, {
            ["<leader>d"] = { name = "+debug" },
            ["<leader>da"] = { name = "+adapters" },
            -- TODO Add a few more of these baseline name mappings
            -- directly onto the which-key configuration here.
          })
        end,
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
    },
  },
}
