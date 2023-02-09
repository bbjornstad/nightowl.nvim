require('neogen').setup({
    enabled = true,
    input_after_comment = true,
})

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>df", ":lua require('neogen').generate()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>dc", ":lua require('neogen').generate({ type = 'class' })<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>dt", ":lua require('neogen').generate({ type = 'type' })<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>de", ":lua require('neogen').generate({ type = 'file' })<CR>", opts)

