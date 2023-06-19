local env = require("environment.ui")

return {
  -- neodev
  {
    "folke/neodev.nvim",
    opts = {
      debug = true,
      experimental = { pathStrict = true },
    },
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
      { "williamboman/mason.nvim" }, -- Optional
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          "VonHeikemen/lsp-zero.nvim",
        },
      }, -- Optional
      { "jay-babu/mason-null-ls.nvim" },
      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" }, -- Required
      -- Required when using LazyVim, in order to prevent
      -- startup warnings related to incorrect plugin load order.
      { "folke/neoconf.nvim" },
      { "nvim-lua/lsp-status.nvim" },
      { "folke/neodev.nvim" },
    },
    ---@diagnostic disable-next-line: unused-local
    config = function(_, opts)
      local lsp = require("lsp-zero").preset({
        name = "minimal",
        set_lsp_keymaps = { preserve_mappings = true },
        setup_servers_on_start = true,
        float_border = env.borders.main,
        configure_diagnostics = true,
        manage_nvim_cmp = {
          set_basic_mappings = true,
          set_extra_mappings = true,
          set_sources = "recommended",
          use_luasnip = true,
          set_format = false,
          documentation_window = true,
        },
      })
      require("lsp-status").register_progress()
      lsp.on_attach(function(client, bufnr)
        require("lsp-status").on_attach(client)
        lsp.default_keymaps({ buffer = bufnr, preserve_mappings = true })
        if client.server_capabilities.documentSymbolProvider then
          local navic = require("nvim-navic") or {}
          if navic ~= {} then
            navic.attach(client, bufnr)
          end
        end
      end)

      if vim.fn.has("rust-tools") then
        lsp.skip_server_setup("rust_analyzer")
        local rust_tools = require("rust-tools")
        rust_tools.setup({
          server = {
            on_attach = function()
              vim.keymap.set(
                { "n" },
                "<leader>ca",
                rust_tools.hover_actions.hover_actions,
                {
                  buffer = vim.nvim_get_current_buf(),
                  desc = "lsp=> rust code actions for symbol",
                }
              )
            end,
          },
        })
      end

      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls({
        on_attach = function(client, bufnr)
          local hinter = require("inlay-hints") or {}
          print(hinter)
          if hinter ~= {} then
            hinter.on_attach(client, bufnr)
          end
        end,
        settings = {
          Lua = {
            hint = {
              enabled = true,
            },
          },
        },
      }))
      lsp.setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gF",
        vim.lsp.buf.format,
        desc = "lsp=> format current buffer",
      }
      keys[#keys + 1] =
        { "K", vim.lsp.buf.hover, "hover", desc = "lsp=> hover information" }
      keys[#keys + 1] = {
        "gk",
        vim.lsp.buf.signature_help,
        desc = "lsp=> symbol signature help",
      }
      keys[#keys + 1] = {
        "gl",
        vim.diagnostic.open_float,
        desc = "lsp=> show line diagnostics",
      }
      keys[#keys + 1] = {
        "ga",
        vim.lsp.buf.code_action,
        desc = "lsp=> show code actions",
      }
      keys[#keys + 1] = {
        "g?",
        function()
          vim.cmd([[help ]] .. vim.fn.expand("<cword>"))
        end,
        desc = "lsp=> find symbol help",
      }
    end,
    dependencies = {
      "VonHeikemen/lsp-zero.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-null-ls.nvim",
      "nvim-lua/lsp-status.nvim",
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "VonHeikemen/lsp-zero.nvim" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "VonHeikemen/lsp-zero.nvim",
    },
  },
}
