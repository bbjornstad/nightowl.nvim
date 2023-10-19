local mod = {}

function mod.strip(item, strip, suppress_return)
  local res = {}
  for k, v in pairs(strip) do
    res[v] = item[v]
    item[v] = nil
  end
  return res
end

function mod.tabler(item, enforce_list_input, allow_empty_return)
  enforce_list_input = enforce_list_input or false
  allow_empty_return = allow_empty_return or true
  local tbl = type(item) == "table"
      and (enforce_list_input and vim.tbl_islist(item))
      and item
    or { item }
  return not allow_empty_return and (tbl or {}) or tbl
end

---@alias OptifyHandlersPhase Ix_OptsField
---@alias OptsFunction fun(plugin: LazyPluginSpec, opts: T_Opts)|fun(plugin: LazyPluginSpec, opts: T_OptsField)
--- turns a table that is specified in an opts field of a LazyPluginSpec into a
--- function which deeply merges each indexed field of the spec with the _opts
--- argument of the returned function, along with the specified callbacks
--- functions if desired. The aim here is to achieve something that can
--- automatically format such a field in a user's spec to still allow for calls
--- to required functions that belong to plugins which may not yet have been
--- loaded. This solves problems that occur when lazily loading plugins without
--- using a form of "field protection"--in the sense that passing a function
--- allows deferal of plugin requirement after the normal behavior that would
--- otherwise be used if the field were given as a table instead. By doing so,
--- this would allow the user to specify the field in a more standard/readable
--- format, but still allow for the definition of variables or otherwise enable
--- more complex behavior.
---@param opts T_Opts any field specified as a table format, but generally ones
---for which the behavioral modifications allowed with this tool make sense,
---e.g. `opts`. Rarely `keys` could be used. It is unlikely that other fields
---will find all that much utility from this function otherwise.
---@param handlers OptsFunction|OptsFunction[]|table<OptifyHandlersPhase, OptsFunction>
---a collection of optional handlers that should be applied. The behavior is as
---follows: if this argument is a single function, it is applied after the
---merging is complete. If the argument is a list of functions, they are each
---applied successively based on their numerical indices after the merging is
---complete. If the argument is an indexed table of functions, then it is
---assumed that the keys match a subset of the keys of the original opts table,
---and each handler is applied after the specific step that merges a single
---field.
---@param behavior {merge_before: boolean, tbl_merge: MergeBehavior}
---@return OptsFunction optified
function mod.fopts(opts, handlers, behavior)
  opts = opts or {}
  local inset_merge = type(opts) == "table" and not vim.tbl_islist(opts)
  behavior = behavior or {}
  local merge_before = behavior.merge_before or false

  local function get_handler(key)
    key = key or false
    return type(handlers) == "table" and handlers[key] or handlers
  end

  return function(plugin, _opts)
    local handler
    if not inset_merge and merge_before then
      -- this is some weird form of pretreatment I guess.
      handler = get_handler()
      if handler then
        handler(plugin, _opts)
      end
    end

    for k, v in pairs(_opts) do
      handler = get_handler(k)
      if inset_merge and merge_before and handler then
        handler(plugin, v)
      end
      local merged =
        vim.tbl_deep_merge(behavior.tbl_merge or "force", v, opts[k])
      if inset_merge and not merge_before and handler then
        handler(plugin, merged)
      end
      _opts[k] = merged
    end
    if not inset_merge and not merge_before then
      handler = get_handler()
      if handler then
        handler(plugin, _opts)
      end
    end
  end
end

---@alias MOptsError
---| '"suppress"' # error on merging of input tables is not propogated
---| '"error"' # error on merging of input tables is propogated
---
--- recursively merges two sets of options, given as table items with optional named keys;
--- this is a deep merge, so fully recursive down each table for the merge. This
--- is most frequently used to add user-defined parameters to plugins which have
--- defaults, but it doesn't make any assumptions about where the data first
--- comes from.
---@param defaults table the default options that should be present if there are
---no user overrides for the matching key.
---@param overrides table the options which should override the defaults by
---passing values explicitly in this table.
---@param error MOptsError? one of "suppress" or "raise", indicating what should
---happen if there is no passed overrides to this function. This is helpful in
---cases where it is not clear if the user has passed additional options.
---Defaults to `"suppress"`.
---@return table results the table that results from merging the options deeply
---and recursively.
function mod.mopts(defaults, overrides, error)
  error = error or "suppress"
  if error == "suppress" then
    overrides = overrides or {}
    defaults = defaults or {}
  end

  local overridden
  if vim.tbl_islist(overrides) and vim.tbl_islist(defaults) then
    if overridden == nil then
      -- no overrides here
      overridden = defaults
    end
  else
    overridden = vim.tbl_deep_extend("force", defaults, overrides)
  end

  return overridden or {}
end

return mod
