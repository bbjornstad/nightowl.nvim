local M = {}

--- any table, generally should be thought of as an individual item in a group
--- of comparable items. Comparable in this case means from the same metric
--- space.
---@generic Point: table
--- computes the euclidean distance between two items; the euclidean distance is
--- the sum-of-squared-differences method for computing the distance, and works
--- for any metric
---@param this Point any table, but the shape must match `that`
---@param that Point any table, but the shape must match `this`
---@return number distance the computed euclidean distance, e.g. square root of
---the L2 norm, e.g. square root of sum of squares
function M.euclidean(this, that)
  local items = require("funsak.wrap").rezip({ this, that })
  local squares = vim.tbl_map(function(i)
    local _this, _that = unpack(i)
    return (_this - _that) ^ 2
  end, items)
  local summed = require("funsak.wrap").reduce(function(agg, new)
    return agg + new
  end, squares, 0)
  return math.sqrt(summed)
end

return M
