-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  callback = function()
    vim.lsp.set_log_level("error")
  end,
})

-- Shamelessly stealing this from "mateuszwieloch/automkdir.nvim" since this is
-- the entire content of the plugin.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("augroupAutomkdir", { clear = true }),
  callback = function(t)
    -- Function gets a table that contains match key, which maps to `<amatch>` (a full filepath).
    local dirname = vim.fs.dirname(t.match)
    -- Attempt to mkdir. If dir already exists, it returns nil.
    -- Use 755 permissions, which means rwxr.xr.x
    vim.uv.fs_mkdir(dirname, tonumber("0755", 8))
  end,
})
