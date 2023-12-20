---@module "funsak.string" functional utilities for string manipulation,
---transformation, or generation.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.string
local M = {}

function M.split(input, sep)
  sep = sep or "%s"
  local t = {}
  for field, s in string.gmatch(input, "([^" .. sep .. "]*)(" .. sep .. "?)") do
    table.insert(t, field)
    if s == "" then
      return
    end
  end
end

return M
