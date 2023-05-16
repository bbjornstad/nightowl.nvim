-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ---------------------------------------------------------------------------------------------------------------
local mapx = vim.keymap.set
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end
-------------------------------------------------------------------------------
-- Rebinding of the <F1> key to stop opening help windows on my fat-fingered
-- mistakes that I seem to make while coding.
-----
-- vim.cmd([[unmap ;]])

mapx("n", "<F1>", "<Esc>", { desc = "esc >> to normal mode", remap = false })

mapx("v", "<F1>", "<Esc>", { desc = "esc >> to normal mode", remap = false })

mapx("o", "<F1>", "<Esc>", { desc = "esc >> to normal mode", remap = false })
mapx("i", "<F1>", "<Esc>", { desc = "esc >> to normal mode", remap = false })

mapx("n", "g?", "<CMD>help<CR>", { desc = "got >> get help", remap = false })
mapx("v", "g?", "<CMD>help<CR>", { desc = "got >> get help", remap = false })
mapx("o", "g?", "<CMD>help<CR>", { desc = "got >> get help", remap = false })
