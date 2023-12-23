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

---@class funsak.keys.keybundle
local Keybundle = {}

function Keybundle:new()
  -- TODO: implementation
end

return Keybundle
