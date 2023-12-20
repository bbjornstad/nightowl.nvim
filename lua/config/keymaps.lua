-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
local edit_tools = require("uutils.text")
local kenv = require("environment.keys")
local key_cline = kenv.editor.cline
local key_lists = kenv.lists
local mapx = vim.keymap.set
local delx = vim.keymap.del
local has = require("lazyvim.util").has

--- gets the help in vim documentation for the item under the cursor
local function helpmapper()
  local thishelp = ("help %s"):format(vim.fn.expand("<cword>"))
  vim.cmd(thishelp)
end

-- Rebind the herp menu to be attached to "gh"
mapx(
  "n",
  "gH",
  helpmapper,
  { desc = "::got=> get help", remap = false, nowait = true }
)

-- because I spam escape in the upper left corner sometimes, the following binds
-- stop help from showing up on any touch of the <f1> key by default, which gets
-- annoying as heck.
mapx(
  { "n", "i" },
  "<F1>",
  "<NOP>",
  { desc = "::got=> don't get help", remap = false, nowait = false }
)

-- refix of the lazy.nvim keybinds here such that the <leader>l combo of keys is
-- available for other things.
mapx({ "n" }, kenv.lazy.open, "<CMD>Lazy<CR>", { desc = "::lazy=> panel" })
mapx(
  { "n" },
  kenv.lazy.update,
  "<CMD>Lazy update<CR>",
  { desc = "::lazy=> update" }
)
mapx({ "n" }, kenv.lazy.log, "<CMD>Lazy log<CR>", { desc = "::lazy=> log" })
mapx(
  { "n" },
  kenv.lazy.clean,
  "<CMD>Lazy clean<CR>",
  { desc = "::lazy=> clean" }
)
mapx(
  { "n" },
  kenv.lazy.debug,
  "<CMD>Lazy debug<CR>",
  { desc = "::lazy=> debug" }
)
mapx({ "n" }, kenv.lazy.help, "<CMD>Lazy help<CR>", { desc = "::lazy=> help" })
mapx(
  { "n" },
  kenv.lazy.build,
  "<CMD>Lazy build<CR>",
  { desc = "::lazy=> build" }
)
mapx(
  { "n" },
  kenv.lazy.reload,
  "<CMD>Lazy reload<CR>",
  { desc = "::lazy=> reload" }
)
mapx(
  { "n" },
  kenv.lazy.extras,
  "<CMD>LazyExtras<CR>",
  { desc = "::lazy=> extras" }
)
delx({ "n" }, "<leader>l")

-- move to beginning and end of line with S-H and S-L, overriding the lazyvim
-- default behavior which is next and previous buffers. These are rebound to
-- include Control modifier, so that I stop accidentally switching buffers when
-- I don't want to.
mapx({ "n", "v" }, "<S-h>", "_", { desc = "::goto=> line first character" })
mapx({ "n", "v" }, "<S-l>", "$", { desc = "::goto=> line end character" })
mapx("i", "<C-S-h>", "<C-o>_", { desc = "::goto=> line first character" })
mapx("i", "<C-S-l>", "<C-o>$", { desc = "::goto=> line end character" })
mapx("i", "<C-j>", "<C-o><down>", { desc = "::buf=> cursor down" })
mapx("i", "<C-k>", "<C-o><up>", { desc = "::buf=> cursor up" })
mapx("i", "<C-h>", "<C-o><left>", { desc = "::buf=> cursor left" })
mapx("i", "<C-l>", "<C-o><right>", { desc = "::buf=> cursor right" })

if not has("cybu.nvim") then
  mapx("n", "<C-S-h>", "<cmd>bprevious<cr>", { desc = "::buf=> previous" })
  mapx("n", "<C-S-l>", "<cmd>bnext<cr>", { desc = "::buf=> next" })
  mapx("n", "[b", "<cmd>bprevious<cr>", { desc = "::buf=> previous" })
  mapx("n", "]b", "<cmd>bnext<cr>", { desc = "::buf=> next" })
end

