local mod = {}

function mod.from_env(varname, caster)
  caster = caster or function(...)
    return ...
  end

  local res = os.getenv(varname)
  return caster(res)
end

function mod.bool_from_env(varname)
  return mod.from_env(varname, function(val)
    if val == "true" then
      return true
    end
    return false
  end)
end

function mod.toboolean(v)
  local ok, res = pcall(tonumber, v)
  if ok then
    return res
  end
  if v == "false" or not v then
    return false
  elseif v == "true" then
    return true
  end
  return nil
end

return mod
