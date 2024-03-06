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

---@module "funsak.index" tools for manipulating across indexed objects in a
---functional manner.
---@author Bailey Bjornstad
---@license MIT

-- ╓─────────────────────────────────────────────────────────────────────╖
-- ║ funsak.index                                                        ║
-- ╙─────────────────────────────────────────────────────────────────────╜

---@class funsak.index
local M = {}

--- walks across a table of arbitrary shape computing the result of a given
--- predicate function of comparison-like nature, in the sense that it is a
--- predicate function between the previous "optimal" selection and the current
--- result.
---@param fn fun(prev: any, next: any): boolean when called with the current iteration's
---new computed value and previous optimal selection, this function should
---return true if the new value is more optimal and should be kept for future
---comparisons instead, and false if the previously found value is more optimal.
---@return fun(tbl: { [any]: any }): any, any handler this function accepts any
---arbitrarily shaped table as input and returns the key and value of the
---optimal selection. In the case of tied results: n.b. the most recently
---visited best selection "wins" against earlier matches
function M.ix(fn)
  return function(tbl)
    local key = next(tbl)
    local fd = tbl[key]

    for k, v in pairs(tbl) do
      if fn(v, fd) then
        key, fd = k, v
      end
    end
    return key, fd
  end
end

M.idxmin = M.ix(function(new, prev)
  return new < prev
end)

M.idxmax = M.ix(function(new, prev)
  return new > prev
end)

return M
