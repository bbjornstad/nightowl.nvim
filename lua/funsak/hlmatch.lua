--- a submodule whose purpose is to identify the "matched" highlight options and
--- ensure consistency in group definitions when switching colorschemes. The
--- hope is to create a submodule which can (more or less) agnostically create
--- highlight groups, while maintaining the same level of readability or UI
--- styling even when the colorscheme is switched.
---@class HLMatcher
local HLMatcher = {}
HLMatcher.matches = {}
HLMatcher.derivatives = {}
HLMatcher.namespace = 0

--- a spruced up highlight with the ability to resolve itself into a dynamic
--- definition determined by the active or target colorscheme.
---@class HLMatch: owhl.NvimHighlight
---@field registry {MatchColorscheme: HLComponentValue|fun(opts: T_Opts): HLComponentValue}
local HLMatch = {}
HLMatch.registry = {}

function HLMatch:register(scheme, opts)
  local prev = self.registry[scheme]
  if not prev then
    self.registry[scheme] = {}
  end
end

function HLMatch:add(name, scheme, hl, opts)
  local prev = self.registry[scheme]
  local add_to = prev[name] or {}
  prev[name] = require("funsak.table").mopts(add_to, hl)
end

function HLMatch:highlights(scheme)
  return vim.tbl_map(function(hl)
    return scheme .. "." .. hl
  end, self:get(scheme))
end

function HLMatch:new(name, scheme, hl, opts)
  opts = opts or {}
  hl = hl or {}
  hl = type(hl) ~= "table" and { link = hl } or hl
  self.group = name
  self.description = opts.description or nil
  self.namespace = opts.namespace or 0

  setmetatable(hl, self)
  hl:register(scheme, opts)
  hl:add(name, scheme, hl, opts)
  return hl
end

-- TODO: determine if this is the most effective way of going about
-- this...ultimately the goal is:
-- 1. register custom highlight values (mainly colors) to all colorschemes that
--    are installed, or otherwise a subset of them.
-- 2. on load, make sure that the set representation for a given highlight group
--    matches the colorscheme that is being selected or targeted.

function HLMatch:parse(color)
  local hex_match = "#%x"
  local rgb_match = { red = false, green = false, blue = false, alpha = false }
  local rgb_str_match = "r:%x,g:%x,b:%x,a:%x"
  local hsl_match =
    { hue = false, saturation = false, lightness = false, transparency = false }
  local hsl_str_match = "h:%x,s:%x,l:%x,a:%x"

  if type(color) == "table" then
  end
  return
end

function HLMatch:targets(name, opts)
  local targets = vim.tbl_map(function(v)
    return vim.tbl_contains(vim.tbl_keys(v), name)
  end, self.registry)
  local iter_tgt = vim.iter(targets)
  return targets,
    iter_tgt:all(function(x)
      return x
    end),
    iter_tgt:any(function(x)
      return x
    end)
end
--- transforms a color or scheme into a mapped-representation in hexadecimal
--- notation.
---@param target string | { [string]: Color }
function HLMatch:hex(target) end

function HLMatch:rgb(scheme) end

function HLMatch:hsl(scheme) end

function HLMatch:get(scheme, opts)
  local potential = self.registry[scheme]
  return vim.is_callable(potential) and potential(opts) or potential
end

function HLMatch:factor(opts)
  -- TODO: implement the following factor multiplication for visual
  -- lightening/darkening on the fly.
  return (opts.factor or 1.0) * 1
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
