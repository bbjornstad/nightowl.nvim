vim.opt.modeline = true
vim.opt.modelines = 10
vim.opt.modelineexpr = true

local mapk = require("uutils.key").mapk
local wk = require("uutils.key").wkreg
local namer = require("uutils.key").wknamer

mname = "modelines"
stem = "toggle or control"
wk({[";m"] = namer(mname, stem, true)})
mapk("n", ";mt", function() vim.opt.modeline = not vim.opt.modeline end,
     {desc = "Toggle Modelines"})
mapk("n", ";mn", function() vim.opt.modelines = (vim.opt.modelines - 1) end,
     {desc = "Decrease N Modelines"})
mapk("n", ";mN", function() vim.opt.modelines = (vim.opt.modelines + 1) end,
     {desc = "Increase N Modelines"})