mapx("n", "<C-q><C-q>", "<CMD>quit<CR>", { desc = "::quit=> terminate" })
mapx(
  "n",
  "<C-q><C-w>",
  "<CMD>write-quit<CR>",
  { desc = "::quit=> save > terminate" }
)
mapx(
  "n",
  "<C-q>w",
  "<CMD>write-quit<CR>",
  { desc = "::quit=> save > terminate" }
)
mapx("n", "<C-q>!", "<CMD>quit!<CR>", { desc = "::quit=> [!] terminate" })
mapx("n", "<C-q><C-!>", "<CMD>quit!<CR>", { desc = "::quit=> [!] terminate" })
mapx(
  "n",
  "<C-S-q>w",
  "<CMD>wqall<CR>",
  { desc = "::quit=> [all] save > terminate" }
)
mapx(
  "n",
  "<C-S-q><C-w>",
  "<CMD>wqall<CR>",
  { desc = "::quit=> [all] save > terminate" }
)
mapx("n", "<C-S-q>Q", "<CMD>quitall<CR>", { desc = "::quit=> [all] terminate" })
mapx(
  "n",
  "<C-S-q><C-S-q>",
  "<CMD>quitall<CR>",
  { desc = "::quit=> [all] terminate" }
)
mapx(
  "n",
  "<C-S-q><C-!>",
  "<CMD>quitall!<CR>",
  { desc = "::quit=> [all, !] terminate" }
)
mapx(
  "n",
  "<C-S-q>!",
  "<CMD>quitall!<CR>",
  { desc = "::quit=> [all, !] terminate" }
)

-- remove macro on the q key, as I prefer to use a plugin to handle macros and
-- the q key is prime real estate for other functions.
-- At one point macros were probably crucially important to the vim experience,
-- but I think that language tooling has evolved substantially enough to where
-- this is less of a showstopper of a feature.
mapx("n", "q", "<NOP>", { desc = "macro=> don't record" })

-- upgrades to closing behavior.
mapx("n", "<C-c>", function()
  vim.api.nvim_win_close(0, false)
end, { desc = "::win=> close window" })
mapx("n", "qqq", function()
  vim.api.nvim_win_close(0, false)
end, { desc = "::win=> close window" })

-- remove some default binds to free them up for different entries under the "f"
-- subleader
delx("n", "<leader>fn")
delx("n", "<leader>ft")
mapx("n", kenv.fm.fs.new, function()
  vim.ui.input({ prompt = "enter filename:" }, function(input)
    vim.cmd(("edit ./%s"):format(input))
  end)
end, { desc = "::buf=> new buffer" })
mapx(
  "n",
  kenv.buffer.write,
  "<CMD>write<CR>",
  { desc = "::buf=> save current buffer" }
)
mapx(
  "n",
  kenv.buffer.writeall,
  "<CMD>writeall<CR>",
  { desc = "::buf=> [all] write" }
)
mapx(
  "n",
  kenv.buffer.wipeout,
  "<CMD>bwipeout<CR>",
  { desc = "::buf=> wipeout this buffer" }
)
mapx(
  "n",
  kenv.buffer.force_wipeout,
  "<CMD>bwipeout!<CR>",
  { desc = "::buf=> [!] wipeout this buffer" }
)
mapx("n", kenv.buffer.write, "<CMD>write<CR>", { desc = "::buf=> write" })
mapx(
  "n",
  kenv.buffer.writeall,
  "<CMD>writeall<CR>",
  { desc = "::buf=> [all] write" }
)
delx({ "n" }, "<leader>bb")
delx({ "n" }, "<leader>qq")

