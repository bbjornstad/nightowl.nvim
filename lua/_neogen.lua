local mapk = require('uutils.key').mapk
local namer = require('uutils.key').wknamer
local wk = require('uutils.key').wkreg

require('neogen').setup({
    enabled = true,
    input_after_comment = true,
})

local opts = { noremap = true, silent = true }
wk({["<leader>d"] = {name = namer('neogen: Docstrings', 'auto-generation', true)}})
mapk("n", "<Leader>df", ":lua require('neogen').generate()<CR>", opts)
mapk("n", "<Leader>dc", ":lua require('neogen').generate({ type = 'class' })<CR>", opts)
mapk("n", "<Leader>dt", ":lua require('neogen').generate({ type = 'type' })<CR>", opts)
mapk("n", "<Leader>de", ":lua require('neogen').generate({ type = 'file' })<CR>", opts)

