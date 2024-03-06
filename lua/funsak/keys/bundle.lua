---@module "funsak.keys.bundle" definition for a keybundle object, in other
---words, a collection of related key bindings with similar structure.
---@author Bailey Bjornstad | ursa-major
---@license MIT

-- TODO: I would like to be able to have the group not depend on a single
-- leader, which should just be a pretty simple recursive map on tables for
-- leader related function implementations.

-- TODO: This is maybe a bit of a reach item at the moment, but it might be kind
-- of nice to have a keygroup be capable of checking map consistency against a
-- set of allowed keys, e.g. with a specific set of keys being allowed in the
-- creation of the universe that lhs specifications in user config files would
-- represent

--- TODO: we have a decent amount left to accomplish, but the big thing is that
-- currently, the inheritence specification does not seem to be functioning
-- appropriately. Leading modifications are normally pretty easy to put
-- together, but a prominent issue is that if a leader is specified and the user
-- wants to bind a subgroup to a key that does not include the leader, it is not
-- possible.

-- NOTE: I think we might need to take a step back from this in order to
-- appropriately ascertain what the correct flow is from stage to stage of the
-- construction of a keybundle. Otherwise, this might start to grow out of scope
-- and handle cases that should be handled elsewhere.
-- From the user's perspective: they have a collection of keybindings that are
-- grouped roughly in the correct format they want to have for their keystroke
-- and mapped actions configuration. They will be desiring specifications for:
-- leader construction (prefix or postfix), capitalization, shortcut behavior,
-- inheritance, and the specification given as a separate lua file for target
-- components of the system.
-- This implies the following:

--- a collection of semantically grouped keybindings with configurable behavior
--- of keybinding modifications to make it a bit easier to remember a particular
--- keybinding based on personal linguistic idiosyncracies.
---@class funsak.keys.Keybundle
local Keybundle = {}

---@alias M.Target
---| string # represents the action of a particular keybind or portion (e.g.
---family, grouping, class, etc) of a keybind. Notably, this is likely a
---subportion of a composite index in a multi-level table.
---| fun(): string # alternatively, a function that evaluates to a
---representation of the action of a particular keybinding.

---@alias M.Bound
---| string # represents a keybinding or a portion of a keybinding. This must be
---the concrete type, rather than accepting a callback function as an
---alternative specification. Reason for this is mainly that this should
---represent the final keybind the user must complete in order to trigger the
---mapped action.

---@alias M.Identikey
---| M.Bound #

---@class M.BindOptions

---@class M.Binder
---@field ident
---@field handler fun(tgt: M.Target , opts: M.BindOptions): M.Binder
---@field bind fun(): M.Bound

---@alias M.KeyAutomorphism
---| "filter"
---| "link"
---| "lettercase"
---| "shortcut"
---| "mask"

---@class M.FilterSpec
---@field append M.Bound?
---@field prepend M.Bound?

---@class M.InheritSpec?
---@field morph M.KeyAutomorphism
---@field from M.Target?
---@field parent boolean?

---@class M.ShortcutSpec
---@field rebound M.Bound
---@field opts M.BindOptions

---@class M.LettercaseSpec
---@field uppercase table
---@field lowercase table

---@class M.ToolbeltSpec
---@field tools { M.Target: fun() }

---@class M.InitOptions
---@field which_key table?
---@field debug table?

--- constructor for a Keybundle object;
---@param keys { FILTERS: M.FilterSpec?, [M.Target]: M.Bound }?
---@param opts M.InitOptions?
---@return funsak.keys.Keybundle
function Keybundle.new(keys, opts)
  keys = keys or {}
  opts = opts or {}
  -- TODO: implementation
  local mt = {}

  return setmetatable(keys, mt)
end

return Keybundle
