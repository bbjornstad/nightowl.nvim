-- vim:ft=lua
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
----------------------------------------------
local kutils = require("uutils.key")
local mapx = kutils.mapx

local mod = {}
local cmpk = require("uutils.key").cmp_mapk
local namer = kutils.wknamer

---
-- @submodule Main User keymappings
local mappings = {}

-- for which key
local mname
local stem
local keystem
local prompt
local promptsep = ":|"

local function desc(body, prompt, sep)
  return kutils.desc(body, prompt, sep, mname, promptsep)
end

-- TODO :: Organize these with mapx groups.
-- 			- this is also important because without it, we would basically have
-- 			to do it whenever we actually get around to implementing the nesting
-- 			correctly.

-- Re-Export
mod.which_key_registration_name = namer

---
-- @keymaps:nvim-tree: 		nvim-tree bindings
----------------------------------------------
local treeapi = require("nvim-tree.api")
mname = "nvim-tree"
stem = "explore"
keystem = ";t"
prompt = "editor::tree"

mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(keystem .. "o", treeapi.tree.open, desc("open nvim-tree", prompt))
mapx.nnoremap(
  keystem .. "f",
  treeapi.tree.find_files,
  { silent = true },
  desc("find files in nvim-tree", prompt)
)
mapx.nnoremap(
  keystem,
  treeapi.tree.toggle,
  { silent = true },
  desc("toggle nvim-tree", prompt)
)

---
-- @keymaps:easyread: 		bionic reading capabilities
-------------------------------------------------------
mname = "easyread"
stem = "bionic reading"
keystem = ";r"
prompt = "editor::bionic"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem,
  "<CMD>EasyreadToggle<CR>",
  desc("toggle easyread", prompt)
)

---
-- @keymaps:glow.nvim 		MarkDown preview inside neovim, with glow
---------------------------------------------------------------------
mname = "glow"
stem = "markdown"
keystem = ";p"
prompt = "editor::glow"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem,
  "<CMD>Glow!<CR>",
  desc("toggle markdown preview", prompt)
)

