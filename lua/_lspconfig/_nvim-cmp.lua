local _nvim_cmp = {}

local master_setup = require('lsp-setup')

_nvim_cmp.sources = master_setup.cmp_sources
_nvim_cmp.config = master_setup.cmp_configuration

return _nvim_cmp
