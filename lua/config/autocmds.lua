-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
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

---
-- @augroup orgmode.nvim Language Settings
-- local orgmode_cmdspec = {
--  name = "orgmodeAU",
--  -- {
--  --    event = {"FileType"},
--  --    pattern = {"org"},
--  --    command = "inoremap <buffer> <C-CR> <C-O>v:lua.org_meta_return",
--  --    opts = {}
--  -- },
--  { event = { "FileType" }, pattern = { "org" }, command = "UfoDetach", opts = {} },
--  {
--    event = { "FileType" },
--    pattern = { "org" },
--    command = "set tabstop=2",
--    opts = {},
--  },
-- }
-- local orgmode_au = mod.setup_augroup(orgmode_cmdspec)

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
-- obsoleted by LazyVim handling of the same feature.
-- local help_rebind_cmdspec = {
--  name = "helpRebindAU",
--  {
--    event = { "FileType" },
--    pattern = { "help" },
--    command = "noremap <buffer> q <CMD>quit<CR><Ctrl-C>",
--    opts = {},
--  },
-- }
-- mod.setup_augroup(help_rebind_cmdspec)

---
-- @augroup otter md
local otter = require("otter")
local mapx = vim.keymap.set
local mapn = require("plenary").functional.partial(mapx, "n")
local otter_md_activate = {
  name = "otterMDActivateAU",
  {
    event = { "BufEnter" },
    pattern = { "*.qmd" },
    callback = function()
      mapn("gd", otter.ask_definition, { silent = true })
      mapn("K", otter.ask_hover, { silent = true })
      otter.activate({ "r", "python", "lua", "julia", "rust" }, true)
    end,
    opts = {},
  },
}
mod.setup_augroup(otter_md_activate)

return mod
