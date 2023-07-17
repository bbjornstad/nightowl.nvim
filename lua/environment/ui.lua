local function toboolean(str)
  local bool = false
  if str == "true" or str == "1" then
    bool = true
  end
  return bool
end

local env = {}
--------------------------------------------------------------------------------
-- UI: Borders
-- ===========
-- Spec is that the main border should be shadow. We want this to apply to all
-- borders that are not made by mason or lazy, the package management tools.
-- Those receive the alt border, which is the double.
env.borders = {}
env.borders.main = "shadow"
env.borders.alt = "solid"
env.borders.main_accent = "double"

env.ai = {}
env.ai.enabled = {
  copilot = false,
  cmp_ai = true,
  chatgpt = true,
  codegpt = true,
  neural = true,
  neoai = true,
  hfcc = true,
  tabnine = false,
  codeium = true,
  rgpt = false,
  navi = false,
}
env.ai.configured_notify = false

env.telescope = {}
env.telescope.theme = "ivy"

env.navic = {}
env.navic.opts = {}

env.bufferline = {}
env.bufferline.tab_format = "slant"

env.enable_vim_strict = false

env.screensaver = {}
env.screensaver.enabled = false
env.screensaver.selections = { "treadmill", "epilepsy", "dvd" }

--------------------------------------------------------------------------------
-- UI: Colorscheme Options
-- ===========
env.default_colorscheme = "kanagawa"
env.colorscheme = {}

env.lualine_theme = env.default_colorscheme

return env
