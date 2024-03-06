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

---@module "funsak.color.knolor" a reimplementation of colors, designed to be
---substantially simpler, and sporting a unified interface, at least in
---comparison to previous implementations of the same functionality.
---@author Bailey Bjornstad | ursa-major
---@license MIT

-- ╓─────────────────────────────────────────────────────────────────────╖
-- ║ funsak.color.knolor:                                                ║
-- ╙─────────────────────────────────────────────────────────────────────╜
-- The reimplementation of color definitions in less disparate, more
-- straightforward manner. Seeks to unify several of the similarly operating
-- functions in the first draft versions.

---@class funsak.color.knolor
local M = {}

---@alias M funsak.color.knolor

-- ┌─ Type Definitions ─────────────────────────────────────────────────────────┐

---@alias M.ColorPresentation
---| funsak.RGBColor # color in RGB format
---| funsak.HSLuvColor # color in HSV format
---| funsak.HexColor # color in Hex format

---@alias M.HighlightGroup
---| string # name of a highlight group

---@alias M.HighlightAttribute
---| Ix<vim.api.keyset.highlight> # highlight attribute names, e.g. the index of
---the table fields accepted on call to `vim.api.nvim_set_hl`

---@alias M.ColorScheme
---| string # name of a colorscheme

local _get_hl = function(name, namespace)
  local ok, res = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if ok then
    return res
  end
  require("funsak.lazy").warn(
    ("Failed getting highlight `%s` in namespace `%s`\nMessage: %s"):format(
      name,
      namespace,
      res
    )
  )
end

--- returns the currently registered highlight attribute table for a particular
--- highlight group
---@param hlgroup M.HighlightGroup name of a highlight group
---@return vim.api.keyset.highlight group_def the highlight attributes
---registered to this group.
function M.get_hl(hlgroup)
  return _get_hl(hlgroup)
end

--- A placeholder for any component field of any valid color representation,
--- e.g. "red", or "lightness".
---@alias M.ScaleChannel
---| M.HighlightAttribute # highlight attribute of a highlight group in
---any representation, e.g. one possible channel on which scaling can occur

---@generic ChannelValue: any
---@alias M.ScaleMethod<ChannelValue>
---| `"exp"` # exponential scaling factor
---| `"log"` # logistic scaling factor
---| `"lin"` # linear scaling factor
---| `"ln"` # natural logarithm scaling factor
---| fun(current: `ChannelValue`, factor: number): `ChannelValue`

--- A representation of a transformation or collection thereof to be applied to
--- a color. The transformation is given as a mapping of scalar values against
--- color-channel names. The values of those scalars determines how much and in
--- which direction each of the axes of the input color should adjust to get to
--- the scaled value.
---@class M.Scaler
--- multiplicative adjuster value; at each scaling the previous value is
--- multiplied by this number and the product is used to adjust and compute a
--- new value, depending on the method selected. A single number is applied to
--- all axes; a table mapping axes to numbers applies scaling along each
--- specified channel by the corresponding amount given, or a function which
--- returns either of these options (and interpreted identically) can also be
--- used.
---@field factor funsak.Fowl<(number | { [M.ScaleChannel]: number })>
--- function mapping form that should be used to perform the scaling, "exp"
--- corresponds to exponential, "log" for logistic, "ln" for the natural
--- logarithm, and "lin" for the standard linear. Can also be given as a
--- function of a pair of input arguments: the current value along the channel of
--- computation, and the value of the factor. This function should return the
--- new value. (default "lin")
---@field method M.ScaleMethod?

local _scalar = {}

--- linear scalar function
---@param current number value at the current slice
---@param factor number factor of increase or decrease, like a throttle
---@return number new transformed channel value
function _scalar.lin(current, factor)
  return (current * factor)
end
function _scalar.exp(current, factor)
  return math.exp(factor + current)
end
function _scalar.ln(current, factor)
  return math.log(current) + math.log(factor)
end
function _scalar.log(current, factor) end

--- scales an input color along the given axes by the specified scaling factor
--- and scaling method
---@param factor M.Scaler a scaling specification in appropriate form for the
---target color
---@param color M.ColorPresentation a color in any valid representation
---@param opts { factor: { extra_args: any[] }? } additional options
---@return M.ColorPresentation modified of the same form as the input color
function M.scale(factor, color, opts)
  opts = opts or {}
  local factor_opts = opts.factor or {}
  local extra_args = factor_opts.extra_args or {}
  local oper = factor.method ~= nil and factor.method or "lin"
  color = type(color) == "string"
      and require("funsak.color.hsluv").hex_to_hsluv(color)
    or color
  ---@cast color -string
  local fct = factor.factor ~= nil and factor.factor or {}
  fct = vim.tbl_contains({ "function", "table" }, type(fct)) and fct or { fct }
  fct = vim.is_callable(fct) and fct(unpack(extra_args)) or fct
  oper = type(oper) == "string" and _scalar[oper] or oper
  for attr_channel, current in pairs(color) do
    local factorval = vim.is_callable(fct)
        and fct(attr_channel, current, unpack(extra_args))
      or fct[attr_channel]
    color[attr_channel] = oper(current, factorval)
  end
  return color
end

--- factory functor which creates transforming functions which scale an input
--- color by specified factors and scaling methods along component axes.
---@param factor M.Scaler scaling factor specification which will be applied to
---all colors who pass through the return value of this functor (e.g. another
---function)
---@return fun(color: M.ColorPresentation, opts: funsak.GenericOpts): M.ColorPresentation builder
function M.scaler(factor)
  return function(color, opts)
    return M.scale(factor, color, opts)
  end
end

--- linkage target from one highlight group to a subset of another; represents
--- the actual targeted value, so the new hlgroup name is not present as a data
--- field here, that is handled by the operating functions that accept this
--- object as an argument.
---@class M.SublinkTarget: { [M.HighlightAttribute]: M.HighlightGroup }

--- returns a subset of highlight attributes, intended to act as a pseudo-link
--- to a subset of the attributes of another highlight group computed for
--- colorscheme overrides, etc.
---@param target M.SublinkTarget mapping of highlight attributes to the existing
---highlight group names whose values the returned subset should inherit
---@return vim.api.keyset.highlight? subset n.b. subset can mean the whole set,
---so this can act as a "hard"-link in that it borrows the whole definition.
---Will return nil in the event that the target highlights nor their
---respectively selected fields exist.
function M.slink(target)
  local ret = vim
    .iter(target)
    :map(function(key, val)
      local other = M.get_hl(val) or {}
      return other[key]
    end)
    :totable()
end

--- applys a collection of highlight definitions through an internal nvim api
--- call, e.g. to `nvim_set_hl`.
---@param hldef vim.api.keyset.highlight
--- target namespace for the highlight definitions, see `:help highlight`;
--- defaults to 0 for the global highlight namespace. Can also be specified as a
--- function which returns the namespace id when called with input arguments
--- `attr` and `group`
---@param namespace funsak.Fowl<integer>
function M.paint(hldef, namespace)
  namespace = namespace ~= nil and namespace or 0
  for attr, group in pairs(hldef) do
    namespace = vim.is_callable(namespace) and namespace(attr, group)
      or namespace
    ---@cast namespace integer
    vim.api.nvim_set_hl(namespace, attr, group)
  end
end

return M
