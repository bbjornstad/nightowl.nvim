---@module "funsak.table" utilities for operating and manipulating with lua
---table items, and conversion to/from for use in function definitions, etc.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.table
local M = {}

---@alias T_Iter
---| table
---| any[]

local function _contains(items, tbl)
  return tbl[items] ~= nil
end

function M.contains(tbl, items)
  local f = require("funsak.wrap").recurser(_contains)
  local res = vim.iter(f(items, tbl))
  return res:all(function(i)
    return i
  end)
end

--- collects the items in an iterator into a table with arbitrary keys, in
--- contrast to the standard builtin iterable method `totable` which only really
--- works with list-like maps and nothing containing actual information in the
--- keys.
---@param iter T_Iter iterable collection of things that must be gathered
---together into a single dataset.
---@return table t the collected table.
function M.miter(iter)
  return iter:fold({}, function(t, k, v)
    t[k] = v
    return t
  end)
end

---@generic Ix: any
--- strips off the specified elements from the table. This function will access
--- the items in the table to get their values, store them appropriately, then
--- remove their indices from the original table. Used normally to prepare
--- arguments to functions at the beginning of the implementation, though this
--- is not enforced.
---@param item table<Ix, any> any table for which certain elements should be
---popped
---@param strip Ix | Ix[] indices of the target items to strip out of the `item`
---table
---@param defaults table<Ix, any>? a table containing optional defaults if the
---items are
---@param deepcopy boolean? whether or not the stripped item should be copied
---before assignment into the results table.
---@return table<Ix, any> subset the returned table will be a subset of the
---input table, and the input table will not have the corresponding elements.
function M.strip(item, strip, defaults, deepcopy)
  local res = {}
  strip = type(strip) ~= "table" and { strip } or strip
  defaults = defaults or {}
  deepcopy = deepcopy or false
  for _, v in ipairs(strip) do
    local this = item[v] or defaults[v]
    res[v] = deepcopy and vim.deepcopy(this) or this
    item[v] = nil
  end
  return res
end

function M.dstrip(tbl, items, deepcopy)
  local res = {}
  local strip
  local input_is_list = vim.tbl_islist(items)
  if input_is_list then
    strip = items
  else
    strip = vim.tbl_keys(items)
  end

  deepcopy = deepcopy or false
  for _, v in ipairs(strip) do
    local this = tbl[v] or items[v] or nil
    res[v] = deepcopy and (this and vim.deepcopy(this)) or this
    tbl[v] = nil
  end
  return res
end

--- forces that the specified input item is of a table form, which is to say
--- that if it is a table, the item is returned unchanged, but if not, the item
--- is placed into a new table by itself. Used typically to prepare function
--- arguments that are to be operated on iterably but whose type may not
--- necessarily be iterable.
---@param item any any item that should be squished into a table if it is not
---already one.
---@param enforce_list_input boolean? if the function should fail with an error
---if the input item is not list-like. Defaults to `false`.
---@param return_empty boolean? if the function should return an empty
---table if the computed value does not represent any elements or otherwise
---fails. Defaults to `true`.
function M.tabler(item, enforce_list_input, return_empty)
  enforce_list_input = enforce_list_input or false
  return_empty = return_empty or true
  local tbl = type(item) == "table"
      and (enforce_list_input and vim.tbl_islist(item))
      and item
    or { item }
  return not return_empty and (tbl or {}) or tbl
end

---@alias OptifyHandlersPhase
---| funsak.Ix_Options #

---@alias OptsFunction
---| fun(plugin: LazyPlugin, opts: funsak.GenericOpts)

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
---@param opts funsak.GenericOpts any field specified as a table format, but
---generally ones for which the behavioral modifications allowed with this tool
---make sense, e.g. `opts`. Rarely `keys` could be used. It is unlikely that
---other fields will find all that much utility from this function otherwise.
---@param handlers OptsFunction | OptsFunction[] | { [OptifyHandlersPhase]: OptsFunction }
---a collection of optional handlers that should be applied. The behavior is as
---follows: if this argument is a single function, it is applied after the
---merging is complete. If the argument is a list of functions, they are each
---applied successively based on their numerical indices after the merging is
---complete. If the argument is an indexed table of functions, then it is
---assumed that the keys match a subset of the keys of the original opts table,
---and each handler is applied after the specific step that merges a single
---field.
---@param behavior {merge_phase: OptifyHandlersPhase?, extend: TblExtendBehavior}
---@return OptsFunction optified
function M.fopts(opts, handlers, behavior)
  opts = opts or {}
  local inset_merge = type(opts) == "table" and not vim.tbl_islist(opts)
  behavior = behavior or {}
  local merge_before = vim.tbl_contains(behavior.merge_phase, "before") or false
  local merge_after = vim.tbl_contains(behavior.merge_phase, "before") or false

  local function get_handler(key)
    key = key or nil
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
        vim.tbl_deep_extend(behavior.tbl_merge or "force", v, opts[k])
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

--- recursively merges two sets of options, given as table items with optional
--- named keys; this is a deep merge, so fully recursive down each table for
--- the merge. This is most frequently used to add user-defined parameters to
--- plugins which have defaults, but it doesn't make any assumptions about
--- where the data first comes from.
---@param defaults table? the default options that should be present if there
---are no user overrides for the matching key.
---@param overrides table? the options which should override the defaults by
---passing values explicitly in this table.
---@param error TblExtendErrorBehavior? one of "suppress" or "raise", indicating what should
---happen if there is no passed overrides to this function. This is helpful in
---cases where it is not clear if the user has passed additional options.
---Defaults to `"suppress"`.
---@return table? results the table that results from merging the options deeply
---and recursively.
function M.mopts(defaults, overrides, error)
  error = error or "suppress"
  if error == "suppress" then
    overrides = overrides or {}
    defaults = defaults or {}
  end

  local overridden = vim.tbl_deep_extend("force", defaults, overrides)
  return overridden
