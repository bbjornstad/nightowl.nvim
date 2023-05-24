local mod = {}

local aistem = ";"

mod.mapn = require("plenary.functional").partial(vim.keymap.set, "n")
mod.mapv = require("plenary.functional").partial(vim.keymap.set, "v")
mod.mapo = require("plenary.functional").partial(vim.keymap.set, "o")
mod.mapi = require("plenary.functional").partial(vim.keymap.set, "i")
mod.mapnv = require("plenary.functional").partial(vim.keymap.set, { "n", "v" })

mod.mapd =
  require("plenary.functional").partial(vim.keymap.set, { "n", "v", "i", "o" })

mod.keymap_style = "bind_api_init" -- or "bind_lazy"

function mod.primer(keymap)
  -- do somethign but mostly ensure correct formatting for input to register
  local wk = require("which-key").register
  local function wrap() end
  return wrap
end

function mod.prime_wk(plugspec)
  if not plugspec.stems then
    -- ideally we do something here
    plugspec.stems = {}
  end
  local inferred_keys = mod.infer_keystems(plugspec)
  return {
    "folke/which-key.nvim",
    opts = {
      unpack(mod.infer_keystems(inferred_keys)),
    },
  }
end

mod.stems = {}

mod.stems.ccc = "<leader>uh"
mod.stems.pomodoro = "<leader>t"
mod.stems.easyread = "<leader>ub"
mod.stems.neural = aistem .. "n"
mod.stems.copilot = aistem .. "g"
mod.stems.neoai = aistem .. "a"
mod.stems.hfcc = aistem .. "h"
mod.stems.chatgpt = aistem .. "c"
mod.stems.codegpt = aistem .. "C"
mod.stems.telescope = "<leader>i"
mod.stems.glow = "<leader>P"
mod.stems.notify = "<leader>n"
mod.stems.vista = "<leader>v"
mod.stems.neogen = "<leader>D"
mod.stems.lens = "<leader>ue"
mod.stems.iron = "<leader>r"
-- cannot use o key for oil, since orgmode has the binding
mod.stems.oil = "<leader>l"

mod.stems.figlet = "<localleader>i"
mod.stems.textgen = "<localleader>t"
mod.stems.cbox = "<localleader>b"
mod.stems.cline = "<localleader>l"

return mod
