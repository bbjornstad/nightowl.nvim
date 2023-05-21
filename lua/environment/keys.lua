local mod = {}

local aistem = ";"

mod.mapn = require("plenary.functional").partial(vim.keymap.set, "n")
mod.mapv = require("plenary.functional").partial(vim.keymap.set, "v")
mod.mapo = require("plenary.functional").partial(vim.keymap.set, "o")
mod.mapi = require("plenary.functional").partial(vim.keymap.set, "i")
mod.mapnv = require("plenary.functional").partial(vim.keymap.set, {"n", "v"})

mod.stems = {}

mod.stems.ccc = "<leader>uh"
mod.stems.pomodoro = "<leader>o"
mod.stems.easyread = "<leader>ub"
mod.stems.neural = aistem .. "n"
mod.stems.copilot = aistem .. "g"
mod.stems.neoai = aistem .. "a"
mod.stems.hfcc = aistem .. "h"
mod.stems.chatgpt = aistem .. "c"
mod.stems.codegpt = aistem .. "C"
mod.stems.telescope = "<leader>i"
mod.stems.glow = "<leader>p"
mod.stems.notify = "<leader>n"
mod.stems.vista = "<leader>v"
mod.stems.neogen = "<leader>D"
mod.stems.lens = "<leader>ue"
mod.stems.iron = "<leader>r"

mod.stems.figlet = "<localleader>i"
mod.stems.textgen = "<localleader>t"
mod.stems.cbox = "<localleader>b"
mod.stems.cline = "<localleader>l"

return mod