-----
---- @keymaps:hints: 		inline hints management
---------------------------------------------------------
-- mname = "hints"
-- stem = "inline help and suggestions"
-- keystem = ";h"
-- prompt = "editor::inline-hints"
-- mapx.nname(keystem, namer(mname, stem, false))
-- mapx.nnoremap(keystem, require(', desc("toggle markdown preview", prompt))

---
-- @keymaps:text-utilities: 		utilities for in-buffer text manipulation
-----------------------------------------------------------------------------
--  The following defines keybindings for comment insertions
mname = "buffer & text"
stem = "insert and edit"
keystem = "<leader>t"
prompt = "editor::util.text"
mapx.nname(stem, namer(mname, stem, false))
mapx.nnoremap(keystem .. "c", function()
  require("uutils.edit").InsertCommentBreak(tonumber(vim.o.textwidth), "-")
end, desc("insert comment break", prompt))

mapx.nnoremap(keystem .. "d", function()
  require("uutils.edit").InsertDashBreak(tonumber(vim.o.textwidth), "-")
end, desc("insert dash break", prompt))

---
-- @keymaps:text-utilities:cbox              callboxes comment division
-- insertion
--

---
-- @keymaps:vim.wm: 		window management bindings to standard-ish keys
---------------------------------------------------------------------------
--  The following defines user mappings for handling window management.
mname = "vim action"
stem = "buffers"
prompt = "buf"

mapx.nnoremap("<F11>", "<cmd>bprevious<CR>", desc("previous buffer", prompt))
mapx.nnoremap("<F12>", "<cmd>bnext<CR>", desc("next buffer", prompt))
mapx.nnoremap(
  "<F3>",
  "<cmd>vsplit<CR>",
  desc("open buffer in vertical split (default split settings)", prompt)
)
mapx.nnoremap(
  "<F4>",
  "<cmd>split<CR>",
  desc("open buffer in horizontal split (default split settings)", prompt)
)

---
-- @keymaps:vim.dap: 		debugger configuration
--------------------------------------------------
--  Configuration to access debugger commands via keys
local dap = require("dap")
local dwidgets = require("dap.ui.widgets")
mname = "debug adapters: vim action"
stem = "debugging"
prompt = "dap"
mapx.nnoremap(
  "<F8>",
  dap.toggle_breakpoint,
  desc("toggle debugging breakpoint on this line", prompt)
)
mapx.nnoremap(
  "<S-F8>",
  dap.set_breakpoint,
  desc("set debugging breakpoint (guaranteed) on this line", prompt)
)
mapx.nnoremap("<F9>", dap.continue, desc("debug flow >> continue", prompt))
mapx.nnoremap("<F10>", dap.step_over, desc("debug flow >> step over", prompt))
mapx.nnoremap("<S-F10>", dap.step_into, desc("debug flow >> step into", prompt))
mapx.nnoremap(
  "<F12>",
  dwidgets.hover,
  desc("hover information from debug adapters", prompt)
)
mapx.nnoremap("<F5>", function()
  require("osv").launch({ port = 8086 })
end, desc("launch debug adapters?", prompt))

---
-- @keymaps:vim.<leader>: 	<leader> keymappings
------------------------------------------------
-- @subgroup -- Defining complex leader overrides. The hope is to be able to
mname = "<leader> action"
stem = "editor behavior configuration"
prompt = string.format("go{}", vim.g.mapleader)
mapx.nname(keystem, namer(mname, stem, false))

---
-- @subgroup -- buffer manipulation mappings under leader
mname = "buffer manipulation"
stem = "leader key"
keystem = "<leader>b"
prompt = "buf"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(keystem .. "d", "<cmd>bdelete<CR>", desc("delete buffer", prompt))
mapx.nnoremap(
  keystem .. "p",
  "<cmd>bprevious<CR>",
  desc("previous buffer", prompt)
)
mapx.nnoremap(keystem .. "n", "<cmd>bnext<CR>", desc("next buffer", prompt))
mapx.nnoremap(keystem .. "b", "<cmd>BufNew<CR>", desc("new buffer", prompt))

mapx.nnoremap(
  keystem .. "v",
  "<cmd>vsplit<CR>",
  desc("vertical split current buffer", prompt)
)
mapx.nnoremap(
  keystem .. "h",
  "<cmd>split<CR>",
  desc("horizontal split current buffer", prompt)
)
mapx.nnoremap(keystem, "<cmd>buffers<CR>", desc("list all buffers", prompt))

mname = "quit"
stem = "escape from neovim"
keystem = "<leader>q"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(keystem .. "q", "<CMD>qa<CR>", desc("quit all", prompt))
mapx.nnoremap(keystem .. "i", "<CMD>q!<CR>", desc("quit immediately", prompt))
mapx.nnoremap(
  keystem .. "Q",
  "<CMD>qa!<CR>",
  desc("quit all immediately", prompt)
)
mapx.nnoremap("<leader>Q", "<CMD>q<CR>", desc("quit", prompt))

mname = "alpha"
stem = "go home"
prompt = "home"
mapx.nnoremap("<Home>", function()
  vim.cmd("Alpha")
end, desc("return to alpha state", prompt))

---
-- @subgroup -- lazy package manager mappings
mname = "lazy (package manager)"
stem = "shortcuts"
keystem = "<leader>p"
prompt = "pkg"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "s",
  "<cmd>Lazy sync<CR>",
  desc("sync package manager", prompt)
)
mapx.nnoremap(
  keystem .. "c",
  "<cmd>Lazy clean<CR>",
  desc("clean package manager")
)
mapx.nnoremap(
  keystem .. "h",
  "<cmd>Lazy home<CR>",
  desc("return to package manager home screen", prompt)
)
mapx.nnoremap(keystem, "<cmd>Lazy<CR>", desc("lazy package manager", prompt))

---
-- @keymaps:cmp: 	nvim-cmp keymappings
----------------------------------------
mname = "nvim-cmp"
local cmp_sel = require("cmp").SelectBehavior

local cmp_mappings = {
  ["<C-b>"] = cmpk.scroll_docs(-4),
  ["<C-f>"] = cmpk.scroll_docs(4),
  ["<C-BS>"] = cmpk.abort(),
  ["<C-Space>"] = cmpk.complete(),
  ["<C-y>"] = cmpk.complete({ behavior = cmp_sel.Select }),
  ["<CR>"] = cmpk.complete({ behavior = cmp_sel.Select }),
}

---
-- @keymaps:localleader  		keymappings for the localleader, generally goes
-- here. further, more specific instructions will be available soon for plugins
-- and other desired extensions.
-------------------------------------------------------------------------------
mname = "<localleader> action"
stem = "formatting and diagnostics"
prompt = string.format("go{}", vim.g.maplocalleader)
mapx.nname(stem, namer(mname, stem, false))

---
-- @keymaps:notify 		nvim-notify mappings, namely to open in telescope and/or
-- get notification history
--------------------------------------------------------------------------------
mname = "[no]ice/tify"
stem = "notification history"
keystem = "<localleader>n"
prompt = "noit!"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "n",
  require("notify").history,
  desc("notification history", prompt)
)
mapx.nnoremap(
  keystem .. "o",
  require("notify").history,
  desc("vim history details", prompt)
)
mapx.nnoremap(
  keystem .. "t",
  require("telescope").extensions.notify.notify,
  desc("notifications", prompt)
)
-- mapx.nnoremap(keystem .. "i", require('noice').cmd("telescope"), desc("noice", prompt))
mapx.nnoremap(
  keystem,
  require("telescope").extensions.notify.notify,
  desc("notifications", prompt)
)

