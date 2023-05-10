return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre" },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gF",
        vim.lsp.buf.format,
        "lsp-format current buffer",
      }
      keys[#keys + 1] = {
        "K",
        vim.lsp.buf.hover,
        "lsp hover item information",
      }
      keys[#keys + 1] = { "g?", vim.lsp.buf.hover }
    end,
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre" },
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "williamboman/mason.nvim",
      },
      "VonHeikemen/lsp-zero.nvim",
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre" },
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      "williamboman/mason.nvim",
      "VonHeikemen/lsp-zero.nvim",
    },
    opts = {
      ensure_installed = nil,
      automatic_installation = true, -- You can still set this to `true`
      handlers = {
        -- Here you can add functions to register sources.
        -- See https://github.com/jay-babu/mason-null-ls.nvim#handlers-usage
        --
        -- If left empty, mason-null-ls will  use a "default handler"
        -- to register all sources
      },
    },
  },
}
