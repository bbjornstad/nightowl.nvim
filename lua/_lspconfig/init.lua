-- clear stuff out here
package.loaded['lspconfig._mason'] = nil
package.loaded['lspconfig._null-ls'] = nil
package.loaded['lspconfig._nvim-cmp'] = nil
package.loaded['uutils'] = nil

-- and also do the mason packages themselves.
package.loaded['mason'] = nil
package.loaded['mason-lspconfig'] = nil
package.loaded['mason-null-ls'] = nil
package.loaded['lsp-zero'] = nil

-- import tooling
local uutils = require('uutils')

-- import mason settings from neighbor module
local _mason = require('_lspconfig._mason')

-- same for nvim-cmp
local _nvim_cmp = require('_lspconfig._nvim-cmp')



-- Master Mason Setup
require('mason.settings').set(_mason.config.mason)
require('mason-lspconfig.settings').set(_mason.config.mason_lspconfig)

-- ----- Set up the actual LSP Zero configuration using recommended
local lsp = require('lsp-zero')
lsp.preset('recommended')

local cmp_nopreselect = require('cmp').PreselectMode.None
local cmp_itempreselect = require('cmp').PreselectMode.Item

-- wraps the mason command of the same name
lsp.ensure_installed(_mason.sources)

if not _nvim_cmp.config.preselect then
    _nvim_cmp.config.preselect = cmp_nopreselect
else
    _nvim_cmp.config.preselect = cmp_itempreselect
end


local src_t1 = {unpack(lsp.defaults.cmp_sources())}
local new_src = uutils.merge(src_t1, _nvim_cmp.sources)

_nvim_cmp.config['sources'] = new_src
_nvim_cmp.config = lsp.defaults.cmp_config(_nvim_cmp.config)
lsp.setup_nvim_cmp(_nvim_cmp.config)

lsp.setup()


-- get null_ls
local _null_ls = require('_lspconfig._null-ls')
local null_ls = require('null-ls')
local null_opts = lsp.build_options('null-ls', {})
-- define the attach function relative to the location of null_opts
-- and further such that we guarantee this is included
local function base_attach(client, bufnr)
    null_opts.on_attach(client, bufnr)
    --	You can define other behavior for the intersection here
    --	should get called as a function from the lsp-setup.
    _null_ls.on_attach(client, bufnr)
end

_null_ls.config['on_attach'] = base_attach
_null_ls.config['sources'] = _null_ls.sources
null_ls.setup(_null_ls.config)

-- See mason-null-ls.nvim's documentation for more details:
-- https://github.com/jay-babu/mason-null-ls.nvim#setup
require('mason-null-ls').setup(_mason.config.mason_null_ls)

-- Required when `automatic_setup` is true
require('mason-null-ls').setup_handlers()

