--
-- @config User Autocommands
--
--  This file defines the autocommand specifications. These are read
--  into a specific function that defines autocmd groups
--
--  Syntax is
--	augroup_cmdspec = {
--	    { { trigger events }, { opts table }, command/callback = },
--          ...
--	    { { trigger events }, { opts table }, command/callback = },
--	}
---
-- @config Specific Function Definitions
local mod = {}

local lcs = require("uutils.string").maximal_common_substring
local clone = require("uutils.tbl").clone
mod.tmap = require("uutils.tbl").tmap

-- force that table is input
function mod.autocmd(cname, events, opts, specopts)
    specopts = (specopts or {})
    local cmdr = vim.api.nvim_create_autocmd
    local fopts = vim.tbl_extend("force", opts, specopts)
    return {name = cname, does = cmdr(events, fopts)}
end

function mod.dopt(opt, def)
	if opt == nil then
		return def
	else
		return opt
	end
end

function mod.autogroup(grpspec, mod_opts)
    mod_opts = (mod_opts or {})

	local gname = mod.dopt(grpspec.name,
		-- if no name is given, we will generate a random id string in UUID form
		string.format('augroupID-%s', require('uutils.fn').uuid()))
    -- we need function bindings to the nvim api section for autocmds
    local grpr = vim.api.nvim_create_augroup

    -- clone the given grpspec into a new table so we can manipulate the shape

    -- if it does not exist then the commands are assigned to "ungroup"
    local fgrpspec = clone(grpspec)
    local grp = grpr(gname, mod_opts)

    -- further set name to nil so we can loop the pairings more easily?
    -- might get changed a bit...
    fgrpspec.name = nil

    -- use the tmap (table map) function to map a locally defined handler over
    -- the elements of fgrpspec. In particular, we want to define the new
    -- autocmd name as the maximal substring shared between all events.
    local repacked = mod.tmap(function(cmd_to_repack, mod_opts)
        mod_opts = (mod_opts or {})
        -- the signature of our call to create an autocommand needs to be
        -- matched here. `cmd_to_repack` in this case contains a table of
        -- specifications in flat format, but we need ({events}, {opts}) where
        -- opts contains at least a pattern, and one of either command or
        -- callback following the vim.api.nvim_create_autocmd documentation.

        -- strip events
        local tevents = clone(cmd_to_repack.event)
        cmd_to_repack.event = nil

        -- determine name based on shared substrings from the events.
        -- The final name will be kept in the opts.desc field of the autocommand
        -- call below, e.g. to get passed through
        local tname = lcs(tevents)
        cmd_to_repack.desc = tname -- TODO: Maybe make this output more descriptive?
        -- set our group to the correct group id, which we just got.
        cmd_to_repack.group = grp
        -- make the final name of the form:
        -- 		augroupName_<lcs({events})>
        -- where <lcs({events})> is the result of the largest common substring
        -- for the events.
        -- TODO: fix the lcs so that it can accept arbitrary number of
        -- 		items.
        tname = string.format("%s_%s", gname, tname)
        -- cmd_to_repack.name = nil,
        local specopts = clone(cmd_to_repack.opts)
        cmd_to_repack.opts = nil

        local fopts = vim.tbl_extend("force", cmd_to_repack, specopts)
        return {name = tname, event = tevents, opts = fopts}
    end, fgrpspec)

    --
    -- finally, make the actual remapping with the local api binding for
    -- autocmds
    local remapped = mod.tmap(function(cmd_arg_table)
		local cname = cmd_arg_table.name
		local events = cmd_arg_table.event
		local fopts = cmd_arg_table.opts
        return mod.autocmd(cname, events, fopts)
    end, repacked, {}, {})

    -- return the group itself
    return {gid = grp, group_def = remapped}
end

local function setColorColumn()
    if vim.opt.textwidth == 0 then
        vim.opt.colorcolumn = 80
    end
end

return mod
