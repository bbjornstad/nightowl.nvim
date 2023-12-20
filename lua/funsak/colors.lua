---@module "funsak.colors" color manipulation utilities for functional swiss army
---knives and lazy nvim configurations.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@alias hexadecimal
---| string # a string consisting of two characters and whose digits represent
---numbers in base 16. This is obviously constructed such that 0-255 are the
---possible numerical values represented with the characters between "00" and
---"FF".

---@alias RGBColor { red: integer, green: integer, blue: integer, alpha: integer? }
---@alias HSVColor { hue: integer, sat: integer, light: integer, alpha: integer? }
---@alias Hexpanded { red: hexadecimal, green: hexadecimal, blue: hexadecimal, alpha: hexadecimal? }
---@alias HexColor
---| string # a string of the form "#??????" or "#????????", where each successive
---pair of hexadecimal digits represents the red, green, and blue channels. If
---the string has a full 8 characters, the last pair represents the alpha
---channel.
---| Hexpanded # Hex representation in table form with individual components
---separated but given in hex form

---@alias ColorPresentation
---| RGBColor # color in RGB format
---| HSVColor # color in HSV format
---| HexColor # color in Hex format

---@alias HighlightGroup
---| string # name of a highlight group

---@alias ColorScheme
---| string # name of a colorscheme

---@alias HlGroupDefn
---| vim.api.keyset.highlight # a mapping from highlight attributes to values.

---@class funsak.colors
local M = {}

function M.rgb_to_hcl(color) end

---@generic Point: table any table, generally should be thought of as an
---individual item in a group of comparable items. Comparable in this case means
---from the same metric space.
---
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

--- configuration options for color tranformation that scales the "intensity" of
--- the color by adjusting the final "value" component in HSV space, but which
--- keeps general hue and saturation.
---@class ScaleIntensitySpec
---@field lighten number? float scaling factor which is first mapped using the
---appropriate method, then applied as an increase in the `value` component.
---(default 0)
---@field darken number? float scaling factor which is first mapped using the
---appropriate method, then applied as a decrease in the `value` component.
---(default 0)
---@field scale_method ("exp" | "log" | "lin")? function mapping form that
---should be used to perform the scaling, "exp" corresponds to exponential,
---"log" for natural logarithm, and "lin" for the standard linear. (default
---"lin")
---@field output_space ("rgb" | "hsv" | "infer")? if a specific representation
---of color is desired, it can be specified here, otherwise use "infer" to
---return the color in the same presentation as the input color. (default
---"infer")

function M.noramlize_rgb(color)
  local red = color.red
  local blue = color.blue
  local green = color.green
  local alpha = color.alpha or 256
  if not red or not blue or not green then
    vim.notify(
      "Specified color is of incorrect format, please make sure that this color is a valid color in RGB representation"
    )
    return
  end

  return {
    red = red / 256,
    blue = blue / 256,
    green = green / 256,
    alpha = alpha / 256,
  }
end

--- lightens or darkens the given color, by first converting the color to hsv
--- space and then scaling the `value` component according to the user
--- parameters.
---@param color ColorPresentation any color form will work, using a non HSV form
---will force a conversion into HSV to start.
---@param opts ScaleIntensitySpec? intensity scaling operation configuration
---options.
function M.scale_intensity(color, opts)
  opts = opts or {}
  opts.lighten = opts.lighten ~= nil and opts.lighten or 0
  opts.darken = opts.darken ~= nil and opts.darken or 0
  opts.output_space = opts.output_space or "rgb"
end

