local kenv = require("environment.keys")
local mopts = require("uutils.functional").mopts
local key_broot = kenv.stems.broot
local key_htop = kenv.stems.htop

local mod = {}

function mod.term(opts)
  local Term = require("toggleterm.terminal").Terminal
  local new_term = Term:new(opts)
  return new_term
end

function mod.toggler(term, opts)
  opts = opts or {}
  term = term or mod.term(opts)
  local function _toggle_wrapper()
    term:toggle()
  end
  return _toggle_wrapper
end

function mod.toggleable(cmd, opts)
  local toggleable = mod.term(mopts({
    cmd = cmd,
    hidden = true,
  }, opts))
  local toggler = mod.toggler(toggleable)
  return toggler
end

return mod
