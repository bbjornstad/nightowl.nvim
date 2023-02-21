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

mod.autocmd = require("uutils.cmd").autocmd
mod.setup_augroup = require("uutils.cmd").autogroup

local lcs = require("uutils.string").maximal_common_substring
local clone = require("uutils.tbl").clone
mod.tmap = require("uutils.tbl").tmap

function mod.dopt(opt, def)
	if opt == nil then
		return def
	else
		return opt
	end
end

local function setColorColumn()
	if vim.opt.textwidth == 0 then
		vim.opt.colorcolumn = "80"
	else
		vim.opt.colorcolumn = "0"
	end
end

---nvim pairs
-- @augroup Vertical Split Default
local vsplit_help_cmdspec = {
	name = "vsplits-helpAU",
	-- need to take a chunk like this and map it down to the correct signature
	-- for our call to the autocmd generator.
	{ event = { "WinNew" }, pattern = { "*" }, command = "wincmd L", opts = {} },
	-----------------------------------------
	{ event = { "FileType" }, pattern = { "help" }, command = "wincmd L", opts = {} },
}
local vsplithelp_au = mod.setup_augroup(vsplit_help_cmdspec)

---nvim pairs
-- @augroup Vertical Split Default
local vsplit_cmdspec = {
	name = "vsplitsAU",
	-- need to take a chunk like this and map it down to the correct signature
	-- for our call to the autocmd generator.
	{ event = { "WinNew" }, pattern = { "*" }, command = "wincmd L", opts = {} },
	-----------------------------------------
	{
		event = { "BufWinEnter" },
		pattern = { "<buffer>" },
		command = "wincmd L",
		opts = {},
	},
}
local vsplit_au = mod.setup_augroup(vsplit_cmdspec)
---
-- @augroup Color Column Calculation
local colorcol_cmdspec = {
	name = "colorcolAU",
	{
		event = { "OptionSet" },
		pattern = { "textwidth" },
		callback = setColorColumn,
		opts = {},
	},
	{
		event = { "BufEnter" },
		pattern = { "*" },
		callback = setColorColumn,
		opts = {},
	},
}
local colorcol_au = mod.setup_augroup(colorcol_cmdspec)
---
-- @augroup orgmode.nvim Language Settings
local orgmode_cmdspec = {
	name = "orgmodeAU",
	{
		event = { "FileType" },
		pattern = { "org" },
		command = "inoremap <buffer> <C-CR> <C-O>v:lua.org_meta_return",
		opts = {},
	},
}
local orgmode_au = mod.setup_augroup(orgmode_cmdspec)

-----
---- @augroup vista window management
--local vista_cmdspec = {
--	name = "vistaAU",
--	{
--		event = { "VimEnter" },
--		command = "Vista",
--		opts = {},
--	},
--}
--local vista_au = mod.setup_augroup(vista_cmdspec)


---
-- @augroup help rebind quit
local help_rebind_cmdspec = {
	name = "helpRebindAU",
	{
		event = { "FileType" },
		pattern = { "help" },
		command = "noremap <buffer> q <CMD>quit<CR><Ctrl-C>",
		opts = {}
	},
}
local help_rebind_au  mod.setup_augroup(help_rebind_cmdspec)

-----
---- @augroup minimap
--local mini_cmdspec = {
--	name = "miniAU",
--	{
--		event = { "VimEnter" },
--		callback = require('mini.map').open,
--		opts = {},
--	},
--}
--local mini_au = mod.setup_augroup(mini_cmdspec)

return mod
