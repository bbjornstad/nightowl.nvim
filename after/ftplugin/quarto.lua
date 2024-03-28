local omapx = require("funsak.keys.group").omapx
local function omapn(lhs, rhs, opts)
  return omapx("n", lhs, rhs, opts)
end

local comps = require("environment.status.component")

local M = {}

omapn("gd", function()
  require("otter").ask_definition()
end, { class = "repl", family = "otter", label = "definition" })
omapn("gK", function()
  require("otter").ask_hover()
end, { class = "repl", family = "otter", label = "hover", silent = true })

return M
