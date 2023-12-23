---@module "uutils.window" helpers and utilities for window management
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class uutils.window
local M = {}

local function focus_direction_mapper(dir_indicated)
  local has = require("funsak.table").contains
  if has({ "j", "<Down>" }, dir_indicated) then
    return "j"
  elseif has({ "k", "<Up>" }, dir_indicated) then
    return "k"
  elseif has({ "h", "<Left>" }, dir_indicated) then
    return "h"
  elseif has({ "l", "<Right>" }, dir_indicated) then
    return "l"
  end
end

function M.focus_split_helper()
  local dir_indicated = vim.v.char
  dir_indicated = focus_direction_mapper(dir_indicated)
  return function()
    require("focus").split_command(dir_indicated)
  end
end

return M
