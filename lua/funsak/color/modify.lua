-- SPDX-FileCopyrightText: 2023 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2023 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

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

---@module "funsak.color.modify" color manipulation utilities for functional swiss army
---knives and lazy nvim configurations.
---@author Bailey Bjornstad | ursa-major
---@license MIT

-- ╓─────────────────────────────────────────────────────────────────────╖
-- ║ funsak.color.modify                                                       ║
-- ╙─────────────────────────────────────────────────────────────────────╜
-- color modification utilities for the funsak toolset

---@class funsak.color.modify
local M = {}

-- ┌─ Type Definitions ─────────────────────────────────────────────────────────┐
---@alias funsak.color.modify.Representation
---| funsak.RGBColor # color in RGB format
---| funsak.HSVColor # color in HSV format
---| funsak.HexColor # color in Hex format

---@alias funsak.color.modify.HighlightGroup
---| string # name of a highlight group

---@alias funsak.color.modify.ColorScheme
---| string # name of a colorscheme

--- a safe function to call to get highlight definitions, even across versions
--- of lua/nvim which are lacking the most up to date form of
--- `vim.api.nvim_get_hl`
---@diagnostic disable-next-line: undefined-doc-param
---@param name string name of the highlight group to return
---@return funsak.color.modify.HighlightGroup hl the definition of the target group,
---if it exists.
M.get_hl = vim.api.nvim_get_hl
    and function(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end
  or function(name)
    ---@diagnostic disable-next-line: deprecated
    return vim.api.nvim_get_hl_by_name(name, true)
  end

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

--- converts a color from RGB representation into the HCL space.
---@param color funsak.RGBColor
---@return funsak.HSVColor color
function M.rgb_to_hcl(color)
  local cmin, cminval = M.idxmin(color)
  local cmax, cmaxval = M.idxmax(color)
end

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
  end, squares, {})
  return math.sqrt(summed)
end

---@alias funsak.color.modify.ScaleMethod
---| `"exp"` # exponential scaling factor
---| `"log"` # logistic scaling factor
---| `"lin"` # linear scaling factor

--- configuration options for color tranformation that scales the "intensity" of
--- the color by adjusting the final "value" component in HSV space, but which
--- keeps general hue and saturation.
---@class funsak.color.modify.Scaler: { ["1"]: number }
---@field scale_method funsak.color.modify.ScaleMethod? function mapping form that
---should be used to perform the scaling, "exp" corresponds to exponential,
---"log" for natural logarithm, and "lin" for the standard linear. (default
---"lin")

--- normalizes an RGB color to specifically force that each component is between
--- 0 and 1.
---@param color funsak.RGBColor
---@return funsak.RGBColor normalized
function M.normalize_rgb(color)
  color.red = color.red or 0
  color.blue = color.blue or 0
  color.green = color.green or 0
  color.alpha = color.alpha or 256

  return vim.tbl_map(function(n)
    return n / 256
  end, color)
end

--- normalizes an HSL color to specifically force that each component is between
--- 0 and 1.
---@param color funsak.HSVColor
---@return funsak.HSVColor normalized
function M.normalize_hsv(color)
  -- TODO: Implementation
  return color
end

function M.hsv_to_rgb(color) end

--- lightens or darkens the given color, by first converting the color to hsv
--- space and then scaling the `value` component according to the user
--- parameters.
---@param color funsak.HSVColor an HSL described color representation
---@param opts funsak.color.modify.Scaler? intensity scaling operation configuration
---options
function M.scale(axis, color, opts)
  opts = opts or {}
  local scale_factor = opts[next(opts)]
  local new_value = color[axis] + (color[axis] * scale_factor)
  color[axis] = new_value
  return color
end

function M.scaler(axis)
  return function(color, opts)
    return M.scale(axis, color, opts)
  end
end

M.scale_lightness = M.scaler("lightness")
M.scale_transparency = M.scaler("alpha")
function M.scale_colormix(color, opts) end

--- a modification expression of an existing highlight definition
---@class funsak.color.modify.HLComponentMod
--- an amount by which to modify the lightness of the target highlight
--- component. Positive numbers indicate that the component should be subject to
--- lightening, while negative values indicate darkening.
---@field lightness? number
--- an amount by which to modify the transparency/window blend of the target
--- component. Positive numbers indicate that the component should be made more
--- transparent, while negative numbers indicate increasing transparency.
---@field blend? number
--- a color with which the target component will be mixed. If a simple string is
--- given, then the mixing between colors will be even, otherwise a table
--- specification is allowed wherein the `amount` field indicates a mix portion
--- of the new color into the old, e.g. 0.6 means 60% from the new color, 40%
--- from the old.
---@field mixin? string | { color: string, amount: number }

--- an expression of modifications to an existing highlight definition
---@class (exact) funsak.color.modify.HLModifier: { [vim.api.keyset.highlight]: funsak.color.modify.HLComponentMod }

