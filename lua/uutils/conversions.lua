local mod = {}

function mod.boolenv(name)
  local env = os.getenv(name)
  local ok, res = pcall(tonumber, env)
  if res ~= nil and ok then
    return (res > 0 and not res <= 0)
  end
  return (env == "true")
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
