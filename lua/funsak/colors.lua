local mopts = require("funsak.table").mopts

local mod = {}

---@alias MatchColorscheme string represents a valid name for an installed
---colorscheme
---@alias HLGroupName string represents a valid highlight group name
---@alias HLGroupComponent string represents a valid highlight group component,
---such as `guifg`
---@alias HLComponentValue string represents the matching value of a highlight
---group component, such as the color represented as a string or the status of
---other text styling like `underline`

---@class HLMatcher a submodule whose purpose is to identify the "matched"
---highlight options and ensure consistency in group definitions when switching
---colorschemes. The hope is to create a submodule which can (more or less)
---agnostically create highlight groups, while maintaining the same level of
---readability or UI styling even when the colorscheme is switched.
local HLMatcher = {}
HLMatcher.matches = {}
HLMatcher.derivatives = {}

---@class NvimHighlight represents an internal highlight definition from neovim
---directly. This is not used directly, it simply exists as a method of allowing
---for the inheritence of `HLMatch` items as being directly created from the
---internal highlight.
local NvimHighlight = {
  ["fg"] = false,
  ["bg"] = false,
  ["sp"] = false,
  ["blend"] = false,
  ["bold"] = false,
  ["standout"] = false,
  ["underline"] = false,
  ["undercurl"] = false,
  ["underdouble"] = false,
  ["underdotted"] = false,
  ["underdashed"] = false,
  ["strikethrough"] = false,
  ["italic"] = false,
  ["reverse"] = false,
  ["nocombine"] = false,
  ["link"] = false,
  ["default"] = false,
  ["ctermfg"] = false,
  ["ctermbg"] = false,
  ["cterm"] = false,

  -- these only have effect in graphical (non-terminal) nvim versions = false.
  ["guifg"] = false,
  ["guibg"] = false,
}

---@class HLMatch: NvimHighlight a spruced up highlight with the ability to
---resolve itself into a dynamic definition determined by the active or target
---colorscheme.
local HLMatch = {}

--- registers a new highlight group to be tracked by the Matcher, thereby
--- allowing for granular configuration between schemes if necessary.
---@param scheme MatchColorscheme|MatchColorscheme[] a colorscheme or list of
---colorscheme to which the new group definition is registered under
---@param group HLGroupName|HLGroupName[] a highlight group name or list of
---such names to which the new options should be registered.
---@param derivative_opts table<HLGroupComponent, HLComponentValue> the
---definitions of highlight components that are specific to this registration.
function HLMatcher:register_derivatives(scheme, group, derivative_opts) end

local function __register_scheme(registry, scheme, opts)
  registry[scheme] = mopts(registry[scheme] or {}, opts)
  return registry
end

function HLMatcher:register_schemes(schemes, opts)
  local schemer = require("funsak.wrap").recurser(function(s, o)
    return __register_scheme(self.matches, s, o)
  end)
  return schemer(self.matches, schemes, opts)
end

function HLMatcher:get(schemes)
  if schemes == nil then
    return self.matches
  end

  local schemer = require("funsak.wrap").recurser(function(s)
    return self.matches[s]
  end)

  return schemer(schemes)
end

function HLMatcher:hl(schemes, opts) end

--- sets the given highlight groups to have the definitions specified as
--- options.
---@param hls HLGroupName[] list of highlight group names that are to receive
---the `opts` as their definitions.
---@param opts table<HLGroupComponent, table> table whose index keys refer to
---highlight components
function mod.initialize_custom_highlights(hls, opts)
  hls = type(hls) ~= "table" and { hls } or hls
  vim.tbl_map(function(n)
    vim.api.nvim_set_hl(0, n, opts)
  end, hls)
end

--- retrieves the foreground color of the specified highlight group.
---@param hlgroup string highlight group name
---@param link string if the highlight group is accessible by link, this
---argument can accept the name. Defaults to `true`.
---@return string color the color of the foreground of the specified highlight
---group
function mod.identify_highlight(hlgroup, link)
  link = link or true
  local labeled_hl = vim.api.nvim_get_hl(0, { name = hlgroup, link = link })
  return labeled_hl.fg or labeled_hl.guifg
end

--- formats the necessary field access and method calls to bring in well-defined
--- colors from the colorscheme Kanagawa. This will need to be remimplemented
--- in the future to accept other themes as well.This gets around an apparent function call
--- timing issue where the kanagawa.colors item is not yet accessible when the
--- definition is made. By using this function, you are effectively deferring the
--- evaluation of the color definition until it is directly accessed.
---
---@param opts table: Maps the item that is to be colored to a string of the
--- color that it should receive.
---@param scheme_target string: Identifies an item that is to be required in the
---sense of calling lua's require to bring the main definitions into focus.
function mod.colors(opts, scheme_target, scheme_cfg)
  scheme_target = scheme_target or "kanagawa.colors"
  scheme_cfg = scheme_cfg or {}
  local function itemized_color(colorname)
    local retval = require(scheme_target).setup(scheme_cfg).palette[colorname]
    return retval
  end

  local retval = vim.tbl_map(itemized_color, opts)
  return retval
end

function mod.kanacolors(opts)
  return mod.colors(opts, "kanagawa.colors", { theme = "wave" })
end

return mod