---
-- @keymaps:telescope: 	Telescope keymappings
---------------------------------------------
mname = "telescope"
local scope = require("telescope")
local pickers = require("telescope.builtin")
local scopestem = "<localleader><localleader>"

keystem = scopestem .. "f"
stem = "files"
prompt = "scope"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "o",
  pickers.oldfiles,
  desc("search for old files", prompt)
)
mapx.nnoremap(keystem, pickers.find_files, desc("find files", prompt))
stem = "buffers"
keystem = "<localleader><localleader>b"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(keystem, pickers.buffers, desc("search within buffers", prompt))
stem = "treesitter"
keystem = "<localleader><localleader>r"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem,
  pickers.treesitter,
  desc("search within treesitter metadata", prompt)
)
stem = "tags"
keystem = "<localleader><localleader>g"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "c",
  pickers.current_buffer_tags,
  desc("search for tags in the current buffer", prompt)
)
mapx.nnoremap(keystem, pickers.tags, desc("search for tags", prompt))
stem = "Commands"
keystem = "<localleader><localleader>c"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem,
  pickers.commands,
  desc("search for shell commands", prompt)
)
stem = "Help/History"
keystem = "<localleader><localleader>h"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "t",
  pickers.help_tags,
  desc("search for help_tags", prompt)
)
mapx.nnoremap(
  keystem .. "m",
  pickers.man_pages,
  desc("search for manual pages", prompt)
)
mapx.nnoremap(
  keystem .. "s",
  pickers.search_history,
  desc("search for search history", prompt)
)
mapx.nnoremap(
  keystem .. "c",
  pickers.command_history,
  desc("search for command history", prompt)
)
mapx.nnoremap(
  keystem,
  pickers.man_pages,
  desc("search for manual pages", prompt)
)
stem = "vim::marks"
keystem = "<localleader><localleader>m"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(keystem, pickers.marks, desc("search for vim marks", prompt))
stem = "loclist"
keystem = "<localleader><localleader>y"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(keystem, pickers.loclist, desc("search for loclist", prompt))
stem = "keymappings"
keystem = "<localleader><localleader>k"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(keystem, pickers.keymaps, desc("search for keymaps", prompt))
stem = "telescope"
keystem = "<localleader><localleader>p"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem,
  pickers.pickers,
  desc("search for telescope pickers", prompt)
)
stem = "vim::options"
keystem = "<localleader><localleader>v"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "v",
  pickers.vim_options,
  desc("search for vim options", prompt)
)
stem = "snippets"
mapx.nnoremap(
  keystem .. "s",
  scope.extensions.luasnip.luasnip,
  desc("search snippets", prompt)
)
stem = "notifications"
keystem = "<localleader><localleader>n"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "h",
  require("telescope").extensions.notify.notify,
  desc("search notification history", prompt)
)
-- local noice = require('noice')
-- mapx.nnoremap(keystem .. "n", noice.cmd('telescope'))
-- mapx.nnoremap(keystem, noice.cmd)
mapx.nnoremap(
  scopestem,
  "<CMD>Telescope<CR>",
  desc("open telescope (default)", prompt)
)