--- computes the distance between two colors in RGB space. This is essentially
--- just the calculation of a notion of distance which makes sense according to
--- analytical principles of metric spaces
--- (https://en.wikipedia.org/wiki/Metric_space). Note that since hex values are
--- simply a different textual representation of RGB space, it suffices to
--- calculate this for general rgb values and use a separater conversion
--- function to achieve the hex metrics.
---@param color RGBColor
---@param other RGBColor
function M.metric_rgb(color, other)
  color = M.normalize_rgb(color)
  other = M.normalize_rgb(other)
  local red = (color.red - other.red) ^ 2
  local green = (color.green - other.green) ^ 2
  local blue = (color.blue - other.blue) ^ 2
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
---@param color HSVColor
---@param other HSVColor
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
---@param hls HighlightGroup | HighlightGroup[] list of highlight group names
---that are to receive the `opts` as their definitions.
---@param opts T_Opts options that are passed to the underlying call to
---nvim_set_hl
function M.initialize_custom_highlights(hls, opts)
  hls = type(hls) ~= "table" and { hls } or hls
  vim.tbl_map(function(n)
    vim.api.nvim_set_hl(0, n, opts)
  end, hls)
end

--- retrieves the foreground color of the specified highlight group.
---@param hlgroup HighlightGroup
---@param link boolean? shows the linked highlight group name instead of the
---"effective definition". Needs a good example of behavior. Defaults to `true`.
---@return string color the color of the foreground of the specified highlight
---group
function M.identify_highlight(hlgroup, link)
  link = link or true
  local labeled_hl = vim.api.nvim_get_hl(0, { name = hlgroup, link = link })
  return labeled_hl.fg or labeled_hl.guifg
end

--- a safe function to call to get highlight definitions, even across versions
--- of lua/nvim which are lacking the most up to date form of
--- `vim.api.nvim_get_hl`
---@diagnostic disable-next-line: undefined-doc-param
---@param name string name of the highlight group to return
---@return HighlightGroup hl the definition of the target group, if it
---exists.
M.get_hl = vim.api.nvim_get_hl
    and function(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end
  or function(name)
    ---@diagnostic disable-next-line: deprecated
    return vim.api.nvim_get_hl_by_name(name, true)
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
---@param name HighlightGroup
---@param component string | string[] highlight group property names
---@param hlmap HlGroupDefn? if desired, a remapping of old highlight
---group properties to new highlight group properties can be given. The values
---for each of the constituent highlight components for components indexed by
---the `hlmap` parameter will instead be mapped to the corresponding remapped
---component portions. For example, if a map { bg = "fg" } is provided, then
---background values in the new definition are derived from the "fg" values in
---the original definition.
---@return HlGroupDefn
function M.component(name, component, hlmap)
  component = type(component) ~= "table" and { component } or component
  local f = require("funsak.wrap").recurser(hl_component)
  local fres = f(component, name, hlmap)
  local ret = vim.tbl_deep_extend("force", {}, unpack(fres))
  -- vim.notify("postcomp" .. vim.inspect(ret))
  return ret
end

--- returns the currently selected colorscheme.
---@return string name colorscheme name
function M.current_scheme()
  return vim.g.colors_name or vim.cmd([[colorscheme]])
end

---@class HlTargetSpec
---@field namespace { name: string?, clear_existing: (boolean | fun(ns_id: integer, ns_name: string): boolean)? }
---@field buffer { bufnr: integer? }
---@field merge_behavior ("override" | "inherit" | "intersect")?

--- applys a highlight definition, with additional wrapping around the internal
--- call to `vim.api.nvim_set_hl` with some manipulations of the highlight
--- namespace based on the selected or current colorscheme.
---@param name string
---@param defhl HlGroupDefn
---@param opts HlTargetSpec
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
---@param defhl HlGroupDefn highlight definition mapping.
---@param namespace string? if desired, the target namespace can be given here,
---otherwise the current colorscheme is used.
---@return HlGroupDefn inherited highlight definition with
---overrides.
function M.from_hl(name, defhl, namespace)
  local hl = M.get_hl(name)
  local new_def = vim.tbl_deep_extend("force", hl, defhl)
  return new_def
end

--- updates a highlight definition with the specified new highlight definition
--- mapping values, optionally in a user-targeted highlight namespace.
---@param name string highlight group name which is to be updated
---@param hlmap HlGroupDefn | HlGroupDefn[] highlight
---definition values
---@param namespace string? target highlight namespace, if desired. Otherwise,
---the current colorscheme is used.
---@return HlGroupDefn merged the merged components that are the
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
M.schemaphore = {}
M.schemaphore.__index = M.schemaphore

function M.schemaphore:register(scheme, accessor_spec)
  self[scheme] = self:parse_accessors(accessor_spec)
end

local dynamo = require("funsak.wrap").dynamo

function M.schemaphore:parse_accessors(spec)
  local highlight_override = spec.hl_override
  local palette = spec.palette
  local theme = spec.semantic_theme

  if vim.is_callable(highlight_override) then
    highlight_override = function(scheme, opts)
      return highlight_override(require(scheme), opts)
    end
  else
    highlight_override = function(scheme, opts)
      local subfield = rget(require(scheme), opts.field)
      if vim.is_callable(subfield) then
        return subfield(opts)
      end
      return subfield
    end
  end

  if vim.is_callable(palette) then
    palette = function(scheme, opts)
      return palette(require(scheme), opts)
    end
  else
    palette = function(scheme, opts) end
  end
end

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
