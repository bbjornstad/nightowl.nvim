local mod = {}

---
-- @section Module manipulation functions - `uutils.mod`
--
-- Anything that is related to loading or unloading of modules should got here
function mod.reload(m)
  package.loaded[m] = nil
  return require(m)
end

function mod._funcmod(mf)
  if pcall(mf) then
    -- this is not a module, this is a function. return the function.
    return mf
  else
    -- this is a module. return the results of the requirement of the
    -- module.
    return require(mf)
  end
end

function mod.call_hooks(...)
  step_setup = { ... }
end

return mod
