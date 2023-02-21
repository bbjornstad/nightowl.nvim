-- clear stuff out here
package.loaded["lspconfig._mason"] = nil
package.loaded["lspconfig._null-ls"] = nil
package.loaded["lspconfig._nvim-cmp"] = nil
package.loaded["uutils"] = nil

-- import mason settings from neighbor module
local _mason = require("_lspconfig._mason")

-- Master Mason Setup
require("mason.settings").set(_mason.config.mason)
require("mason-lspconfig.settings").set(_mason.config.mason_lspconfig)
-- nvim cmp import
local _nvim_cmp = require("_lspconfig._nvim-cmp")

-- ----- Set up the actual LSP Zero configuration using recommended
local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.nvim_workspace()

-- wraps the mason command of the same name
lsp.ensure_installed(_mason.sources)

lsp.setup_nvim_cmp(_nvim_cmp.config)

-- lsp-status linkage
local lsp_status = require('lsp-status')
lsp_status.register_progress()

-- finally let's pin the keymaps for the lsp commands that are commonly used.
lsp.on_attach(function(client, bufnr)
	client.config.capabilities = vim.tbl_extend('keep', client.config.capabilities or {}, lsp_status.capabilities)
	lsp_status.on_attach(client)
	require('lsp-setup').on_attach_user(client, bufnr)
end)

lsp.setup()



-- get null_ls
local _null_ls = require("_lspconfig._null-ls")
local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})
-- define the attach function relative to the location of null_opts
-- and further such that we guarantee this is included
local function base_attach(client, bufnr)
	null_opts.on_attach(client, bufnr)
	--	You can define other behavior for the intersection here
	--	should get called as a function from the lsp-setup.
	_null_ls.on_attach(client, bufnr)
end

_null_ls.config["on_attach"] = base_attach
_null_ls.config["sources"] = _null_ls.sources
null_ls.setup(_null_ls.config)

-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
require("mason-null-ls").setup(_mason.config.mason_null_ls)

-- Required when `automatic_setup` is true
require("mason-null-ls").setup_handlers()

-- lastly set the unified UI options
vim.diagnostic.config(require("lsp-setup").uiconfig)

-- If you want insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
