---
--@config User Keybindings
--
--  This file defines the user's keymappings. These are read
--  into a specific function that creates the keybind with the nvim api.
--
--  Syntax is
--	augroup_cmdspec = {
--	    { { trigger events }, { opts table }, command/callback = },
--          ...
--	    { { trigger events }, { opts table }, command/callback = },
--	}
---
--@config Specific Function Definitions
-- doing a test

-- store local module
local mod = {}
local mapk = require("uutils.key").mapk
local cmpk = require("uutils.key").cmp_mapk

---
--@section Main User keymappings
local mappings = {}
local defaultopts = {}

---
--@subsection -- tree file browser bindings
treeapi = require('nvim-tree.api')
mappings.nvim_tree = mapk('n', '_T', treeapi.tree.toggle, { silent = true })


---
--@subsection -- Defining complex leader overrides. The hope is to be able to
--access a leader key command from the insertion mode by using a special
--overmapping to get back to cmd mode plus leader.
mappings.insleader = mapk("i", "<C-e><leader>", "<C-o><leader>", {})
mappings.inslocalleader = mapk("i", "<C-e><localleader>", "<C-o><localleader>", {})

---
--@keygroup Comment Break Mappings
--  The following defines keybindings for comment insertions
mappings.cmtbreak = mapk("", "<M-I><M-L>", require("uutils.edit").InsertCommentBreak, {})
mappings.dashbreak = mapk("", "<M-i><M-l>", require("uutils.edit").InsertDashBreak, {})

---
--@keygroup Window Management Mappings
--  The following defines user mappings for handling window management.
mappings.bufprev1 = mapk("n", "<C-M-S>[", "<cmd>bprevious<CR>", {})
mappings.bufnext1 = mapk("n", "<C-M-S>]", "<cmd>bnext<CR>", {})
mappings.bufprev2 = mapk("", "<F11>", "<cmd>bprevious<CR>", {})
mappings.bufnext2 = mapk("", "<F12>", "<cmd>bnext<CR>", {})

mappings.vsplitfn = mapk("", "<F3>", "<cmd>vsplit<CR>", {})
mappings.hsplitfn = mapk("", "<F4>", "<cmd>split<CR>", {})
---
--@keygroup Leader Key mappings
--  @subgroup This first one is for other buffer manipulation
mappings.bufdel = mapk("", "<leader>bd", "<cmd>bdelete<CR>", {})
mappings.bufprev3 = mapk("", "<leader>bp", "<cmd>bprevious<CR>", {})
mappings.bufnext3 = mapk("", "<leader>bn", "<cmd>bnext<CR>", {})

mappings.hsplitld = mapk("", "<leader>bsv", "<cmd>vsplit<CR>", {})
mappings.vsplitld = mapk("", "<leader>bsh", "<cmd>split<CR>", {})
mappings.quitall = mapk("", "<leader>bqq", "<cmd>qa<CR>", {})
mappings.dquitall = mapk("", "<leader>bqQ", "<cmd>qa!<CR>", {})
---
--  @subgroup the next one is for spellcheck toggles
mappings.setspell = mapk("", "<leader>so", "<cmd>set spell!<CR>", {})

---
-- @subgroup: These keymappings define behavior for cmp autofill___

cmp_sel = require("cmp").SelectBehavior
cmp_vis = require("cmp").visible

local function cmp_keyselector(key)
	if cmp_vis then
		cmp.select_next_item({ behavior = cmp_sel.Insert })
	else
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
--@keygroup Telescope Mappings
local builtin = require("telescope.builtin")
local theme_config = {
	-- put theme configuration materials here if they exist
}

local function themebind(picker_name, theme)
	return builtin[picker_name](theme)
end

local function fcrs(picker_name, force_dropdown)
	force_dropdown = force_dropdown or false
	local crs = require("telescope.themes").get_ivy(theme_config)
	local actionable = function()
		return themebind(picker_name, crs)
	end
	return actionable
