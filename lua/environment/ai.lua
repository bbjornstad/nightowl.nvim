local env_bool = require("funsak.convert").bool_from_env

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
    local varname = ("NIGHTOWL_FEATURE_%s"):format(string.upper(k))
    if val.env then
      inner_result = env_bool(varname)
      res[k].enable = inner_result or (val.fallback or false)
    else
      res[k].enable = val.fallback or false
    end
  end
  return res
end

env.enabled = env.enablements({
  copilot = { env = true, fallback = false },
  cmp_ai = { env = true, fallback = false },
  chatgpt = { env = true, fallback = false },
  codegpt = { env = true, fallback = false },
  neural = { env = true, fallback = false },
  neoai = { env = true, fallback = false },
  llm = { env = true, fallback = false },
  tabnine = { env = true, fallback = false },
  cmp_tabnine = { env = true, fallback = false },
  codeium = { env = true, fallback = false },
  rgpt = { env = true, fallback = false },
  navi = { env = true, fallback = false },
  explain_it = { env = true, fallback = false },
  doctor = { env = true, fallback = false },
  model = { env = true, fallback = false },
  backseat = { env = true, fallback = false },
  wtf = { env = true, fallback = false },
  prompter = { env = true, fallback = false },
  aider = { env = true, fallback = false },
  jogpt = { env = true, fallback = false },
  gptnvim = { env = true, fallback = false },
  llama = { env = true, fallback = false },
  ollero = { env = true, fallback = false },
  gen = { env = true, fallback = false },
  dante = { env = true, fallback = false },
  text_to_colorscheme = { env = true, fallback = true },
})
env.status_notify_on_startup = false

-- =============================================================================
-- HuggingFace: Large Language Models
-- ==================================
-- llm.nvim: from huggingface
-- this plugin's name conflicts with another large language model plugin, this
-- one is also included in the same file as the huggingface option, but we can't
-- have the name conflict, so we have to rename one of them appropriately.
env.hf = {}
env.hf.llm = {}
env.hf.llm.name = "llm"
env.hf.llm.model = "bigcode/starcoder"

return env