end

--- merges recursively and deeply the input arguments. This is basically the
--- same as the `mopts` function which is used commonly but can work on multiple
--- tables, not only a single pair, but the signature is switched.
---@param error TblExtendErrorBehavior?
---@param defaults table the default selections which will be used when no toher
---matching key is present to override the value.
---@vararg table[] other tables that should be considered during recursive
---merging.
---@return table the merged table
function M.rmopts(error, defaults, ...)
  error = error or "suppress"
  defaults = defaults or {}

  return vim.tbl_deep_extend("force", defaults, unpack({ ... }))
end

--- merges list-like tables using the vim.list_extend standard library function.
--- This is different from any `mopts` derivative as this extends the list, e.g.
--- there could be duplicated entries using this function.
---@param defaults any[]
---@param overrides any[]
---@param error ("suppress" | "raise")? whether an error should be raised if
---either of the operands are missing. Defaults to "suppress".
---@return any[] list the final list-like extension.
function M.lopts(defaults, overrides, error)
  error = error or "suppress"
  if error == "suppress" then
    overrides = overrides or {}
    defaults = defaults or {}
  end

  defaults = vim.list_extend(defaults, overrides)
  return defaults
end

local strsplit = require("funsak.string").split
function M.rget(tbl, field, sep)
  sep = sep or "."
  local fields = strsplit(field, sep)
  local res

  local operated_on = vim.deepcopy(tbl)
  if fields ~= nil then
    for _, fld in ipairs(fields) do
      operated_on = operated_on[fld]
    end
  else
    require("funsak.lazy").warn(
      "No indexing field given, returning entire table..."
    )
  end
  return operated_on
end

function M.xtd(behavior, deep_extend, ...)
  --- We only merge empty tables or tables that are not an array (indexed by integers)
  local function can_merge(v)
    return type(v) == "table" and (vim.tbl_isempty(v) or not vim.tbl_isarray(v))
  end

  if
    behavior ~= "error"
    and behavior ~= "keep"
    and behavior ~= "force"
    and not vim.is_callable(behavior)
  then
    error("invalid \"behavior\": " .. tostring(behavior))
  end

  if select("#", ...) < 2 then
    error(
      "wrong number of arguments (given "
        .. tostring(1 + select("#", ...))
        .. ", expected at least 3)"
    )
  end

  local ret = {}
  if
    vim._empty_dict_mt ~= nil
    and getmetatable(select(1, ...)) == vim._empty_dict_mt
  then
    ret = vim.empty_dict()
  end

  for i = 1, select("#", ...) do
    local tbl = select(i, ...)
    vim.validate({ ["after the second argument"] = { tbl, "t" } })
    if tbl then
      for k, v in pairs(tbl) do
        if deep_extend and can_merge(v) and can_merge(ret[k]) then
          ret[k] = M.xtd(behavior, true, ret[k], v)
        elseif behavior ~= "force" and ret[k] ~= nil then
          if vim.is_callable(behavior) then
            ret[k] = behavior(ret[k], v)
          elseif behavior == "error" then
            error("key found in more than one map: " .. k)
          end -- Else behavior is "keep".
        else
          ret[k] = v
        end
      end
    end
  end
  return ret
end

function M.idxr(list)
  local res = {}
  for _, v in ipairs(list) do
    res[v] = v
  end
  return res
end

--- converts a list-like table into a table whose keys are the corresponding
--- list items and the value is their ordering; essentially just a reversing of
--- keys and values.
---@param tbl table list like collection
---@return table { [any]: integer }
function M.idxlist(tbl)
  local res = {}
  for i, v in pairs(tbl) do
    res[v] = i
  end
  return res
end

function M.slice(tbl)
  local mt = getmetatable(tbl)
  mt.slice = function(t, first, last)
    local keys = vim.tbl_keys(t)
    keys = vim.tbl_filter(function(v)
      if v < first or v > last then
        return false
      end
      return true
    end, keys)
    return vim
      .iter(M.idxlist(keys))
      :map(function(k, v)
        return tbl[k]
      end)
      :totable()
  end
end

function M.firstn(n)
  return function(tbl)
    return vim
      .iter(tbl)
      :enumerate()
      :filter(function(i, v)
        if not i > n then
          return v
        end
      end)
      :map(function(ivpair)
        local i, v = unpack(ivpair)
        return v
      end)
      :totable()
  end
end

function M.zip(indexer, values)
  local res = {}
  for i, v in ipairs(indexer) do
    local new_idx = indexer[i]
    local new_val = values[i]
    res[new_idx] = new_val
  end
  return res
end

---@generic Axis: table
--- creates a handler which accepts a function operating over a certain feature
--- element of the given table, and effectively maps the input function along
--- the chosen axis. Generally a thin wrapper around calls to vim standard
--- library iterable operation functions, but with some additional conveniences
--- to make this a bit more helpful
---@param tbl table any table type could theoretically use this function. Most
---often, this will be hidden away behind a method-invocation syntax using a
---`:`. But this is not strictly necessary, and this function can be called
---directly on the table and indexer directly from the module.
---@param idxr Axis reference to an `axis` of the table `tbl`. Note that this
---can be
function M.per(tbl, idxr)
  return function(fn, ...)
    local args = { ... }
    local idx = vim.iter(idxr)
    idx:map(function(k, v)
      -- there are really two possibilities here, either we are iterating over a
      -- list-like item in which case,
      return fn(v, unpack(args))
    end)
  end
end

return M
