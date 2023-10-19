local leader_core = "<leader>"

local leader_definitions = {
  __leader__ = leader_core,
  buffer = "q",
  window = leader_core .. "w",
  motion = "g",
  lazy = leader_core .. "L",
  completion = false,
  build = "`",
  time = "<localleader>",
  ai = ";",
  fm = leader_core .. "f",
  repl = "`",
  fuzzy = leader_core .. leader_core,
  scope = "Z",
  lsp = leader_core .. "l",
  code = leader_core .. "c",
  term = leader_core .. "m",
  versioning = leader_core,
  mail = leader_core .. "M",
  tool = leader_core,
  search = leader_core .. "s",
  editor = "\\",
  ui = leader_core .. "u",
  debug = leader_core .. "d",
  competitive = false,
}

return leader_definitions
