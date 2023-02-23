local mapk = require("uutils.key").mapk
local wk = require("uutils.key").wkreg
local namer = require("uutils.key").wknamer

require("trouble").setup({
    position = "right",
    width = math.floor(0.35 * vim.opt.columns:get())
})

-- Lua
local mname = "trouble"
local stem = "Xtended diagnostics"
wk({["<localleader>x"] = {name = namer(mname, stem, true)}})
mapk("n", "<localleader>xx", "<cmd>TroubleToggle<cr>",
     {silent = true, noremap = true})
mapk("n", "<localleader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
     {silent = true, noremap = true})
mapk("n", "<localleader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
     {silent = true, noremap = true})
mapk("n", "<localleader>xl", "<cmd>TroubleToggle loclist<cr>",
     {silent = true, noremap = true})
mapk("n", "<localleader>xq", "<cmd>TroubleToggle quickfix<cr>",
     {silent = true, noremap = true})
mapk("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
     {silent = true, noremap = true})
mapk("n", "<localleader>x", "<CMD>TroubleToggle<CR>", { desc = "Toggle Trouble" })
