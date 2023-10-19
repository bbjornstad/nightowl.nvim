local mod = {}

function mod.kmap(modes)
  local function returnable(lhs, rhs, opts)
    vim.keymap.set(modes, lhs, rhs, opts)
  end

  return returnable
end

mod.KeyModule = require("funsak.keys.kmod")
mod.kbind = require("funsak.keys.binding")

function mod.kmod(leader, map_tbl, opts)
  local ret = KeyModule:new(map_tbl, opts):with_leader(leader):wrap(opts)
  -- vim.notify(vim.inspect(ret))
  return ret
end

local requisition = require("funsak.masquerade").requisition

return requisition(mod)
