---@module "funsak.wrap" utilities for wrapping and manipulating function valued
---items.
---@author Bailey Bjornstad | ursa-major
---@license MIT

--- a collection of utilities that are related to functors acting as a wrap over
--- other functions, in order to enhance the behavior of those wrapped
--- functions. Some of the other `funsak` utilities also fit this description
--- but may be in a more specific submodule if the domain fits.
---@class funsak.wrap
local M = {}

--- makes a function evaluation and returns the results only when the given
--- condition evaluates to true. If the condition is not given, nil is used and
--- the behavior is to simply evaluate func directly and return the results. If
--- the condition is given explicitly but the result of the condition is false,
--- then nothing is returned from this function (rather, nil is explicitly
--- returned). If the condition is true, the function is evaluated and the
--- results returned.
---@param fn function a callable item that is to be conditionalized in the
---manner described.
---@param condition any anything that can be a condition in lua, e.g.
---if conditions.
---@return function fn the function wrapper, accepting any set of arguments
---which are passed directly to the call to func when the condition is true.
function M.conditionalize(fn, condition)
  local function condition_wrap(...)
    if condition ~= nil then
      -- the condition ends up being given explicitly and is true, so we simply
      -- evaluate the function and return
      if condition(...) or condition then
        return fn(...)
      end
      -- a condition was supplied explicitly, but it ended up being false. in
      -- this case, we don't want anything to return here, as this function is
      -- frequently used for table building. We have two options, we can either
      -- return nothing in the form of an explicit nil value, which is chosen
      -- here, or we could just not include a return statement in the match-arm
      -- that returns nil.

      return nil
    end
    return fn(...)
  end
  return condition_wrap
end

--- wraps a function of a a single variable such that it can operate on an
--- interable collection of such input variables as well as the single variable.
--- In other words, given an input function f(var: any): any?, allows the
--- operation of f across iterable collections of var, e.g. by returning a
--- function f'(var: any|any[]): any?
---@param fn fun(var: any, ...): any? a function that accepts at least a single
---argument, which will be wrapped to accept a collection of such `var`
---@param is_method boolean? a flag that indicates whether or not the function
---being wrapped is called using a typical method syntax; this is required to
---safely handle the method case since it is normally assumed that the first
---variable (which would correspond to `self` in a method) is the argument which
---is supposed to be recursed over.
---@return fun(var: any|any[], ...): any? fn the new wrapped function, which can
---accept the collection form of `var`
function M.recurser(fn, is_method)
  is_method = is_method or false
  local recurse_wrap
  if is_method then
    function recurse_wrap(cls, targ, ...)
      local args = { ... }
      if type(targ) == "table" and vim.tbl_islist(targ) then
        return vim.tbl_map(function(t)
          return fn(cls, t, unpack(args))
        end, targ)
      end
      return fn(cls, targ, unpack(args))
    end
  else
    function recurse_wrap(targ, ...)
      local args = { ... }
      if type(targ) == "table" and vim.tbl_islist(targ) then
        return vim.tbl_map(function(t)
          return fn(t, unpack(args))
        end, targ)
      end
      return fn(targ, unpack(args))
    end
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
function M.rezip(arguments)
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
function M.unpacker(pretreat, posttreat, arguments)
  pretreat = pretreat or M.F
  posttreat = posttreat or M.F
  arguments = arguments or {}
  local arg_pre = pretreat(arguments)
  -- we need to redo this below so that we can do a different method. In
  -- particular, this computes the length of each table. This is ok when the
  -- keys are numbers. But the general case is that minidx should create the
  -- inidices of what we want out of each table, hence we make the intersection
  -- of the keys for each table and that provides the maximal amount of complete
  -- pairs we can make.
  local rezipped = M.rezip(arg_pre)
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
function M.batch(func, pretreat, override_opts)
  -- func operates on the single elements, we want to map this here across a
  -- collection of k,v pairs.
  -- hence, we are going to do a thing where we create a function wrapper which
  -- performs the map across arbitrary collections passed in.
  local function wrap(...)
    local res = {}
    local unpacked = M.unpacker(pretreat, ...) or {}
    for k, val in pairs(unpacked) do
      res[k] = func(unpack(val))
    end
    return res
  end
  return wrap
end

---@alias t_Agg
---| any # represents the result of folded-style aggregation, can be
---any type that makes sense given the context in which the aggregation is being
---performed.
---@alias Reduceable
---| any # represents a single item in the collection which is
---the target for a reduction procedure.
---@alias idx_Reduceable
---| Ix<Reduceable>

---@alias Reducer
---| fun(agg: t_Agg, new: Reduceable, init_val: Reduceable?): t_Agg # represents
---the aggregation callback function in the two forms which are acceptable by
---nvim. The signature without an `idx` argument is the more common option, and
---is applied for list-like tables. The signature including `idx` is used only
---for map-like tables. When presented with the opportunity to use this form,
---only do so if the index value itself is relevant for the computation of the
---new aggregation, otherwise the form lacking an `idx` argument is preferred
---for user clarity.

