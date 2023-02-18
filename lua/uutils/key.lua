local mod = {}

local _default_options = {
	remap = false,
}

---
--@section Keymap Definitions - `uutils.key`
function mod.mapk(mode, lhs, rhs, useropts)
	useropts = useropts or {}
	local opts = vim.tbl_extend('force', _default_options, useropts)
    return vim.keymap.set(mode, lhs, rhs, opts)
end

mod.cmp_mapk = require('cmp').mapping

function mod.cmd_create(name, command, opts)
	return vim.api.nvim_create_user_command(name, command, opts)
end

function mod.set_default_options(opts)
	_default_options = opts
end

function mod.default_options()
	return _default_options
end

function mod.wknamer(stem, additional, affix_plus)
    local ret
    if affix_plus then
        ret = string.format([[%s: %s]] .. [[+]], stem, additional)
    else
        ret = string.format([[%s: %s]], stem, additional)
    end
    return ret
end
mod.wkreg = require("which-key").register

return mod
