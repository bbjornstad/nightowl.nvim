local env = require("environment.ui")
local opt = require("environment.optional")
local key_code = require("environment.keys").code
local key_lsp = require("environment.keys").lsp
local key_sc = require("environment.keys").shortcut
local mopts = require("funsak.table").mopts
local lz = require("funsak.lazy")

-- LSP Configuration
-- =================
-- Main LSP Configuration is in the config and opts fields of the nvim-lspconfig
-- specification. `config` can only be defined once, while opts can be defined
-- as many times as needed, but there is some extra functionality that is not
-- available at the `opts` stage in comparison to the `config` stage.

--- extension of the standard lsp.Client object to hold additional parliament
--- specific options.
---@class owl.lsp.ServerClient: string

---@class owl.lsp.ClientConfig: lspconfig.options

---@alias owl.lsp.EnhancementSpec
---| boolean # flag to enable or disable the corresponding enhancement
---| table # alternatively, a table of configuration options overriding
---defaults, if it makes sense to give this for the target enhancement.

--- enhancement components specification for all language servers.
---@class owl.lsp.Enhancements
--- enabling flag or options for lsp-status.nvim
---@field status owl.lsp.EnhancementSpec?
--- enabling flag or options for virtual-types.nvim
---@field virtual_types owl.lsp.EnhancementSpec?
--- enabling flag or options for lsp inlay_hints
---@field inlay_hints owl.lsp.EnhancementSpec?

--- extension of lsp.ConfigurationParams to hold additional parliament
--- specific options.
---@class owl.lsp.LSPConfigSpec: lsp.ConfigurationParams
--- options for vim.diagnostic.config
---@field diagnostics lsp.DiagnosticOptions?
--- specification of lsp servers
---@field servers { [owl.lsp.ServerClient]: owl.lsp.ClientConfig | fun(): owl.lsp.ClientConfig }?
--- alternative setup specification
---@field setup { handlers: { [owl.lsp.ServerClient]: fun() }?, hooks: { [owl.lsp.ServerClient]: owl.lsp.SetupHooks? } }?
--- mason behavioral adjustments
---@field mason { enabled: { [owl.lsp.ServerClient]: boolean }?, extra_installed: owl.lsp.ServerClient[]? }?
--- formatting configuration specification. Generally overridden by conform.
---@field format { on_write: boolean?, format_opts: table?, blacklist: { [owl.lsp.ServerClient]: boolean? }? }?
--- globally available capabilities that should be added to all servers.
---@field capabilities lsp.ClientCapabilities?
--- whether or not to enable inlay hints or additional config options for hints
---@field inlay_hints owl.lsp.EnhancementSpec?
--- target log level for the lsp system.
---@field log_level vim.log.levels?

