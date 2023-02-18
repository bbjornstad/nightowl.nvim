---
-- @component	User Keympappings
---------------------------------
-- @author	Bailey Bjornstad (ursa-major.rsp)
--
--  This file defines the user's keymappings. These are read
--  into a specific function that creates the keybind with the nvim api.
--
--  Those calls are wrapped into helper functions available here for the user
--  but may end up wrapped back into a different module.
---
-- @config Specific Function Definitions
---------------------------------
---
-- @module User keymappings - Main definitions
---------------------------------------------
local mod = {}
local mapk = require("uutils.key").mapk
local cmpk = require("uutils.key").cmp_mapk

---
-- @submodule Main User keymappings
local mappings = {}
local defaultopts = {}

-- for which key
local mname
local stem
local namer = require("uutils.key").wknamer

local wk = require("uutils.key").wkreg

mod.which_key_registration_name = namer

---
-- @keymaps:nvim-tree: 		nvim-tree bindings
----------------------------------------------
local treeapi = require("nvim-tree.api")
mname = "nvim-tree"
stem = "Explore"

wk({ ["<leader>e"] = { name = namer(mname, stem, true) } })
mappings.leader_nvim_tree = mapk("n", "<leader>eo", treeapi.tree.toggle, { silent = true })
mappings.leader_nvim_tree = mapk("n", "<leader>ep", treeapi.tree.toggle, { silent = true })
mappings.nvim_tree = mapk("n", "_T", treeapi.tree.toggle, { silent = true })

---
-- @keymaps:vim.wm: 		window management bindings to standard-ish keys
-----------------------------------------------------------------------
--  The following defines keybindings for comment insertions
mname = "(Metatext)"
stem = "Insert"
wk({ ["<M-i>"] = { name = namer(mname, stem, true) } })
mappings.cmtbreak = mapk("", "<M-i><M-c>", require("uutils.edit").InsertCommentBreak, { desc = "comment break" })
mappings.dashbreak = mapk("", "<M-i><M-d>", require("uutils.edit").InsertDashBreak, { desc = "dash break" })

---
-- @keymaps:vim.wm: 		window management bindings to standard-ish keys
-----------------------------------------------------------------------
--  The following defines user mappings for handling window management.
mname = "vim action"
stem = "Buffers"
mappings.bufprev1 = mapk("n", "<C-M-S>[", "<cmd>bprevious<CR>", {})
mappings.bufnext1 = mapk("n", "<C-M-S>]", "<cmd>bnext<CR>", {})
mappings.bufprev2 = mapk("", "<F11>", "<cmd>bprevious<CR>", {})
mappings.bufnext2 = mapk("", "<F12>", "<cmd>bnext<CR>", {})

mappings.vsplitfn = mapk("", "<F3>", "<cmd>vsplit<CR>", {})
mappings.hsplitfn = mapk("", "<F4>", "<cmd>split<CR>", {})

---
-- @keymaps:vim.dap: 		debugger configuration
-----------------------------------------------------------------------
--  Configuration to access debugger commands via keys
mname = "vim action"
stem = "debugging"
mapk("n", "<F8>", [[:lua require"dap".toggle_breakpoint()<CR>]], {})
mapk("n", "<F9>", [[:lua require"dap".continue()<CR>]], {})
mapk("n", "<F10>", [[:lua require"dap".step_over()<CR>]], {})
mapk("n", "<S-F10>", [[:lua require"dap".step_into()<CR>]], {})
mapk("n", "<F12>", [[:lua require"dap.ui.widgets".hover()<CR>]], {})
mapk("n", "<F5>", [[:lua require"osv".launch({port = 8086})<CR>]], {})

---
-- @keymaps:vim.<leader>: 	<leader> keymappings
------------------------------------------------
-- @subgroup -- Defining complex leader overrides. The hope is to be able to
mname = string.format("%s action", vim.g.mapleader)
stem = "actions and bindings"
wk({ ["<leader>"] = { name = namer(mname, stem, true) } })

