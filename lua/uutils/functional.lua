local mod = {}

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
---@return module deferred the module is returned if it was required
---successfully.
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
---@param func callable function that is to be conditionalized in the manner
---described.
---@param condition expression anything that can be a condition in lua, e.g.
---if conditions.
---@return callable fn the function wrapper, accepting any set of arguments
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

return mod
