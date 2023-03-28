local lsp_setup = {}

lsp_setup.uiconfig = {float = {border = "single"}}

-- ---------------------------------------------------------------------------
-- The following settings are for mason, mason-lspconfig, and mason-null-ls
-- ---------------------------------------------------------------------------
-- LSP Ensure Installed Packages
lsp_setup.mason_servers = {
    "jedi_language_server", "rust_analyzer", "vimls", "sqlls", "bashls",
    "clangd", "jsonls", "lua_ls", "salt_ls", "yamlls", "diagnosticls",
    "marksman", "taplo"
}

-- Mason UI Settings
lsp_setup.mason_configuration = {ui = {border = "single"}}

lsp_setup.mason_lspconfig_configuration = {}

lsp_setup.mason_null_ls_configuration = {
    ensure_installed = nil,
    automatic_installation = true, -- you can still set this to `true`
    automatic_setup = true
}

-- ---------------------------------------------------------------------------
-- The following settings are for nvim-cmp
-- ---------------------------------------------------------------------------
-- nvim-cmp Configuration
lsp_setup.cmp_sources = {
    {name = "nvim-lsp", max_item_count = 5},
    {name = "buffer", max_item_count = 5}, {name = "path", max_item_count = 4},
    {name = "env", max_item_count = 4}, {name = "rg", max_item_count = 3},
    {name = "luasnip", max_item_count = 3},
    {name = "snippy", max_item_count = 4}, {name = "dap", max_item_count = 5},
    {name = "calc", max_item_count = 3},
    {name = "cmp_tabnine", max_item_count = 3},
    {name = "cmdline", max_item_count = 3},
    {name = "treesitter", max_item_count = 4},
    {name = "ctags", max_item_count = 3}, {name = "otter", max_item_count = 3},
    {name = "color_names", max_item_count = 3},
    {name = "nvim_lsp_signature_help", max_item_count = 3}
}

lsp_setup.cmp_configuration = {
    preselect = true,
    completion = {
        autocomplete = false,
        completeopt = "menu,menuone,noinsert"
    },
    window = {documentation = {border = "solid"}}
}

local usr_keybinds = require("keymappings")
lsp_setup.cmp_keymaps = usr_keybinds.cmp_mappings

-- ---------------------------------------------------------------------------
-- The following settings are for any additional behavior that should occur
-- during the on_attach phase of setting up the language server for a particular
-- file. We are namely including:
-- 	- Forcing the LSP keybindings to take their default values as specified by
-- 	nvim-lspconfig and not from any plugin that may have overwritten them.
-- 	- nvim-navic support
-- 	- ???
-- ---------------------------------------------------------------------------
function lsp_setup.on_attach_user(client, bufnr)
    local wk = require("uutils.key").wkreg
    local namer = require("uutils.key").wknamer
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
    local mapk = require("uutils.key").mapk

    local mname = "Language server"
    local stem = "defaults"

    wk({["g"] = {name = 'Go to do actions"'}})
    mapk("n", "gD", vim.lsp.buf.declaration,
         vim.tbl_extend("force", bufopts, {desc = "go to declaration"}))
    mapk("n", "gd", vim.lsp.buf.definition,
         vim.tbl_extend("force", bufopts, {desc = "go to definition"}))
    mapk("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, {
        desc = "open hover for item under cursor"
    }))
    mapk("n", "gi", vim.lsp.buf.implementation,
         vim.tbl_extend("force", bufopts, {desc = "go to implementation"}))
    mapk("n", "<C-k>", vim.lsp.buf.signature_help,
         vim.tbl_extend("force", bufopts, {desc = "function signature help"}))

    wk({[";"] = {name = namer("workspace actions", "", true)}})
    mapk("n", ";wa", vim.lsp.buf.add_workspace_folder,
         vim.tbl_extend("force", bufopts, {desc = "add folder to workspace"}))
    mapk("n", ";wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend(
             "force", bufopts, {desc = "remove folder from workspace"}))
    mapk("n", ";wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend("force", bufopts, {desc = "list folders in workspace"}))
    mapk("n", "gT", vim.lsp.buf.type_definition,
         vim.tbl_extend("force", bufopts, {desc = "go to type definition"}))
    wk({["gc"] = {name = "go with change"}})
    mapk("n", "gcr", vim.lsp.buf.rename,
         vim.tbl_extend("force", bufopts, {desc = "rename via LSP"}))
    mapk("n", "gca", vim.lsp.buf.code_action,
         vim.tbl_extend("force", bufopts, {desc = "code actions"}))
    mapk("n", "gl", vim.diagnostic.open_float,
         vim.tbl_extend("force", bufopts, {desc = "view line diagnostics"}))
    mapk("n", "gr", vim.lsp.buf.references,
         vim.tbl_extend("force", bufopts, {desc = "go to references"}))

    -- this below is needed to allow for nvim-navic to function correctly.
    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end
end

-- ---------------------------------------------------------------------------
-- The following settings are for null-ls
-- ---------------------------------------------------------------------------
local lsnull = require("null-ls")

lsp_setup.null_ls_sources = {
    lsnull.builtins.formatting.yapf, lsnull.builtins.formatting.yamlfmt,
    lsnull.builtins.formatting.prettierd, lsnull.builtins.diagnostics.sqlfluff,
    lsnull.builtins.diagnostics.vint, lsnull.builtins.diagnostics.shellcheck,
    lsnull.builtins.diagnostics.commitlint
}

lsp_setup.null_ls_configuration = {}

function lsp_setup.null_ls_attach(client, bufnr)
    --  Do some stuff with client, bufnr
    --  e.g. user function can go here
end

vim.diagnostic.config(lsp_setup.uiconfig)

-- turn into a module
return lsp_setup
