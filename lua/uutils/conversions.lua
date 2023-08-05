local mod = {}

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
