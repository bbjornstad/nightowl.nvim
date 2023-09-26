---@module merger tools for merging lazy.nvim spec tables.
---@author Bailey Bjornstad
---@license MIT
-- vim: set ft=lua ts=2 sw=2 sts=2 et:

---@alias MergerID any

--- acts as lubrication in connecting pieces of lazy.nvim specification tables
--- to each other when defined in different files. Merger is its own metatable,
--- which means that the Merger definition can be used to hold information about
--- all Merger instances, each of which wraps a specific table.
---@class Merger: table
---@field __merger_tracked_data table maps string identification tags for the targeted
---plugins' config table spec items that are to be merged using disparate "instances"
---to the data that was wrapped using that "instance". Accessed typically using the `tracked`
---method, e.g. `merger_inst:tracked()`.
---@field __merger_tracked_inst table maps wrapped tables to their corresponding id items.
---@field __merger_tracked_id MergerID identifies this particular family of Merger items with the
---assignment of a special field. Merger's cannot merge if they are not under a shared
--- __merger_tracked_id
local Merger = {}

--- returns a new Merger, constrained to the specific tag provided. The returned merger
--- represents a single item in the list
---@param tbl table table that will be wrapped with this particular instance of
---the Merger object.
---@param id MergerID any item which identifies a particular family of Merger
---instances which represent a single group.
function Merger:new(tbl, id)
  -- we need to add the values in tbl to the values that have already been
  -- tracked by other Merger instances with the same id.
  tbl = tbl or {}
  self.__index = function(slf, idx)
    -- holdsall tracked items in merged format
  end
  -- ff
  self.__merger_tracked_data = {}
  -- hold registered instances.2727
  self.__merger_tracked_inst = {}
  --
  local this = {
    __merger_tracked_id = id,
  }

  return setmetatable(
    vim.tbl_deep_extend("force", tbl, this) or this or tbl,
    self
  )
end

--- gets the id from a Merger instance, e.g. the target location for a merged
--- table.
---@return MergerID id the identifier value for this particular Merger.
function Merger:id()
  return rawget(self, "__merger_tracked_id")
end

--- gets a list of all table instances that have been registered with the same
--- id field as this current Merger instance.
---@return table[] results list of tables that are registered under this id.
function Merger:inst()
  local tbl = rawget(self, "__merger_tracked_inst")
  local res = {}
  for k, v in pairs(tbl) do
    if v == self:id() then
      table.insert(res, k)
    end
  end
  return res
end

--- gets all values corresponding to the id field of this Merger instance,
--- across all Merger instances.
function Merger:values()
  local tbls = self:inst()
  vim.tbl_deep_extend("force", unpack(tbls))
end

--- returns the table containing all tracked values by ID.
---@return table tracked contains all of the tracked values across Merger
---instances, indexed by ID field.
function Merger:tracked()
  local t = rawget(self, "__merger_tracked_data")
  local id = self:id()
  return id and rawget(t, id) or t
end

--- returns a list of all id fields that are registered with this MergerID.
---@return MergerID[] all id fields currently registered.
function Merger:ids()
  return vim.tbl_keys(rawget(self, "__merger_tracked_data"))
end

--- adds a new id to the set, along with the corresponding table values. This is
--- an internal helper function for handling the `__newindex` metamethod.
---@param id MergerID the identifier for this group of tables.
---@param value table the values that are to be added and tracked if they don't
---already exist in the merged table.
function Merger:__new_tracked(id, value)
  local t = rawget(self.__merger_tracked_data, id) or {}
  rawset(t, value)
end

--- overloads the assignment operation of Merger instances, such that the table
--- that is added is merged with any existing options.
---@param key MergerID a merger grouping identifier.
---@param value table the values that are registered by this instance of the
---Merger.
function Merger:__newindex(key, value)
  self:__new_tracked(key, value)
end

---@alias MergeBehavior "force"|"keep"|"error"
--- joins this Merger and another together using the specified merge behavior,
--- e.g. wraps a call to `vim.tbl_deep_extend`.
---@param other Merger another Merger object
---@param behavior MergeBehavior? merge behavior for `vim.tbl_deep_extend`
---@return Merger? the merged table
function Merger:merge(other, behavior, copy)
  behavior = behavior or "force"
  copy = copy or false
  local prev = self:tracked(other:id())
  return prev
      and vim.tbl_deep_extend(
        behavior,
        copy and vim.deepcopy(prev) or prev,
        other
      )
end

function Merger:wrap(tbl, id)
  local wrap = self:new(tbl, id)
  self:merge(wrap, "force", false)
  return setmetatable(tbl, self)
end

--- places the values contained from the Merger instance, e.g. all of the
--- combined across all individual instances into the table specified.
---@param tbl table the table which is to be extended with the items contained
---in this merger object.
function Merger:into(tbl)
  local m = self:tracked()
  return m and vim.tbl_deep_extend("force", tbl, m)
      or vim.tbl_deep_extend("force", tbl, self)
end

--- creates a new function whose execution will result in the creation of a new
--- Merger object with the specified plugin and field as its target. The
--- execution of that function accepts a single argument, the table spec that
--- should be added or merged to existing table spec. Because this is the
--- returned value from the module, this is also the only way to create a
--- Merger, and all Merger functions can only be executed with an instance.
---@param  tbl table table to wrap with disparate merging behavior.
---@param  id MergerID specification id of the targeted group of tables.
---@return Merger merger the Merger object that will control merging behavior
---for items with specified `id` as an instance wrapping a specific table.
local function merger(tbl, id)
  local merge = Merger:new(tbl, id)
  return merge:wrap(id, tbl)
end

--- creates a new function whose execution will result in the creation of a new
--- Merger instance. This interface is designed as a wrapper that is to be used
--- for a particular id grouping, in other words one can use it to define a
--- reusable Merger factory for the given id designation.
---@param id MergerID
---@return function wrapper when executed, this will create a new Merger object
---wrapping the specified table under the ID designation.
local function wrap(id)
  local f = require("plenary.functional").partial(function(id, tbl)
    return merger(tbl, id)
  end, id)

  return f
end

--- executes the wrap function to create a new Merger instance, with the
--- specific stipulation that the identifier ID field is given as the
--- concatenation of a lazy.nvim plugin spec name and a corresponding subfield
--- of the lazy.nvim spec.
---@param plugin string name of the lazy.nvim plugin which is targeted.
---@param field string the name of a lazy.nvim spec field, e.g. "opts" or "keys".
---@return function wrapper signature `wrapper(tbl: table)` when executed,
---this will create a new Merger object with an id of `"{plugin}.{field}"`.
local function pwrap(plugin, field)
  return wrap(string.format("%s.%s", field, plugin))
end

return {
  merger = merger,
  wrap = wrap,
  pwrap = pwrap,
}