mname = string.format("%s action", vim.g.maplocalleader)
stem = "formatting and diagnostics"
wk({ ["<localleader>"] = { name = namer(mname, stem, true) } })
-- access a leader key command from the insertion mode by using a special
-- overmapping to get back to cmd mode plus leader.
mappings.insleader = mapk("i", "<C-e><leader>", "<C-o><leader>", {})
mappings.inslocalleader = mapk("i", "<C-e><localleader>", "<C-o><localleader>", {})
---
-- @subgroup -- buffer manipulation mappings under leader
mname = "Buffer manipulation"
stem = "leader key"
wk({ ["<leader>b"] = { name = namer(mname, stem, true) } })
mappings.bufdel = mapk("", "<leader>bd", "<cmd>bdelete<CR>", {})
mappings.bufprev3 = mapk("", "<leader>bp", "<cmd>bprevious<CR>", {})
mappings.bufnext3 = mapk("", "<leader>bn", "<cmd>bnext<CR>", {})
mappings.bufnew = mapk("", "<leader>bN", "<cmd>BufNew<CR>", {})

mappings.hsplitld = mapk("", "<leader>bsv", "<cmd>vsplit<CR>", {})
mappings.vsplitld = mapk("", "<leader>bsh", "<cmd>split<CR>", {})
mappings.quitall = mapk("", "<leader>bqq", "<cmd>qa<CR>", {})
mappings.dquitall = mapk("", "<leader>bqQ", "<cmd>qa!<CR>", {})

---
-- @subgroup -- lazy package manager mappings
mname = "lazy (Package manager)"
stem = "leader key"
wk({ ["<leader>p"] = { name = namer(mname, stem, true) } })
mappings.lazyopen = mapk("", "<leader>po", "<cmd>Lazy<CR>", {})
mappings.lazysync = mapk("", "<leader>ps", "<cmd>Lazy sync<CR>", {})
mappings.lazyclean = mapk("", "<leader>pc", "<cmd>Lazy clean<CR>", {})
mappings.lazyhome = mapk("", "<leader>ph", "<cmd>Lazy clean<CR>", {})

---
--  @subgroup the next one is for spellcheck toggles
mname = "Zpellcheck+"
stem = "spelling correction in vim"
wk({ ["<leader>z"] = { name = namer(mname, stem, true) } })
mappings.setspell = mapk("", "<leader>zo", "<cmd>set spell!<CR>", {})

---
-- @keymaps:cmp: 	nvim-cmp keymappings
----------------------------------------
mname = "nvim-cmp"
local cmp_sel = require("cmp").SelectBehavior
local cmp_vis = require("cmp").visible

local function cmp_keyselector(key)
	if cmp_vis then
		cmpk.select_next_item({ behavior = cmp_sel.Insert })
	end
end

local function cmp_completer(mode, key)
	return cmp_keyselector(key)(mode)
end

local cmp_mappings = {
	["<C-b>"] = cmpk.scroll_docs(-4),
	["<C-f>"] = cmpk.scroll_docs(4),
	["<C-BS>"] = cmpk.abort(),
	["<C-Space>"] = cmpk.complete(),
	["<C-y>"] = cmpk.complete({ behavior = cmp_sel.Select }),
}

