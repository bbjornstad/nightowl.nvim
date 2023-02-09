-- this is a module that contains null-ls source and other setup parameters
--
-- This is important because we want to expose the internal sources easily but
-- we don't want to touch anything of the automatic handlers underneath.

local _null_ls = {}

local master_setup = require('lsp-setup')

_null_ls.sources = master_setup.null_ls_sources
_null_ls.config = master_setup.null_ls_configuration
_null_ls.on_attach = master_setup.null_ls_attach

return _null_ls
