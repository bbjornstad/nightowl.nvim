local env = require("environment.ui")

return {
  -- neodev
  {
    "folke/neodev.nvim",
    opts = {
      debug = true,
      experimental = { pathStrict = true },
      library = { runtime = "~/projects/neovim/runtime/" },
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
      -- { -- Optional
      --  "williamboman/mason.nvim",
      --  build = function()
      --    pcall(vim.cmd, "MasonUpdate")
      --  end,
      -- },
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
    config = function()
      -- print(string.format("LSPZero Config: {}", vim.inspect(opts)))
      local lsp = require("lsp-zero").preset(vim.tbl_deep_extend("force", {}, {
        set_lsp_keymaps = { preserve_mappings = true },
        float_border = env.borders.main,
        manage_nvim_cmp = {
          set_basic_mappings = true,
          set_extra_mappings = true,
          set_sources = "recommended",
          use_luasnip = true,
          set_format = true,
          documentation_window = true,
        },
      }))
      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr, preserve_mappings = false })
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, bufnr)
        end
      end)

      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()
    end,
  },
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
        "<CMD>lua require'pretty_hover'.hover()<CR>",
        -- vim.lsp.buf.hover,
        "lsp hover item information",
      }
      keys[#keys + 1] = { "gK", vim.lsp.buf.hover, "hover (unprettified)" }
      keys[#keys + 1] = {
        "g?",
        function()
          vim.cmd([[help]])
        end,
      }
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
