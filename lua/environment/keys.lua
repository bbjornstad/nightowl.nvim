local mod = {}

mod.mapn = require("plenary.functional").partial(vim.keymap.set, "n")

mod.stems = {}

mod.stems.ccc = "<leader>uh"
mod.stems.pomodoro = "<leader>o"
mod.stems.easyread = "<leader>r"
mod.stems.figlet = "<localleader>i"
mod.stems.neural = ";n"
mod.stems.copilot = ";c"
mod.stems.neoai = ";a"
mod.stems.hfcc = ";h"
mod.stems.telescope = "<leader>i"
mod.stems.glow = "<leader>p"
mod.stems.notify = "<leader>n"
mod.stems.vista = "<leader>v"
mod.stems.chatgpt = ";g"
mod.stems.neogen = "<leader>D"
mod.stems.lens = "<leader>ue"

return mod
