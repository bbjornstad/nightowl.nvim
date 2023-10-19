local mod = {}

--- makes a function evaluation and returns the results only when the given
--- condition evaluates to true. If the condition is not given, nil is used and
--- the behavior is to simply evaluate func directly and return the results. If
--- the condition is given explicitly but the result of the condition is false,
--- then nothing is returned from this function (rather, nil is explicitly
--- returned). If the condition is true, the function is evaluated and the
--- results returned.
---@param func function a callable item that is to be conditionalized in the
---manner described.
---@param condition any anything that can be a condition in lua, e.g.
---if conditions.
---@return function fn the function wrapper, accepting any set of arguments
---which are passed directly to the call to func when the condition is true.
function mod.conditionalize(func, condition)
  local function condition_wrapper(...)
    if condition ~= nil then
      -- the condition ends up being given explicitly and is true, so we simply
      -- evaluate the function and return
      if condition(...) or condition then
        return func(...)
      end
      -- a condition was supplied explicitly, but it ended up being false. in
      -- this case, we don't want anything to return here, as this function is
      -- frequently used for table building. We have two options, we can either
      -- return nothing in the form of an explicit nil value, which is chosen
      -- here, or we could just not include a return statement in the match-arm
      -- that returns nil.

      return nil
    end
    return func(...)
  end
  return condition_wrapper
end

function mod.recurser(fn)
  local function recurse_wrap(targ, ...)
    local args = { ... }
    if type(targ) == "table" then
      return vim.tbl_map(function(t)
        return fn(t, unpack(args))
      end, targ)
    end
    return fn(targ, unpack(args))
  end

  return recurse_wrap
end

local OSet = require("funsak.orderedset")
--- a helper function for this module, which helps the helper function
--- functional.unpacker by doing the "rezipping" of slices out of their
--- constitutent table parent items.
---@param arguments table[] arguments any set of arbitrarily sized tables, whose
---elements should be unpacked slice-wise.
---@return table list containing a slice of each table at the top-level
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
  pretreat = pretreat or mod.F
  posttreat = posttreat or mod.F
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
---@param func function callable item accepting individual elements of separate
---tables.
---@param override_opts table options that should override default selections if
---given.
---@return function wrapper a function which operates on arbitrarily sized
---collections of element slices.
function mod.batch(func, pretreat, override_opts)
  -- func operates on the single elements, we want to map this here across a
  -- collection of k,v pairs.
  -- hence, we are going to do a thing where we create a function wrapper which
  -- performs the map across arbitrary collections passed in.
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

---@generic t_Agg any represents the result of folded-style aggregation, can be
---any type that makes sense given the context in which the aggregation is being
---performed.
---@generic t_Reduceable any represents a single item in the collection which is
---the target for a reduction procedure.
---@generic idx_Reduceable any represents the type of the index item, relevant
---only in the rare case where the `tbl `
---@alias Reducer fun(agg: t_Agg, new: t_Reduceable): t_Agg | fun(agg: t_Agg, idx: idx_Reduceable, val: t_Reduceable)
---represents the aggregation callback function in the two forms which are acceptable
---by nvim. The signature without an `idx` argument is the more common option, and is
---applied for list-like tables. The signature including `idx` is used only for
---map-like tables. When presented with the opportunity to use this form, only
---do so if the index value itself is relevant for the computation of the new
---aggregation, otherwise the form lacking an `idx` argument is preferred for
---user clarity.
--
--- a standard reduce implementation, aggregating/"condensing" the tables values
--- sequentially using a specified aggregation function. A foundational
--- component of functional programming tooling, and can serve many seemingly
--- disparate use-cases.
---@param fn Reducer an aggregation function with the
---inner computation logic for the processing of an iterable to
---produce a single value from its items through repeated function application.
---@param tbl table<idx_Reduceable, t_Reduceable> a series of items for which the aggregation
---function will be applied.
---@param initial t_Reduceable? an optional parameter which allows adjustment of
---the desired initial value used by the reduce operation. If no parameter is
---given, the initial value is taken to be the first item of `tbl` instead.
function mod.reduce(fn, tbl, initial)
  local it = vim.iter(tbl)
  local function folder(agg, key, val)
    return fn(agg, key, val) or fn(agg, val)
  end
  local res = (it:enumerate():fold(initial, folder))
  vim.notify(vim.inspect(res))
  return res
end

--- the simplest possible function that can accept arbitrary arguments and does
--- absolutely nothing. this mainly exists when we need a random function to
--- latch onto for other reasons and lack a convenient option with better
--- semantic meaning, or as the "null" result for parameters that expect
--- function values.
---@vararg any[] these exist purely for compatibility with other functions
function mod.eff(...) end

--- the simplest possible function accepting arbitrary arguments with full
--- information flow through the wrapper, e.g. the function returns the raw set
--- of varargs given as arguments. This mainly exists when we need a random function to
--- latch onto for other reasons and lack a convenient option with better
--- semantic meaning, or as the "null" result for parameters that expect
--- function values, but specifically for code contexts where there are output
--- values expected corresponding to the number of input values.
---@vararg any[] these exist purely for compatibility with other functions, and
---are returned from `F` unaltered.
function mod.F(...)
  return ...
end

return mod