local function generate_lsp_keymapper(opts)
  local function lsp_keymapper(client, bufnr)
    vim.keymap.set("n", key_lsp.auxiliary.format.zero, function()
      require("lsp-zero").async_autoformat(client, bufnr, {})
    end, { desc = "lsp:buf| fmt |=> apply zero", buffer = bufnr })
    vim.keymap.set(
      "n",
      key_lsp.auxiliary.code_action,
      vim.lsp.buf.code_action,
      { desc = "lsp:| act |=> code actions", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.auxiliary.rename,
      vim.lsp.buf.rename,
      { desc = "lsp:| act |=> rename symb", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.auxiliary.info,
      "<CMD>LspInfo<CR>",
      { desc = "lsp:| info |=> servers", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.auxiliary.log,
      "<CMD>LspLog<CR>",
      { desc = "lsp:| log |=> view", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_sc.diagnostics.go.next,
      vim.diagnostic.goto_next,
      { desc = "lsp:| diag |=> next", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_sc.diagnostics.go.previous,
      vim.diagnostic.goto_prev,
      { desc = "lsp:| diag |=> previous", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.diagnostic.buffer,
      vim.diagnostic.open_float,
      { desc = "lsp:| diag |=> float", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.go.type_definition,
      vim.lsp.buf.type_definition,
      { desc = "lsp:| go |=> type definition", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.go.signature_help,
      vim.lsp.buf.signature_help,
      { desc = "lsp:| go |=> signature help", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.go.definition,
      vim.lsp.buf.definition,
      { desc = "lsp:| go |=> definition", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.go.references,
      vim.lsp.buf.references,
      { desc = "lsp:| go |=> references", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.go.implementation,
      vim.lsp.buf.implementation,
      { desc = "lsp:| go |=> implementation", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.calls.incoming,
      vim.lsp.buf.incoming_calls,
      { desc = "lsp:| calls |=> incoming", buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      key_lsp.calls.outgoing,
      vim.lsp.buf.outgoing_calls,
      { desc = "lsp:| calls |=> outgoing", buffer = bufnr }
    )
  end
  return lsp_keymapper
end

local function generate_zero_keymapper(opts)
  local function zero_keymaps(client, bufnr)
    local zero = require("lsp-zero")
    zero.default_keymaps({
      buffer = bufnr,
      exclude = opts.exclude or {},
    })
  end
  return zero_keymaps
end

local function generate_keymappers()
  local zk = lz.opts("lsp-zero.nvim").default_keymaps or {}
  zk = vim.tbl_contains({ "boolean", "table" }, type(zk)) and zk or { zk }
  zk = zk == true and {} or zk
  local zkm = generate_zero_keymapper(zk)

  local lspk = generate_lsp_keymapper()

  return zkm, lspk
end

--- creates a version of the attach_handler for a language server with
--- customizable "enhancement" plugin integrations.
---@param enhancements owl.lsp.Enhancements
---@return fun(client: lsp.Client, bufnr: integer) handler
local function generate_attach_handler(enhancements)
  local status = enhancements.status ~= nil and enhancements.status or true
  status = not vim.tbl_contains({ "table", "boolean" }, type(status))
      and { status }
    or status
  local vtypes = enhancements.virtual_types ~= nil
      and enhancements.virtual_types
    or true
  vtypes = not vim.tbl_contains({ "table", "boolean" }, type(vtypes))
      and { vtypes }
    or vtypes
  local hints = enhancements.inlay_hints ~= nil and enhancements.inlay_hints
    or true
  hints = not vim.tbl_contains({ "table", "boolean" }, type(hints))
      and { hints }
    or hints

  ---@param client lsp.Client
  local function attach_handler(client, bufnr)
    if status and lz.has("lsp-status.nvim") then
      require("lsp-status").on_attach(client)
    end
    if
      vtypes
      and client.supports_method("textDocument/codeLens")
      and lz.has("virtual-types.nvim")
    then
      require("virtualtypes").on_attach(client, bufnr)
    end
    if hints and client.supports_method("textDocument/inlayHint") then
      if vim.fn.has("nvim-0.10.0") == 0 and lz.has("lsp-inlayhints.nvim") then
        require("lsp-inlayhints").on_attach(client, bufnr)
      else
        local ih = vim.lsp.inlay_hint.enable ~= nil
            and vim.lsp.inlay_hint.enable
          or vim.lsp.inlay_hint
        local ok, res = pcall(ih, bufnr, true)
        if not ok then
          lz.warn(
            ("Failed to set inlay hints for server: %s\nMessage: %s"):format(
              client,
              res
            )
          )
        end
      end
    end
  end

  return attach_handler
end

return {
  -- LSP-Zero: Core LSP Glue
  -- =======================
  -- The lsp-zero plugin is responsible for providing an interface integrating
  -- various LSP-related components to each other, for instance nvim-lspconfig
  -- and mason-lspconfig are held together with lsp-zero in that the lsp-zero
  -- provides a default handler out of the box for use with mason-lspconfig.
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
    config = function(_, opts) end,
    opts = {
      default_keymaps = {
        enabled = true,
        excluded = { "gl", "go", "gs", "<F2>", "<F3>", "<F4>", "<C-k>" },
      },
    },
  },
  -- Mason.nvim
  -- ==========
  -- Installs and manages local language server installations.
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function(_, opts)
      require("mason").setup(opts)
    end,
    opts = {
      log_level = vim.log.levels.DEBUG,
      ui = { border = env.borders.main },
    },
    keys = {
      {
        key_code.mason,
        "<CMD>Mason<CR>",
        mode = "n",
        desc = "lsp:| mason |=> info panel",
      },
    },
  },
  -- nvim-lspconfig: Core Plugin to Manage LSP Behavior and Modifications
  -- ====================================================================
  -- the nvim-lspconfig plugin is not technically the only way to initialize and
  -- setup the LSP and associated servers and language configurations. It is,
  -- however a very useful plugin that is hosted on neovim's github, so it
  -- should probably be considered as strictly necessary. Regardless, trying to
  -- set up the LSP without this plugin would probably go terribly.
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- copied from LazyVim specification of neoconf and neodev. The
      -- documentation about these plugins are not great, so copying makes more
      -- sense. But, I also feel like the specs make sense.
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        config = false,
        dependencies = { "neovim/nvim-lspconfig" },
      },
      { "folke/neodev.nvim", opts = {} },
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
      },
      {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip" },
      },
      { "VonHeikemen/lsp-zero.nvim" },
      -- enhancement controlled
      { "jubnzv/virtual-types.nvim", optional = true },
      { "nvim-lua/lsp-status.nvim", optional = true },
    },

    ---@param _ LazyPlugin
    ---@param opts owl.lsp.LSPConfigSpec
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
      if lz.has("neoconf.nvim") then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(
          require("lazy.core.plugin").values(plugin, "opts", false)
        )
      end

      local vtypes_opts, status_opts, hint_opts
      if lz.has("virtual-types.nvim") then
        vtypes_opts = lz.opts("virtual-types.nvim") or {}
      end
      if lz.has("lsp-status.nvim") then
        status_opts = lz.opts("lsp-status.nvim") or {}
      end
      hint_opts = (vim.fn.has("nvim-0.10.0") and opts.inlay_hints)
        or (lz.has("lsp-inlayhints.nvim") and lz.opts("lsp-inlayhints.nvim"))
        or {}

      -- optional enhancement submodules
      -- ===============================
      -- this is to allow conditional configuration of the following features
      -- without failure if the corresponding plugin doesn't exist.
      local enhance = {
        status = status_opts.enabled ~= nil and status_opts.enabled
          or status_opts,
        virtual_types = vtypes_opts.enabled ~= nil and vtypes_opts.enabled
          or vtypes_opts,
        inlay_hint = hint_opts.enabled ~= nil and hint_opts.enabled
          or hint_opts,
      }

      if enhance.status then
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
      end

      -- lsp-zero.nvim, mason.nvim, and mason-lspconfig.nvim
      -- ===================================================
      -- in this configuration, we use lsp-zero as the core language server
      -- glue. This requires a bit of special setup for our purposes here, even
      -- though the plugin is designed to reduce overall boilerplate in setting
      -- up LSP capabilities. This is because of the fact that we are seeking
      -- the most modular setup possible, and as a result, each language that is
      -- targeted for development capabilities should be capable of specifying
      -- all of its integrations in a single file specific to the language. In
      -- other words, there should be no language-specific configuration present
      -- in this file, but rather they should be provided in the `language`
      -- subdirectory.
      local servers = opts.servers or {}
      local setup = opts.setup or {}
      local non_mason = {}
      local mason_opts = opts.mason or {}
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
        info = env.icons.diagnostic.Info,
      })
      local zkm, lspk = generate_keymappers()
      zero.on_attach(function(client, bufnr)
        if zkm then
          zkm(client, bufnr)
        end
        if lspk then
          lspk(client, bufnr)
        end
      end)
      -- create an appropriate server attach handler based on the enhancements
      -- specification.
      zero.set_server_config({
        on_attach = generate_attach_handler(enhance),
      })

      -- mason.nvim and mason-lspconfig.nvim setup
      -- =========================================
      -- this is the section which does the brunt of the heavy lifting of
      -- configuration of language servers. It does so by using a combination of
      -- handler-factories, e.g. factory functions which produce specifically
      -- configured handlers based on the user configurations provided.
      --
      -- TODO: we may perhaps want to utilize the fact that lazy.nvim ships with
      -- a set of utilities (that are not very well covered in docs and seem
      -- mostly internal) that can manipulate the internal plugin spec object
      -- that tracks all plugin configurations provided by the user. The current
      -- methods are more like LazyVim in their spirit, given that we dogpile
      -- many configuration options for different plugins of the lsp into the
      -- nvim-lspconfig spec.
      local has_mason, mlspcfg = pcall(require, "mason-lspconfig")
      local mlsp_mapping = {}
      if has_mason then
        mlsp_mapping = vim.tbl_keys(
          require("mason-lspconfig.mappings.server").lspconfig_to_package
        )
      end

      -- the most basic handler that the LSP could support here, note that this
      -- is a thin additional wrapping around the call to the specific server's
      -- setup function which handles some additional modification of options.
      -- Namely, this allows the options to be passed as a callback function
      -- which returns the options table, and further adds any global
      -- capabilities configured here.
      local function basic_handler(srv, o)
        return function()
          o = vim.is_callable(o) and o() or o
          o = vim.tbl_deep_extend(
            "force",
            o,
            {
              capabilities = vim.deepcopy(opts.capabilities) or nil,
            },
            lz.has("lsp-status.nvim") and require("lsp-status").capabilities
              or {}
          )
          require("lspconfig")[srv].setup(o)
        end
      end

      -- helper function to handle the execution of the before-setup and
      -- after-setup hooks for an LSP server. These are specifiable via the
      -- `setup` key.
      local function attach_hooks(fn, name, ...)
        local this_hook = name ~= nil and hooks[name] or {}
        local hook_post = vim.is_callable(this_hook) and this_hook
          or this_hook.after
        local hook_pre = this_hook.before
        local hook_args = { ... }

        return function(...)
          if hook_pre then
            hook_pre(unpack(hook_args))
          end
          fn(...)
          if hook_post then
            hook_post(unpack(hook_args))
          end
        end
      end

      -- helper function which will pick the user-specified handler for the
      -- server if it exists, and otherwise gets the basic handler. In either
      -- case, the attach_hooks function is used to add the setup hooks for any
      -- handler passed.
      local function handler_switch(srv, o)
        local this_user = user_handlers[srv]
        return this_user ~= nil and attach_hooks(this_user, srv)
          or attach_hooks(basic_handler(srv, o), srv)
      end

      -- creates a handler function using the above suite of factory functions,
      -- noting in particular that if the default lsp-zero setup is used, we
      -- actually don't want to generate any handler and instead zero the entry
      -- by returning nil, thereby using the first passed handler in
      -- mason-lspconfig.
      local function generate_handler(srv, o)
        local is_enabled = mason_opts.enabled[srv] ~= nil
            and mason_opts.enabled[srv]
          or true
        local is_masonic = vim.tbl_contains(mlsp_mapping, srv)
        local handler = handler_switch(srv, o)

        local should_use_mason = is_enabled and is_masonic

        return should_use_mason, handler
      end

      -- generally speaking we don't need much in the way of handlers on account
      -- of the default setup being suitable for all default mason options.
      -- Hence we only need a handler for non-mason cases or when the options
      -- are default.
      local function generate_setup(name, sopts)
        sopts = sopts or {}
        sopts = vim.is_callable(sopts) and sopts() or sopts
        local masonic, wrap_handler = generate_handler(name, sopts)

        if masonic then
          table.insert(mason_ensure_installed, name)
          user_handlers[name] = wrap_handler
        else
          -- this is a server which we cannot set up through mason directly.
          -- instead we will return the function which does the final
          -- setup...does this make sense?
          non_mason[name] = wrap_handler
        end
      end

      -- creates setup handlers for all configured servers.
      for name, srvopts in pairs(servers) do
        generate_setup(name, srvopts)
      end

      local srvmason = {
        ensure_installed = mason_ensure_installed,
        handlers = vim.tbl_extend(
          "force",
          { attach_hooks(zero.default_setup) },
          user_handlers
        ),
      }

      -- this is the money, by using the default setup handler provided by
      -- lsp-zero, any language servers without any specifications will be set
      -- up in such a way that expected LSP compatibility is maintained.
      if has_mason then
        mlspcfg.setup(srvmason)
      end

      -- directly set up any servers which are not handled by mason, for one
      -- reason or another
      for name, srvsetup in pairs(non_mason) do
        -- lz.warn(("server %s setup is not using mason"):format(name))
        srvsetup()
      end

      vim.diagnostic.config(opts.diagnostics or {})

      ---@diagnostic disable-next-line: param-type-mismatch
      vim.lsp.set_log_level(opts.log_level or vim.log.levels.WARN)
    end,
    opts = function(_, opts)
      opts.inlay_hints =
        vim.tbl_deep_extend("force", opts.inlay_hints or {}, { enabled = true })
      opts.format_notify = opts.format_notify ~= nil or true
      opts.format = vim.tbl_deep_extend(
        "force",
        opts.format or {},
        { formatting_options = nil, timeout_ms = 10000 }
      )
    end,
  },
  {
    "jubnzv/virtual-types.nvim",
    config = function(_, opts) end,
    opts = { enabled = true },
    event = "LspAttach",
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    config = function(_, opts)
      require("lsp-inlayhints").setup()
    end,
    opts = { enabled = true },
    event = "LspAttach",
  },
  {
    "nvim-lua/lsp-status.nvim",
    config = function(_, opts) end,
    opts = { enabled = true },
    event = "LspAttach",
  },
}
