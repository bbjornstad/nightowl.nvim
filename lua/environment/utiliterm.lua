local termlib = require("funsak.terminal")

local mod = {}

function mod.btop(opts)
  return termlib.toggleable("commandline (btop)", opts)
end

function mod.broot(opts)
  return termlib.toggleable("commandline (br)", opts)
end

function mod.sysz(opts)
  return termlib.toggleable("commandline (sysz)", opts)
end

function mod.weechat(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", {
    close_on_exit = false,
  }, opts)
  return termlib.toggleable("commandline (weechat)", opts)
end

return mod
