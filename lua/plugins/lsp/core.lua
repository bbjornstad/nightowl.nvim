local env = require("environment.ui")
local key_sniprun = require("environment.keys").stems.sniprun

return {
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
      }, -- Optional but recommended
      { "jay-babu/mason-null-ls.nvim" },
      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required
      { "hrsh7th/cmp-nvim-lsp" }, -- Required
      { "L3MON4D3/LuaSnip" }, -- Required
      { "nvim-lua/lsp-status.nvim" }, -- Optional but recommended
    },
    opts = {
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
        set_format = true,
        documentation_window = true,
      },
    },
    config = function(_, opts)
      local lsp = require("lsp-zero").preset(opts)
      require("lsp-status").register_progress()
      lsp.on_attach(function(client, bufnr)
        require("lsp-status").on_attach(client)
        lsp.default_keymaps({ buffer = bufnr })
      end)

      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls({
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
    opts = {
      inlay_hints = {
        enabled = true,
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gF",
        vim.lsp.buf.format,
        mode = "n",
        desc = "lsp=> format current buffer",
      }
      -- keys[#keys + 1] =
      --   { "K", vim.lsp.buf.hover, "hover", desc = "lsp=> hover information" }
      keys[#keys + 1] = {
        "gk",
        vim.lsp.buf.signature_help,
        mode = "n",
        desc = "lsp=> symbol signature help",
      }
      -- keys[#keys + 1] = {
      --   "gl",
      --   vim.diagnostic.open_float,
      --   desc = "lsp=> show line diagnostics",
      -- }
      keys[#keys + 1] = {
        "ga",
        vim.lsp.buf.code_action,
        mode = "n",
        desc = "lsp=> show code actions",
      }
      keys[#keys + 1] = {
        "<leader>uHh",
        function()
          vim.lsp.inlay_hint(0, true)
        end,
        mode = "n",
        desc = "lsp=> enable current buffer inlay hints",
      }
      keys[#keys + 1] = {
        "<leader>uHq",
        function()
          vim.lsp.inlay_hint(0, false)
        end,
        mode = "n",
        desc = "lsp=> disable current buffer inlay hints",
      }
    end,
    dependencies = {
      "VonHeikemen/lsp-zero.nvim",
      "nvim-treesitter/nvim-treesitter",
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
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>"] = { name = "+nvim core fxns" },
        ["<localleader>"] = { name = "+metadata and special editor cmds" },
        ["<Bar>"] = { name = "+task and time management" },
        ["`"] = { name = "+repl style" },
        -- TODO Add a few more of these baseline name mappings
        -- directly onto the which-key configuration here.
      },
    },
  },
}