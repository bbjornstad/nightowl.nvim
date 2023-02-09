-- get vim api for autocmd definitions
local api = vim.api

---
-- @module uutils
--  This module contains some useful tools that might come in handy when using
--  lua for neovim configuration.
local uutils = {}


---
--@section Autocmd Definitions
--
--  Recreating the old autocmd definitions from init.vim
function uutils.augrp(name, gopts)
    return api.nvim_create_augroup(name, gopts)
end

function uutils.acmd(event, opts, command)
    if opts.pattern ~= nil then
	opts.pattern = {'*'}
    end
    return api.nvim_create_autocmd(event, opts, command)
end

function uutils.merge(tbl1, tbl2)
    -- Merges two tables
    --
    -- operates on tbl1 by insertion of all key,value pairs from tbl2
    -- does not do a deep copy.
    for _,v in ipairs(tbl2) do
	table.insert(tbl1, v)
    end
    return tbl1
end

function uutils.clone(tbl)
    -- Clones a single table without a deep copy.
    return {unpack(tbl)}
end

---
-- Module manipulation functions
--
-- Anything that is related to loading or unloading of modules should got here
function uutils.reload(mod)
    package.loaded[mod] = nil
    return require(mod)
end

return uutils