--- modifies an existing highlight group definition such according to the
--- specified parameters
---@param hl funsak.color.modify.HighlightGroup | funsak.color.modify.HighlightGroup[]
---@param mods funsak.color.modify.HLModifier
function M.modify(hl, mods)
  local hls = M.get_hl(hl)
  local mapper = {
    lightness = M.scale_lightness,
    blend = M.scale_transparency,
    mixin = M.scale_colormix,
  }
  for i, val in pairs(mods) do
    local f = mapper[i]
    f(val)
  end
end

--- computes the distance between two colors in RGB space. This is essentially
--- just the calculation of a notion of distance which makes sense according to
--- analytical principles of metric spaces
--- (https://en.wikipedia.org/wiki/Metric_space). Note that since hex values are
--- simply a different textual representation of RGB space, it suffices to
--- calculate this for general rgb values and use a separater conversion
--- function to achieve the hex metrics.
---@param color funsak.RGBColor
---@param other funsak.RGBColor
function M.metric_rgb(color, other)
  color = M.normalize_rgb(color)
  other = M.normalize_rgb(other)
  local red = (color.red - other.red) ^ 2 or nil
  local green = (color.green - other.green) ^ 2 or nil
  local blue = (color.blue - other.blue) ^ 2 or nil
  return math.sqrt(red + green + blue)
end

--- computes the distance between two colors in HSV space. This is essentially
--- the calculation of a notion of distance which makes sense according to
--- analytical principles of metric spaces
--- (https://en.wikipedia.org/wiki/Metric_space). This is a slightly different
--- representation of the color-space than RGB and so we also provide the metric
--- implementation in this context so that conversion into RGB values is not
--- strictly necessary (though very likely). I believe that the
--- conversion/transformation is basically a projection onto a radial, e.g.
--- circular curve. Supposedly this provides a more accurate representation of
--- how colors blend physically to create new colors and the human perception
--- thereof.
---@param color funsak.HSVColor
---@param other funsak.HSVColor
function M.metric_hsv(color, other)
  color = M.normalize_hsv(color)
  other = M.normalize_hsv(other)
  local first = (
    math.sin(color.hue) * color.saturation * color.value
    - math.sin(other.hue) * other.saturation * other.value
  ) ^ 2
  local second = (
    math.cos(color.hue) * color.saturation * color.value
    - math.cos(other.hue) * other.saturation * other.value
  ) ^ 2
  local third = (color.value - other.value) ^ 2

  return math.sqrt(first + second + third)
end

--- sets the given highlight groups to have the definitions specified as
--- options.
---@param hls funsak.color.modify.HighlightGroup | funsak.color.modify.HighlightGroup[] list of highlight group names
---that are to receive the `opts` as their definitions.
---@param defn vim.api.keyset.highlight options that are passed to the
---underlying call to nvim_set_hl
function M.set_hl_multi(hls, defn)
  hls = type(hls) ~= "table" and { hls } or hls
  ---@cast hls -string
  vim.tbl_map(function(n)
    vim.api.nvim_set_hl(0, n, defn)
  end, hls)
end

---@generic gfn_ColorMod: fun(color: vim.api.keyset.highlight): vim.api.keyset.highlight
---@alias funsak.color.modify.Modifier gfn_ColorMod

---@class owl.color.HighlighterOpts
---@field ns integer?
---@field colormods (funsak.color.modify.Modifier | funsak.color.modify.Modifier[])?

--- directly sets highlight groups using an internal vim api call.
---@param hls { [funsak.color.modify.HighlightGroup]: vim.api.keyset.highlight? }
---@param opts owl.color.HighlighterOpts
function M.set_hl(hls, opts)
  opts = opts or {}
  opts.colormods = opts.colormods ~= nil and opts.colormods
  opts.colormods = type(opts.colormods) == "table" and opts.colormods
    or { opts.colormods }
  for k, v in pairs(hls) do
    if opts.colormods then
      for i, fn in ipairs(opts.colormods) do
        v = fn(v)
      end
    end
    vim.api.nvim_set_hl(opts.ns or 0, k, v)
  end
end

--- retrieves the foreground color of the specified highlight group.
---@param hlgroup funsak.color.modify.HighlightGroup
---@param link boolean? shows the linked highlight group name instead of the
---"effective definition". Needs a good example of behavior. Defaults to `true`.
---@return string color the color of the foreground of the specified highlight
---group
function M.identify_highlight(hlgroup, link)
  link = link or true
  local labeled_hl = vim.api.nvim_get_hl(0, { name = hlgroup, link = link })
  return labeled_hl.fg or labeled_hl.guifg
end

local function hl_component(component, name, hlmap)
  hlmap = hlmap or {}
  local hl = M.get_hl(name)
  local compid = hlmap and hlmap[component] or component
  local comp = hl and hl[compid] or nil
  return comp and { [component] = string.format("#%06x", comp) or nil } or {}
end

--- retrieves the values of the given highlight group component properties from
--- the highlight group with the specified names.
---@param name funsak.color.modify.HighlightGroup
---@param component string | string[] highlight group property names
---@param hlmap vim.api.keyset.highlight? if desired, a remapping of old highlight
---group properties to new highlight group properties can be given. The values
---for each of the constituent highlight components for components indexed by
---the `hlmap` parameter will instead be mapped to the corresponding remapped
---component portions. For example, if a map { bg = "fg" } is provided, then
---background values in the new definition are derived from the "fg" values in
---the original definition.
---@return vim.api.keyset.highlight
function M.component(name, component, hlmap)
  component = type(component) ~= "table" and { component } or component
  local f = require("funsak.wrap").recurser(hl_component)
  local fres = f(component, name, hlmap)
  local ret = vim.tbl_deep_extend("force", {}, unpack(fres))
  return ret
end

function M.dvalue(name, component, hlmap)
  component = type(component) ~= "string" and tostring(component) or nil
  local hl = M.get_hl(name)
  local compid = hlmap and hlmap[component] or component
  local comp = hl and hl[compid] or nil
  return comp
end

--- returns the currently selected colorscheme.
---@return string name colorscheme name
function M.current_scheme()
  return vim.g.colors_name or vim.cmd([[colorscheme]])
end

---@class funsak.color.modify.HlTargetSpec
---@field namespace { name: string?, clear_existing: (boolean | fun(ns_id: integer, ns_name: string): boolean)? }
---@field buffer { bufnr: integer? }
---@field merge_behavior ("override" | "inherit" | "intersect")?

--- applys a highlight definition, with additional wrapping around the internal
--- call to `vim.api.nvim_set_hl` with some manipulations of the highlight
--- namespace based on the selected or current colorscheme.
---@param name string
---@param defhl vim.api.keyset.highlight
---@param opts funsak.color.modify.HlTargetSpec
function M.applicate(name, defhl, opts)
  opts = opts or {}
  local ns_opts = opts.namespace or {}
  local buf_opts = opts.buffer or {}
  local ns_name = ns_opts.name or M.current_scheme()
  local clear_ns = ns_opts.clear_existing or false

  local ns = vim.api.nvim_create_namespace(ns_name)

  if clear_ns then
    vim.api.nvim_buf_clear_namespace(buf_opts.bufnr or 0, ns, 0, -1)
  end

  -- TODO: implement the merge behavior on application, either to merge with
  -- existing while forcing new keys, inheriting old keys, or intersecting the
  -- keys so only the common ones remain. This is two distinct hyperparameters.
  vim.api.nvim_set_hl(ns, name, defhl)
end

--- directly inherits a previous highlight definition, overriding the target
--- fields with the specified additional definition.
---@param name string highlight group name
---@param defhl vim.api.keyset.highlight highlight definition mapping.
---@param namespace string? if desired, the target namespace can be given here,
---otherwise the current colorscheme is used.
---@return vim.api.keyset.highlight inherited highlight definition with
---overrides.
function M.from_hl(name, defhl, namespace)
  local hl = M.get_hl(name)
  local new_def = vim.tbl_deep_extend("force", hl, defhl)
  return new_def
end

--- updates a highlight definition with the specified new highlight definition
--- mapping values, optionally in a user-targeted highlight namespace.
---@param name string highlight group name which is to be updated
---@param hlmap vim.api.keyset.highlight | vim.api.keyset.highlight[] highlight
---definition values
---@param namespace string? target highlight namespace, if desired. Otherwise,
---the current colorscheme is used.
---@return vim.api.keyset.highlight merged the merged components that are the
---new highlight definition.
function M.merge_hl(name, hlmap, namespace)
  local f = require("funsak.wrap").recurser(function(d, n, ns)
    return M.from_hl(n, d, ns)
  end)
  local fres = f(hlmap, name, namespace)
  local should_reduce = type(fres) == "table"
    and vim.iter(fres):all(function(item)
      return type(item) == "table"
    end)
  return should_reduce
      and require("funsak.wrap").reduce(function(agg, new)
        vim.tbl_deep_extend("force", agg, new)
      end, fres, {})
    or fres
end

local rget = require("funsak.table").rget
local fnul = require("funsak.wrap").eff

---@param opts table Maps the item that is to be colore to a string of the
--- color that it should receive.
---@param scheme_target string Identifies an item that is to be required in the
---sense of calling lua's require to bring the main definitions into focus.
function M.colors(opts, scheme_target, scheme_cfg)
  scheme_target = scheme_target or "kanagawa.colors"
  scheme_cfg = scheme_cfg or {}
  local function itemized_color(colorname)
    local retval = require(scheme_target).setup(scheme_cfg).palette[colorname]
    return retval
  end

  local retval = vim.tbl_map(itemized_color, opts)
  return retval
end

function M.kanacolors(opts)
  return M.colors(opts, "kanagawa.colors", { theme = "wave" })
end

return M
