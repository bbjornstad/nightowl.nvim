--
-- @config User Autocommands
--
--  This file defines the autocommand specifications. These are read
--  into a specific function that defines autocmd groups
--
--  Syntax is
--	augroup_cmdspec = {
--		name = [optional name field]
--	    { { trigger events }, { opts table }, command/callback = },
--          ...
--	    { { trigger events }, { opts table }, command/callback = },
--	}
---
-- @config Specific Function Definitions
local mod = {}

mod.autocmd = require("uutils.cmd").autocmd
mod.setup_augroup = require("uutils.cmd").autogroup

---nvim pairs
-- @augroup Vertical Split Default
local vsplit_help_cmdspec = {
  name = "vsplits-helpAU",
  -- need to take a chunk like this and map it down to the correct signature
  -- for our call to the autocmd generator.
  { event = { "WinNew" }, pattern = { "*" }, command = "wincmd L", opts = {} },
  -----------------------------------------
  {
    event = { "FileType" },
    pattern = { "help" },
    command = "wincmd L",
    opts = {},
  },
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
  -- {
  --    event = {"FileType"},
  --    pattern = {"org"},
  --    command = "inoremap <buffer> <C-CR> <C-O>v:lua.org_meta_return",
  --    opts = {}
  -- },
  {
    event = { "FileType" },
    pattern = { "org" },
    command = "UfoDetach",
    opts = {},
  },
  {
    event = { "FileType" },
    pattern = { "org" },
    command = "set tabstop=2",
    opts = {},
  },
}
local orgmode_au = mod.setup_augroup(orgmode_cmdspec)

-----
---- @augroup vista window management
-- local vista_cmdspec = {
--	name = "vistaAU",
--	{
--		event = { "VimEnter" },
--		command = "Vista",
--		opts = {},
--	},
-- }
-- local vista_au = mod.setup_augroup(vista_cmdspec)

---
-- @augroup help rebind quit
local help_rebind_cmdspec = {
  name = "helpRebindAU",
  {
    event = { "FileType" },
    pattern = { "help" },
    command = "noremap <buffer> q <CMD>quit<CR><Ctrl-C>",
    opts = {},
  },
}
mod.setup_augroup(help_rebind_cmdspec)

---
-- @augroup otter md
local otter = require("otter")
local otter_md_activate = {
  name = "otterMDActivateAU",
  {
    event = { "BufEnter" },
    pattern = { "*.qmd" },
    callback = function()
      local mapx = require("uutils.key").mapx
      mapx.nnoremap("n", "gd", otter.ask_definition, { silent = true })
      mapx.nnoremap("n", "K", otter.ask_hover, { silent = true })
      otter.activate({ "r", "python", "lua", "julia", "rust" }, true)
    end,
    opts = {},
  },
}
mod.setup_augroup(otter_md_activate)

return mod
