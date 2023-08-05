local mod = {}

local aistem = ";"

function mod.map(modes)
  local function returnable(lhs, rhs, opts)
    vim.keymap.set(modes, lhs, rhs, opts)
  end

  return returnable
end

mod.stems = {}
mod.stems.ccc = "<leader>uh"
mod.stems.toggleterm = "<leader>t"
mod.stems.easyread = "<leader>uB"
mod.stems.rest = "<leader>R"
mod.stems.lsp = "<leader>c"
mod.stems.lazy = "<leader>L"
mod.stems.cmp = "<C-o>"

mod.stems.taskorg = "<bar>"
mod.stems.pomodoro = mod.stems.taskorg .. "p"
mod.stems.overseer = mod.stems.taskorg .. "v"
mod.stems.unfog = mod.stems.taskorg .. "u"
mod.stems._do = mod.stems.taskorg .. "d"

--------------------------------------------------------------------------------
mod.stems.BASEAI = aistem
mod.stems.neural = aistem .. "n"
mod.stems.copilot = aistem .. "g"
mod.stems.codeium = aistem .. "d"
mod.stems.neoai = aistem .. "e"
mod.stems.cmp_ai = aistem .. "a"
mod.stems.hfcc = aistem .. "h"
mod.stems.chatgpt = aistem .. "c"
mod.stems.codegpt = aistem .. "o"
mod.stems.rgpt = aistem .. "r"
mod.stems.navi = aistem .. "v"
mod.stems.explain_it = aistem .. "x"
mod.stems.tabnine = aistem .. "9"

mod.stems.repl = "`"
mod.stems.sniprun = mod.stems.repl .. "s"
mod.stems.iron = mod.stems.repl .. "r"
mod.stems.vlime = mod.stems.repl .. "v"
mod.stems.acid = mod.stems.repl .. "a"
mod.stems.conjure = mod.stems.repl .. "c"
mod.stems.jupyter = mod.stems.repl .. "j"

mod.stems.telescope = "<leader><leader>"
mod.stems.glow = "<leader>P"
mod.stems.notify = "<leader>n"
mod.stems.vista = "<leader>v"
mod.stems.neogen = "<leader>D"
mod.stems.lens = "<leader>uo"
mod.stems.iron = "<leader>r"
mod.stems.oil = "<leader>f"
mod.stems.git = "<leader>g"
mod.stems.block = "<leader>ub"
mod.stems.tterm = "<leader>T"
mod.stems.navbuddy = "<leader>v"
mod.stems.undotree = "<leader>U"
mod.stems.based = "<leader>B"

mod.stems.figlet = "<localleader>i"
mod.stems.figban = "<localleader>f"
mod.stems.textgen = "<localleader>t"
mod.stems.cbox = "<localleader>b"
mod.stems.cline = "<localleader>l"

mod.stems.modeline = "<localleader>m"

return mod
