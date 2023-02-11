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
	"sumneko_lua",
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
	{ name = "nvim-lsp", max_item_count = 10 },
	{ name = "buffer", max_item_count = 20 },
	{ name = "path", max_item_count = 10 },
	{ name = "env", max_item_count = 10 },
	{ name = "rg", max_item_count = 20 },
	{ name = "luasnip", max_item_count = 10 },
	{ name = "snippy", max_item_count = 10 },
	{ name = "dap", max_item_count = 20 },
	{ name = "calc" },
	{ nqame = "cmp_tabnine", max_item_count = 5 },
	{ name = "cmdline", max_item_count = 5 },
	{ name = "treesitter", max_item_count = 10 },
	{ name = "ctags", max_item_count = 5 },
	{ name = "otter" },
	{ name = "color_names" },
	{ name = "nvim_lsp_signature_help", max_item_count = 5 },
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
