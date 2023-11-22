local env = {}
local bfe = require("funsak.convert").bool_from_env

env.accelerated_jk = false
env.tabout = true
env.screensaver = {
  enable = bfe("NIGHTOWL_ENABLE_SCREENSAVER") or false,
  selections = { "treadmill", "epilepsy", "dvd" },
}
env.hardtime = false
env.file_managers = {
  oil = true,
  nnn = true,
  fm_nvim = false,
  bolt = true,
  attempt = true,
  broot = true,
}
env.specs = false
env.tabtree = true
env.troublesum = true
env.undotree = true
env.reverb = false
env.gh_actions = false
env.lsp = {
  diagnostics = {
    lsp_lines = true,
  },
}
env.symbol = {
  aerial = false,
  outline = true,
}
env.games = {
  blackjack = false,
  killersheep = false,
  nvimesweeper = false,
  sudoku = false,
  tetris = false,
}

env.git = {
  neogit = true,
  git_conflict = false,
  gitblame = true,
  blamer = true,
}

env.windowing = {
  focus_v_windows = {
    focus = { prefer = true },
    windows = { prefer = false },
  },
}

--- contains preferential behavior specifications for nvim plugins which step on
--- each others toes, generally accomplishing similar tasks. This is a
--- performance consideration.
env.prefer = {
  focus_windows = "focus",
  gitblame = "f-person",
  symbol_outline = "outline",
  timers = {
    pomodoro = "pulse",
  },
}

return env