---
-- @keymaps:substitute: 	substitute.nvim keymappings
-------------------------------------------------------
mname = "Substitute"
stem = "upgraded substitute operations"
wk({ ["s"] = { name = namer(mname, stem, true) } })
mapk("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
mapk("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
mapk("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
mapk("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })

---
-- @keymaps:telescope: 	Telescope keymappings
---------------------------------------------
mname = "Telescope"
local scope_api = require("_ui.telescope")
local theme_config = {
	-- put theme configuration materials here if they exist
}
scope_api.set_theme_config(theme_config)

wk({ ["<localleader>t"] = { name = namer(mname, "", true) } })
-- seems we need to do it this way instead.

mapk("", "<localleader><localleader>", scope_api.fcrs())
stem = "Files"
wk({ ["<localleader>tf"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tff", scope_api.fcrs("find_files"), {})
mapk("", "<localleader>tfo", scope_api.fcrs("oldfiles"), { desc = "Search for old files" })
stem = "Buffers"
wk({ ["<localleader>tb"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tbb", scope_api.fcrs("buffers"), { desc = "Search within buffers" })
stem = "treeSitter"
wk({ ["<localleader>ts"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tsr", scope_api.fcrs("treesitter"), { desc = "Search within treesitter metadata" })
stem = "taGs"
wk({ ["<localleader>tg"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tgs", scope_api.fcrs("tags"), { desc = "Search for tags" })
stem = "Commands"
wk({ ["<localleader>tc"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tcm", scope_api.fcrs("commands"), { desc = "Search for shell commands" })
stem = "Help"
wk({ ["<localleader>th"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tht", scope_api.fcrs("help_tags"), { desc = "Search for help_tags" })
mapk("", "<localleader>thm", scope_api.fcrs("man_pages"), { desc = "Search for manual pages" })
stem = "Marks (vim)"
wk({ ["<localleader>tm"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tms", scope_api.fcrs("marks"), { desc = "Search for vim marks" })
stem = "Loclist"
wk({ ["<localleader>ty"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tyl", scope_api.fcrs("loclist"), { desc = "Search for loclist" })
stem = "Keymappings"
wk({ ["<localleader>tk"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tkm", scope_api.fcrs("keymaps"), { desc = "Search for keymaps" })
stem = "Telescope"
wk({ ["<localleader>tt"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>ttp", scope_api.fcrs("pickers"), { desc = "Search for telescope pickers" })
stem = "Options (Vim)"
wk({ ["<localleader>tv"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>tvo", scope_api.fcrs("vim_options"), { desc = "Search for vim options" })
stem = "taGs"
mapk("", "<localleader>tgc", scope_api.fcrs("current_buffer_tags"), { desc = "Search for tags in the current buffer" })
stem = "Help"
mapk("", "<localleader>ths", scope_api.fcrs("search_history"), { desc = "Search for search history" })
mapk("", "<localleader>thc", scope_api.fcrs("command_history"), { desc = "Search for command history" })

mname = "lsp"
stem = "Language server"
wk({ ["<localleader>l"] = { name = namer(mname, stem, true) } })
-- seems we need to do it this way instead.
mapk("", "<localleader>lf", scope_api.fcrs("lsp_references"), { desc = "Search for references from language server" })
mapk(
	"",
	"<localleader>ln",
	scope_api.fcrs("lsp_incoming_calls"),
	{ desc = "Search for incoming calls to language server" }
)
mapk(
	"",
	"<localleader>lo",
	scope_api.fcrs("lsp_outgoing_calls"),
	{ desc = "Search for outgoing calls to language server" }
)
mapk(
	"",
	"<localleader>lsd",
	scope_api.fcrs("lsp_document_symbols"),
	{ desc = "Search for document symbols in language server" }
)
mapk(
	"",
	"<localleader>lsw",
	scope_api.fcrs("lsp_workspace_symbols"),
	{ desc = "Search for symbols in language server over whole workspace" }
)

stem = "Diagnostics"
wk({ ["<localleader>d"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>dd", scope_api.fcrs("diagnostics"), { desc = "Search within diagnostic output" })
mapk("", "<localleader>ld", scope_api.fcrs("lsp_definitions"), { desc = "Search for definitions in language server" })
mapk(
	"",
	"<localleader>li",
	scope_api.fcrs("lsp_implementations"),
	{ desc = "Search for implementations in language server" }
)
mapk("", "<localleader>lt", scope_api.fcrs("lsp_type_definitions"), { desc = "Search for type definitions" })

-- TODO: Document this thing. This is important but not noted at all.
local scope_mappings = { ["<C-h>"] = "which_key" }

---
-- @keymaps:lspsaga: 	Lspsaga keymappings
-------------------------------------------
mname = "lspsaGa"
stem = "Base"
wk({ ["<localleader>s"] = { name = namer(mname, stem, true) } })
mapk("", "<localleader>sg", "<cmd>Lspsaga lsp_finder<CR>", { desc = "Search for definition under cursor" })
mapk("", "<localleader>so", "<cmd>Lspsaga outline<CR>", { desc = "Search for definition under cursor" })
mapk("", "<localleader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Search for code actions" })
mapk("", "<localleader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename all instances of item under cursor in file" })
mapk(
	"",
	"<localleader>ran",
	"<cmd>Lspsaga rename ++project<CR>",
	{ desc = "Rename all instances of item under cursor in selected files" }
)
mapk(
	"",
	"<localleader>gd",
	"<cmd>Lspsaga peek_definition<CR>",
	{ desc = "Peek at definition under cursor, use <C-t> to return" }
)
stem = "Diagnostics"
mapk(
	"",
	"<localleader>dl",
	"<cmd>Lspsaga show_line_diagnostics<CR>",
	{ desc = "Show line diagnostics, use <C-t> to return" }
)
mapk(
	"",
	"<localleader>dc",
	"<cmd>Lspsaga show_cursor_diagnostics<CR>",
	{ desc = "Show cursor diagnostics, use <C-t> to return" }
)
mapk(
	"",
	"<localleader>db",
	"<cmd>Lspsaga show_buf_diagnostics<CR>",
	{ desc = "Show buffer diagnostics, use <C-t> to return" }
)
mapk(
	"",
	"<localleader>[e",
	"<cmd>Lspsaga diagnostic_jump_prev<CR>",
	{ desc = "Go to previous diagnostic item, use <C-t> to return" }
)
mapk(
	"",
	"<localleader>]e",
	"<cmd>Lspsaga diagnostic_jump_next<CR>",
	{ desc = "Go to next diagnostic item, use <C-t> to return" }
)
mapk(
	"",
	"<localleader>K",
	"<cmd>Lspsaga hover_doc<CR>",
	{ desc = "Peek at definition under cursor, use <C-t> to return" }
)

---
-- @keymaps:null-ls: 	null-ls neovim lsp injection (formatting, etc)
----------------------------------------------------------------------
mname = "null-ls"
stem = "Formatting"
wk({ ["<localleader>f"] = { name = namer(mname, stem, true) } })
local function nullformat(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end
mapk("", "<localleader>ff", nullformat, { desc = "null-ls: Format Document" })

---
-- @keymaps:vim: 	enable autoformatting with a keymap
-------------------------------------------------------
mname = "Automatic"
wk({ ["<localleader>a"] = { name = namer(mname, "", true) } })
local currentopts = vim.opt.formatoptions:get()
local function operator(char)
	if currentopts.a then
		vim.opt.formatoptions:remove(char)
	else
		vim.opt.formatoptions:append(char)
	end
end

mapk("", "<localleader>af", function()
	-- NOTE: the character must be specified in list form, we might
	-- generalize this later.
	operator({ "a" })
end, { desc = "Toggle autoformatting" })

---
-- @keymaps:which-key: 	which-key keymappings
----------------------------------------
mname = "which-key"
stem = "mapping"
mapk("n", "<Ctrl-H>", "<cmd>WhichKey<CR>", { desc = "which-key: find key mappings" })

---
-- @keymaps:Vista: 	enable vista menus
--------------------------------------
mapk("", "<localleader>vv", "<CMD>Vista!!<CR>", { desc = "Vista: browse tags" })
mapk("", "<localleader>vf", "<CMD>Vista finder<CR>", { desc = "Vista: Fzf finder" })

---
-- @keymaps:skim: 		skim functionality bound
------------------------------------------------
-- local ucmd = require('uutils.key').cmd_create
-- local rgluacmd = ucmd('SkimRG', vim.call([[fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))]]), {})
-- local agluacmd = ucmd('SkimAG', vim.call([[fzf#vim#ag_interactive(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'alt-h'))]]), {})

---
-- @module Now we attach everything to mod to return
---------------------------------------------------
mod.mappings = mappings
mod.cmp_mappings = cmp_mappings
mod.scope_mappings = scope_mappings

return mod
