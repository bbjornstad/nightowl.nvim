local function from_env(varname, caster)
  caster = caster or function(...)
    return unpack({ ... })
  end

  local res = vim.env[varname]
  return caster(res)
end

local function bool_from_env(varname)
  return from_env(varname, function(val)
    if val == "true" then
      return true
    end
    return false
  end)
end

local function toboolean(v)
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

return {
  from_env = from_env,
  bool_from_env = bool_from_env,
  toboolean = toboolean,
}
