-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ---------------------------------------------------------------------------------------------------------------
local mapx = vim.keymap.set

-------------------------------------------------------------------------------
-- Rebinding of the <F1> key to stop opening help windows on my fat-fingered
-- mistakes that I seem to make while coding.
-----
mapx("n", "<F1>", "<Esc>", { desc = "esc >> to normal mode" })

mapx("v", "<F1>", "<Esc>", { desc = "esc >> to normal mode" })

mapx("o", "<F1>", "<Esc>", { desc = "esc >> to normal mode" })
mapx("i", "<F1>", "<Esc>", { desc = "esc >> to normal mode" })

mapx("n", "g?", "<CMD>help<CR>", { desc = "got >> get help", remap = false })
mapx("v", "g?", "<CMD>help<CR>", { desc = "got >> get help", remap = false })
mapx("o", "g?", "<CMD>help<CR>", { desc = "got >> get help", remap = false })