end

-- seems we need to do it this way instead.
mapk("", "<leader>tff", fcrs("find_files"), { desc = "Search for local files" })
mapk("", "<leader>tfo", fcrs("oldfiles"), { desc = "Search for old files" })
mapk("", "<leader>tbb", fcrs("buffers"), { desc = "Search within buffers" })
mapk("", "<leader>ttr", fcrs("treesitter"), { desc = "Search within treesitter metadata" })
mapk("", "<leader>tgs", fcrs("tags"), { desc = "Search for tags" })
mapk("", "<leader>tcm", fcrs("commands"), { desc = "Search for shell commands" })
mapk("", "<leader>tht", fcrs("help_tags"), { desc = "Search for help_tags" })
mapk("", "<leader>thm", fcrs("man_pages"), { desc = "Search for manual pages" })
mapk("", "<leader>tks", fcrs("marks"), { desc = "Search for vim marks" })
mapk("", "<leader>tll", fcrs("loclist"), { desc = "Search for loclist" })
mapk("", "<leader>tkm", fcrs("keymaps"), { desc = "Search for keymaps" })
mapk("", "<leader>ttp", fcrs("pickers"), { desc = "Search for telescope pickers" })
mapk("", "<leader>tvo", fcrs("vim_options"), { desc = "Search for vim options" })
mapk("", "<leader>tgc", fcrs("current_buffer_tags"), { desc = "Search for tags in the current buffer" })
mapk("", "<leader>tsh", fcrs("search_history"), { desc = "Search for search history" })
mapk("", "<leader>tch", fcrs("command_history"), { desc = "Search for command history" })

-- seems we need to do it this way instead.
mapk("", "<leader>lf", fcrs("lsp_references"), { desc = "Search for references from language server" })
mapk("", "<leader>ln", fcrs("lsp_incoming_calls"), { desc = "Search for incoming calls to language server" })
mapk("", "<leader>lo", fcrs("lsp_outgoing_calls"), { desc = "Search for outgoing calls to language server" })
mapk("", "<leader>lsd", fcrs("lsp_document_symbols"), { desc = "Search for document symbols in language server" })
mapk(
	"",
	"<leader>lsw",
	fcrs("lsp_workspace_symbols"),
	{ desc = "Search for symbols in language server over whole workspace" }
)
mapk("", "<leader>dd", fcrs("diagnostics"), { desc = "Search within diagnostic output" })
mapk("", "<leader>ld", fcrs("lsp_definitions"), { desc = "Search for definitions in language server" })
mapk("", "<leader>li", fcrs("lsp_implementations"), { desc = "Search for implementations in language server" })
mapk("", "<leader>lt", fcrs("lsp_type_definitions"), { desc = "Search for type definitions" })

local scope_mappings = {
	["<C-h>"] = "which_key",
}

-- lspsaga keymaps
mapk("", "<localleader>sg", "<cmd>Lspsaga lsp_finder<CR>", { desc = "Search for definition under cursor" })
mapk("", "<localleader>so", "<cmd>Lspsaga outline<CR>", { desc = "Search for definition under cursor" })
mapk("", "<localleader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Search for code actions" })
mapk("", "<localleader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename all instances of item under cursor in file" })
mapk(
	"",
	"<localleader>arn",
	"<cmd>Lspsaga rename ++project<CR>",
	{ desc = "Rename all instances of item under cursor in selected files" }
)
mapk(
	"",
	"<localleader>gd",
	"<cmd>Lspsaga peek_definition<CR>",
	{ desc = "Peek at definition under cursor, use <C-t> to return" }
)
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

-- null-ls mappings
local function nullformat(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end
mapk("", "<localleader>f", nullformat, { desc = "Format Document" })

---
--@module Now we attach everything to mod to return
mod.mappings = mappings
mod.cmp_mappings = cmp_mappings
mod.scope_mappings = scope_mappings

return mod
