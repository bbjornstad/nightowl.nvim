local mod = {}

---
--@section Module manipulation functions - `uutils.mod`
--
-- Anything that is related to loading or unloading of modules should got here
function mod.reload(m)
    package.loaded[m] = nil
    return require(m)
end

return mod
