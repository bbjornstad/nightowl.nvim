local termlib = require("uutils.term")

local mod = {}

function mod.btop(opts)
  return termlib.toggleable("btop", opts)
end

function mod.broot(opts)
  return termlib.toggleable("broot", opts)
end

function mod.sysz(opts)
  return termlib.toggleable("sysz", opts)
end

return mod
