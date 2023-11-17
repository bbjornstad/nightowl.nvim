---@module "funsak.convert" utilities for value conversion and environment variable
---parsing.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.convert
local M = {}

---@generic T
--- gets the value of an environment variable and casts it to a specific type
--- using the given parameter
---@param varname string name of environment variable to fetch and convert
---@param caster? fun(varval: any, ...): T
---@return T env the converted value of the environment variable.
function M.from_env(varname, caster)
  caster = caster or function(...)
    return unpack({ ... })
  end

  local res = vim.env[varname]
  return caster(res)
end

--- gets the value of an environment variable and attempts to cast it to a
--- boolean value by passing the appropriate function as the caster in
--- `from_env`.
---@param varname string name of environment variable to fetch and convert.
---@return boolean val true if the given variable was exactly "true", false
---otherwise.
function M.bool_from_env(varname)
  return M.from_env(varname, function(val)
    if val == "true" then
      return true
    end
    return false
  end)
end

--- converts a value that is known only as a string into a boolean, but only
--- when the castable value is exactly "true" as a string.
---@param v any value to convert, if possible.
---@return boolean? conv the converted value; this is only nil if there was a
---failure in conversion where the item was neither "true", "false", or string
---representation of a number.
function M.toboolean(v)
  local ok, res = pcall(tonumber, v)
  if ok then
    return res > 0
  end
  if v == "false" or not v then
    return false
  elseif v == "true" then
    return true
  end
  return nil
end

return M
