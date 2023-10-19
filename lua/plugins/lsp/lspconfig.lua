local mopts = require("funsak.table").mopts
local key_lsp = require("environment.keys").lsp

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          { "hrsh7th/cmp-nvim-lsp" },
          { "L3MON4D3/LuaSnip" },
        },
      },
      -- required now
      { "nvim-lua/lsp-status.nvim" },
      { "jubnzv/virtual-types.nvim" },
    },
    init = function()
      local lk = require("lazyvim.plugins.lsp.keymaps").get()
      lk[#lk + 1] = { "K", vim.lsp.buf.hover, mode = "n", desc = "lsp=> hover" }
      lk[#lk + 1] = {
        key_lsp.definition,
        vim.lsp.buf.definition,
        mode = "n",
        desc = "lsp=> definition",
      }
      lk[#lk + 1] = {
        key_lsp.declaration,
        vim.lsp.buf.declaration,
        mode = "n",
        desc = "lsp=> declaration",
      }
      lk[#lk + 1] = {
        key_lsp.implementation,
        vim.lsp.buf.implementation,
        mode = "n",
        desc = "lsp=> implementation",
      }
      lk[#lk + 1] = {
        key_lsp.type_definition,
        vim.lsp.buf.type_definition,
        mode = "n",
        desc = "lsp=> type definition",
      }
      lk[#lk + 1] = {
        key_lsp.references,
        vim.lsp.buf.references,
        mode = "n",
        desc = "lsp=> references",
      }
      lk[#lk + 1] = {
        key_lsp.signature_help,
        vim.lsp.buf.signature_help,
        mode = "n",
        desc = "lsp=> signature help",
      }
      lk[#lk + 1] = {
        key_lsp.rename,
        vim.lsp.buf.rename,
        mode = "n",
        desc = "lsp=> rename",
      }
      lk[#lk + 1] = {
        key_lsp.code_action,
        vim.lsp.buf.code_action,
        mode = "n",
        desc = "lsp=> code action",
      }
      lk[#lk + 1] = {
        key_lsp.open_float,
        vim.diagnostic.open_float,
        mode = "n",
        desc = "lsp=> float diagnostics",
      }
      lk[#lk + 1] = {
        key_lsp.goto_next,
        vim.diagnostic.goto_next,
        mode = "n",
        desc = "lsp=> float diagnostics",
      }
      lk[#lk + 1] = {
        key_lsp.goto_prev,
        vim.diagnostic.goto_prev,
        mode = "n",
        desc = "lsp=> float diagnostics",
      }
    end,
    opts = function(_, opts)
      require("lsp-status").register_progress()
      local attach_hook = require("lazyvim.util.lsp").on_attach
      attach_hook(function(client, bufnr)
        if client.supports_method("textDocument/codeLens") then
          require("virtualtypes").on_attach(client)
        end
        require("lsp-status").on_attach(client)
      end)

      opts.diagnostics = mopts(opts.diagnostics or {}, {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "icons",
        },
        severity_sort = true,
      })
      opts.inlay_hints = mopts(opts.inlay_hints or {}, {
        enabled = true,
      })
      opts.capabilities = mopts(opts.capabilities or {}, {})
      opts.format_notify = opts.format_notify or true
      opts.format = mopts(opts.format or {}, {
        formatting_options = nil,
        timeout_ms = 5000,
      })
      opts.servers = mopts(opts.servers or {}, {})
      opts.setup = mopts(opts.setup or {}, {
        -- ["*"] = function(server, opts) end
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function(_, opts)
      require("null-ls").setup(opts)
    end,
    opts = {
      sources = {},
    },
  },
}
