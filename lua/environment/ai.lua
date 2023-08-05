local toboolean = require("uutils.conversions").toboolean

--- The AI environment module contains the necessary configuration and setupthat
--- that is exposed to the user, specifically for a selection of AI agent plugins
--- that are available for the neovim platform. As a user, this is where you
--- should configure any parameters related to AI agents.
local env = {}

--- a helper function that serves to format the table of AI agent enabled states
---@param tbl_enable table table that describes the enabled states for each agent
---@return table formatted table of AI agent enabled states.
local function enablements(tbl_enable)
  local retval = vim.tbl_map(function(agent)
    if agent.env then
      return {
        enable = toboolean(
          os.getenv(("NIGHTOWL_AI_FEATURE_%s"):format(string.upper(agent.name)))
        ) or agent.fallback,
        name = agent.name,
      }
    end
    return {
      name = agent.name,
      enable = agent.fallback,
    }
  end, tbl_enable)

  local final = {}
  for _, v in pairs(retval) do
    final[v.name] = v
  end
  return final
end

env.enabled = {
  { name = "copilot", env = true, fallback = false },
  { name = "cmp_ai", env = true, fallback = false },
  { name = "chatgpt", env = true, fallback = true },
  { name = "codegpt", env = true, fallback = true },
  { name = "neural", env = true, fallback = true },
  { name = "neoai", env = true, fallback = true },
  { name = "hfcc", env = true, fallback = false },
  { name = "tabnine", env = true, fallback = true },
  { name = "cmp_tabnine", env = true, fallback = true },
  { name = "codeium", env = true, fallback = true },
  { name = "rgpt", env = true, fallback = false },
  { name = "navi", env = true, fallback = true },
  { name = "explain_it", env = true, fallback = false },
}
env.note_enabled_ai_agents = true
env.enabled_agents_status = enablements(env.enabled)

return env
