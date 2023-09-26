-- -----------------------------------------------------------------------------
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -----------------------------------------------------------------------------
local edit_tools = require("uutils.text")
local key_cline = require("environment.keys").stems.cline
local key_precede = require("environment.keys").stems.precede
local mapx = vim.keymap.set

--- appends or removes a given character from the internal formatoptions vim
--- option, which controls document formatting behavior; most often used in
--- toggling autoformatting on insert behavior.
---@param char string   the string value to toggle.
local function toggle_fmtopt(char)
  local currentopts = vim.opt.formatoptions:get()
  if currentopts[char] then
    vim.opt.formatoptions:remove(char)
  else
    vim.opt.formatoptions:append(char)
  end
end

local function helpmapper()
  local thishelp = ("help %s"):format(vim.fn.expand("<cword>"))
  vim.cmd(thishelp)
end
-------------------------------------------------------------------------------
-- Rebind the help menu to be attached to "gh"
mapx(
  "n",
  "gh",
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

---------------------------------------------------------------------------------
-- Toggles autoformatting on insert by appending the appropriate character to
-- the toggle_fmtopt function defined above.
mapx("n", "<leader>uF", function()
  toggle_fmtopt("a")
end, { desc = "ui=> toggle insert autoformat" })

---------------------------------------------------------------------------------
-- Some basic line breaks using comment characters.
-- There are more advanced text-generation and commented breakline methods
-- available using the figlet and comment-box plugins (in extras.lua)
mapx("n", key_cline .. "b", function()
  edit_tools.InsertCommentBreak(tonumber(vim.o.textwidth), "-", false)
end, { desc = "brk=> insert comment break" })
mapx("n", key_cline .. "B", function()
  edit_tools.InsertCommentBreak(tonumber(vim.o.textwidth), "-", true)
end, { desc = "brk=> insert comment break" })

mapx("n", key_cline .. "d", function()
  edit_tools.InsertDashBreak(tonumber(vim.o.textwidth), "-")
end, { desc = "brk=> insert dash break" })

mapx("n", key_cline .. "s", function()
  edit_tools.SelectedCommentBreak(tonumber(vim.o.textwidth), false)
end, { desc = "brk=> select dash break" })
mapx("n", key_cline .. "S", function()
  edit_tools.SelectedCommentBreak(tonumber(vim.o.textwidth), true)
end, { desc = "brk=> select dash break" })

mapx("n", key_precede .. "c", function()
  edit_tools.SucceedingCommentBreak(true)
end, { desc = "brk=> succeeding dash break" })
mapx("n", key_precede .. "C", function()
  edit_tools.SucceedingCommentBreak(false)
end, { desc = "brk=> succeeding dash break" })

-- -----------------------------------------------------------------------------
-- this simply binds a key to be able to turn off any temporary highlighting
-- that might be applied to the buffer due to things like search or flash.nvim
mapx(
  "n",
  "<C-c>",
  "<CMD>nohlsearch<CR>",
  { desc = "hilite=> remove temporary highlighting" }
)

-- -----------------------------------------------------------------------------
-- this section contains relevant keybindings that can close or open windows.
-- these are bound by default to keys beginning with the prefix `q`, which can
-- cause some behavioral quirks related to recording macros. Hence, we rebind
-- the macro record input to be <leader>q
mapx(
  "n",
  "<leader>Q",
  "q",
  { desc = "macro=> record macro into register", remap = false }
)
vim.keymap.del("n", "q")
-- mapx("n", "q", "<nop>", { remap = false })
mapx("n", "qq", "<CMD>quit<CR>", { desc = "quit=> terminate window" })
mapx("n", "q!", "<CMD>quit!<CR>", { desc = "quit=> [!] terminate window" })
mapx("n", "QQ", "<CMD>quitall<CR>", { desc = "quit=> terminate all windows" })
mapx(
  "n",
  "Q!",
  "<CMD>quitall!<CR>",
  { desc = "quit=> [!] terminate all windows" }
)
mapx("n", "qn", function()
  vim.ui.input({ prompt = "enter filename:" }, function(input)
    vim.cmd(("edit ./%s"):format(input))
  end)
end, { desc = "buf=> new buffer" })
mapx("n", "qw", "<CMD>write<CR>", { desc = "buf=> save current buffer" })
mapx("n", "qW", "<CMD>writeall<CR>", { desc = "buf=> save all buffers" })
mapx("n", "qo", "<CMD>bwipeout<CR>", { desc = "buf=> wipeout this buffer" })
mapx(
  "n",
  "qO",
  "<CMD>bwipeout!<CR>",
  { desc = "buf=> [!] wipeout this buffer" }
)
vim.keymap.del("n", "<leader>bb")

-- vim.keymap.del("n", require("environment.keys").stems.base.repl)
local jk_status = require("lazyvim.util").has("accelerated-jk.nvim")

if jk_status then
  vim.notify(vim.inspect(jk_status))
  vim.keymap.del({ "n", "v" }, "j")
  vim.keymap.del({ "n", "v" }, "k")
  mapx({ "n", "v" }, "j", "<Plug>(accelerated_jk_j)", { desc = "move=> down" })
  mapx({ "n", "v" }, "k", "<Plug>(accelerated_jk_k)", { desc = "move=> up" })
end
vim.keymap.del({ "n", "v", "i" }, "<A-j>")
vim.keymap.del({ "n", "v", "i" }, "<A-k>")
mapx({ "n", "v", "i" }, "<A-l>", "<Right>", { desc = "move => right" })
mapx({ "n", "v", "i" }, "<A-h>", "<Left>", { desc = "move => left" })
mapx({ "n", "v", "i" }, "<A-k>", "<Up>", { desc = "move => up" })
mapx({ "n", "v" }, "<A-j>", "<Down>", { desc = "move => down" })
mapx({ "n", "v", }, "<C-H>", "<CMD>bprevious<CR>", { desc = "buf=> previous" })
mapx({ "n", "v", }, "<C-L>", "<CMD>bnext<CR>", { desc = "buf=> next" })

mapx(
  { "n", "v", "i" },
  "<A-H>",
  "<CMD>bprevious<CR>",
  { desc = "buf=> previous" }
)
mapx({ "n", "v", "i" }, "<A-L>", "<CMD>bnext<CR>", { desc = "buf=> next" })

mapx({ "n" }, "<leader>uR", function()
  local scrollval = tonumber(vim.opt.scrolloff:get())
  vim.opt.scrolloff = 999 - scrollval
end, { desc = "win=> sticky center cursor" })
