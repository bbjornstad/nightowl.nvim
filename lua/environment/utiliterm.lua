local termlib = require("uutils.term")

local mod = {}

function mod.btop(opts)
  return termlib.toggleable("btop", opts)()
end

function mod.broot(opts)
  return termlib.toggleable("broot", opts)()
end

function mod.sysz(opts)
  return termlib.toggleable("sysz", opts)()
end

function mod.weechat(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", {
    close_on_exit = false,
  }, opts)
  return termlib.toggleable("weechat", opts)()
end

return mod
