---@module "funsak.orderedset" implementation of a set-like data structure that is
---capable of tracking order of insertion of elements.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.orderedset
local OrderedSet = {}
OrderedSet.__index = OrderedSet

function OrderedSet:add(element)
  if not self.set[element] then
    table.insert(self.elements, element)
    self.set[element] = #self.elements
  end
end

function OrderedSet.new(initial)
  initial = initial or {}
  local self = setmetatable({}, OrderedSet)
  self.set = {}
  self.elements = {}
  if initial and type(initial) == "table" then
    for _, element in ipairs(initial) do
      self:add(element)
    end
  end

  return self
end

-- Check if an element exists in the set
function OrderedSet:contains(element)
  return self.set[element] ~= nil
end

-- Get the index of an element in the set
function OrderedSet:indexof(element)
  return self.set[element]
end

-- Get the intersection of two sets
function OrderedSet:intersect(otherSet)
  local intersection = OrderedSet.new()
  for _, element in ipairs(self.elements) do
    if otherSet:contains(element) then
      intersection:add(element)
    end
  end
  return intersection
end

-- Get the union of two sets
function OrderedSet:union(otherSet)
  local unionSet = OrderedSet.new()
  for _, element in ipairs(self.elements) do
    unionSet:add(element)
  end
  for _, element in ipairs(otherSet.elements) do
    unionSet:add(element)
  end
  return unionSet
end

return OrderedSet
