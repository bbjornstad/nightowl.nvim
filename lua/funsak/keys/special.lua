---@class SpecialModifierSpec
---@field affix boolean|string
---@field prefix boolean|string
---@field postfix boolean|string
---@field const_bind string?
---@field alternate {[string]: string}?
---@field description string?

---@alias SpecialModifierRegistry {[string]: SpecialModifierSpec}
---internally used mapping controling the formatting behavior around adjusting
---and binding within a family of keys which constitute a group/component.
local SpecialModifierRegistry = {
  leader = { prefix = true },
  accept = { ModifierKey.ctrl },
  cancel = { ModifierKey.ctrl, const_bind = "e" },
  close = { ModifierKey.ctrl, const_bind = "q" },
  preview = { ModifierKey.ctrl, const_bind = "p" },
}

--- parses an entry, selected by name, from the internal registry of special
--- eys and their associated modifier formatting specifications, into its
--- consitutent set of modifiers, representing the actual additional held-keys,
--- and opts, representing dynamic configuration parameters that can be added for specific special bindings.
---@param entry SpecialModifierSpec a single entry or pseudo-entry of a special
---key formatting adjustment that is to be parsed into the modifiers and format
---options.
---@return T_List modifiers, T_Opts opts a list-like table of modifiers and
---another table containing corresponding options.
function SpecialModifierRegistry:parse(entry)
  local modifiers = {}
  local opts = {}

  -- TODO: rewrite the below loop in terms of a map over an iterable instead of
  -- as a loop. Namely, we need to pull out the inner logic into a function
  -- which can be wrapped appropriately.
  for k, v in pairs(entry) do
    local convertible, _ = pcall(tonumber, k)
    if convertible then
      table.insert(modifiers, v)
    else
      opts[k] = v
    end
  end
  return modifiers, opts
end

--- parses an entry into its registered modifier and additional options parts,
--- and then uses the results of this computation in order to compute a suitable
--- function that can be used to do the actual formatting as an operation on a
--- target
---@param special SpecialModifierSpec
function SpecialModifierRegistry:specializer(special)
  local reduce = require("funsak.wrap").reduce
  -- modifiers are stored in a separate table, which is shared across all
  -- resources within an application instance. In particular, there are a set
  -- amount of these modifier keys available within neovim, and they all
  -- generally have a rigid format. Thus an opinionated position is taken where
  -- the modifier format specification is less configurable to an end user.
  local modifiers, opts = self:parse(special)
  -- the modifier selections have been retrieved from the shared modifier-format
  -- registry, so we want to parse those results into a collection of formatter
  -- function references which can be used to actually do the formatting
  -- specified for each modifier.
  local f_modifiers = vim.tbl_map(function(m)
    return ModifierKey.formatter(m, opts)
  end, modifiers)

  return reduce(function(agg, new)
    -- agg and new are both functions, therefore if we want to do anything
    -- meaningful with either of them in this context, our reduction operation
    -- must be the functional composition of the two (with agg wrapped by new)
    -- there is a somewhat up in the air question about the manner of the
    -- arguments to each function becoming conflated with each other due to the
    -- way that this is implemented
    return function(...)
      return new(agg(...))
    end
  end, f_modifiers)
end
