local env = require("environment.ui")

return {
  {
    "folke/lazy.nvim",
    opts = { defaults = { lazy = true }, ui = { border = env.borders.alt } },
  },
  {
    "williamboman/mason.nvim",
    build = function()
      pcall(vim.cmd, "MasonUpdate")
    end,
    opts = { ui = { border = env.borders.alt } },
  },
  ---------------------------------------------------------------------------
  -- if we want to use this (lsp-zero) we need to be a bit more careful about
  -- how we are handling dependencies in the setup of lazyvim. It is unclear
  -- if this is even a worthwhile inclusion, but it simplifies boilerplate
  -- somewhat and I hope better links things between mason and the rest of the
  -- plugin stack.
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { -- Optional
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          "VonHeikemen/lsp-zero.nvim",
        },
      }, -- Optional
      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" }, -- Required
      -- Required when using LazyVim, in order to prevent
      -- startup warnings related to incorrect plugin load order.
      { "folke/neoconf.nvim" },
    },
    config = function(opts)
      -- print(string.format("LSPZero Config: {}", vim.inspect(opts)))
      local lsp = require("lsp-zero").preset({})
      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end)

      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup(opts)
    end,
  },
}