---
-- @keymaps:languageserver: 	LSP keymappings
-----------------------------------------------
mname = "lsp"
stem = "language server"
keystem = "<localleader>l"
prompt = "lsp"
mapx.nname(keystem, namer(mname, stem, false))
-- seems we need to do it this way instead.
mapx.nnoremap(
  keystem .. "f",
  pickers.lsp_references,
  desc("search for references from language server", prompt)
)
mapx.nnoremap(
  keystem .. "n",
  pickers.lsp_incoming_calls,
  desc("search for incoming calls to language server", prompt)
)
mapx.nnoremap(
  keystem .. "o",
  pickers.lsp_outgoing_calls,
  desc("search for outgoing calls to language server", prompt)
)
mapx.nnoremap(
  keystem .. "sd",
  pickers.lsp_document_symbols,
  desc("search for document symbols in language server", prompt)
)
mapx.nnoremap(
  keystem .. "sw",
  pickers.lsp_workspace_symbols,
  desc("search for symbols in language server over whole workspace", prompt)
)

---
-- @keymaps:languageserver: 	LSP keymappings
-----------------------------------------------
stem = "diagnostics"
keystem = "<localleader>d"
prompt = "diag"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "d",
  pickers.diagnostics,
  desc("search within diagnostic output", prompt)
)

---
-- @keymaps:null-ls: 	null-ls neovim lsp injection (formatting, etc)
----------------------------------------------------------------------
mname = "null-ls"
stem = "formatting"
keystem = "<localleader>f"
prompt = "go{} set toggle on with a vengeance"
promptsep = "null-ls"
mapx.nname(keystem, namer(mname, stem, false))
local function nullformat(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

local function toggle_fmtopt(char)
  local currentopts = vim.opt.formatoptions:get()
  if currentopts[char] then
    vim.opt.formatoptions:remove(char)
  else
    vim.opt.formatoptions:append(char)
  end
end
mapx.nnoremap(
  keystem .. "f",
  nullformat,
  desc("null-ls > format document", prompt)
)
mapx.nnoremap(keystem .. "a", function()
  return toggle_fmtopt("a")
end, desc("toggle autoformatting on insert", prompt))

---
-- @keymaps:Vista: 	enable vista menus
--------------------------------------
mname = "vista"
stem = "ctags and code items"
keystem = "<localleader>v"
prompt = "vistags"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "vs",
  "<CMD>Vista show<CR>",
  desc("jump to nearest and show", prompt)
)
mapx.nnoremap(
  keystem .. "vf",
  "<CMD>Vista finder<CR>",
  desc("fzf finder", prompt)
)
mapx.nnoremap(
  keystem .. "v",
  "<CMD>Vista!!<CR>",
  desc("browse tags (toggle)", prompt)
)

