local termlib = require("funsak.terminal")

local M = {}

function M.btop(opts)
  return termlib.toggleable("commandline (btop)", opts)
end

function M.broot(opts)
  return termlib.toggleable("commandline (br)", opts)
end

function M.sysz(opts)
  return termlib.toggleable("commandline (sysz)", opts)
end

function M.weechat(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", {
    close_on_exit = false,
  }, opts)
  return termlib.toggleable("commandline (weechat)", opts)
end

function M.gitui(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", {
    close_on_exit = false,
  }, opts)
  return termlib.toggleable("commandline (gitui)", opts)
end

return M
