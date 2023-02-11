local uutils = require('uutils')
local master_setup = require('lsp-setup')
local lsp_defaults = require('lsp-zero').defaults
-- selection modes
local cmp_nopreselect = require('cmp').PreselectMode.None
local cmp_itempreselect = require('cmp').PreselectMode.Item

local _nvim_cmp = {}

-- neovim cmp setup
_nvim_cmp.sources = master_setup.cmp_sources
_nvim_cmp.config = master_setup.cmp_configuration
_nvim_cmp.usr_keymaps = master_setup.cmp_keymaps

if not _nvim_cmp.config.preselect then
    _nvim_cmp.config.preselect = cmp_nopreselect
else
    _nvim_cmp.config.preselect = cmp_itempreselect
end

local src_t1 = uutils.tbl.clone(lsp_defaults.cmp_sources())
_nvim_cmp.sources = uutils.tbl.merge(src_t1, _nvim_cmp.sources)

_nvim_cmp.config.sources = _nvim_cmp.sources
_nvim_cmp.config = lsp_defaults.cmp_config(_nvim_cmp.config)

_nvim_cmp.keymaps = lsp_defaults.cmp_mappings(_nvim_cmp.usr_keymaps)
_nvim_cmp.config.mapping = _nvim_cmp.keymaps

return _nvim_cmp

