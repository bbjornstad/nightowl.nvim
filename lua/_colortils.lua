local color_utils = require('uutils.colors').color_utilities
local mapk = require('uutils.key').mapk
local wk = require('uutils.key').wkreg
local namer = require('uutils.key').wknamer

wk({["<leader>c"] = { name = namer("Color utilities", "", true) }})
mapk("n", "<leader>C", "<CMD>Colortils picker #FFFFFF<CR>", { desc = "Color picker" })
mapk("n", "<leader>cp", "<CMD>Colortils picker<CR>", { desc = "Color picker" })
mapk("n", "<leader>cl", "<CMD>Colortils lighten<CR>", { desc = "Lighten Color" })
mapk("n", "<leader>cd", "<CMD>Colortils darken<CR>", { desc = "Darken Color" })
mapk("n", "<leader>cs", "<CMD>Colortils css list<CR>", { desc = "list css colors" })

return color_utils

