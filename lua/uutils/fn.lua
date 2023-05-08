local mod = {}

---
-- Generates a UUID from the series of passed arguments which really don't do
-- much at all.
-- @param ... :: Any number of arguments can be passed in, they are all ignored.
local random = math.random
function mod.uuid(...)
  math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 9)))
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
    return string.format("%x", v)
  end)
end

---
-- Requires a plugin or component followed immediately by the call to a setup()
-- with the given options.
-- @param id :: [ String|Func(opts) ] either a string name or a function which
-- computes a string name from the associated set of options.
function mod.requisition(id, opts, mod_before, mod_after)
  if mod_before ~= nil then
    require(mod_before)
  end

  local function determine(id)
    local new_id
    if id ~= nil then
      if type(id) == "string" then
        new_id = id
      else
        new_id = id(opts)
      end
    else
      error("cannot determine the plugin specification you are requisitioning")
    end
    return new_id
  end

  id = determine(id)

  local res = require(id).setup(opts)

  if mod_after ~= nil then
    require(mod_after)
  end

  return res
end

return mod
