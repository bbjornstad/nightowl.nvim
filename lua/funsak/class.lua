---@module "funsak.class" extensible definition of a standard-style class for
---holding data and methods. This is a commonly found implementation originally
---from the GitHub user `rsi` and which is also featured in plenary. We could
---use plenary directly, but that would mean introducing that as a hard
---dependency.
---@author Bailey Bjornstad | ursa-major [Via https://github.com/rxi/classic]
---@license MIT

---@class funsak.class
local Object = {}
Object.__index = Object

--- IMPLEMENTATION REQUIRED: a constructor for a new instance of an object based
--- on the class template that is extending this Object.
---@vararg any[]? arguments to the constructor
function Object:new(...) end

--- extends this object definition to create a new class for a custom family
--- of object instances
---@return funsak.class extension extends the class.
function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

--- attaches the target implementations of methods to the class
---@vararg any[]?
function Object:implement(...)
  for _, cls in pairs({ ... }) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end

--- checks to see if an object is equivalent to another object.
---@param T any another object
---@return boolean cond true if the object is equal to `T`, false otherwise.
function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end

--- IMPLEMENTATION REQUIRED: converts the given object into a string
--- representation as a metamethod.
---@return string rep the representation of the object as a string.
function Object:__tostring()
  return "Object"
end

--- treats the class definition like it might in Python, where the call to `new`
--- can be tucked away and instantiation can occur when calling the class
--- directly.
---@vararg any[]?
---@return funsak.class result the new instance.
function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end

return Object