---
-- @keymaps:ccc.nvim: 	color utilities
---------------------------------------
mname = "ccc"
stem = "color utilities"
keystem = "<localleader>c"
prompt = "color"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "p",
  "<CMD>CccPick<CR>",
  desc("pick color interactively", prompt)
)
mapx.nnoremap(
  keystem .. "h",
  "<CMD>CccHighlighterToggle<CR>",
  desc("toggle inline color highlighting for recognized colors", prompt)
)
mapx.nnoremap(
  keystem .. "v",
  "<CMD>CccConvert<CR>",
  desc("convert color to another format", prompt)
)
mapx.nnoremap(
  keystem .. "f",
  "<CMD>CccHighlighterDisable<CR>",
  desc("turn off inline color highlighting for recognized colors", prompt)
)
mapx.nnoremap(
  keystem .. "o",
  "<CMD>CccHighlighterEnable<CR>",
  desc("turn on inline color highlighting for recognized colors", prompt)
)
mapx.nnoremap(
  keystem,
  "<CMD>CccHighlighterToggle<CR>",
  desc("toggle inline color highlighting for recognized colors", prompt)
)

---
-- @keymaps:pomodoro.nvim 	time tracking
-- @keymaps:orgmode.nvim  	time tracking within orgmode to sync with pomodoro.
-------------------------------------------------------------------------------
mname = "time tracking"
stem = "pomodoro and orgmode"
keystem = "<localleader>o"
prompt = "pomnorg/time >> "
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "p",
  "<CMD>pompom<CR>",
  desc("start pomodoro timer", prompt)
)
mapx.nnoremap(
  keystem .. "P",
  "<CMD>PomodoroStart<CR>",
  desc("start pomodoro timer (sync orgmode)", prompt)
)
mapx.nnoremap(
  keystem .. "q",
  "<CMD>PomodoroStop<CR>",
  { silent = true },
  desc("stop pomodoro timer", prompt)
)
mapx.nnoremap(
  keystem .. "Q",
  "<CMD>PomodoroStop<CR>",
  { silent = true },
  desc("stop pomodoro timer (cancel orgmode)", prompt)
)
mapx.nnoremap(
  keystem .. "s",
  "<CMD>PomodoroStatus<CR>",
  desc("pomodoro status", prompt)
)
mapx.nnoremap(
  keystem .. "",
  "<CMD>PomodoroStatus<CR>",
  desc("pomodoro status", prompt)
)

---
-- @keymaps:neural 			AI based code generation tools
----------------------------------------------------------
mname = "ai"
stem = "use chatgpt and other models"
keystem = "<localleader>/"
prompt = "nrl"
mapx.nname(keystem, namer(mname, stem, false))
mapx.nnoremap(
  keystem .. "n",
  "<CMD>Neural<CR>",
  desc("gpt alternative interface", prompt)
)
mapx.nnoremap(
  keystem .. "r",
  "<CMD>ChatGPTActAs<CR>",
  desc("role prompts", prompt)
)
mapx.nnoremap(
  keystem .. "e",
  "<CMD>ChatGPTEditWithInstructions<CR>",
  desc("edit with instructions", prompt)
)
mapx.nnoremap(
  keystem .. "c",
  "<CMD>ChatGPTCompleteCode<CR>",
  desc("code completion", prompt)
)
mapx.nnoremap(
  keystem .. "a",
  "<CMD>ChatGPTRunCustomCodeAction<CR>",
  desc("custom code action", prompt)
)
mapx.nnoremap(
  keystem,
  "<CMD>ChatGPT<CR>",
  desc("openai api interface with gpt models", prompt)
)

---
-- @module Now we attach everything to mod to return
---------------------------------------------------
mod.mappings = mappings
mod.cmp_mappings = cmp_mappings
mod.scope_mappings = scope_mappings

return mod
