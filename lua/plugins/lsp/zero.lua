local env = require("environment.ui")
local merger = require("uutils.merger")

return {
  {
    "folke/neodev.nvim",
    opts = {},
    config = function(_, opts) require('neodev').setup(opts) end,
  },
  {
    "folke/neoconf.nvim",
    opts = {},
    config = false,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function(_, opts)
      require("null-ls").setup(opts)
    end,
  },
  ---------------------------------------------------------------------------
  -- if we want to use this (lsp-zero) we need to be a bit more careful about
  -- how we are handling dependencies in the setup of lazyvim. It is unclear
  -- if this is even a worthwhile inclusion, but it simplifies boilerplate
  -- somewhat and I hope better links things between mason and the rest of the
  -- plugin stack.
  --
  -- Update: 2023-09-19: LSPZero is here to stay. I like it.
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = function(_, opts) end,
    init = function()
      vim.g.lsp_zero_extend_cmp = 1
      vim.g.lsp_zero_extend_lspconfig = 1
      vim.g.lsp_zero_ui_float_border = env.borders.main
      vim.g.lsp_zero_ui_signcolumn = 1
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    dependencies = {
      "williamboman/mason.nvim",
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = {},
        },
      },
      {
        "jay-babu/mason-null-ls.nvim",
        dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
      },
      "nvimtools/none-ls.nvim",
      {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
      },
      -- Optional but recommended
      { "nvim-lua/lsp-status.nvim" },
      -- required now
      -- { "27justin/virtuality.nvim" },
      { "jubnzv/virtual-types.nvim" },
      -- required now
      { "VonHeikemen/lsp-zero.nvim" },
      { "b0o/SchemaStore.nvim" },
      { "folke/neoconf.nvim" },
    },
    config = function(_, opts)
      local zero = require("lsp-zero")
      local status = require('lsp-status')
      require('neoconf').setup({
        import = {
          vscode = true,
          coc = true,
          nlsp = true,
        },
      })
      zero.extend_lspconfig()
      status.register_progress()
      zero.on_attach(function(client, bufnr)
        zero.default_keymaps({ buffer = bufnr })
      end)

      local capabilities = vim.tbl_deep_extend("force", {},
        zero.get_capabilities(), opts.capabilities or {}) or {}
      zero.set_server_config({
        capabilities = capabilities
      })

      local function on_attach(client)
        if client.supportsMethod('textdocument/codeLens') then
          require('virtualtypes').on_attach(client)
        end
        status.on_attach(client)
      end

      local function setup(server, topts)
        local sopts = vim.tbl_deep_extend("force", {
          capabilities = vim.tbl_deep_extend("force", vim.deepcopy(capabilities),
            status.capabilities or {}),
          handlers = status.extensions[server].setup() or {},
          on_attach = on_attach
        }, opts.servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, sopts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, sopts) then
            return
          end
        end
        require('lspconfig')[server].setup(sopts)
      end

      require("mason").setup()

      local masopts = vim.tbl_deep_extend("force", {
        ensure_installed = {},
        handlers = {
          zero.default_setup,
        },
      }, require('lazyvim.util').opts('mason-lspconfig.nvim'))
      vim.notify(vim.inspect(masopts))
      require("mason-lspconfig").setup(masopts)

      require("mason-null-ls").setup({
        ensure_installed = { "stylua", "selene" },
        automatic_installation = true,
      })
      require("null-ls").setup({
        sources = {},
      })

      zero.format_on_save({
        format_opts = {
          async = false,
          timeout = 10000,
        },
        servers = {
          ["rust_analyzer"] = { "rust" },
          ["lua_ls"] = { "lua" },
          ["jsonls"] = { "json" },
          ["yamlls"] = { "yaml" },
          ["bashls"] = { "bash" },
          ["nu-ls"] = { "nu" },
          ["clojure_lsp"] = { "clojure" },
          ["jedi_language_server"] = { "python" },
        },
      })

      zero.set_sign_icons({
        error = "",
        warn = "󱒾",
        info = "󱇏",
        hint = "󰻸",
      })
      require("lspconfig.ui.windows").default_options.border = env.borders.main
    end,
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●"
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = true,
      },
      capabilities = {},
      autoformat = true,
      format_notify = true,
      format = {
        formatting_options = nil,
        timeout_ms = 5000
      },
      servers = {},
      setup = {
        ["*"] = function(server, opts) end
      }
    },
  },
}
