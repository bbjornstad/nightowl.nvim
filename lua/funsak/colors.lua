---@module "funsak.colors" color manipulation utilities for functional swiss army
---knives and lazy nvim configurations.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@alias hexadecimal string a string consisting of two characters and whose
---digits represent numbers in base 16. This is obviously constructed such that
---0-255 are the possible numerical values represented with the characters
---between "00" and "FF"

---@alias RGBColor { red: integer, green: integer, blue: integer, alpha: integer? }
---@alias HSLColor { hue: integer, sat: integer, light: integer, alpha: integer? }
---@alias HexColor { red: hexadecimal, green: hexadecimal, blue: hexadecimal, alpha: hexadecimal? }
---@alias T_Color RGBColor | HSLColor | HexColor

---@class funsak.colors
local M = {}

---@alias owhl.ColorScheme string represents a valid name for an installed
---colorscheme
---@alias owhl.HighlightGroup string represents a valid highlight group name
---@alias owhl.ix_HlComponent string represents a valid highlight group
---component, such as `guifg`
---@alias owhl.HlComponent table represents the matching values of a highlight
---group component, such as the color represented as a string or the status of
---other text styling like `underline`

---@alias owhl.NvimHighlightComponents { [owhl.ix_HlComponent]: owhl.HlComponent? }
---@alias owhl.NvimHighlight owhl.NvimHighlightComponents

function M.rgb_to_hcl(color) end

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
  local red = (color.red - other.red) ^ 2
  local green = (color.green - other.green) ^ 2
  local blue = (color.blue - other.blue) ^ 2
  return math.sqrt(red + green + blue)
end

--- computes the distance between two colors in HSL space. This is essentially
--- the calculation of a notion of distance which makes sense according to
--- analytical principles of metric spaces
--- (https://en.wikipedia.org/wiki/Metric_space). This is a slightly different
--- representation of the color-space than RGB and so we also provide the metric
--- implementation in this context so that conversion into RGB values is not
--- strictly necessary (though very likely). I believe that the
--- conversion/transformation is basically a projection onto a radial, e.g.
--- circular curve. Supposedly this provides a more accurate representation of
--- how colors blend physically to create new colors.
---@param color HSLColor
---@param other HSLColor
function M.metric_hsl(color, other) end

--- sets the given highlight groups to have the definitions specified as
--- options.
---@param hls owhl.HighlightGroup[] list of highlight group names that are to receive
---the `opts` as their definitions.
---@param opts T_Opts options that are passed to the underlying call to
---nvim_set_hl
function M.initialize_custom_highlights(hls, opts)
  hls = type(hls) ~= "table" and { hls } or hls
  vim.tbl_map(function(n)
    vim.api.nvim_set_hl(0, n, opts)
  end, hls)
end

--- retrieves the foreground color of the specified highlight group.
---@param hlgroup owhl.HighlightGroup
---@param link boolean? shows the linked highlight group name instead of the
---"effective definition". Needs a good example of behavior. Defaults to `true`.
---@return string color the color of the foreground of the specified highlight
---group
function M.identify_highlight(hlgroup, link)
  link = link or true
  local labeled_hl = vim.api.nvim_get_hl(0, { name = hlgroup, link = link })
  return labeled_hl.fg or labeled_hl.guifg
end

M.hl = vim.api.nvim_get_hl
    and function(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end
  or function(name)
    return vim.api.nvim_get_hl_by_name(name, true)
  end

local function hl_component(component, name, hlmap)
  hlmap = hlmap or {}
  component = component or "fg"
  local hl = M.hl(name)
  local comp = hl and hl[component] or nil
  local compid = hlmap and hlmap[component] or component
  return comp and { [compid] = string.format("#%06x", comp) } or nil
end

--- retrieves the values of the given highlight group component properties from
--- the highlight group with the specified names.
---@param name owhl.HighlightGroup
---@param component string | string[] highlight group property names
---@return owhl.NvimHighlight
function M.component(name, component, hlmap)
  local f = require("funsak.wrap").recurser(hl_component)
  local fres = f(component, name, hlmap)
  local should_reduce = type(fres) == "table"
    and vim.iter(fres):all(function(item)
      return type(item) ~= "table"
    end)
  return should_reduce
      and require("funsak.wrap").reduce(function(agg, new)
        vim.notify(vim.inspect(agg))
        vim.notify(vim.inspect(new))
        return vim.tbl_deep_extend("force", agg, new)
      end, fres, {})
    or fres
end

local function hl_adjust(augment, name, opts)
  opts = opts or {}
  local hl = M.hl(name)
  local new_def = vim.tbl_deep_extend("force", hl, augment)
  local has_link = vim.tbl_contains(vim.tbl_keys(new_def), "link")
  return has_link and (opts.follow_links and { link = new_def.link }) or new_def
end

--- modifies or creates a neovim highlight definition with the specified
--- augmentations, returning either the new highlight or the modified highlight
--- if the definition already existed; serves to allow for new coloration to be
--- added to the existing highlight behavior.
---@param name owhl.HighlightGroup name of neovim highlight group
---@param augments owhl.NvimHighlightComponents highlight group
---component mapping
---@param opts T_Opts
---@return owhl.NvimHighlight
function M.sethl(name, augments, opts)
  local f = require("funsak.wrap").recurser(hl_adjust)
  local fres = f(augments, name, opts)
  local should_reduce = type(fres) == "table"
    and vim.iter(fres):all(function(item)
      return type(item) ~= "table"
    end)
  return should_reduce
      and require("funsak.wrap").reduce(function(agg, new)
        vim.tbl_deep_extend("force", agg, new)
      end, fres, {})
    or fres
end

---@param opts table Maps the item that is to be colored to a string of the
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
