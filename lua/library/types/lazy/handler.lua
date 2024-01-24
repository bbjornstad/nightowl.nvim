---@module "library.types.lazy.handler" core lazy.nvim types for event handlers
---@author Folke Lemaitre -- adaptation by Bailey Bjornstad | ursa-major
---@license MIT

local M = {}
---@enum LazyHandlerTypes
M.types = {
  keys = "keys",
  event = "event",
  cmd = "cmd",
  ft = "ft",
}

---@class LazyHandler
---@field type LazyHandlerTypes
---@field extends? LazyHandler
---@field active table<string,table<string,string>>
---@field managed table<string,string>
---@field super LazyHandler

---@class LazyEventHandler:LazyHandler
---@field events table<string,true>
---@field group number

return M
