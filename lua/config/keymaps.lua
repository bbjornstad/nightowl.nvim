-- -----------------------------------------------------------------------------
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -----------------------------------------------------------------------------
local edit_tools = require("uutils.edit")
local key_cline = require("environment.keys").stems.cline
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

-------------------------------------------------------------------------------
-- rebinding for the q-mode close mappings. using the q key so liberally for
-- macros makes no sense in my mind, so what we are doing instead is subsetting
-- off any keys we want specifically for buffer/window manipulation instead.
-- Any non-bound q-keys should still work as macros.
-----
-- mapx(
--   { "n", "v", "o" },
--   "qq",
--   "<CMD>quit<CR>",
--   { desc = "quit=> close this buffer", remap = false, nowait = true }
-- )
-- mapx(
--   { "n", "v", "o" },
--   "QQ",
--   "<CMD>quit!<CR>",
--   { desc = "quit=> close forcefully", remap = false, nowait = true }
-- )

--------------------------------------------------------------------------------
-- Rebindings for q-mode delete buffer mappings.
-- mapx(
--   { "n", "v", "o" },
--   "qd",
--   "<CMD>bdelete<CR>",
--   { desc = "quit=> close forcefully", remap = false, nowait = true }
-- )
-- mapx(
--   { "n", "v", "o" },
--   "qD",
--   "<CMD>bdelete!<CR>",
--   { desc = "quit=> close forcefully", remap = false, nowait = true }
-- )

--------------------------------------------------------------------------------
-- Rebind the help menu to be attached to "gh"
mapx(
  { "n", "v", "o" },
  "gh",
  ("<CMD>help %s<CR>"):format(vim.fn.expand("<cword>")),
  { desc = "got=> get help", remap = false, nowait = true }
)

---------------------------------------------------------------------------------
-- Basic Buffer Manipulation. Most of this is handled in interface via the
-- plugin nvim-smartbuffs.
mapx(
  { "n", "v" },
  "<leader>bw",
  "<CMD>write<CR>",
  { desc = "buf=> save buffer" }
)
mapx(
  { "n", "v" },
  "<leader>bW",
  "<CMD>writeall<CR>",
  { desc = "buf=> save buffer" }
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
  edit_tools.InsertCommentBreak(tonumber(vim.o.textwidth), "-")
end, { desc = "brk=> insert comment break" })

mapx("n", key_cline .. "d", function()
  edit_tools.InsertDashBreak(tonumber(vim.o.textwidth), "-")
end, { desc = "brk=> insert dash break" })

-- -----------------------------------------------------------------------------
-- this simply binds a key to be able to turn off any temporary highlighting
-- that might be applied to the buffer due to things like search or flash.nvim
mapx(
  "n",
  "<C-n>",
  "<CMD>nohlsearch<CR>",
  { desc = "hilite=> remove temporary highlighting" }
)
