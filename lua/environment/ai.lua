local env_bool = require("uutils.conversion").bool_from_env

--- The AI environment module contains the necessary configuration and setupthat
--- that is exposed to the user, specifically for a selection of AI agent plugins
--- that are available for the neovim platform. As a user, this is where you
--- should configure any parameters related to AI agents.
local env = {}

--- a helper function that serves to format the table of AI agent enabled states
---@param tbl_enable table table that describes the enabled states for each agent
function env.enablements(tbl_enable)
  local res = {}
  for k, val in pairs(tbl_enable) do
    local inner_result
    res[k] = {}
    local varname = ("NIGHTOWL_AI_FEATURE_%s"):format(string.upper(k))
    if val.env then
      inner_result = env_bool(varname)
      res[k].enable = inner_result or (val.fallback or false)
    else
      res[k].enable = val.fallback or false
    end
  end
  return res
end

env.enabled = {
  copilot = { env = true, fallback = false },
  cmp_ai = { env = true, fallback = false },
  chatgpt = { env = true, fallback = false },
  codegpt = { env = true, fallback = false },
  neural = { env = true, fallback = false },
  neoai = { env = true, fallback = false },
  hfcc = { env = true, fallback = true },
  tabnine = { env = true, fallback = true },
  cmp_tabnine = { env = true, fallback = true },
  codeium = { env = true, fallback = true },
  rgpt = { env = true, fallback = false },
  navi = { env = true, fallback = false },
  explain_it = { env = true, fallback = false },
  doctor = { env = true, fallback = false },
  llm = { env = true, fallback = false },
}
env.status_notify_on_startup = false

return env
