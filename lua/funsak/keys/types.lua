---@module funsak.keys.types collection of useful types for keymod-style wrappings for
---keymap definitions.
---

-- ============================================================================
-- Random Miscellaneous/Utility Types
--  namely defines a few aliases that can be used as "pseudo"-generic types that
--  ascribe certain semantic knowledge to function arguments, in terms of what
--  is acceptable input given that Lua has no strong typing.
-- ==================================
---@alias t_fmtstr string a string containing a formatting specification that is
---to be parsed and formatted when the bound key is retrieved.
---@alias t_formatable t_fmtstr|fun(cls: KeyModule, opts: table): t_fmtstr
---@alias LeaderKeySpec string|string[]|table<string,string>|boolean @alias LeaderOptionsSpec {keybind: LeaderKeySpec, inherit: boolean}

local types = {}

---@enum ModifierKey the possible additional keys that can be held alongside a
---certain keymapping in order to alter behavior, this exists mostly to serve as
---a unifying structural joint when parsing out desired modifier behavior and
---mapping that to a string format specification.
types.ModifierKey = {
  shift = "SHIFT",
  ctrl = "CTRL",
  meta = "META",
  alt = "ALT",
  super = "SUPER",
  win = "WIN",
  DEFAULT = false,
}

---@enum ModifierKey.Format formattable strings that can be used when binding modifier
---keys during keybinding calculation, with a straightforward template syntax
---for describing how the component keybind parts are supposed to be assembled.
---It is unclear if there will be an API exposed for the registration of new
---components. There are pros and cons to each format.
types.ModifierKey.Format = {
  shift = "S-{{ MOD }}",
  ctrl = "C-{{ MOD }}",
  meta = "M-{{ MOD}}",
  alt = "A-{{ MOD }}",
  super = "M-{{ MOD }}",
  win = "M-{{ MOD }}",
  DEFAULT = "{{ MOD }}",
}

--- ensures consistency and validity to modifier key formatting adjustments for
--- the purposes of not fucking the keymapping system for neovim itself, mostly
--- by ensuring that the correct punctuation style is used.
---@param modified ModifierKey|ModifierKey[] a valid modifier key, or a
---list-like table of such keys if multiple modifier keys are required.
---@param opts T_Opts function keyword options for configuration, namely
---controls some behavior related to nesting.
---@return string|string[] valid a valid string to pass to an underlying keybind engine,
---namely lazy.nvim or vim.keymap.set directly, describing a key with
---complementary modifier selections, or a list-like table thereof.
function types.ModifierKey.punctuate(modified, opts)
  -- determine if the passed modified argument is a list-like table, if so we
  -- assume that this is supposed to be called recursively to apply action
  -- to all elements.
  if type(modified) == "table" and vim.tbl_islist(modified) then
    return vim.tbl_map(function(m)
      return types.ModifierKey.punctuate(m, opts)
    end, modified)
  else
    -- assume that type is table here, if it wasn't a table to begin with then
    -- we would want to jump to outside this if-block to handle this. Thus we
    -- can say that the previous condition failed because the table wasn't
    -- list-like (and force by construction that the "missed" case is handled in
    -- the remaining scope)
    return types.ModifierKey.punctuate(m.keybind, opts)
  end

  -- type is not table for remaining scope under the preceding assumptions
  if not vim.startswith(modified, [[<]]) then
    modified = [[<]] .. modified
  end
  if not vim.endswith(modified, [[>]]) then
    modified = modified .. [[>]]
  end
  return modified
end

function types.ModifierKey.punctuator(fn)
  return function(...)
    return types.ModifierKey.punctuate(fn(...))
  end
end

--- creates a function that upon execution with a keybind-specifier argument,
--- formats a binding with additional modifier key specifications, thereby
--- modulating the keybind behavior to trigger only when the specific selection
--- of modification keys is additionally pressed alongside the base mapping.
---@param selection ModifierKey
---@param opts T_Opts
---@return fun(bind: KeybindSpecifier): string
function types.ModifierKey.formatter(selection, opts)
  local t_fmt = types.ModifierKey.Format
  local fmt_string = t_fmt[selection] or t_fmt.DEFAULT
  local res = function(bind)
    return string.gsub(fmt_string, "{{ bind }}", bind)
  end

  return (
    opts.punctuator
    and (
      vim.is_callable(opts.punctuator) and opts.punctuator(res)
      or types.ModifierKey.punctuator(res)
    )
  ) or res
end

return types