--- a standard reduce implementation, aggregating/"condensing" the tables values
--- sequentially using a specified aggregation function. A foundational
--- component of functional programming tooling, and can serve many seemingly
--- disparate use-cases.
---@param fn Reducer an aggregation function with the inner computation logic
---for the processing of an iterable to produce a single value from its items
---through repeated function application.
---@param tbl table<idx_Reduceable, Reduceable> a series of items for which
---the aggregation function will be applied.
---@param initial Reduceable? an optional parameter which allows adjustment of
---the desired initial value used by the reduce operation. If no parameter is
---given, the initial value is taken to be the first item of `tbl` instead.
function M.reduce(fn, tbl, initial)
  local it = vim.iter(tbl)
  local function folder(agg, key, val)
    return fn(agg, key, val) or fn(agg, val)
  end
  local res = (it:fold(initial, folder))
  return res
end

--- the simplest possible function that can accept arbitrary arguments and does
--- absolutely nothing. this mainly exists when we need a random function to
--- latch onto for other reasons and lack a convenient option with better
--- semantic meaning, or as the "null" result for parameters that expect
--- function values.
---@vararg any[] these exist purely for compatibility with other functions
function M.eff(...) end

--- the simplest possible function accepting arbitrary arguments with full
--- information flow through the wrapper, e.g. the function returns the raw set
--- of varargs given as arguments. This mainly exists when we need a random function to
--- latch onto for other reasons and lack a convenient option with better
--- semantic meaning, or as the "null" result for parameters that expect
--- function values, but specifically for code contexts where there are output
--- values expected corresponding to the number of input values.
---@vararg any[] these exist purely for compatibility with other functions, and
---are returned from `F` unaltered.
function M.F(...)
  return ...
end

---@generic T
---@alias Fn fun(...): T?
--- turns the given function into a callback function. A callback function is in
--- this context simply a bare wrapper around the function.
---@param fn Fn a function to wrap in a callback
---@return Fn fn the callback wrapper
function M.cb(fn)
  return function(...)
    return fn(...)
  end
end

--- turns the given function into a callback function, essentially a bare
--- wrapper around the original function. This is distinct from the behavior in
--- the standard `cb` function, as this allows for additional options to be
--- passed from the top level "factory" invocation.
---@param fn fun(...): any? a function to wrap
---@vararg any[] additional arguments that are given to the call to fn after
---merging with the options passed in the level below.
---@return fun(...): any? the callback
function M.cbmerge(fn, ...)
  local those = { ... }
  return function(...)
    local these = { ... }
    local args = vim.list_extend(those, these)
    return fn(unpack(args))
  end
end

--- wraps the given function such that when called, additional options passed
--- through a standard `opts` argument are treated using the `handler` function
--- before being reinserted into the original function arguments during
--- evaluation of the wrapping.
---@param fn fun(...): any? a function, whose last argument is the `opts` field.
---@param handler fun(opts: owl.GenericOpts): any? function to "handle" the extra opts
---that are passed through the `opts` argument of the original function
---@param consume_optarg boolean? whether or not the opts field that is held in
---the last argument position should be removed for processing, or simply read
---for processing.
---@return fun(...): any? wrapping wrapped function
function M.inject(fn, handler, consume_optarg)
  consume_optarg = consume_optarg or false

  local getopts = function(iter)
    if consume_optarg then
      return iter:nextback()
    end
    return iter:peekback()
  end

  local function wrap(...)
    local args = vim.iter({ ... })
    local opts = getopts(args)
    local handler_results = handler(opts)

    return fn(unpack(args), handler_results)
  end

  return wrap
end

--- "conditional callback" creates a function wrapping factory whose returned
--- output are functions that when evaluated check a condition and applies the
--- affirmative function when true, and a fallback when false
---@param fn fun(...): any? any function whose output should be conditional on
---the result of the given expression.
---@return fun(fallback: (fun(...): any?), condition: any?): any?
function M.ccb(fn)
  return function(fallback, condition)
    condition = condition ~= nil and condition or true
    return function(...)
      if condition then
        return fn(...)
      end
      return fallback(...)
    end
  end
end

local function treat_args(args, treatments, opts)
  opts = opts or {}
  args = vim
    .iter(ipairs(args))
    :map(function(i, val)
      local treater = treatments[i] or M.eff
      return treater(val)
    end)
    :totable()

  return opts.unpack and unpack(args) or args
end

function M.dynamo(tbl_or_fn, arg_treatments)
  arg_treatments = arg_treatments or false
  if vim.is_callable(tbl_or_fn) then
    return function(...)
      local args = { ... }
      if arg_treatments then
        args = vim
          .iter(ipairs(args))
          :map(function(i, val)
            local treater = arg_treatments[i] or M.eff
            return treater(val)
          end)
          :totable()
      end
      return tbl_or_fn(unpack(args))
    end
  else
    return function(...)
      local args = { ... }
      if arg_treatments then
        args = vim
          .iter(ipairs(args))
          :map(function(i, val)
            local treater = arg_treatments[i] or M.eff
            return treater(val)
          end)
          :totable()
      end
      return tbl_or_fn
    end
  end
end

function M.extermiwrap(fn)
  return function(...)
    local args = { ... }
    local maxarg = #args - 1
    local slicer = require("funsak.table").firstn(#args - 1)
    local operargs = vim.iter(args)
    local last = operargs:peekback()
    args = slicer(args)
    local res
    if last.debug == true then
      res = fn(unpack(args))
    end
  end
end

---@alias EvaluatedExpression fun(...): any
--- creates and returns an anonynous function based on the input expression
--- representation as a string in the form: `"arg1,arg2,...argn |="`
---@param expr string expression of form `"arg1,arg2...argn |=> ~expr~"`
---@return EvaluatedExpression fun
function M.lambda(expr) end

return M
