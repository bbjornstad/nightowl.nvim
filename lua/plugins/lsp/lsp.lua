local env = require("environment.ui")
local mopts = require("funsak.table").mopts
local has = require("lazyvim.util").has

local function default_keymaps()
  local kenv = require("environment.keys").lsp
  local scenv = require("environment.keys").shortcut
  local lk = require("lazyvim.plugins.lsp.keymaps").get()
  lk[#lk + 1] = {
    kenv.go.definition,
    vim.lsp.buf.definition,
    mode = "n",
    desc = "::lsp.go=> definition",
  }
  lk[#lk + 1] = {
    kenv.go.declaration,
    vim.lsp.buf.declaration,
    mode = "n",
    desc = "::lsp.go=> declaration",
  }
  lk[#lk + 1] = {
    kenv.go.type_definition,
    vim.lsp.buf.type_definition,
    mode = "n",
    desc = "::lsp.go=> type definition",
  }
  lk[#lk + 1] = {
    kenv.go.references,
    vim.lsp.buf.references,
    mode = "n",
    desc = "::lsp.go=> references",
  }
  lk[#lk + 1] = {
    kenv.go.implementation,
    vim.lsp.buf.implementation,
    mode = "n",
    desc = "::lsp.go=> implementation",
  }
  lk[#lk + 1] = {
    kenv.go.signature_help,
    vim.lsp.buf.signature_help,
    mode = "n",
    desc = "::lsp.go=> signature_help",
  }
  lk[#lk + 1] = {
    kenv.hover,
    vim.lsp.buf.hover,
    mode = "n",
    desc = "::lsp.go=> hover",
  }
  lk[#lk + 1] = {
    kenv.auxillary.rename,
    vim.lsp.buf.rename,
    mode = "n",
    desc = "::lsp.rn=> rename",
  }
  lk[#lk + 1] = {
    kenv.auxillary.format,
    vim.lsp.buf.format,
    mode = "n",
    desc = "::lsp.fmt=> format",
  }
  lk[#lk + 1] = {
    kenv.auxillary.code_action,
    vim.lsp.buf.code_action,
    mode = "n",
    desc = "::lsp.act=> code actions",
  }
  lk[#lk + 1] = {
    kenv.auxillary.open_float,
    vim.diagnostic.open_float,
    mode = "n",
    desc = "::lsp.diag=> line-float",
  }
  lk[#lk + 1] = {
    scenv.diagnostics.go.next,
    vim.diagnostic.goto_next,
    mode = "n",
    desc = "::lsp.diag=> next",
  }
  lk[#lk + 1] = {
    scenv.diagnostics.go.previous,
    vim.diagnostic.goto_prev,
    mode = "n",
    desc = "::lsp.diag=> previous",
  }
end

local function zero_default_keymaps(client, bufnr)
  local zero = require("lsp-zero")
  zero.default_keymaps({
    buffer = bufnr,
    exclude = { "<CR>", "gl", "go", "gs", "<F2>", "<F3>", "<F4>" },
  })
end

local function attach_handler(client, bufnr)
  require("lsp-status").on_attach(client)
  if
    client.supports_method("textDocument/codeLens")
    and has("virtual-types.nvim")
  then
    require("virtualtypes").on_attach(client, bufnr)
  end
  if client.server_capabilities.inlayHintProvider then
    if has("lsp-inlayhints.nvim") then
      require("lsp-inlayhints").on_attach(client, bufnr)
    else
      vim.lsp.inlay_hint(bufnr, true)
    end
  end
end

return {
  {
    "folke/neodev.nvim",
    lazy = false,
    opts = {},
    dependencies = { "folke/neoconf.nvim" },
  },
  {
    "folke/neoconf.nvim",
    lazy = false,
    cmd = "Neoconf",
    config = false,
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "folke/neoconf.nvim" },
      { "folke/neodev.nvim", opts = {} },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "L3MON4D3/LuaSnip",
        },
      },
      { "jubnzv/virtual-types.nvim", optional = true },
      { "lvimuser/lsp-inlayhints.nvim", optional = true },
      { "nvim-lua/lsp-status.nvim" },
      { "VonHeikemen/lsp-zero.nvim", optional = true },
    },
    opts = function(_, opts)
      local status = require("lsp-status")
      status.register_progress()
      status.config({
        indicator_errors = env.icons.diagnostic.Error,
        indicator_warnings = env.icons.diagnostic.Warning,
        indicator_info = env.icons.diagnostic.Info,
        indicator_hint = env.icons.diagnostic.Hint,
        indicator_ok = env.icons.misc.Ok,
      })
      opts.inlay_hints = mopts(opts.inlay_hints or {}, { enabled = true })
      opts.capabilities = mopts(opts.capabilities or {}, {})
      opts.format_notify = opts.format_notify or true
      opts.format = mopts(opts.format or {}, {
        formatting_options = nil,
        timeout_ms = 10000,
      })
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
      opts.servers = mopts({
        efm = {},
        contextive = {},
      }, opts.servers or {})

      local fn_setup
      if has("lsp-zero.nvim") then
        local zero = require("lsp-zero")
        vim.notify("Inside zero setup...")
        zero.extend_lspconfig()
        fn_setup = function(server, o)
          zero.default_setup(server)
        end
        zero.on_attach(function(client, bufnr)
          zero_default_keymaps(client, bufnr)
        end)
        zero.set_server_config({
          on_attach = attach_handler,
        })
      else
        fn_setup = function(server, o)
          require("lspconfig")[server].setup(mopts(o, {
            on_attach = attach_handler,
          }))
        end
      end
      opts.setup = mopts(opts.setup or {}, {
        ["*"] = fn_setup,
      })
    end,
    init = default_keymaps,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "jay-babu/mason-null-ls.nvim",
    },
    config = function(_, opts)
      require("null-ls").setup(opts)
      require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
      })
    end,
    opts = {},
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
  },
  { "williamboman/mason.nvim" },
  { "jubnzv/virtual-types.nvim", event = "LspAttach" },
  { "lvimuser/lsp-inlayhints.nvim", event = "LspAttach" },
  {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x",
    dependencies = { "neovim/nvim-lspconfig" },
  },
}
