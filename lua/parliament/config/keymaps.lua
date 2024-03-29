-- SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "parliament.config.keymap" main mappings for nightowl with
---kickstarter many of these are ripped directly from LazyVim.
-- Keymaps are automatically loaded on the VeryLazy event

-- ╓─────────────────────────────────────────────────────────────────────╖
-- ║ parliament keymappings:                                             ║
-- ╙─────────────────────────────────────────────────────────────────────╜
local edit_tools = require("parliament.utils.text")
local kenv = require("environment.keys")
local key_cline = kenv.editor.cline
local key_lists = kenv.lists
local mapx = vim.keymap.set
local delx = vim.keymap.del
local has = require("funsak.lazy").has
local toggle = require("funsak.toggle")

-- ─[ general improvements ]───────────────────────────────────────────────

-- gets the help in vim documentation for the item under the cursor
local function helpmapper()
  local thishelp = ("help %s"):format(vim.fn.expand("<cword>"))
  vim.cmd(thishelp)
end

-- for better default experience
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
  kenv.help.vimhelp,
  helpmapper,
  { desc = "got:| |=> get help", remap = false, nowait = true }
)

-- because I spam escape in the upper left corner sometimes, the following binds
-- stop help from showing up on any touch of the <f1> key by default, which gets
-- annoying as heck.
mapx(
  { "n", "i" },
  "<F1>",
  "<NOP>",
  { desc = "got:| |=> don't get help", remap = false, nowait = false }
)

-- ─[ lazy.nvim keybindings ]──────────────────────────────────────────────

-- refix of the lazy.nvim keybinds here such that the <leader>l combo of keys is
-- available for other things.
mapx({ "n" }, kenv.lazy.open, "<CMD>Lazy<CR>", { desc = "lazy |=> panel" })
mapx(
  { "n" },
  kenv.lazy.update,
  "<CMD>Lazy update<CR>",
  { desc = "lazy:| |=> update" }
)
mapx({ "n" }, kenv.lazy.log, "<CMD>Lazy log<CR>", { desc = "lazy |=> log" })
mapx(
  { "n" },
  kenv.lazy.clean,
  "<CMD>Lazy clean<CR>",
  { desc = "lazy |=> clean" }
)
mapx(
  { "n" },
  kenv.lazy.debug,
  "<CMD>Lazy debug<CR>",
  { desc = "lazy |=> debug" }
)
mapx({ "n" }, kenv.lazy.help, "<CMD>Lazy help<CR>", { desc = "lazy |=> help" })
mapx(
  { "n" },
  kenv.lazy.build,
  "<CMD>Lazy build<CR>",
  { desc = "lazy |=> build" }
)
mapx(
  { "n" },
  kenv.lazy.reload,
  "<CMD>Lazy reload<CR>",
  { desc = "lazy:| |=> reload" }
)
mapx(
  { "n" },
  kenv.lazy.extras,
  "<CMD>LazyExtras<CR>",
  { desc = "lazy:| |=> extras" }
)
mapx("n", "<C-c>", function()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  if ft == "lazy" then
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, true)
  else
    return "<C-c>"
  end
end, { expr = true, desc = "close" })
-- pcall(delx, { "n" }, "<leader>l")

-- ─[ motion keymappings: ]────────────────────────────────────────────────
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
mapx("i", "<C-S-h>", "<C-o>_", { desc = "goto:| |=> line first character" })
mapx("i", "<C-S-l>", "<C-o>$", { desc = "goto:| |=> line end character" })
mapx("i", "<C-j>", "<C-o><down>", { desc = "buf:| |=> cursor down" })
mapx("i", "<C-k>", "<C-o><up>", { desc = "buf:| |=> cursor up" })
mapx("i", "<C-h>", "<C-o><left>", { desc = "buf:| |=> cursor left" })
mapx("i", "<C-l>", "<C-o><right>", { desc = "buf:| |=> cursor right" })
mapx("n", "H", "_", { desc = "`_` BOL" })
mapx("n", "L", "$", { desc = "`$` EOL" })

