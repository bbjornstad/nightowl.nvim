local OSet = require("uutils.orderedset")

local mod = {}

--- a helper function for this module, which helps the helper function
--- functional.unpacker by doing the "rezipping" of slices out of their
--- constitutent table parent items.
---@vararg any set of arbitrarily sized tables, whose elements should be
---unpacked slice-wise.
local function rezip(arguments)
  local res = {}
  local indices = vim.iter(vim.tbl_map(function(val)
    return vim.tbl_keys(val)
  end, arguments))
  local idxset = indices:fold(OSet({}), function(agg, k, val)
    agg = agg:intersect(val)
  end)

  for _, idx in pairs(idxset) do
    res[idx] = vim.tbl_map(function(val)
      return val[idx]
    end, arguments)
  end
  return res
end

--- a helper function for this module, which helps the batch operation by
--- facilitating the unpacking of slices of elements from the given tables as
--- arguments.
---@vararg any set of arbitrarily sized tables, whose elements should be
---unpacked slice-wise
function mod.unpacker(pretreat, posttreat, arguments)
  pretreat = pretreat or function(...)
    return ...
  end
  posttreat = posttreat or function(...)
    return ...
  end
  arguments = arguments or {}
  local arg_pre = pretreat(arguments)
  -- we need to redo this below so that we can do a different method. In
  -- particular, this computes the length of each table. This is ok when the
  -- keys are numbers. But the general case is that minidx should create the
  -- inidices of what we want out of each table, hence we make the intersection
  -- of the keys for each table and that provides the maximal amount of complete
  -- pairs we can make.
  local rezipped = rezip(arg_pre)
  posttreat(rezipped)
  return rezipped
end

--- wraps a function which operates on individual element slices of a series of
--- table items in such a way that the function can operate agnostically across
--- arbitrarily sized collections of arguments; without loss of generality,
--- given a function f(x, y, z) where x, y, and z are each elements of tables X,
--- Y, and Z,creates a new function accepting tables X, Y, and Z, where the
--- result is the operation of the function f across individual element slices
--- of X, Y, and Z.
---@param func function callable item accepting individual elements of seoparate
---tables.
---@param override_opts table options that should override default selections if
---given.
---@return function wrapper a function which operates on arbitrarily sized
---collections of element slices.
function mod.batch(func, pretreat, override_opts)
  -- func operates on the single elements, we want to map this here across a
  -- collection of k,v pairs.
  -- hence, we are going to do a thing where we create a function wrapper which
  -- performs the map across arbitrary collections passed in. Pretty similar to
  -- unumAI work. In fact, it's the same.
  local function funcwrap(...)
    local res = {}
    local unpacked = mod.unpacker(pretreat, ...) or {}
    for k, val in pairs(unpacked) do
      res[k] = func(unpack(val))
    end
    return res
  end
  return funcwrap
end

--- recursively merges two sets of options, given as table items with optional named keys;
--- this is a deep merge, so fully recursive down each table for the merge. This
--- is most frequently used to add user-defined parameters to plugins which have
--- defaults, but it doesn't make any assumptions about where the data first
--- comes from.
---@param defaults table the default options that should be present if there are
---no user overrides for the matching key.
---@param overrides table the options which should override the defaults by
---passing values explicitly in this table.
---@param error string? one of "suppress" or "raise", indicating what should
---happen if there is no passed overrides to this function. This is helpful in
---cases where it is not clear if the user has passed additional options.
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

    -- TODO: determine if we want to use the below or write a separate similar
    -- function to handle it.
  end

  return overridden
end

--- wraps a function in such a way that its implementation can now accept merged
--- options that result from the functional.mopts function which merges
--- arbitrary optionsk.
---@param func function any function that accepts options which can be merged
---with user specified overrides.
---@param defaults table default values that should be present wherever the user
---does not specify a matching override in the resulting function wrappper that
---is returned.
---@return function wrapper the wrapper that is created such that the signature
---can accept both default options and overrides.
function mod.moptify(func, defaults)
  local function funcwrap(...)
    -- TODO implementation do something here
  end

  return funcwrap
end

--- defers the given callable from evaluation in its immediate context by
--- wrapping it in a secondary function, much like decorators in python.
---@param callable function callable whose evaluation is to be deferred for the
---immediate context.
---@param _return boolean? whether or not the value of the evaluating the
---callable should be returned to the user when calling this function.
---@return function fn wrapper around the argument given as the deferrable
---callable thing.
function mod.lazy_defer(callable, _return)
  _return = _return or false
  local function deferred(...)
    local res = callable(...)
    if _return then
      return res
    end
  end
  return deferred
end

--- defers the given callable from evaluation in its immediate context by
--- wrapping it in a secondary function, much like python decorators. This
--- differs from the similar function `lazy_defer` as it uses a pcall under the
--- hood to catch any errors during evaluation of callable.
---@param callable function callable whose evaluation is to be deferred for the
---immediate context.
---@param _return boolean? whether or not the value of the evaluating the
---callable should be returned to the user when calling this function.
---@return function fn wrapper around the argument given as the deferrable
---callable thing.
function mod.prot_lazy_defer(callable, _return)
  _return = _return or false
  local function deferred(...)
    local status, res = pcall(callable, ...)
    if not status then
      return false
    end
    if _return then
      return res
    end
  end
  return deferred
end

function mod.string_lazy_defer(callable, _return)
  --please hold.
end

--- defers the importation of a module file in its immediate context by simply
--- adding a level of function nesting. This is to ideally prevent issues where
--- requiring an item in the opts field when represented as a table fails due to
--- an apparent timing mismatch issue determining which modules are available at
--- a given moment.
---@param mod string name of the module that is to be required using this
---function.
---@return table deferred the module is returned if it was required
-- successfully.
function mod.defer_require(mod)
  return require(mod)
end

--- makes a function evaluation and returns the results only when the given
--- condition evaluates to true. If the condition is not given, nil is used and
--- the behavior is to simply evaluate func directly and return the results. If
--- the condition is given explicitly but the result of the condition is false,
--- then nothing is returned from this function (rather, nil is explicitly
--- returned). If the condition is true, the function is evaluated and the
--- results returned.
---@param func function a callable itme that is to be conditionalized in the
---manner described.
---@param condition any anything that can be a condition in lua, e.g.
---if conditions.
---@return function fn the function wrapper, accepting any set of arguments
---which are passed directly to the call to func when the condition is true.
function mod.conditionalize(func, condition)
  local function condition_wrapper(...)
    if condition ~= nil then
      -- the condition ends up being given explicitly and is true, so we simply evaluate the function and return
      if condition(...) or condition then
        return func(...)
      end
      -- a condition was supplied explicitly, but it ended up being false. in this
      -- case, we don't want anything to return here, as this function is frequently
      -- used for table building. We have two options, we can either return nothing
      -- in the form of an explicit nil value, which is chosen here, or we could
      -- just not include a return statement in the match-arm that returns nil.

      return nil
    end
    return func(...)
  end
  return condition_wrapper
end

--- the simplest function, denoted eff for f while also meaning fuck
---@vararg _ these are unused in the case of eff, only here for compatibility
---reasons with other functions.
function eff(...) end

return mod
