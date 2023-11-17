---@module "funsak.linline" utilities and tools for working with statusline
---components.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.linline
local M

function M.get(section, barget)
  barget = barget == "status" and "sections" or barget
  return require("lualine").get_config()[barget][section]
end

function M.insert(section, barget, value, position)
  local it_line = M.get(section, barget)
  table.insert(it_line, value, position)
end

return M
