local env = require("environment.ui")
local opt = require("environment.optional")
local key_code = require("environment.keys").code
local key_lsp = require("environment.keys").lsp
local mopts = require("funsak.table").mopts
local lz = require('funsak.lazy')
local has = lz.has

local function zero_default_keymaps(client, bufnr)
  local zero = require("lsp-zero")
  zero.default_keymaps({
    buffer = bufnr,
    exclude = { "<CR>", "gl", "go", "gs", "<F2>", "<F3>", "<F4>", "<C-k>" },
  })
  vim.keymap.set("n", key_lsp.auxillary.format, function()
    require('lsp-zero').async_autoformat(client, bufnr, {})
  end)
  vim.keymap.set("n", key_lsp.auxillary.rename, vim.lsp.buf.rename, { desc = "lsp=> rename" })
end

local function attach_handler(client, bufnr)
  require("lsp-status").on_attach(client)
  if
    client.supports_method("textDocument/codeLens")
    and has("virtual-types.nvim")
  then
    require("virtualtypes").on_attach(client, bufnr)
  end
  if client.supports_method("textDocument/inlayHint") then
    if not vim.lsp.inlay_hint.enable(bufnr, true) then
      vim.lsp_inlay_hint(bufnr, true)
    end
  end
end

return {
  {
    "VonHeikemen/lsp-zero.nvim",
    lazy = true,
    branch = "v3.x",
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
      vim.g.lsp_zero_ui_float_border = env.borders.main
      vim.g.lsp_zero_ui_signcolumn = 1
    end,
    config = false,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function(_, opts)
      require("mason").setup(opts)
    end,
    opts = {
      ui = {
        border = env.borders.main,
      }
    },
    keys = {
      {
        key_code.mason,
        "<CMD>Mason<CR>",
        mode = "n",
        desc = "lsp.mason=> info panel",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "neovim/nvim-lspconfig" } },
      { "folke/neodev.nvim", opts = {} },
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
      },
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          "L3MON4D3/LuaSnip",
        },
      },
      { "jubnzv/virtual-types.nvim" },
      { "nvim-lua/lsp-status.nvim" },
      { "VonHeikemen/lsp-zero.nvim" },
    },
    -- LSP Configuration
    -- =================
    -- Main LSP Configuration is in the config and opts fields of the
    -- nvim-lspconfig specification. `config` can only be defined once, while
    -- opts can be defined as many times as needed, but there is some extra
    -- functionality that is not available at the `opts` stage in comparison to
    -- the `config` stage.

    ---@alias LanguageServer string
    ---@alias LSPSetupHook fun(srv: LanguageServer, opts: LanguageServerOwlSpec)
    ---@alias LSPSpecCallback fun(): LanguageServerOwlSpec
    ---@alias LSPConfigServerSetupHooks { before: fun(srv: string, opts: T_Opts)?, after: fun(srv: string, opts: T_Opts) }

    ---@class LSPConfigOwlSpec
    ---@field diagnostics table? options for vim.diagnostic.config
    ---@field enhancements { status: boolean | table?, virtual_types: boolean | table?, zero_keymaps: boolean | table?, null_ls: boolean | table?  }
    ---@field servers { [LanguageServer]: LanguageServerOwlSpec | fun(): LanguageServerOwlSpec }?
    ---specification of lsp servers
    ---@field setup { handlers: { [LanguageServer]: fun() }?, hooks: { [LanguageServer]: LSPConfigServerSetupHooks? } }?
    ---@field mason { enabled: { [LanguageServer]: boolean }?, extra_installed: LanguageServer[]? }?
    ---@field format { on_write: boolean?, format_opts: table?, blacklist: { [LanguageServer]: boolean? }? }?
    ---@field capabilities table globally available capabilities that should be
    ---added to all servers.

    ---@param _ LazyPlugin the current plugin, unused in most cases.
    ---@param opts LSPConfigOwlSpec
    config = function(_, opts)
      -- unlike LazyVim, we are using the lsp-zero plugin as the underlying glue
      -- that manages all of our individual components which depend on lsp
      -- configuration. This is things like certain highlights, completion
      -- behavior, and diagnostic display.
      local zero = require("lsp-zero")
      zero.extend_lspconfig()

      -- neoconf.nvim
      -- ============
      -- for project local plugin and LSP settings. This must be loaded first in
      -- order to prevent weird startup issues and not great warning messages.
      -- More accurately, this is simply needed to be set up before we configure
      -- the rest of the LSP, even lsp-zero (which is typically first)
      if has("neoconf.nvim") then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(
          require("lazy.core.plugin").values(plugin, "opts", false)
        )
      end

      -- lsp-status.nvim
      -- ===============
      -- status and progress messages directly from LSP
      local status = require("lsp-status")
      status.register_progress()
      status.config({
        indicator_errors = env.icons.diagnostic.Error,
        indicator_warnings = env.icons.diagnostic.Warning,
        indicator_info = env.icons.diagnostic.Info,
        indicator_hint = env.icons.diagnostic.Hint,
        indicator_ok = env.icons.misc.Ok,
      })

      -- vim.diagnostic.config
      -- =====================
      -- * adjust icon selections and define signs for the corresponding lsp
      --   severities.
      -- * adjust behavior on certain selections of diagnostic display.
      opts.diagnostics = opts.diagnostics or {}
      local diag_icons = require("funsak.table").strip(
        opts.diagnostics,
        { "icons" },
        {},
        false
      )
      for name, icon in pairs(diag_icons) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      if
        type(opts.diagnostics.virtual_text) == "table"
        and opts.diagnostics.virtual_text.prefix == "icons"
      then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0
            and "●"
          or function(diagnostic)
            for d, icon in pairs(diag_icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      -- this sets up the actual diagnostic configuration internally with vim,
      -- as opposed to the additional enhancements that we provided above.
      -- LazyVim's corresponding implementation uses a deepcopy, I'm not sure
      -- why exactly but it is going to stay here.
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- lsp-zero.nvim, mason.nvim, and mason-lspconfig.nvim
      -- ===================================================
      -- in this configuration, we use lsp-zero as the core language server
      -- glue,
      local servers = opts.servers or {}
      local setup = opts.setup or {}
      local non_mason = {}
      local mason_opts = opts.mason or {}
      local enabled_mason = mason_opts.enabled or {}
      local mason_ensure_installed = mason_opts.extra_installed or {}
      local user_handlers = setup.handlers or {}
      local hooks = setup.hooks or {}

      -- lsp-zero.nvim main setup
      -- ========================
      -- this adds the basic configurations that are necessary for lsp-zero and
      -- integrating with the rest of the nightowl.nvim situation
      zero.set_sign_icons({
        error = env.icons.diagnostic.Error,
        warn = env.icons.diagnostic.Warn,
        hint = env.icons.diagnostic.Hint,
        info = env.icons.diagnostic.Info
      })
      zero.on_attach(function(client, bufnr)
        zero_default_keymaps(client, bufnr)
      end)
      zero.set_server_config({
        on_attach = attach_handler,
      })

      local has_mason, mlspcfg = pcall(require, "mason-lspconfig")
      local mlsp_mapping = {}
      if has_mason then
        mlsp_mapping = vim.tbl_keys(
          require("mason-lspconfig.mappings.server").lspconfig_to_package
        )
      end

      local function basic_handler(srv, o)
        return function()
          o = vim.is_callable(o) and o() or o
          o = vim.tbl_deep_extend("force", o, { capabilities = vim.deepcopy(opts.capabilities) or nil })
          require('lspconfig')[srv].setup(o)
        end
      end

      local function handler_switch(srv, o)
        local this_user = user_handlers[srv]
        return this_user ~= nil and this_user or basic_handler(srv, o)
      end

      local function generate_handler(srv, o)
        local is_disabled = mason_opts.enabled[srv] ~= nil and mason_opts.enabled[srv] or true
        local is_masonic = vim.tbl_contains(mlsp_mapping, srv)
        local handler = handler_switch(srv, o)

        local should_use_mason = is_masonic and not is_disabled and handler ~= nil

        return should_use_mason, handler
      end

      -- generally speaking we don't need much in the way of handlers on account
      -- of the default setup being suitable for all default mason options.
      -- Hence we only need a handler for non-mason cases or when the options
      -- are default.
      local function generate_setup(name, sopts)
        sopts = sopts or {}
        sopts = vim.is_callable(sopts) and sopts() or sopts
        local hook_pre, hook_post
        if hooks[name] then
          hook_pre = hooks[name].before ~= nil and hooks[name].before or false
          hook_post = hooks[name].after ~= nil and hooks[name].after or false
        end
        local masonic, wrap_handler = generate_handler(name, sopts)

        if not masonic then
          -- this is a server which we cannot set up through mason directly.
          -- instead we will return the function which does the final
          -- setup...does this make sense?
          non_mason[name] = wrap_handler
        else
          table.insert(mason_ensure_installed, name)
          user_handlers[name] = wrap_handler
        end

      end


      for name,srvopts in pairs(servers) do
        generate_setup(name, srvopts)
      end

      local srvmason = {
        ensure_installed = mason_ensure_installed,
        handlers = vim.tbl_deep_extend("force", { zero.default_setup }, user_handlers)
      }
      vim.notify("final mason: " .. vim.inspect(srvmason))

      -- this is the money, by using the default setup handler provided by
      -- lsp-zero, any language servers without any specifications will be set
      -- up in such a way that expected LSP compatibility is maintained.
      if has_mason then
        mlspcfg.setup(srvmason)
      end

      -- directly set up any servers which are not handled by mason, for one
      -- reason or another
      for name,srvsetup in pairs(non_mason) do
        lz.warn(("server %s setup is not using mason"):format(name))
        srvsetup()
      end

      -- these are technically not required, I still use them both due to the
      -- fact that nushell's main LSP implementation requires using null-ls as a
      -- plugin and provides a corresponding source for null-ls. However, they
      -- are wrapped in a guard to prevent issues in case these are not desired
      -- or needed.
      -- Moreover, consult with the documentation on `mason-null-ls` for more
      -- information on installation and setup using mason-null-ls to configure
      -- null-ls tools and sources automagically.
      local has_nullls, null = pcall(require, "null-ls")
      local has_mnull, mnull = pcall(require, "mason-null-ls")
      if has_mnull then
        mnull.setup({
          ensure_installed = {},
          automatic_installation = true,
          handlers = {},
        })
      end

      if has_nullls then
        null.setup({
          sources = {},
        })
      end

      -- lsp-zero.nvim formatting options
      -- ================================
      -- this too is loosely mimicked from the implementations provided in
      -- lazyvim. But, we make some modifications to integrate lsp-zero
      -- appropriately.
      local fmtopt = opts.format or {}
      local ftfmt = require("funsak.table").strip(
        fmtopt,
        { "formatters_by_ftype" },
        {},
        false
      )
      zero.format_on_save({})
      zero.format_mapping()
    end,
    opts = function(_, opts)
      opts.inlay_hints = mopts(opts.inlay_hints or {}, { enabled = true })
      opts.format_notify = opts.format_notify ~= nil or true
      opts.format = mopts(opts.format or {}, {
        formatting_options = nil,
        timeout_ms = 10000,
      })
      local diag = not has("lsp_lines.nvim")
          and mopts(opts.diagnostics or {}, {

            underline = true,
            update_in_insert = false,
            virtual_text = {
              spacing = 2,
              source = "if_many",
              prefix = "icons",
            },
            severity_sort = true,
            float = {
              border = env.borders.main,
              title = "󰼀 lsp::diagnostic",
              title_pos = "right",
            },
          })
        or {}
      opts.diagnostics = mopts(opts.diagnostics or {}, diag)
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    enabled = opt.lsp.null_ls,
    dependencies = {
      "neovim/nvim-lspconfig",
      { "jay-babu/mason-null-ls.nvim", enabled = opt.lsp.null_ls },
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
    dependencies = {
      "williamboman/mason.nvim",
      { "nvimtools/none-ls.nvim", optional = true },
    },
    optional = true,
  },
  { "jubnzv/virtual-types.nvim", event = "LspAttach" },
  { "lvimuser/lsp-inlayhints.nvim", event = "LspAttach" },
}
