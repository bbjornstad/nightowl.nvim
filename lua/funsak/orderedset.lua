-- SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "funsak.orderedset" implementation of a set-like data structure that is
---capable of tracking order of insertion of elements.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@generic Elem: any
--- together, the two fields of the OrderedSet help keep track of the insertion
--- order of elements into this set-like table as well as enforces the
--- uniqueness aspect in order to be set-like at all.
---@class funsak.OrderedSet<Elem>
---@field set { [`Elem`]: integer }
---@field elements { [integer]: `Elem` }
local OrderedSet = {}
OrderedSet.__index = OrderedSet

---@generic Elem: any
--- adds an element to the ordered set
---@param element Elem
function OrderedSet:add(element)
  if not self.set[element] then
    table.insert(self.elements, element)
    self.set[element] = #self.elements
  end
end

---@generic Elem: any
--- creates a new OrderedSet, using the given argument as the initial table
--- value underpinning the OrderedSet.
---@param initial { [any]: Elem }? initial values that should be populated
---into the OrderedSet.
---@return funsak.OrderedSet
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

---@generic Elem: any
--- check if an element exists in the set
---@param element Elem
---@return boolean
function OrderedSet:contains(element)
  return self.set[element] ~= nil
end

---@generic Elem: any
--- gets the index in the set of the item given as an argument
---@param element Elem element to get index of
---@return integer index
function OrderedSet:indexof(element)
  return self.set[element]
end

---@generic Elem: any
--- performs the set-theoretic intersection of an OrderedSet against another
--- OrderedSet
---@param otherSet funsak.OrderedSet<Elem>
---@return funsak.OrderedSet<Elem> intersected
function OrderedSet:intersect(otherSet)
  ---@cast otherSet funsak.OrderedSet
  local intersection = OrderedSet.new()
  ---@cast intersection funsak.OrderedSet
  for _, element in ipairs(self.elements) do
    if otherSet:contains(element) then
      intersection:add(element)
    end
  end
  return intersection
end

---@generic Elem: any
--- gets the set-theoretic union of an OrderedSet against another OrderedSet.
---@param otherSet funsak.OrderedSet<`Elem`>
---@return funsak.OrderedSet<Elem>
function OrderedSet:union(otherSet)
  ---@cast otherSet funsak.OrderedSet
  local unionSet = OrderedSet.new()
  ---@cast unionSet funsak.OrderedSet
  for _, element in ipairs(self.elements) do
    unionSet:add(element)
  end
  for _, element in ipairs(otherSet.elements) do
    unionSet:add(element)
  end
  return unionSet
end

---@generic Elem: any
--- unpacks the values represented in the OrderedSet, either returning the
--- values or inserting them into the given table argument.
---@param into table? optional target table into which the values are unpacked.
---Specifying a falsy value will force the return statement, while a truthy
---statement will be assumed to be a table and the values will be inserted at
---the end.
---@return Elem[]? values
function OrderedSet:values(into)
  local vals = vim.tbl_values(self.elements)
  if into then
    vim.list_extend(into, vim.tbl_values(self.elements))
  else
    return vim.tbl_values(self.elements)
  end
end

return OrderedSet
