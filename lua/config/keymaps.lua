-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
local edit_tools = require("uutils.text")
local kenv = require("environment.keys")
local key_cline = kenv.editor.cline
local mapx = vim.keymap.set
local delx = vim.keymap.del
local has = require("lazyvim.util").has

--- gets the help in vim documentation for the item under the cursor
local function helpmapper()
  local thishelp = ("help %s"):format(vim.fn.expand("<cword>"))
  vim.cmd(thishelp)
end

-- Rebind the help menu to be attached to "gh"
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
mapx("i", "<A-S-h>", "<C-o>_", { desc = "::goto=> line first character" })
mapx("i", "<A-S-l>", "<C-o>$", { desc = "::goto=> line end character" })

if not has("cybu.nvim") then
  mapx("n", "<C-S-h>", "<cmd>bprevious<cr>", { desc = "::buf=> previous" })
  mapx("n", "<C-S-l>", "<cmd>bnext<cr>", { desc = "::buf=> next" })
  mapx("i", "<C-S-h>", "<C-o><cmd>bprevious<cr>", { desc = "::buf=> previous" })
  mapx("i", "<C-S-l>", "<C-o><cmd>bnext<cr>", { desc = "::buf=> next" })
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
  "<C-Q>w",
  "<CMD>wqall<CR>",
  { desc = "::quit=> [all] save > terminate" }
)
mapx(
  "n",
  "<C-Q><C-w>",
  "<CMD>wqall<CR>",
  { desc = "::quit=> [all] save > terminate" }
)
mapx("n", "<C-Q>Q", "<CMD>quitall<CR>", { desc = "::quit=> [all] terminate" })
mapx(
  "n",
  "<C-Q><C-Q>",
  "<CMD>quitall<CR>",
  { desc = "::quit=> [all] terminate" }
)
mapx(
  "n",
  "<C-Q><C-!>",
  "<CMD>quitall!<CR>",
  { desc = "::quit=> [all, !] terminate" }
)
mapx(
  "n",
  "<C-Q>!",
  "<CMD>quitall!<CR>",
  { desc = "::quit=> [all, !] terminate" }
)

delx("n", "<leader>fn")
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
mapx("n", "<A-h>", "<C-w>h", { desc = "::win=> go left", remap = true })
mapx("n", "<A-j>", "<C-w>j", { desc = "::win=> go down", remap = true })
mapx("n", "<A-k>", "<C-w>k", { desc = "::win=> go up", remap = true })
mapx("n", "<A-l>", "<C-w>l", { desc = "::win=> go right", remap = true })
mapx("n", "<leader>wh", "<C-w>h", { desc = "::win=> go left", remap = false })
mapx("n", "<leader>wj", "<C-w>j", { desc = "::win=> go down", remap = false })
mapx("n", "<leader>wk", "<C-w>k", { desc = "::win=> go up", remap = false })
mapx("n", "<leader>wl", "<C-w>l", { desc = "::win=> go right", remap = false })

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

if has("accelerated-jk.nvim") then
  delx({ "n", "v" }, "j")
  delx({ "n", "v" }, "k")
  mapx({ "n", "v" }, "j", "<Plug>(accelerated_jk_j)", { desc = "mtn=> down" })
  mapx({ "n", "v" }, "k", "<Plug>(accelerated_jk_k)", { desc = "mtn=> up" })
end

-- these mappings are somewhat annoying as by default the alt-j key and alt-k
-- keys act to move the line up or down another line (e.g. swap line with above
-- or below line.) It is too easy for me to accidentally hit this when I don't
-- mean to.
delx({ "n", "v", "i" }, "<A-j>")
delx({ "n", "v", "i" }, "<A-k>")
mapx({ "n", "v" }, "<A-l>", "<Right>", { desc = "mtn=> right" })
mapx({ "n", "v" }, "<A-h>", "<Left>", { desc = "mtn=> left" })
mapx({ "n", "v" }, "<A-k>", "<Up>", { desc = "mtn=> up" })
mapx({ "n", "v" }, "<A-j>", "<Down>", { desc = "mtn=> down" })
mapx({ "i" }, "<A-l>", "<C-o><Right>", { desc = "mtn=> right" })
mapx({ "i" }, "<A-h>", "<C-o><Left>", { desc = "mtn=> left" })
mapx({ "i" }, "<A-k>", "<C-o><Up>", { desc = "mtn=> up" })
mapx({ "i" }, "<A-j>", "<C-o><Down>", { desc = "mtn=> down" })

-- binding to toggle centering the cursor when scrolling up or down.
mapx({ "n" }, "<leader>uR", function()
  local scrollval = tonumber(vim.opt.scrolloff:get())
  vim.opt.scrolloff = 999 - scrollval
end, { desc = "::win=> sticky center cursor" })
