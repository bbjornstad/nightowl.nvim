local mod = {}

local _default_options = {
	remap = false,
}

---
--@section Keymap Definitions - `uutils.key`
function mod.mapk(mode, lhs, rhs, useropts)
	local opts = vim.tbl_extend('force', _default_options, useropts)
    return vim.keymap.set(mode, lhs, rhs, opts)
end

mod.cmp_mapk = require('cmp').mapping

function mod.set_default_options(opts)
	_default_options = opts
end

function mod.default_options()
	return _default_opts
end

return mod
