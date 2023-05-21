local mapn = require("environment.keys").mapn
local otter = require("otter")
mapn(
  "gd",
  otter.ask_definition,
  { desc = "otter:>> ask for item definition", silent = true }
)
mapn(
  "gK",
  otter.ask_hover,
  { desc = "otter:>> ask for item hover", silent = true }
)
otter.activate({ "r", "python", "lua", "julia", "rust" }, true)
