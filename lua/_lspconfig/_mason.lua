local _mason = {}

package.loaded['lsp-setup'] = nil
local master_setup = require('lsp-setup')

_mason.sources = master_setup.mason_servers
_mason.config = {
    mason = master_setup.mason_configuration,
    mason_lspconfig = master_setup.mason_lspconfig_configuration,
    mason_null_ls = master_setup.mason_null_ls_configuration,
}


return _mason
