--- creates a proxy object that is to be returned as the result of a module
--- importation, and serves to prevent the unnecessary loading of component
--- pieces. In other words, this is used to wrap modules that are imported with
--- a require statement somewhere else. Expected usage is `returner =
--- require('owl.funsak.modreturn')` followed by an execution of the returner
--- wrapping the target table in the return statement of a submodule definition.
---@class ModReturner
local ModReturner = {}

--- retrieves the modules specified by the argument if they are present in the
--- proxied table containing defined submodules.
---@param names string|string[]? name or list of names to retrieve from proxied
---table. If none provided, then function returns the entire proxied table.
---@return {string: table}
function ModReturner:get_mods(names)
  if not names then
    return self
  end
  names = type(names) == "table" and names or { names }
  return vim.tbl_map(function(n)
    return rawget(self, n)
  end, names)
end

--- either checks for the existence of the specified modules in the proxied
--- table as a boolean function, or when no argument is provided, retrieves the
--- entire set of module names which are the index-keys of the proxied table.
---@param names string|string[]? name or list of names to check for the
---existence of; if none are provided, then function returns the set of proxied
---table keys.
---@return boolean|string[] result the boolean condition indicating if the given
---keys are all found, or the set of all keys contained.
function ModReturner:contains(names)
  if names then
    local requested_n = #names
    local present_n = #self:get_mods(names)
    return requested_n == present_n
  end
  return vim.tbl_keys(self:get_mods())
end

function ModReturner:has_validation(opts)
  -- TODO: Implementation of this function
end

function ModReturner:set_validation(opts)
  -- TODO: Implementation of this function
end

--- creates a new ModReturner object, proxying the table to be returned during
--- module importation, such that indexing the ModReturner will give back the
--- appropritate proxied field. Also allows for the imported module to be used
--- as a function with module name arguments for the same importation purposes
--- by overloading the __call metamethod.
---@param rt_modules table the module that is to be wrapped, will use a default
---empty table {} if none given, but note that this will require assignment of
---module items after object instantiation.
---@param opts table options to be passed to the returner, which can alter some
---behavior like output validation.
---@return ModReturner masked the instantiated object now proxying the target module.
function ModReturner:new(rt_modules, opts)
  opts = opts or {}
  rt_modules = rt_modules or {}
  self.__metatable = "-null- Module Fetch Access Protected"

  self.__index = self
  rt_modules = setmetatable(rt_modules, self)
  if opts.validation then
    rt_modules:set_validation(opts.validation)
  end
  return rt_modules
end

--- overloads the call mechanism for the wrapped table such that calling the
--- function with arguments coming from the set of the keys of the wrapped table
--- gets the corresponding inner components and returns them, or the whole
--- table.
---@vararg any number of module subcomponents that are to be retrieved; these
---items are the keys of the underlying table.
---@return table|any[] results the results of the call application, e.g. the
---requested components as if this table were accessed normally.
function ModReturner:__call(...)
  local requested = { ... }
  return vim.tbl_map(function(module)
    return self:get_mods(module)
  end, requested)
end

function ModReturner:register_modules(name, mod)
  mod = type(mod) ~= "table" and { mod } or mod
  local modules = self:get_mods()
  vim.tbl_map(function(module)
    rawset(modules, name, module)
  end, mod)
end

--- creates a new ModReturner object, proxying the table to be returned during
--- module importation, such that indexing the ModReturner will give back the
--- appropritate proxied field. Also allows for the imported module to be used
--- as a function with module name arguments for the same importation purposes
--- by overloading the __call metamethod.
---@param rt_modules table the module that is to be wrapped, will use a default
---empty table {} if none given, but note that this will require assignment of
---module items after object instantiation.
---@param opts table options to be passed to the returner, which can alter some
---behavior like output validation.
local function returner(rt_modules, opts)
  local rt = ModReturner:new(rt_modules, opts)
  return rt
end

--- this simple function sets the metatable for the module which is to be
--- returned to a form wherein dynamically loaded submodules can lazily defer
--- their requisition. Note that this really will only work with tables and not
--- anything like a class or something that has to adjust its own metatable.
local function requisition(mod, inject)
  local mopts = require("funsak.table").mopts
  inject = inject or {}
  return setmetatable(
    mod,
    mopts({
      __index = function(t, k)
        t[k] = require(mod .. "." .. k)
        return t[k]
      end,
    }, inject)
  )
end

local function masquerade(mod, opts) end

return {
  requisition = requisition,
  masquerade = masquerade,
}