-- ─[ Ctrl-Q Quit Bindings ]───────────────────────────────────────────────
mapx("n", "<C-q><C-q>", "<CMD>quit<CR>", { desc = "quit:| |=> terminate" })
mapx(
  "n",
  "<C-q><C-w>",
  "<CMD>write-quit<CR>",
  { desc = "quit:| |=> save > terminate" }
)
mapx(
  "n",
  "<C-q>w",
  "<CMD>write-quit<CR>",
  { desc = "quit:| |=> save > terminate" }
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
-- mapx("n", "q", "<NOP>", { desc = "macro:| |=> don't record" })

-- ─[ buffers, saving, files ]─────────────────────────────────────────────
mapx("n", kenv.fm.fs.new, function()
  vim.ui.input({ prompt = "󰎝 enter filename: " }, function(input)
    vim.cmd(("edit ./%s"):format(input))
  end)
end, { desc = "buf:| |=> new buffer" })
mapx(
  "n",
  kenv.buffer.write,
  "<CMD>write<CR>",
  { desc = "buf:| |=> save current buffer" }
)
mapx(
  "n",
  kenv.buffer.writeall,
  "<CMD>writeall<CR>",
  { desc = "buf=> [all] write" }
)
mapx("n", kenv.buffer.write, "<CMD>write<CR>", { desc = "buf |=> write" })
mapx(
  "n",
  kenv.buffer.writeall,
  "<CMD>writeall<CR>",
  { desc = "buf=> [all] write" }
)

-- navigating buffers with non-shortcutted keymaps.
-- NOTE: This should be done most effectively in a wrapping conditional check
-- for plugins that may interfere with the typical behavior, even though
-- ultimately they should be overwritten with the plugin regardless.

mapx("n", "<C-S-h>", "<cmd>bprevious<cr>", { desc = "buf:| |=> previous" })
mapx("n", "<C-S-l>", "<cmd>bnext<cr>", { desc = "buf:| |=> next" })
mapx("n", "[b", "<cmd>bprevious<cr>", { desc = "buf:| |=> previous" })
mapx("n", "]b", "<cmd>bnext<cr>", { desc = "buf:| |=> next" })
mapx("n", "<leader>bb", "<cmd>e #<cr>", { desc = "buf:| |=> autocycle" })

-- ─[ Window Keymaps ]─────────────────────────────────────────────────────
-- closing windows without quitting.
mapx("n", "<C-c>", function()
  vim.api.nvim_win_close(0, false)
end, { desc = "win:| |=> close window" })

-- chorded/shortcut bindings
mapx("n", "<C-h>", "<C-w>h", { desc = "win:| go |=> left", remap = true })
mapx("n", "<C-j>", "<C-w>j", { desc = "win:| go |=> down", remap = true })
mapx("n", "<C-k>", "<C-w>k", { desc = "win:| go |=> up", remap = true })
mapx("n", "<C-l>", "<C-w>l", { desc = "win:| go |=> right", remap = true })

-- resize window using <ctrl> + arrow keys
mapx(
  "n",
  "<C-Up>",
  "<cmd>resize +2<cr>",
  { desc = "win.sz:| height |=> increease" }
)
mapx(
  "n",
  "<C-Down>",
  "<cmd>resize -2<cr>",
  { desc = "win.sz:| height |=> decrease" }
)
mapx(
  "n",
  "<C-Left>",
  "<cmd>vertical resize -2<cr>",
  { desc = "win.sz:| width |=> decrease" }
)
mapx(
  "n",
  "<C-Right>",
  "<cmd>vertical resize +2<cr>",
  { desc = "win.sz:| width |=> increase" }
)

mapx("n", "<leader>wxh", "<C-w>s", { desc = "win:| split => horizontal" })
mapx("n", "<leader>wxv", "<C-w>v", { desc = "win:| split => vertical" })
mapx("n", "<leader>wxx", "<C-w>v", { desc = "win:| split => vertical" })

-- leader submenu for window management
mapx("n", "<leader>wh", "<C-w>h", { desc = "win:| go |=> left", remap = false })
mapx("n", "<leader>wj", "<C-w>j", { desc = "win:| go |=> down", remap = false })
mapx(
  "n",
  "<leader>wk",
  "<C-w>k",
  { desc = "win:| go |=> go up", remap = false }
)
mapx(
  "n",
  "<leader>wl",
  "<C-w>l",
  { desc = "win:| go |=> right", remap = false }
)
mapx("n", "<leader>wH", "<C-w>H", { desc = "win:| mv |=> left", remap = false })
mapx(
  "n",
  "<leader>wJ",
  "<C-w>J",
  { desc = "win:| mv |=> bottom", remap = false }
)
mapx("n", "<leader>wK", "<C-w>K", { desc = "win:| mv |=> top", remap = false })
mapx(
  "n",
  "<leader>wL",
  "<C-w>L",
  { desc = "win:| mv |=> right", remap = false }
)
mapx(
  "n",
  "<leader>wr",
  "<C-w>r",
  { desc = "win:| rot |=> rotate down/right", remap = false }
)
mapx(
  "n",
  "<leader>wR",
  "<C-w>R",
  { desc = "win:| rot |=> rotate up/left", remap = false }
)
mapx(
  "n",
  "<leader>w<",
  "<C-w><",
  { desc = "win.sz:| width |=> decrease", remap = false }
)
mapx(
  "n",
  "<leader>w>",
  "<C-w>r",
  { desc = "win.sz:| width |=> increase", remap = false }
)
mapx(
  "n",
  "<leader>w-",
  "<C-w>-",
  { desc = "win.sz:| height |=> decrease", remap = false }
)
mapx(
  "n",
  "<leader>w+",
  "<C-w>+",
  { desc = "win.sz:| height |=> increase", remap = false }
)
mapx(
  "n",
  "<leader>w|",
  "<C-w>|",
  { desc = "win.sz:| width |=> maximize", remap = false }
)
mapx(
  "n",
  "<leader>w_",
  "<C-w>|",
  { desc = "win.sz:| height |=> maximize", remap = false }
)
mapx(
  "n",
  "<leader>w=",
  "<C-w>=",
  { desc = "win:| sz |=> maximize equally", remap = false }
)
mapx(
  "n",
  "<leader>wo",
  "<C-w>o",
  { desc = "win:| close |=> all other windows", remap = false }
)
mapx(
  "n",
  "<leader>wT",
  "<C-w>T",
  { desc = "win:| tab |=> to new", remap = false }
)
mapx(
  "n",
  "<leader>w<tab>",
  "<C-w>T",
  { desc = "win:| tab |=> to new", remap = false }
)
mapx(
  "n",
  "<leader>ww",
  "<C-W>p",
  { desc = "win:| go |=> to other", remap = true }
)
mapx(
  "n",
  "<leader>wd",
  "<C-W>c",
  { desc = "win:| close |=> this window", remap = true }
)

-- tabs
mapx("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "win:| tab |=> last" })
mapx(
  "n",
  "<leader><tab>f",
  "<cmd>tabfirst<cr>",
  { desc = "win:| tab |=> first" }
)
mapx(
  "n",
  "<leader><tab><tab>",
  "<cmd>tabnew<cr>",
  { desc = "win:| tab |=> new" }
)
mapx("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "win:| tab |=> next" })
mapx(
  "n",
  "<leader><tab>d",
  "<cmd>tabclose<cr>",
  { desc = "win:| tab |=> close" }
)
mapx(
  "n",
  "<leader><tab>[",
  "<cmd>tabprevious<cr>",
  { desc = "win:| tab |=> previous" }
)
mapx("n", "[<tab>", "<CMD>tabprevious<CR>", { desc = "win:| tab |=> previous" })
mapx("n", "]<tab>", "<CMD>tabnext<CR>", { desc = "win:| tab |=> next" })

-- ─[ loclist and quickfix ]───────────────────────────────────────────────
-- quickfix list
mapx(
  "n",
  key_lists.quickfix.open,
  "<CMD>copen<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.next,
  "<CMD>cnext<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.last,
  "<CMD>clast<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.previous,
  "<CMD>cprev<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.first,
  "<CMD>cfirst<CR>",
  { desc = "list:| qf |=> open" }
)
mapx(
  "n",
  key_lists.quickfix.close,
  "<CMD>cclose<CR>",
  { desc = "list:| qf |=> open" }
)

-- location list
mapx(
  "n",
  key_lists.loclist.open,
  "<CMD>lopen<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.next,
  "<CMD>lnext<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.last,
  "<CMD>llast<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.previous,
  "<CMD>lprev<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.first,
  "<CMD>lfirst<CR>",
  { desc = "list:| loc |=> open" }
)
mapx(
  "n",
  key_lists.loclist.close,
  "<CMD>lclose<CR>",
  { desc = "list:| loc |=> open" }
)

-- ─[ keywordprg ]─────────────────────────────────────────────────────────
mapx(
  "n",
  "<leader>K",
  "<CMD>norm! K<CR>",
  { desc = { "vim:| keywordprg |=> apply" } }
)

-- ─[ better indenting ]───────────────────────────────────────────────────
mapx("v", "<", "<gv", { desc = "vim:| indent |=> decrease" })
mapx("v", ">", ">gv", { desc = "vim:| indent |=> increase" })

-- ─[ search behavior ]────────────────────────────────────────────────────
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
mapx(
  "n",
  "n",
  "'Nn'[v:searchforward].'zv'",
  { expr = true, desc = "Next search result" }
)
mapx(
  "x",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
mapx(
  "o",
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
mapx(
  "n",
  "N",
  "'nN'[v:searchforward].'zv'",
  { expr = true, desc = "Prev search result" }
)
mapx(
  "x",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)
mapx(
  "o",
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)

-- ─[ TextGen ]────────────────────────────────────────────────────────────
-- Some basic line breaks using comment characters.
-- There are more advanced text-generation and commented breakline methods
-- available using the figlet and comment-box plugins (in extras.lua)
mapx("n", key_cline.custom.comment.insert, function()
  edit_tools.InsertCommentBreak(tonumber(vim.opt.textwidth:get()), "╍", false)
end, { desc = "break:| comment |=> insert" })
mapx("n", key_cline.custom.comment.nospace, function()
  edit_tools.InsertCommentBreak(tonumber(vim.opt.textwidth:get()), "╍", true)
end, { desc = "break:| comment |=> insert (no-space)" })

mapx("n", key_cline.custom.dash.insert, function()
  edit_tools.InsertDashBreak(tonumber(vim.opt.textwidth:get()), "╍")
end, { desc = "break:| dash |=> insert" })

mapx("n", key_cline.custom.select.insert, function()
  edit_tools.SelectedCommentBreak(tonumber(vim.opt.textwidth:get()), false)
end, { desc = "break:| select |=> insert" })
mapx("n", key_cline.custom.select.nospace, function()
  edit_tools.SelectedCommentBreak(tonumber(vim.opt.textwidth:get()), true)
end, { desc = "break:| select |=> insert (no-space)" })

mapx("n", key_cline.custom.following.insert, function()
  edit_tools.SucceedingCommentBreak(true)
end, { desc = "break:| following |=> insert" })
mapx("n", key_cline.custom.following.nospace, function()
  edit_tools.SucceedingCommentBreak(false)
end, { desc = "break:| following |=> insert (no-space)" })

-- ─[ Fat Finger Helpers ]─────────────────────────────────────────────────
-- helpers for quitting when accidentally using Shift
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev q q")

-- ─[ UI bindings ]────────────────────────────────────────────────────────
-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
mapx(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "ui:| hl |=> clupdraw (clear, update, redraw)" }
)

--  under cursor inspection of highlights and extmarks.
mapx(
  "n",
  "<leader>ui",
  "<CMD>Inspect!<CR>",
  -- function()
  --   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  --   local res = vim.inspect_pos(0, row, col, {
  --     syntax = true,
  --     extmarks = true,
  --     treesitter = true,
  --     semantic_tokens = true,
  --   })
  --   require("funsak.lazy").info(res)
  -- end,
  { desc = "ui:| hl |=> inspect under cursor" }
)

mapx("n", kenv.ui.spelling, function()
  toggle("spell")
end, { desc = "ui:| spell |=> toggle" })
mapx("n", kenv.ui.wrap, function()
  toggle("wrap")
end, { desc = "ui:| wrap |=> toggle" })
mapx("n", kenv.ui.numbers.relative, function()
  toggle("relativenumber")
end, { desc = "ui:| number |=> toggle rellineno" })
mapx("n", kenv.ui.numbers.line, function()
  toggle.number()
end, { desc = "ui:| number |=> toggle lineno" })
mapx("n", kenv.ui.diagnostics.toggle, function()
  toggle.diagnostics()
end, { desc = "ui:| lsp |=> toggle diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
mapx("n", kenv.ui.conceal, function()
  toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "ui:| conceal |=> toggle" })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  mapx("n", kenv.ui.inlay_hints, function()
    toggle.inlay_hints()
  end, { desc = "ui:| lsp |=> toggle inlay-hints" })
end
mapx("n", kenv.ui.treesitter, function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
    require("funsak.lazy").warn("Treesitter highlighting disabled")
  else
    vim.treesitter.start()
    require("funsak.lazy").info("Treesitter highlighting enabled")
  end
end, { desc = "ui:| ts |=> toggle highlight" })

local scrollval = vim.o.scrolloff
mapx("n", kenv.ui.centerscroll, function()
  toggle("scrolloff", false, { 200 - scrollval, scrollval })
end, { desc = "ui.scroll:| vertical |=> toggle centered cursor" })

-- ─[ datetime insertion ]───────────────────────────────────────────────
mapx("n", "<localleader>dt", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local date = os.date("%Y-%m-%d")
  vim.api.nvim_buf_set_text(0, row, col, row, col, { date })
end, { desc = "insert date" })

-- ─[ modelines ]────────────────────────────────────────────────────────
mapx("n", "<localleader>mf", function()
  local ft = vim.bo.filetype
  local cs = vim.bo.commentstring
  vim.api.nvim_buf_set_lines(
    0,
    1,
    1,
    false,
    { cs:format(string.format("vim: set ft=%s:", ft)) }
  )
end, { remap = false })
mapx("n", "<localleader>mF", function()
  vim.ui.input(
    { prompt = "filetype: ", default = vim.bo.filetype, complete = "filetype" },
    function(sel)
      if sel == nil then
        return
      end
      local cs = vim.bo.commentstring
      vim.api.nvim_buf_set_lines(
        0,
        1,
        1,
        false,
        { cs:format(string.format("vim: set ft=%s:", sel)) }
      )
    end
  )
end)

vim.g.mc = "y/\\V<C-r>=escape(@\", '/')<CR><CR>"
-- ─[ `cn` remappings ]──────────────────────────────────────────────────
-- https://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
mapx("n", "cn", "*``cgn", { desc = "change next" })
mapx("n", "cN", "*``cgN", { desc = "change previous" })
mapx("v", "cn", "g:mc . '*``cgn'", { expr = true, desc = "change next" })
mapx("v", "cN", "g:mc . '*``cgN'", { expr = true, desc = "change previous" })

local function setup_cr()
  mapx(
    "n",
    "_",
    vim.cmd(
      [[nnoremap _ n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]]
    ),
    { buffer = true }
  )
end

mapx("n", "cq", function()
  setup_cr()
  vim.cmd([[*``qz]])
end, { remap = false, desc = "macro-change next" })
mapx("n", "cQ", function()
  setup_cr()
  vim.cmd([[#``qz]])
end, { remap = false, desc = "macro-change previous" })

-- cut, paste, copy, etc
-- send `x` results to void register
-- this avoids issues where previously copied stuff elsewhere on the system is
-- overwritten when using x to edit the location where the stuff should get
-- pasted.
mapx("n", "x", "\"_x", { desc = "`x` cut to void" })
mapx("v", "x", "\"_x", { desc = "`x` cut to void" })
mapx("n", "p", "p==", { desc = "`p` reindent" })
mapx("n", "P", "P==", { desc = "`P` reindent" })
mapx("n", "Y", "y$", { desc = "`$` yank -> EOL" })
