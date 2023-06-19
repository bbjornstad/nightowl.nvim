-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ---------------------------------------------------------------------------------------------------------------
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
-- Rebinding of the <F1> key to stop opening help windows on my fat-fingered
-- mistakes that I seem to make while coding.
-----
mapx(
  { "n", "v", "o", "i" },
  "<F1>",
  "<Esc>",
  { desc = "esc=> to normal mode", remap = false }
)

--------------------------------------------------------------------------------
-- Rebind the help menu to be attached to "g?"
mapx(
  { "n", "v", "o" },
  "g?",
  "<CMD>help<CR>",
  { desc = "got=> get help", remap = false }
)

---------------------------------------------------------------------------------
-- Basic Buffer Manipulation. Most of this is handled in interface via the
-- plugin nvim-smartbuffs.
mapx(
  { "n", "v" },
  "<leader>bs",
  "<CMD>write<CR>",
  { desc = "buf=> save buffer" }
)
mapx(
  { "n", "v" },
  "<leader>bS",
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
