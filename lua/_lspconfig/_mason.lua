local uutils = require('uutils.mod')
local master_setup = uutils.reload('lsp-setup')

local _mason = {}

_mason.sources = master_setup.mason_servers
_mason.config = {
    mason = master_setup.mason_configuration,
    mason_lspconfig = master_setup.mason_lspconfig_configuration,
    mason_null_ls = master_setup.mason_null_ls_configuration,
}


return _mason
