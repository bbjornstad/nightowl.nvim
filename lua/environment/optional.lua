local env = {}
local bfe = require("funsak.convert").bool_from_env

env.accelerated_jk = {
  enable = false,
}
env.tabout = {
  enable = true,
}
env.screensaver = {
  enable = bfe("NIGHTOWL_ENABLE_SCREENSAVER") or false,
  selections = { "treadmill", "epilepsy", "dvd" },
}
env.hardtime = {
  enable = false,
}
env.file_managers = {
  fm_nvim = {
    enable = false,
  },
  bolt = {
    enable = true,
  },
  attempt = {
    enable = true,
  },
  broot = {
    enable = true,
  },
}
env.specs = {
  enable = false,
}
env.tabtree = {
  enable = true,
}
env.troublesum = {
  enable = true,
}
env.undotree = {
  enable = false,
}
env.reverb = {
  enable = false,
}
env.gh_actions = {
  enable = false,
}
env.lsp = {
  diagnostics = {
    lsp_lines = {
      enable = true,
    },
  },
}
env.symbol = {
  aerial = {
    enable = true,
  },
  outline = {
    enable = true,
  },
}
env.games = {
  blackjack = {
    enable = false,
  },
  killersheep = {
    enable = false,
  },
  nvimesweeper = {
    enable = false,
  },
  sudoku = {
    enable = false,
  },
  tetris = {
    enable = false,
  },
}

env.windowing = {
  focus_v_windows = {
    focus = { prefer = true },
    windows = { prefer = false },
  },
}

env.prefer = {
  focus_windows = "focus",
}

return env
