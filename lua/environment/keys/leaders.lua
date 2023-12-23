local leader_core = "<leader>"

local leader_definitions = {
  __leader__ = leader_core,
  buffer = "q",
  window = leader_core .. "w",
  motion = "g",
  lazy = leader_core .. "L",
  build = "`",
  time = "<localleader>",
  ai = ";",
  fm = leader_core .. "f",
  repl = "`",
  fuzz = leader_core .. leader_core,
  scope = leader_core .. "s",
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
  view = leader_core .. "v",
  action = leader_core .. "a",
  docs = leader_core .. "D",
  git = leader_core .. "g",
}

return leader_definitions
