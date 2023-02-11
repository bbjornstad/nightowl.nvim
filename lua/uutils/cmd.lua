local mod = {}

---
--@section Autocmd Definitions
--
--  Recreating the old autocmd definitions from init.vim
function mod.augrp(name, gopts)
    return vim.api.nvim_create_augroup(name, gopts)
end

function mod.acmd(event, opts, command)
    if opts.pattern ~= nil then
	opts.pattern = {'*'}
    end
    return vim.api.nvim_create_autocmd(event, opts, command)
end

return mod