-- things to move windows around
mapx("n", "<A-h>", "<C-w>h", { desc = "::win.go=> left", remap = true })
mapx("n", "<A-j>", "<C-w>j", { desc = "::win.go=> down", remap = true })
mapx("n", "<A-k>", "<C-w>k", { desc = "::win.go=> up", remap = true })
mapx("n", "<A-l>", "<C-w>l", { desc = "::win.go=> right", remap = true })
mapx("n", "<leader>wh", "<C-w>h", { desc = "::win.go=> left", remap = false })
mapx("n", "<leader>wj", "<C-w>j", { desc = "::win.go=> down", remap = false })
mapx("n", "<leader>wk", "<C-w>k", { desc = "::win.go=> go up", remap = false })
mapx("n", "<leader>wl", "<C-w>l", { desc = "::win.go=> right", remap = false })
mapx("n", "<leader>wH", "<C-w>H", { desc = "::win.mv=> left", remap = false })
mapx("n", "<leader>wJ", "<C-w>J", { desc = "::win.mv=> bottom", remap = false })
mapx("n", "<leader>wK", "<C-w>K", { desc = "::win.mv=> top", remap = false })
mapx("n", "<leader>wL", "<C-w>L", { desc = "::win.mv=> right", remap = false })
mapx(
  "n",
  "<leader>wr",
  "<C-w>r",
  { desc = "::win.rot=> rotate down/right", remap = false }
)
mapx(
  "n",
  "<leader>wR",
  "<C-w>R",
  { desc = "::win.rot=> rotate up/left", remap = false }
)
mapx(
  "n",
  "<leader>w<",
  "<C-w><",
  { desc = "::win.sz.width=> decrease", remap = false }
)
mapx(
  "n",
  "<leader>w>",
  "<C-w>r",
  { desc = "::win.sz.width=> increase", remap = false }
)
mapx(
  "n",
  "<leader>w-",
  "<C-w>-",
  { desc = "::win.sz.height=> decrease", remap = false }
)
mapx(
  "n",
  "<leader>w+",
  "<C-w>+",
  { desc = "::win.sz.height=> increase", remap = false }
)
mapx(
  "n",
  "<leader>w|",
  "<C-w>|",
  { desc = "::win.sz.width=> maximize", remap = false }
)
mapx(
  "n",
  "<leader>w_",
  "<C-w>|",
  { desc = "::win.sz.height=> maximize", remap = false }
)
mapx(
  "n",
  "<leader>w=",
  "<C-w>=",
  { desc = "::win.sz=> maximize equally", remap = false }
)
mapx(
  "n",
  "<leader>wo",
  "<C-w>o",
  { desc = "::win.close=> all other windows", remap = false }
)
mapx(
  "n",
  "<leader>wT",
  "<C-w>T",
  { desc = "::win.tab=> to new", remap = false }
)
mapx(
  "n",
  "<leader>w<tab>",
  "<C-w>T",
  { desc = "::win.tab=> to new", remap = false }
)

mapx("n", key_lists.quickfix.open, "<CMD>copen<CR>", { desc = "qf=> open" })
mapx("n", key_lists.quickfix.next, "<CMD>cnext<CR>", { desc = "qf=> open" })
mapx("n", key_lists.quickfix.last, "<CMD>clast<CR>", { desc = "qf=> open" })
mapx("n", key_lists.quickfix.previous, "<CMD>cprev<CR>", { desc = "qf=> open" })
mapx("n", key_lists.quickfix.first, "<CMD>cfirst<CR>", { desc = "qf=> open" })
mapx("n", key_lists.quickfix.close, "<CMD>cclose<CR>", { desc = "qf=> open" })

-- Some basic line breaks using comment characters.
-- There are more advanced text-generation and commented breakline methods
-- available using the figlet and comment-box plugins (in extras.lua)
mapx("n", key_cline.custom.comment.insert, function()
  edit_tools.InsertCommentBreak(tonumber(vim.opt.textwidth:get()), "╍", false)
end, { desc = "::break.comment=> insert" })
mapx("n", key_cline.custom.comment.nospace, function()
  edit_tools.InsertCommentBreak(tonumber(vim.opt.textwidth:get()), "╍", true)
end, { desc = "::break.comment=> insert (no-space)" })

mapx("n", key_cline.custom.dash.insert, function()
  edit_tools.InsertDashBreak(tonumber(vim.opt.textwidth:get()), "╍")
end, { desc = "::break.dash=> insert" })

mapx("n", key_cline.custom.select.insert, function()
  edit_tools.SelectedCommentBreak(tonumber(vim.opt.textwidth:get()), false)
end, { desc = "::break.select=> insert" })
mapx("n", key_cline.custom.select.nospace, function()
  edit_tools.SelectedCommentBreak(tonumber(vim.opt.textwidth:get()), true)
end, { desc = "::break.select=> insert (no-space)" })

mapx("n", key_cline.custom.following.insert, function()
  edit_tools.SucceedingCommentBreak(true)
end, { desc = "::break.following=> insert" })
mapx("n", key_cline.custom.following.nospace, function()
  edit_tools.SucceedingCommentBreak(false)
end, { desc = "::break.following=> insert (no-space)" })

-- these mappings are somewhat annoying as by default the alt-j key and alt-k
-- keys act to move the line up or down another line (e.g. swap line with above
-- or below line.) It is too easy for me to accidentally hit this when I don't
-- mean to.
delx({ "n", "v", "i" }, "<A-j>")
delx({ "n", "v", "i" }, "<A-k>")

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

-- binding to toggle centering the cursor when scrolling up or down.
mapx({ "n" }, "<leader>uR", function()
  local scrollval = tonumber(vim.opt.scrolloff:get())
  vim.opt.scrolloff = 999 - scrollval
end, { desc = "::win=> sticky center cursor" })
