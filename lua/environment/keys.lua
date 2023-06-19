local mod = {}

local aistem = ";"

function mod.map(modes)
  local function returnable(lhs, rhs, opts)
    vim.keymap.set(modes, lhs, rhs, opts)
  end

  return returnable
end

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
mod.stems.toggleterm = "<leader>t"
mod.stems.pomodoro = "<leader>T"
mod.stems.easyread = "<leader>ub"
mod.stems.neural = aistem .. "r"
mod.stems.copilot = aistem .. "g"
mod.stems.neoai = aistem .. "n"
mod.stems.cmp_ai = aistem .. "a"
mod.stems.hfcc = aistem .. "h"
mod.stems.chatgpt = aistem .. "c"
mod.stems.codegpt = aistem .. "o"
mod.stems.telescope = "<leader>i"
mod.stems.glow = "<leader>P"
mod.stems.notify = "<leader>n"
mod.stems.vista = "<leader>v"
mod.stems.neogen = "<leader>D"
mod.stems.lens = "<leader>ue"
mod.stems.iron = "<leader>r"
-- cannot use o key for oil, since orgmode has the binding
-- also not the l key because lazy has that one.
mod.stems.oil = "<leader>f"
mod.stems.git = "<leader>g"

mod.stems.figlet = "<localleader>i"
mod.stems.textgen = "<localleader>t"
mod.stems.cbox = "<localleader>b"
mod.stems.cline = "<localleader>l"

return mod
