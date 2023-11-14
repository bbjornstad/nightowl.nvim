---@module "funsak.keys" functional swiss-army-knife attachments for management of
---keybinds for lazy.nvim-vim.keymap agnosticity and semantic consistency
---improvements.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@class funsak.keys
local M = {}

M.keygroup = require("funsak.keys.group").keygroup
M.from_file = require("funsak.keys.group").from_file

-- TODO: This is maybe a bit of a reach item at the moment, but it might be kind
-- of nice to have a keygroup be capable of checking map consistency against a
-- set of allowed keys, e.g. with a specific set of keys being allowed in the
-- creation of the universe that lhs specifications in user config files would
-- represent.

function M.kfnmap(mode)
  return function(lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

function M.kfndel(mode)
  return function(lhs, opts)
    vim.keymap.del(lhs, opts)
  end
end

return M
