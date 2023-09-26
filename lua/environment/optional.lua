local env = {}
local toboolean = require("uutils.conversion").toboolean

env.accelerated_jk = {
  enable = false
}
env.tabout = {
  enable = true
}
env.screensaver = {
  enable = toboolean(os.getenv("NIGHTOWL_ENABLE_SCREENSAVER")) or false,
  selections = { "treadmill", "epilepsy", "dvd" }
}
env.hardtime = {
  enable = false
}
env.file_managers = {
  fm_nvim = {
    enable = false
  },
  bolt = {
    enable = false
  },
  attempt = {
    enable = false
  }
}
env.specs = {
  enable = false
}
env.tabtree = {
  enable = false
}
env.troublesum = {
  enable = false,
}
env.undotree = {
  enable = false
}
env.reverb = {
  enable = false
}
env.gh_actions = {
  enable = false,
}
return env
