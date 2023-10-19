local mopts = require("funsak.table").mopts

--- The core KeyModule object. Represents a collection of semantically or
--- otherwise related keybindings, and is generally produced using a
--- KeyModuleFactory for additional "builder-style" configuration of the precise
--- behavior of the KeyModule or its descriptive ui elements.
---@class KeyModule
local KeyModule = {}

function KeyModule.new(cls, maps, gen, opts)
  opts = opts or {}
  maps = maps or {}

  cls.options = {}
  cls.__parent__ = gen.__gen_parent__ or false
  cls.__special__ = gen.__gen_special__ or {}
  cls.__adapters__ = gen.__gen_adapter or {}
  cls.__callbacks__ = gen.__gen_callback__ or {}
end

--- a KeyModuleFactory, containing aliases for specifications paired with
--- templating rules for commonly-behaved keybindings, and tools to help with
--- lazy.nvim keybind specifications, and (eventually) which-key improvements.
---@class KeyModuleFactory
---@field __gen_special__ table
---@field __gen_adapter__ table
---@field __gen_callback__ table
---@field __target_opts__ table
---@field __generator__ table
local KeyModuleFactory = {}
KeyModuleFactory.DEFAULT_MODULE_OPTS = {
  inherit = {},
  merge = {},
  description = {},
}

function KeyModuleFactory.new(cls, maps, opts)
  -- generally, we want to minimize the amount of things that are not exposed
  -- via a method chain construction in this constructor. The former is more
  -- dynamic, and the whole purpose of separation of this from the actual
  -- keymodule is distinction of user concerns during keymap setup versus the
  -- actual input strokes that are used and how those are interpreted by the
  -- machine. In fact, it actually makes no sense whatsoever to even check
  -- anything during instantiation because of the fact that the builder style
  -- pattern basically works on an orthogonal basis from the classical style. In
  -- other words, because we are concerned about inheritance between KeyModules
  -- and not KeyModuleFactories, but we interact with the former via the
  -- latter--in particular through method chains.
  cls.__target_opts__ = mopts(cls.DEFAULT_MODULE_OPTS, opts or {})
  cls.__gen_special__ = {}
  cls.__gen_adapter__ = {}
  cls.__gen_callback__ = {}

  cls.__generator__ = {}
  cls.__index = cls
  return setmetatable(maps, cls)
end

function KeyModuleFactory:wrap(maps, opts)
  maps = require("funsak.table").mopts(self, maps)
  opts = opts or {}

  return require("funsak.wrap").reduce(function(agg, new)
    return new(agg)
  end, self.__generator__, maps)
end

--- retrieves the options set for the given component; the options set is
--- defined here as the result of merging the extra options passed as a function
--- argument with any previously stored options under the umbrella belonging to
--- the passed component. If no component is provided, this simply gets all
--- options.
function KeyModuleFactory:options(component, extra)
  component = component or {}
  component = type(component) == "table" and component or { component }
  extra = extra or {}
  return unpack(vim.tbl_map(function(comp)
    return mopts(self.__target_opts__[comp], extra)
  end, component))
end

function KeyModuleFactory:with_adapters(adapters, opts)
  adapters = vim.iter(adapters or {})
  opts = opts or {}
  adapters = adapters:map(function(ad)
    return self:__adapter_handler(ad, opts)
  end)

  adapters:map(function(ad)
    table.insert(self.__generator__, ad)
  end)
  return self
end

function KeyModuleFactory:__adapter_handler(adapter, opts)
  -- TODO: Implementation
end

function KeyModuleFactory:with_specials(specials, opts)
  -- TODO: Implementation
  specials = vim.iter(specials or {})
  opts = opts or {}
  specials:map(function(s)
    return self:__special_handler(s, opts)
  end)

  specials:map(function(s)
    table.insert(self.__generator__, s)
  end)
  return self
end

function KeyModuleFactory:__special_handler(special, opts)
  -- TODO: Implementation
end

function KeyModuleFactory:leader(opts)
  opts = opts or {}
  opts.target = "leader"
  return self:special(opts)
end

function KeyModuleFactory:accept(opts)
  opts = opts or {}
  opts.target = "accept"
  return self:special(opts)
end

function KeyModuleFactory:cancel(opts)
  opts = opts or {}
  opts.target = "cancel"
  return self:special(opts)
end

return KeyModuleFactory
