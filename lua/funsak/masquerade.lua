---@module "funsak.masquerade" tools for improving the general usability of of custom
---modules written for lazy.nvim specifications and configurations.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.masquerade
local M = {}

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
---@return table<string, table>
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

--- requires a module in protected fashion; the `name` argument is passed to a
--- call to `require` by way of `pcall`, and this function will return either
--- the result if the requirement is successful, and the status code otherwise.
---@param name string name of the module to require
---@return table | boolean mod the required module or the boolean status code.
function M.preq(name)
  local ok, req = pcall(require, name)
  return ok and req or ok
end

--- adjusts the metatable of a given table which is supposed to be imported as a
--- submodule, such that the requirement is delayed and unused
--- definitions/declarations from files other than what is imported are not
--- honored unless explicitly asked.
---@param mod table module to wrap in masqued behavior.
---@param root T_Path? location of the modules in configurable components
---@param opts T_Opts? additional options that should be passed, and I believe
---that I may have your motivation somewhere in the car instead.
function M.masque(mod, root, opts)
  opts = opts or {}
  root = root and root .. "." or ""
  return setmetatable(mod, {
    __index = function(t, k)
      t[k] = require(root .. "." .. k)
      return t[k]
    end,
  })
end

--- a functional wrapper around the masque function, this defines how the
--- deferred importation mechanism should work in context. Generally speaking,
--- this is the main user-facing interface for configuration of the masquerade
--- behavior.
---@param root T_Path root folder of the modules that should be treated
---@param opts T_Opts
---@return fun(mod: any, opts: T_Opts): any |
function M.requisition(root, opts)
  return function(mod, o)
    opts = require("funsak.table").mopts(opts, o)
    return M.masque(mod, root, opts)
  end
end

return M
