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
  hfllm = { env = true, fallback = true },
  tabnine = { env = true, fallback = true },
  cmp_tabnine = { env = true, fallback = true },
  codeium = { env = true, fallback = true },
  rgpt = { env = true, fallback = false },
  navi = { env = true, fallback = false },
  explain_it = { env = true, fallback = false },
  doctor = { env = true, fallback = false },
  llm = { env = true, fallback = false },
  backseat = { env = true, fallback = false },
  wtf = { env = true, fallback = false },
}
env.status_notify_on_startup = false

-- -----------------------------------------------------------------------------
-- HuggingFace: Large Language Models
-- -----
-- llm.nvim: from huggingface
-- this plugin's name conflicts with another large language model plugin, this
-- one is also included in the same file as the huggingface option, but we can't
-- have the name conflict, so we have to rename one of them appropriately.
env.hf = {}
env.hf.llm = {}
env.hf.llm.name = "hfllm"
env.hf.llm.model = "bigcode/starcoder"
env.hf.llm.params = {
  max_new_tokens = 60,
  temperature = 0.2,
  top_p = 0.95,
  stop_token = "<|endoftext|>",
}
env.hf.llm.fim = {
  enabled = true,
  prefix = "<fim_prefix>",
  middle = "<fim_middle>",
  suffix = "<fim_suffix>",
}
env.hf.llm.lsp = {
  enabled = true,
  bin_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/llm_nvim/bin"),
}

return env
