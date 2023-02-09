-- Language Server Setup -- Configuration of Mason, LSPZero, and associated
-- tools.

-- ----- top level module table definition -----
local lsp_setup = {}

-- ---------------------------------------------------------------------------
-- The following settings are for mason, mason-lspconfig, and mason-null-ls
-- ---------------------------------------------------------------------------
-- This module method merges two tables.
-- Acts on the first table directly, e.g. modifies data.
-- ---------------------------------------------------------------------------
-- LSP Ensure Installed Packages
lsp_setup.mason_servers = {
    'jedi_language_server',
    'rust_analyzer',
    'vimls',
    'sqlls',
    'bashls',
    'clangd',
    'jsonls',
    'sumneko_lua',
    'salt_ls',
    'yamlls',
    'diagnosticls',
    'marksman',
    'taplo',
}

lsp_setup.mason_configuration = {
    ui = {
	border = 'single',
    },
}

lsp_setup.mason_lspconfig_configuration = {}

lsp_setup.mason_null_ls_configuration = {
    ensure_installed = nil,
    automatic_installation = true, -- you can still set this to `true`
    automatic_setup = true,
}

-- ---------------------------------------------------------------------------
-- The following settings are for nvim-cmp
-- ---------------------------------------------------------------------------
-- nvim-cmp Configuration
lsp_setup.cmp_sources = {
    { name = 'nvim-lsp' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'env' },
    { name = 'rg' },
    { name = 'luasnip' },
    { name = 'snippy' },
    { name = 'calc' },
    { name = 'cmp_tabnine' },
    { name = 'cmdline' },
    { name = 'dap' },
    { name = 'treesitter' },
    { name = 'ctags' },
    { name = 'otter' },
    { name = 'color_names' },
    { name = 'nvim_lsp_signature_help' },
}

lsp_setup.cmp_configuration = {
    preselect = false,
    completion = {
	autocomplete = false,
	completeopt = 'menu,menuone,noinsert,noselect',
    },
}

-- ---------------------------------------------------------------------------
-- The following settings are for null-ls
-- ---------------------------------------------------------------------------
lsp_setup.null_ls_sources = {
    require('null-ls').builtins.formatting.yapf,
    require('null-ls').builtins.formatting.yamlfmt,
    require('null-ls').builtins.formatting.prettierd,
    require('null-ls').builtins.diagnostics.sqlfluff,
    require('null-ls').builtins.diagnostics.vint,
    require('null-ls').builtins.diagnostics.shellcheck,
    require('null-ls').builtins.diagnostics.commitlint,
}

lsp_setup.null_ls_configuration = {}

function lsp_setup.null_ls_attach(client, bufnr)
--  Do some stuff with client, bufnr
    --  e.g. user function can go here
    
end

-- turn into a module
return lsp_setup
