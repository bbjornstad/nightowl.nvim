---@module "funsak.rendezvous" tools for creating a rendezvous point for data
---and specification options before main use.
---@author Bailey Bjornstad
---@license MIT
-- vim: set ft=lua ts=2 sw=2 sts=2 et:

---@alias MergerID any

---@enum MergerSpecialField
local MergerSpecialField = {
  -- corresponds to registered data targets by tag
  DataIndices = "__data_indices__",
  -- corresponds to the particular tag for a Merger instance.
  TagIdentifier = "__tag_identifier__",
  -- corresponds to the identifier assigned to this particular Merger
  DataProxyIdentifier = "__data_proxy_identifier__",
  DataProxyTable = "__data_proxy_table__",
  -- out of the set, which items should take priority during merge
  MergePriority = "__data_merge_priority__",
}

---@class funsak.rendezvous
local Merger = {}
Merger[MergerSpecialField.DataIndices] = {}

function Merger:__idx__(tag, allow_nil_result)
  local res = {}
  local master = rawget(self, MergerSpecialField.DataIndices)
  for tbl, merger in master do
    if merger:tag() == tag then
      res[merger:proxy_id()] = tbl
    end
  end
  if #res == 0 then
    return not allow_nil_result and master
  end
  return res
end

function Merger:idx(tag)
  return self:__idx__(tag, true)
end

function Merger:tag()
  return rawget(self, MergerSpecialField.TagIdentifier)
end

function Merger:proxy_id()
  return rawget(self, MergerSpecialField.DataProxyIdentifier)
end

function Merger:proxy()
  return rawget(self, MergerSpecialField.DataProxyTable)
end

function Merger:priority()
  return rawget(self, MergerSpecialField.MergePriority)
end

function Merger:__register_proxy__(tbl, opts)
  local outer_proxy = {}
  local proxy_mt = {}
  -- TODO: finish proxy table metamethods
  function proxy_mt.__index(cls, idx)
    local tag = cls:tag()
    local inner_proxy = cls:proxy()
    local mergeable = cls:__idx__(tag, true)
    return inner_proxy
  end

  function proxy_mt.__new_index(cls, idx, value) end

  local registered = self:idx(self:tag())
  self[MergerSpecialField.DataProxyIdentifier] = #registered + 1

  self[MergerSpecialField.MergePriority] = opts.merge_priority

  return setmetatable(outer_proxy, proxy_mt)
end

-- TODO: implement metaindex method for access of items via merger, e.g. this
-- should direct requests to the underlying proxy. this facilitates returning
-- the whole Merger which provides some utility methods.
local function __metaindex__(cls, idx) end

function Merger.new(cls, tag, tbl, opts)
  tbl = tbl or {}
  local merger_target = cls:idx(tag)

  cls[MergerSpecialField.TagIdentifier] = tag
  -- construct a new proxy table, this table serves only to fail on standard
  -- access, thus accessing the __index metamethod every time that the "table"
  -- is accessed. n.b. apparently this strategy does not work for traversal of
  -- tables. We will need to adjust that behavior somewhat.

  cls[MergerSpecialField.DataProxyTable] = cls:__register_proxy__(tbl, opts)

  return setmetatable(cls, { __index = __metaindex__ })
end

local function wrapper(tag, mopts)
  local function wrap(tbl, wopts)
    return Merger:new(tbl, tag, vim.tbl_deep_extend("force", mopts, wopts))
  end
  return wrap
end

return wrapper
