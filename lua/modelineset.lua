vim.opt.modeline = true
vim.opt.modelines = 10
vim.opt.modelineexpr = true

local mapk = require("uutils.key").mapk
local wk = require("uutils.key").wkreg
local namer = require("uutils.key").wknamer

local mname = "modelines"
local stem = "toggle or control"
wk({[";m"] = namer(mname, stem, true)})
mapk("n", ";mt", function() vim.opt.modeline = not vim.opt.modeline:get() end,
     {desc = "Toggle Modelines"})
mapk("n", ";mn", function() vim.opt.modelines = (vim.opt.modelines:get() - 1) end,
     {desc = "Decrease N Modelines"})
mapk("n", ";mN", function() vim.opt.modelines = (vim.opt.modelines:get() + 1) end,
     {desc = "Increase N Modelines"})
