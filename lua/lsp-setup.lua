local lsp_setup = {}

lsp_setup.uiconfig = {
	float = {
		border = "single",
	},
}

-- ---------------------------------------------------------------------------
-- The following settings are for mason, mason-lspconfig, and mason-null-ls
-- ---------------------------------------------------------------------------
-- This module method merges two tables.
-- Acts on the first table directly, e.g. modifies data.
-- ---------------------------------------------------------------------------
-- LSP Ensure Installed Packages
lsp_setup.mason_servers = {
	"jedi_language_server",
	"rust_analyzer",
	"vimls",
	"sqlls",
	"bashls",
	"clangd",
	"jsonls",
	"lua_ls",
	"salt_ls",
	"yamlls",
	"diagnosticls",
	"marksman",
	"taplo",
}

lsp_setup.mason_configuration = {
	ui = {
		border = "single",
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
	{ name = "nvim-lsp", max_item_count = 5 },
	{ name = "buffer", max_item_count = 5 },
	{ name = "path", max_item_count = 4 },
	{ name = "env", max_item_count = 4 },
	{ name = "rg", max_item_count = 3 },
	{ name = "luasnip", max_item_count = 3 },
	{ name = "snippy", max_item_count = 4 },
	{ name = "dap", max_item_count = 5 },
	{ name = "calc", max_item_count = 3 },
	{ name = "cmp_tabnine", max_item_count = 3 },
	{ name = "cmdline", max_item_count = 3 },
	{ name = "treesitter", max_item_count = 4 },
	{ name = "ctags", max_item_count = 3 },
	{ name = "otter", max_item_count = 3 },
	{ name = "color_names", max_item_count = 3 },
	{ name = "nvim_lsp_signature_help", max_item_count = 3 },
}

lsp_setup.cmp_configuration = {
	preselect = false,
	completion = {
		autocomplete = false,
		completeopt = "menu,menuone,noinsert,noselect",
	},
	window = {
		documentation = {
			border = "solid",
		},
	},
}

local usr_keybinds = require("keymappings")
lsp_setup.cmp_keymaps = usr_keybinds.cmp_mappings

-- ---------------------------------------------------------------------------
-- The following settings are for null-ls
-- ---------------------------------------------------------------------------
local lsnull = require("null-ls")

lsp_setup.null_ls_sources = {
	lsnull.builtins.formatting.yapf,
	lsnull.builtins.formatting.yamlfmt,
	lsnull.builtins.formatting.prettierd,
	lsnull.builtins.diagnostics.sqlfluff,
	lsnull.builtins.diagnostics.vint,
	lsnull.builtins.diagnostics.shellcheck,
	lsnull.builtins.diagnostics.commitlint,
}

lsp_setup.null_ls_configuration = {}

function lsp_setup.null_ls_attach(client, bufnr)
	--  Do some stuff with client, bufnr
	--  e.g. user function can go here
end

-- turn into a module
return lsp_setup
