local mopts = require('funsak.table').mopts

---@class BindingKey a wrapper object that holds a few convenience operations on
---keybindings. The BindingKey is centrally identified by its core bound key
---component. For instance, in the case of accessing the Mason menu with
---<leader>cm, note that <leader>c is the leading prefix and `m` is the final
---core binding described. Semantically this serves to define the purpose of the
---leader prefix or any other additional key formatting in relation to the
---"module purpose"
---@field bound
---@field formatters
---@field description
---@field modifier_opts
local BindingKey = {}

function BindingKey:new(km, opts)
  opts = opts or {}
  if type(km) == "table" then
    if vim.tbl_islist(km) then
      local first_idx, first = next(km)
      local rest = unpack(km, first_idx)
      opts = mopts(rest, opts)
      km = first
    else
      -- TODO: Parse out the else option for when the table passed has key names
    end
  end

  self.bound = km
  self.formatters = opts.formatters or {}
  self.description = opts.description or false
  self.modifier_opts = opts.modifier_opts or {}

  self.__index = self
  return setmetatable({}, self)
end

function BindingKey:component_parse(with, modifiers, opts)
  opts = opts or {}
  modifiers = modifiers or {}
  with = with or (opts.suppress_error and "" or false)
  local format = opts.format or false
  format = format and self.formatters[format] or format

  return format, with, modifiers, opts
end

function BindingKey:apply_modifiers(opts)
  local modifiers = opts.modifiers
  local target = opts.target
end

function BindingKey:prefix(with, modifiers, opts)
  local fmt
  fmt, with, modifiers, opts = self:component_parse(with, modifiers, opts)
  local bound = fmt and fmt(self.bound) or self.bound
  return string.format("%s%s", with, bound)
end

function BindingKey:postfix(with, modifiers, opts)
  local fmt
  fmt, with, modifiers, opts = self:component_parse(with, modifiers, opts)
  local bound = fmt and fmt(self.bound) or self.bound
  return string.format("%s%s", bound, with)
end

function BindingKey:inset(with, modifiers, opts)
  local fmt
  fmt, with, modifiers, opts = self:component_parse(with, modifiers, opts)
  local bound = fmt and fmt(self.bound) or self.bound
  local mod_opts = opts.modifier_opts or {}
end

return BindingKey
