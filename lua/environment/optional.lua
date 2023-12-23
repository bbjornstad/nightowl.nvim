local env = {}
local bfe = require("funsak.convert").bool_from_env

env.tabout = true
env.screensaver = {
  enable = bfe("NIGHTOWL_ENABLE_SCREENSAVER") or false,
  selections = { "treadmill", "epilepsy", "dvd" },
}
env.file_managers = {
  oil = true,
  nnn = true,
  fm_nvim = true,
  bolt = false,
  attempt = true,
  broot = true,
}
env.tabtree = true
env.troublesum = true
env.undotree = true
env.gh_actions = true
env.lsp = {
  diagnostics = {
    lsp_lines = true,
  },
  null_ls = true,
}
env.symbol = {
  aerial = false,
  outline = true,
}
env.games = {
  blackjack = true,
  killersheep = true,
  nvimesweeper = true,
  sudoku = true,
  tetris = true,
}

env.git = {
  neogit = true,
  git_conflict = true,
  gitblame = true,
  blamer = true,
}

env.windowing = {
  focus = true,
  windows = true,
  cybu = true,
  ventana = true,
  colorful_winsep = true,
  early_retirement = true,
}

env.sessions = {
  persistence = false,
  possession = true,
}

--- contains preferential behavior specifications for nvim plugins which step on
--- each others toes, generally accomplishing similar tasks. This is a
--- performance consideration.
env.prefer = {
  focus_windows = "windows",
  gitblame = "f-person",
  symbol_outline = "outline",
  timers = {
    pomodoro = "pulse.nvim",
  },
}

return env
