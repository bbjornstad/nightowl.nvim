---@module "parliament.config.keymapx(" main keymapx( for nightowl with kickstarter
---many of these are ripped directly from LazyVim.
-- Keymapx( are automatically loaded on the VeryLazy event
-- Default keymapx( that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymapx(.lua
-- Add any additional keymapx( here
local edit_tools = require("uutils.text")
local kenv = require("environment.keys")
local key_cline = kenv.editor.cline
local key_lists = kenv.lists
local mapx = vim.keymap.set
local delx = vim.keymap.del
local has = require("funsak.lazy").has
local toggle = require('funsak.toggle')

--- gets the help in vim documentation for the item under the cursor
local function helpmapper()
  local thishelp = ("help %s"):format(vim.fn.expand("<cword>"))
  vim.cmd(thishelp)
end

-- Keymapx( for better default experience
mapx({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- better up/down, handling word wrap scenarios gracefully.
mapx(
  { "n", "x" },
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
mapx(
  { "n", "x" },
  "<Down>",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
mapx(
  { "n", "x" },
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
mapx(
  { "n", "x" },
  "<Up>",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)

-- Rebind the help menu to be attached to "gh"
mapx(
  "n",
  "gH",
  helpmapper,
  { desc = "got=> get help", remap = false, nowait = true }
)

-- because I spam escape in the upper left corner sometimes, the following binds
-- stop help from showing up on any touch of the <f1> key by default, which gets
-- annoying as heck.
mapx(
  { "n", "i" },
  "<F1>",
  "<NOP>",
  { desc = "got=> don't get help", remap = false, nowait = false }
)

-- refix of the lazy.nvim keybinds here such that the <leader>l combo of keys is
-- available for other things.
mapx({ "n" }, kenv.lazy.open, "<CMD>Lazy<CR>", { desc = "lazy=> panel" })
mapx(
  { "n" },
  kenv.lazy.update,
  "<CMD>Lazy update<CR>",
  { desc = "lazy=> update" }
)
mapx({ "n" }, kenv.lazy.log, "<CMD>Lazy log<CR>", { desc = "lazy=> log" })
mapx(
  { "n" },
  kenv.lazy.clean,
  "<CMD>Lazy clean<CR>",
  { desc = "lazy=> clean" }
)
mapx(
  { "n" },
  kenv.lazy.debug,
  "<CMD>Lazy debug<CR>",
  { desc = "lazy=> debug" }
)
mapx({ "n" }, kenv.lazy.help, "<CMD>Lazy help<CR>", { desc = "lazy=> help" })
mapx(
  { "n" },
  kenv.lazy.build,
  "<CMD>Lazy build<CR>",
  { desc = "lazy=> build" }
)
mapx(
  { "n" },
  kenv.lazy.reload,
  "<CMD>Lazy reload<CR>",
  { desc = "lazy=> reload" }
)
mapx(
  { "n" },
  kenv.lazy.extras,
  "<CMD>LazyExtras<CR>",
  { desc = "lazy=> extras" }
)
pcall(delx, { "n" }, "<leader>l")

-- Move Lines
mapx("n", "<A-S-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
mapx("n", "<A-S-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
mapx("i", "<A-S-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
mapx("i", "<A-S-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
mapx("v", "<A-S-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
mapx("v", "<A-S-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- move to beginning and end of line with S-H and S-L, overriding the lazyvim
-- default behavior which is next and previous buffers. These are rebound to
-- include Control modifier, so that I stop accidentally switching buffers when
-- I don't want to.
mapx({ "n", "v" }, "<S-h>", "_", { desc = "goto=> line first character" })
mapx({ "n", "v" }, "<S-l>", "$", { desc = "goto=> line end character" })
mapx("i", "<C-S-h>", "<C-o>_", { desc = "goto=> line first character" })
mapx("i", "<C-S-l>", "<C-o>$", { desc = "goto=> line end character" })
mapx("i", "<C-j>", "<C-o><down>", { desc = "buf=> cursor down" })
mapx("i", "<C-k>", "<C-o><up>", { desc = "buf=> cursor up" })
mapx("i", "<C-h>", "<C-o><left>", { desc = "buf=> cursor left" })
mapx("i", "<C-l>", "<C-o><right>", { desc = "buf=> cursor right" })



-- Ctrl-Q Quit Bindings
mapx("n", "<C-q><C-q>", "<CMD>quit<CR>", { desc = "quit=> terminate" })
mapx(
  "n",
  "<C-q><C-w>",
  "<CMD>write-quit<CR>",
  { desc = "quit=> save > terminate" }
)
mapx(
  "n",
  "<C-q>w",
  "<CMD>write-quit<CR>",
  { desc = "quit=> save > terminate" }
)
mapx("n", "<C-q>!", "<CMD>quit!<CR>", { desc = "quit=> [!] terminate" })
mapx("n", "<C-q><C-!>", "<CMD>quit!<CR>", { desc = "quit=> [!] terminate" })
mapx(
  "n",
  "<C-S-q>w",
  "<CMD>wqall<CR>",
  { desc = "quit=> [all] save > terminate" }
)
mapx(
  "n",
  "<C-S-q><C-w>",
  "<CMD>wqall<CR>",
  { desc = "quit=> [all] save > terminate" }
)
mapx("n", "<C-S-q>Q", "<CMD>quitall<CR>", { desc = "quit=> [all] terminate" })
mapx(
  "n",
  "<C-S-q><C-S-q>",
  "<CMD>quitall<CR>",
  { desc = "quit=> [all] terminate" }
)
mapx(
  "n",
  "<C-S-q><C-!>",
  "<CMD>quitall!<CR>",
  { desc = "quit=> [all, !] terminate" }
)
mapx(
  "n",
  "<C-S-q>!",
  "<CMD>quitall!<CR>",
  { desc = "quit=> [all, !] terminate" }
)

-- remove macro on the q key, as I prefer to use a plugin to handle macros and
-- the q key is prime real estate for other functions.
mapx("n", "q", "<NOP>", { desc = "macro=> don't record" })

-- closing windows without quitting.
mapx("n", "<C-c>", function()
  vim.api.nvim_win_close(0, false)
end, { desc = "win=> close window" })
mapx("n", "qqq", function()
  vim.api.nvim_win_close(0, false)
end, { desc = "win=> close window" })

-- remove some default binds to free them up for different entries under the "f"
-- subleader
-- pcall(delx, "n", "<leader>fn")
-- pcall(delx, "n", "<leader>ft")
mapx("n", kenv.fm.fs.new, function()
  vim.ui.input({ prompt = "󰎝 enter filename: " }, function(input)
    vim.cmd(("edit ./%s"):format(input))
  end)
end, { desc = "buf=> new buffer" })
mapx(
  "n",
  kenv.buffer.write,
  "<CMD>write<CR>",
  { desc = "buf=> save current buffer" }
)
mapx(
  "n",
  kenv.buffer.writeall,
  "<CMD>writeall<CR>",
  { desc = "buf=> [all] write" }
)
mapx(
  "n",
  kenv.buffer.wipeout,
  "<CMD>bwipeout<CR>",
  { desc = "buf=> wipeout this buffer" }
)
mapx(
  "n",
  kenv.buffer.force_wipeout,
  "<CMD>bwipeout!<CR>",
  { desc = "buf=> [!] wipeout this buffer" }
)
mapx("n", kenv.buffer.write, "<CMD>write<CR>", { desc = "buf=> write" })
mapx(
  "n",
  kenv.buffer.writeall,
  "<CMD>writeall<CR>",
  { desc = "buf=> [all] write" }
)

-- navigating buffers with non-shortcutted keymapx(.
if not has("cybu.nvim") then
  mapx("n", "<C-S-h>", "<cmd>bprevious<cr>", { desc = "buf=> previous" })
  mapx("n", "<C-S-l>", "<cmd>bnext<cr>", { desc = "buf=> next" })
  mapx("n", "[b", "<cmd>bprevious<cr>", { desc = "buf=> previous" })
  mapx("n", "]b", "<cmd>bnext<cr>", { desc = "buf=> next" })
end

mapx("n", "<leader>bb", "<cmd>e #<cr>", { desc = "buf=> autocycle" })
mapx("n", "<leader>`", "<cmd>e #<cr>", { desc = "buf=> autocycle" })

-- Windowing adjustment keymapx(, for things like moving to a window, resizing,
-- reorganizing, etc.
-- * chorded/shortcut bindings
mapx("n", "<C-h>", "<C-w>h", { desc = "win.go=> left", remap = true })
mapx("n", "<C-j>", "<C-w>j", { desc = "win.go=> down", remap = true })
mapx("n", "<C-k>", "<C-w>k", { desc = "win.go=> up", remap = true })
mapx("n", "<C-l>", "<C-w>l", { desc = "win.go=> right", remap = true })
mapx("n", "<A-h>", "<C-w>h", { desc = "win.go=> left", remap = true })
mapx("n", "<A-j>", "<C-w>j", { desc = "win.go=> down", remap = true })
mapx("n", "<A-k>", "<C-w>k", { desc = "win.go=> up", remap = true })
mapx("n", "<A-l>", "<C-w>l", { desc = "win.go=> right", remap = true })

-- * resize window using <ctrl> + arrow keys
mapx("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "win.sz.height=> increease" })
mapx("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "win.sz.height=> decrease" })
mapx("n", "<C-Left>", "<cmd>vertical resize -2<cr>",
  { desc = "win.sz.width=> decrease" })
mapx("n", "<C-Right>", "<cmd>vertical resize +2<cr>",
  { desc = "win.sz.width=> increase" })

-- * leader submenu for window management
mapx("n", "<leader>wh", "<C-w>h", { desc = "win.go=> left", remap = false })
mapx("n", "<leader>wj", "<C-w>j", { desc = "win.go=> down", remap = false })
mapx("n", "<leader>wk", "<C-w>k", { desc = "win.go=> go up", remap = false })
mapx("n", "<leader>wl", "<C-w>l", { desc = "win.go=> right", remap = false })
mapx("n", "<leader>wH", "<C-w>H", { desc = "win.mv=> left", remap = false })
mapx("n", "<leader>wJ", "<C-w>J", { desc = "win.mv=> bottom", remap = false })
mapx("n", "<leader>wK", "<C-w>K", { desc = "win.mv=> top", remap = false })
mapx("n", "<leader>wL", "<C-w>L", { desc = "win.mv=> right", remap = false })
mapx(
  "n",
  "<leader>wr",
  "<C-w>r",
  { desc = "win.rot=> rotate down/right", remap = false }
)
mapx(
  "n",
  "<leader>wR",
  "<C-w>R",
  { desc = "win.rot=> rotate up/left", remap = false }
)
mapx(
  "n",
  "<leader>w<",
  "<C-w><",
  { desc = "win.sz.width=> decrease", remap = false }
)
mapx(
  "n",
  "<leader>w>",
  "<C-w>r",
  { desc = "win.sz.width=> increase", remap = false }
)
mapx(
  "n",
  "<leader>w-",
  "<C-w>-",
  { desc = "win.sz.height=> decrease", remap = false }
)
mapx(
  "n",
  "<leader>w+",
  "<C-w>+",
  { desc = "win.sz.height=> increase", remap = false }
)
mapx(
  "n",
  "<leader>w|",
  "<C-w>|",
  { desc = "win.sz.width=> maximize", remap = false }
)
mapx(
  "n",
  "<leader>w_",
  "<C-w>|",
  { desc = "win.sz.height=> maximize", remap = false }
)
mapx(
  "n",
  "<leader>w=",
  "<C-w>=",
  { desc = "win.sz=> maximize equally", remap = false }
)
mapx(
  "n",
  "<leader>wo",
  "<C-w>o",
  { desc = "win.close=> all other windows", remap = false }
)
mapx(
  "n",
  "<leader>wT",
  "<C-w>T",
  { desc = "win.tab=> to new", remap = false }
)
mapx(
  "n",
  "<leader>w<tab>",
  "<C-w>T",
  { desc = "win.tab=> to new", remap = false }
)
mapx("n", "<leader>ww", "<C-W>p", { desc = "win.go=> to other", remap = true })
mapx("n", "<leader>wd", "<C-W>c",
  { desc = "win.close=> this window", remap = true })

-- tabs
mapx("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "win.tab=> last" })
mapx("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "win.tab=> first" })
mapx("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "win.tab=> new" })
mapx("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "win.tab=> next" })
mapx("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "win.tab=> close" })
mapx("n", "<leader><tab>[", "<cmd>tabprevious<cr>",
  { desc = "win.tab=> previous" })

-- location lists: loclist and quickfix.
-- * quickfix list
mapx(
  "n",
  key_lists.quickfix.open,
  "<CMD>copen<CR>",
  { desc = "list.qf=> open" }
)
mapx(
  "n",
  key_lists.quickfix.next,
  "<CMD>cnext<CR>",
  { desc = "list.qf=> open" }
)
mapx(
  "n",
  key_lists.quickfix.last,
  "<CMD>clast<CR>",
  { desc = "list.qf=> open" }
)
mapx(
  "n",
  key_lists.quickfix.previous,
  "<CMD>cprev<CR>",
  { desc = "list.qf=> open" }
)
mapx(
  "n",
  key_lists.quickfix.first,
  "<CMD>cfirst<CR>",
  { desc = "list.qf=> open" }
)
mapx(
  "n",
  key_lists.quickfix.close,
  "<CMD>cclose<CR>",
  { desc = "list.qf=> open" }
)

-- * location list
mapx(
  "n",
  key_lists.loclist.open,
  "<CMD>lopen<CR>",
  { desc = "list.loc=> open" }
)
mapx(
  "n",
  key_lists.loclist.next,
  "<CMD>lnext<CR>",
  { desc = "list.loc=> open" }
)
mapx(
  "n",
  key_lists.loclist.last,
  "<CMD>llast<CR>",
  { desc = "list.loc=> open" }
)
mapx(
  "n",
  key_lists.loclist.previous,
  "<CMD>lprev<CR>",
  { desc = "list.loc=> open" }
)
mapx(
  "n",
  key_lists.loclist.first,
  "<CMD>lfirst<CR>",
  { desc = "list.loc=> open" }
)
mapx(
  "n",
  key_lists.loclist.close,
  "<CMD>lclose<CR>",
  { desc = "list.loc=> open" }
)

-- keywordprg
mapx("n", "<leader>K>", "<CMD>norm! K<CR>",
  { desc = { "vim.keywordprg=> apply" } })

-- better indenting
mapx("v", "<", "<gv", { desc = "vim.indent=> decrease" })
mapx("v", ">", ">gv", { desc = "vim.indent=> increase" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
mapx("n", "n", "'Nn'[v:searchforward].'zv'",
  { expr = true, desc = "Next search result" })
mapx("x", "n", "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" })
mapx("o", "n", "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" })
mapx("n", "N", "'nN'[v:searchforward].'zv'",
  { expr = true, desc = "Prev search result" })
mapx("x", "N", "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" })
mapx("o", "N", "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" })

-- Some basic line breaks using comment characters.
-- There are more advanced text-generation and commented breakline methods
-- available using the figlet and comment-box plugins (in extras.lua)
mapx("n", key_cline.custom.comment.insert, function()
  edit_tools.InsertCommentBreak(tonumber(vim.opt.textwidth:get()), "╍", false)
end, { desc = "break.comment=> insert" })
mapx("n", key_cline.custom.comment.nospace, function()
  edit_tools.InsertCommentBreak(tonumber(vim.opt.textwidth:get()), "╍", true)
end, { desc = "break.comment=> insert (no-space)" })

mapx("n", key_cline.custom.dash.insert, function()
  edit_tools.InsertDashBreak(tonumber(vim.opt.textwidth:get()), "╍")
end, { desc = "break.dash=> insert" })

mapx("n", key_cline.custom.select.insert, function()
  edit_tools.SelectedCommentBreak(tonumber(vim.opt.textwidth:get()), false)
end, { desc = "break.select=> insert" })
mapx("n", key_cline.custom.select.nospace, function()
  edit_tools.SelectedCommentBreak(tonumber(vim.opt.textwidth:get()), true)
end, { desc = "break.select=> insert (no-space)" })

mapx("n", key_cline.custom.following.insert, function()
  edit_tools.SucceedingCommentBreak(true)
end, { desc = "break.following=> insert" })
mapx("n", key_cline.custom.following.nospace, function()
  edit_tools.SucceedingCommentBreak(false)
end, { desc = "break.following=> insert (no-space)" })

-- helpers for quitting when accidentally using Shift
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Q q")

-- UI bindings for some basic behavior in controlling things like the
-- notifications, temporary highlighting, treesitter components, etc.
-- * Clear search, diff update and redraw
--   taken from runtime/lua/_editor.lua
mapx(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "ui.hl=> clupdraw (clear, update, redraw)" }
)

-- * under cursor inspection of highlights and extmarks.
mapx(
  "n",
  "<leader>ui",
  vim.show_pos,
  { desc = "ui.hl=> inspect under cursor" }
)

mapx("n", "<leader>us", function() toggle("spell") end,
  { desc = "ui.spell=> toggle" })
mapx("n", "<leader>uw", function() toggle("wrap") end,
  { desc = "ui.wrap=> toggle" })
mapx("n", "<leader>uL", function() toggle("relativenumber") end,
  { desc = "ui.number=> toggle rellineno" })
mapx("n", "<leader>ul", function() toggle.number() end,
  { desc = "ui.number=> toggle lineno" })
mapx("n", "<leader>ud", function() toggle.diagnostics() end,
  { desc = "ui.lsp=> toggle diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
mapx("n", "<leader>uc",
  function() toggle("conceallevel", false, { 0, conceallevel }) end,
  { desc = "ui.conceal=> toggle" })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  mapx("n", "<leader>uh", function() toggle.inlay_hints() end,
    { desc = "ui.lsp=> toggle inlay-hints" })
end
mapx("n", "<leader>uT",
  function() if vim.b.ts_highlight then vim.treesitter.stop() else vim
          .treesitter.start() end end, { desc = "ui.ts=> toggle highlight" })

local scrollval = vim.o.scrolloff
mapx("n", "<leader>uR",
  function() toggle("scrolloff", false, { 999 - scrollval, scrollval }) end,
  { desc = "ui.scroll.vertical=> toggle centered cursor" })
